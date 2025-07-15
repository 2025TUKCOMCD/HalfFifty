import os
import boto3
import tensorflow as tf
import numpy as np
from flask import Flask, request, jsonify

# 🔹 oneDNN 최적화 비활성화 (경고 제거)
os.environ["TF_ENABLE_ONEDNN_OPTS"] = "0"

app = Flask(__name__)

LOCAL_MODEL_PATH = "sign_language.h5"

# 🔹 라벨 리스트
labels = [
    '가세요', '감기', '감사합니다', '괜찮아요', '기분', 
    '날씨', '네', '더워요', '도와드릴게요', '만나서 반가워요', 
    '밝아요', '밥 먹었어요', '배고파요', '버스', '부탁해요',
    '수고하셨습니다', '아니요', '안녕하세요', '어때요', '영화',
    '조금', '조심하세요', '졸려요', '좋아요', '지하철',
    '집', '추워요', '친구', '학교', '힘들어요'
]

# 🔹 모델 로드
def load_model():
    model = tf.keras.models.load_model(LOCAL_MODEL_PATH)
    print("모델 로드 완료")
    return model

# 🔹 모델 초기화
model = load_model()

# 양손 데이터를 합치는 함수
def preprocess_keypoints(keypoints):
    keypoints = np.array(keypoints)  # (30, 2, 21, 3)

    # 왼손, 오른손 데이터를 각각 펼치기
    left_hand = keypoints[:, 0, :, :]  # (30, 21, 3)
    right_hand = keypoints[:, 1, :, :]  # (30, 21, 3)

    # 좌우 손을 나란히 이어붙이기
    combined = np.concatenate([left_hand, right_hand], axis=1)  # (30, 42, 3)

    # (30, 42, 3) → (30, 126)로 펴기
    combined = combined.reshape(30, 126)

    return combined

# 🔹 Flask API 엔드포인트
@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()

        # 🔥 양손 데이터 전처리
        keypoints = preprocess_keypoints(data["keypoints"])
        input_data = np.expand_dims(keypoints, axis=0)  # (1, 30, 126)

        # 🔹 모델 예측
        predictions = model.predict(input_data).tolist()[0]

        # 🔹 결과
        predicted_index = np.argmax(predictions)
        predicted_label = labels[predicted_index]
        confidence = predictions[predicted_index]

        return jsonify({
            "success": True,
            "predicted_label": predicted_label,
            "confidence": confidence
        })

    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

# 🔹 Flask 서버 실행
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002, debug=True)


import numpy as np
import os
from sklearn.model_selection import train_test_split

# 데이터 경로 설정
data_dir = "./"
labels = ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']
sequence_length = 30  # LSTM 입력 시퀀스 길이 설정

X, y = [], []

# 모든 자음 데이터 불러오기
for label_idx, label in enumerate(labels):
    keypoint_files = [f for f in os.listdir(data_dir) if f.startswith(label) and f.endswith("_keypoints.npy")]
    keypoint_files.sort()  # 파일 순서 정렬 (02, 03, 04 순서)
    
    for file in keypoint_files:
        file_path = os.path.join(data_dir, file)
        keypoints = np.load(file_path)

        # LSTM 학습을 위해 sequence_length 만큼 샘플링
        if len(keypoints) >= sequence_length:
            for i in range(len(keypoints) - sequence_length + 1):
                X.append(keypoints[i: i + sequence_length])  # (sequence_length, feature_dim)
                y.append(label_idx)  # 라벨 추가

# NumPy 배열로 변환
X = np.array(X)
y = np.array(y)

print("데이터셋 크기:", X.shape, y.shape)  # (샘플 개수, 시퀀스 길이, 특징 개수), (샘플 개수,)

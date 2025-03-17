
import cv2
import mediapipe as mp
import numpy as np

# Initialize Mediapipe Hands model
mp_hands = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils

# Load the video file
video_path = "./수어 데이터셋 만드는 동영상/ㄹ01.mp4"  # 파일 경로를 확인하세요.
cap = cv2.VideoCapture(video_path)

# Check if video opened successfully
if not cap.isOpened():
    raise IOError("Error opening video file")

# Initialize hand detection
hands = mp_hands.Hands(static_image_mode=False, max_num_hands=1, min_detection_confidence=0.5, min_tracking_confidence=0.5)

# Store keypoints
keypoints_list = []

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # Convert frame to RGB
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # Process frame with Mediapipe Hands
    results = hands.process(frame_rgb)

    if results.multi_hand_landmarks:
        for hand_landmarks in results.multi_hand_landmarks:
            keypoints = []
            for lm in hand_landmarks.landmark:
                keypoints.append([lm.x, lm.y, lm.z])  # Normalize keypoints
            keypoints_list.append(keypoints)

# Release resources
cap.release()
hands.close()

# Convert keypoints to numpy array
keypoints_array = np.array(keypoints_list)

# Save extracted keypoints
keypoints_file = "ㄹ01_keypoints.npy"
np.save(keypoints_file, keypoints_array)

print(f"Keypoints saved to {keypoints_file}")

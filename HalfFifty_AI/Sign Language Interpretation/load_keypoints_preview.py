
import numpy as np

keypoints = np.load("ㅎ05_keypoints.npy")
print("Extracted keypoints shape:", keypoints.shape)
print(keypoints[25:30])  # 첫 5 프레임만 출력

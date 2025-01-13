from tensorflow.keras.utils import to_categorical

# 클래스 수 계산
num_classes = len(np.unique(y_labels))

# 원-핫 인코딩
y_train = to_categorical(y_train, num_classes=num_classes)
y_val = to_categorical(y_val, num_classes=num_classes)

# 출력 확인
print(f"y_train shape after to_categorical: {y_train.shape}")
print(f"y_val shape after to_categorical: {y_val.shape}")

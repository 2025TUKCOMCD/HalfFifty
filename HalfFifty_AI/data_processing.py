import numpy as np

characters = ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
              'ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ',
              'ㅐ', 'ㅒ', 'ㅔ', 'ㅖ', 'ㅢ', 'ㅚ', 'ㅟ']
timestamps = ['1669720403', '1669723415', '1669724266']

x_data = []  # 입력 데이터
y_labels = []  # 라벨 데이터

for timestamp in timestamps:
    for idx, char in enumerate(characters):

        char_data = np.load(f'/content/drive/MyDrive/seq_{char}_{timestamp}.npy')


        x_data.append(char_data)
        y_labels.extend([idx] * len(char_data))


x_data = np.concatenate(x_data, axis=0)
y_labels = np.array(y_labels)

print(f"x_data shape: {x_data.shape}")
print(f"y_labels shape: {y_labels.shape}")

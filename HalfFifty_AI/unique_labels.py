import numpy as np

unique_labels = np.unique(y_labels)
num_classes = len(unique_labels)

print(f"Unique labels: {unique_labels}")
print(f"Number of classes: {num_classes}")

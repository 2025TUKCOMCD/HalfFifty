test_loss, test_accuracy = model.evaluate(x_val, y_val)
print(f"Test Loss: {test_loss}")
print(f"Test Accuracy: {test_accuracy}")

import os

from keras import layers, models, losses, optimizers, callbacks
from sklearn.model_selection import train_test_split

from dataset import load_dataset_file
from utils import plot_model_metrics

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

X, y, classes = load_dataset_file("data/train.json")
y_classes = classes["sounds"]
y = y["sound"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42
)

input_shape = X_train.shape[1:]
n_classes = len(y_classes)

print("\n")
print(f"X_train: {len(X_train)} shape={input_shape}")
print(f"y_train: {len(y_train)} shape={y_train.shape}")
print("\n")
print(f"X_test: {len(X_train)} shape={X_test.shape}")
print(f"y_test: {len(y_train)} shape={y_test.shape}")
print(f"classes: {y_classes}")
print("\n")

model = models.Sequential()
model.add(layers.Input(shape=input_shape, name="input_spectrogram"))
model.add(layers.Resizing(32, 32))

norm_layer = layers.Normalization()
norm_layer.adapt(data=X_train)
model.add(norm_layer)

model.add(layers.Conv2D(32, 3, activation="relu"))
model.add(layers.Conv2D(64, 3, activation="relu"))
model.add(layers.MaxPooling2D())

model.add(layers.Dropout(0.25))
model.add(layers.Flatten())

model.add(layers.Dense(100, activation="relu"))
model.add(layers.Dropout(0.5))
model.add(layers.Dense(n_classes))

model.summary()

model.compile(
    loss=losses.SparseCategoricalCrossentropy(from_logits=True),
    optimizer=optimizers.Adam(),
    metrics=["accuracy"],
)

history = model.fit(
    X_train,
    y_train,
    epochs=40,
    validation_data=(X_test, y_test),
    callbacks=callbacks.EarlyStopping(verbose=1, patience=2),
)

plot_model_metrics(history.epoch, history.history)
model.save("models/phoneme_model.h5", save_format="h5")

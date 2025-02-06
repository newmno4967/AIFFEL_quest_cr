from tensorflow.keras.applications.vgg16 import VGG16

model = VGG16(weights='imagenet')
model.summary()

model.save('vgg16.h5')
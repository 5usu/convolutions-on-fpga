import numpy as np
from PIL import Image

# Read the hex values from the file
with open('output_data.hex', 'r') as f:
    hex_values = f.readlines()

# Convert hex to integers
pixels = [int(value.strip(), 16) for value in hex_values]

# Reshape the array to 224x224
img_array = np.array(pixels, dtype=np.uint8).reshape((256, 256))

# Create and save the image
img = Image.fromarray(img_array)
img.save('output_image.png')

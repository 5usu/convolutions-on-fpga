from PIL import Image
import numpy as np

# Open the image
img = Image.open('image.png').convert('L')  # Convert to grayscale
img_array = np.array(img)

# Write to a hex file
with open('image_data.hex', 'w') as f:
    for pixel in img_array.flatten():
        f.write(f"{pixel:02x}\n")

print(f"Image dimensions: {img.size}")

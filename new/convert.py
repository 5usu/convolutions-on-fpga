from PIL import Image

# Function to convert a PNG image to pixel values
def png_to_pixel_values(image_path, output_path):
    # Open the image
    image = Image.open(image_path)

    # Ensure the image is in grayscale mode (8-bit pixels)
    if image.mode != 'L':
        image = image.convert('L')

    # Get the pixel data
    pixels = list(image.getdata())

    # Write the pixel values to a file
    with open(output_path, 'w') as file:
        for pixel in pixels:
            file.write(f"{pixel:02x}\n")

    print(f"Pixel values saved to {output_path}")

# Main function
def main():
    input_image = 'sample(1).png'  # Input PNG image file
    output_file = 'pixel_data.hex'  # Output file containing pixel values

    # Convert the PNG image to pixel values
    png_to_pixel_values(input_image, output_file)

if __name__ == "__main__":
    main()

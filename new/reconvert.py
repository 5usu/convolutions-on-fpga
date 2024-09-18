from PIL import Image

# Parameters
IMAGE_WIDTH = 256
IMAGE_HEIGHT = 256

# Function to read pixel data from a file
def read_pixel_data(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    pixels = [int(line.strip(), 16) for line in lines]
    return pixels

# Function to create a PNG image from pixel data
def create_png_image(pixel_data, width, height, output_path):
    image = Image.new('L', (width, height))
    image.putdata(pixel_data)
    image.save(output_path)

# Main function
def main():
    input_file = 'pixel_data.hex'  # Input file containing pixel data
    output_file = 'output_image.png'  # Output PNG image file

    # Read pixel data from the input file
    pixel_data = read_pixel_data(input_file)

    # Create and save the PNG image
    create_png_image(pixel_data, IMAGE_WIDTH, IMAGE_HEIGHT, output_file)

    print(f"Image saved as {output_file}")

if __name__ == "__main__":
    main()

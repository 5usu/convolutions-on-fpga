import tkinter as tk
from tkinter import filedialog, messagebox
from PIL import Image, ImageTk
import numpy as np
import mmap

class FPGAConvolutionGUI:
    def __init__(self, master):
        self.master = master
        master.title("FPGA Convolution GUI")

        self.image_path = tk.StringVar()
        self.kernel_choice = tk.StringVar()

        # Image selection
        tk.Label(master, text="Image:").grid(row=0, column=0, sticky="e")
        tk.Entry(master, textvariable=self.image_path, width=50).grid(row=0, column=1)
        tk.Button(master, text="Browse", command=self.browse_image).grid(row=0, column=2)

        # Kernel selection
        tk.Label(master, text="Kernel:").grid(row=1, column=0, sticky="e")
        kernels = ["Gaussian Blur", "Edge Detection", "Sharpen"]
        tk.OptionMenu(master, self.kernel_choice, *kernels).grid(row=1, column=1, sticky="w")

        # Convolution button
        tk.Button(master, text="Apply Convolution", command=self.apply_convolution).grid(row=2, column=1)

        # Image display
        self.image_label = tk.Label(master)
        self.image_label.grid(row=3, column=0, columnspan=3)

    def browse_image(self):
        filename = filedialog.askopenfilename(filetypes=[("Image files", "*.png *.jpg *.bmp")])
        if filename:
            self.image_path.set(filename)
            self.display_image(filename)

    def display_image(self, path):
        image = Image.open(path)
        image.thumbnail((400, 400))  # Resize for display
        photo = ImageTk.PhotoImage(image)
        self.image_label.configure(image=photo)
        self.image_label.image = photo

    def apply_convolution(self):
        if not self.image_path.get():
            messagebox.showerror("Error", "Please select an image first.")
            return

        # Load image and convert to grayscale
        image = Image.open(self.image_path.get()).convert('L')
        image_array = np.array(image)

        # Select kernel
        kernel = self.get_kernel(self.kernel_choice.get())

        # Prepare data for FPGA
        self.prepare_fpga_input(image_array, kernel)

        # Trigger FPGA processing
        self.trigger_fpga_processing()

        # Read result from FPGA
        result_array = self.read_fpga_output(image_array.shape)

        # Display result
        result_image = Image.fromarray(result_array.astype('uint8'))
        result_image.thumbnail((400, 400))  # Resize for display
        photo = ImageTk.PhotoImage(result_image)
        self.image_label.configure(image=photo)
        self.image_label.image = photo

    def get_kernel(self, kernel_name):
        if kernel_name == "Gaussian Blur":
            return np.array([[1, 2, 1], [2, 4, 2], [1, 2, 1]]) / 16
        elif kernel_name == "Edge Detection":
            return np.array([[-1, -1, -1], [-1, 8, -1], [-1, -1, -1]])
        elif kernel_name == "Sharpen":
            return np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
        else:
            raise ValueError("Unknown kernel")

    def prepare_fpga_input(self, image_array, kernel):
        # Write image data to FPGA input buffer
        with open("/dev/mem", "r+b") as f:
            mm = mmap.mmap(f.fileno(), 1024*1024, offset=0x40000000)
            mm.write(image_array.tobytes())
            mm.write(kernel.tobytes())
            mm.close()

    def trigger_fpga_processing(self):
        # Write to control register to start processing
        with open("/dev/mem", "r+b") as f:
            mm = mmap.mmap(f.fileno(), 4, offset=0x41000000)
            mm.write(b'\x01\x00\x00\x00')  # Write 1 to start processing
            mm.close()

    def read_fpga_output(self, shape):
        # Read processed data from FPGA output buffer
        with open("/dev/mem", "r+b") as f:
            mm = mmap.mmap(f.fileno(), shape[0]*shape[1], offset=0x42000000)
            data = mm.read(shape[0]*shape[1])
            mm.close()
        return np.frombuffer(data, dtype=np.uint8).reshape(shape)

root = tk.Tk()
gui = FPGAConvolutionGUI(root)
root.mainloop()

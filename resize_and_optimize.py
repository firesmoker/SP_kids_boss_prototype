import os
from PIL import Image

MAX_DIMENSION = 1500

def resize_image(file_path):
    try:
        with Image.open(file_path) as img:
            width, height = img.size
            # Skip resizing if dimensions are within limits
            if width <= MAX_DIMENSION and height <= MAX_DIMENSION:
                print(f"Skipping resizing: {file_path} (dimensions within limits)")
                return
            
            # Calculate new dimensions
            if width > height:
                new_width = MAX_DIMENSION
                new_height = int(height * MAX_DIMENSION / width)
            else:
                new_height = MAX_DIMENSION
                new_width = int(width * MAX_DIMENSION / height)
            
            # Resize with high-quality resampling
            img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
            img.save(file_path)
            print(f"Image resized: {file_path} to {new_width}x{new_height}")
    except Exception as e:
        print(f"Failed to resize image: {file_path}. Error: {e}")

def process_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                resize_image(file_path)

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python resize_and_optimize.py <directory>")
        sys.exit(1)
    process_directory(sys.argv[1])

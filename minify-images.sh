#!/bin/bash

# Directory to start optimizing from
DIR="/Users/alon.levi/Workspace/SP_kids_boss_prototype/"

# Python script path
PYTHON_SCRIPT="resize_and_optimize.py"

# Ensure the Python script exists
if [[ ! -f $PYTHON_SCRIPT ]]; then
    echo "Error: Python script $PYTHON_SCRIPT not found."
    exit 1
fi

# Resize images using the Python script
echo "Resizing images in directory: $DIR"
python3 $PYTHON_SCRIPT "$DIR"

# Function to optimize PNG images
optimize_png() {
  local file="$1"
  echo "Optimizing PNG: $file"

  pngquant --quality=75 --ext .png --force "$file" >/dev/null 2>&1

  if [[ $? -eq 0 ]]; then
    echo "PNG optimized: $file"
  else
    echo "Failed to optimize PNG: $file"
  fi
}

# Function to optimize JPG images
optimize_jpg() {
  local file="$1"
  echo "Optimizing JPG: $file"

  jpegoptim --max=75 --strip-all "$file" >/dev/null 2>&1

  if [[ $? -eq 0 ]]; then
    echo "JPG optimized: $file"
  else
    echo "Failed to optimize JPG: $file"
  fi
}

# Export functions for use in subshells by the `find` command
export -f optimize_png
export -f optimize_jpg

# Optimize PNG and JPG files
echo "Starting optimization in directory: $DIR"
find "$DIR" -type f \( -iname "*.png" -exec bash -c 'optimize_png "$0"' {} \; \
                     -o -iname "*.jpg" -exec bash -c 'optimize_jpg "$0"' {} \; \)

echo "Optimization complete."

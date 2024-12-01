#!/bin/bash

# Directory to start optimizing from, default is current directory
DIR="/Users/alon.levi/Workspace/SP_kids_boss_prototype/art/"

# Maximum width or height for resizing
MAX_DIMENSION=800

# Function to validate an image file
validate_image() {
  local file="$1"
  # Check if the file is a valid image
  sips -g all "$file" >/dev/null 2>&1
  return $?
}

# Function to downsize images while maintaining aspect ratio
downsize_image() {
  local file="$1"
  local temp_file="$2"

  # Validate the input image
  if ! validate_image "$file"; then
    echo "Invalid input image: $file. Skipping."
    cp "$file" "$temp_file"  # Use original file as fallback
    return
  fi

  # Get the current dimensions of the image
  local current_width=$(sips -g pixelWidth "$file" | awk '/pixelWidth/ {print $2}')
  local current_height=$(sips -g pixelHeight "$file" | awk '/pixelHeight/ {print $2}')

  # Skip resizing if the image is already within the maximum dimensions
  if (( current_width <= MAX_DIMENSION && current_height <= MAX_DIMENSION )); then
    echo "Image already within size limits: $file"
    cp "$file" "$temp_file"
    return
  fi

  # Resize the image to the maximum dimensions while maintaining aspect ratio
  sips --resampleHeightWidthMax 800 "$file" --out "$temp_file" >/dev/null 2>&1

  # Validate the downsized image
  local dimensions=$(sips -g pixelWidth -g pixelHeight "$temp_file" 2>/dev/null | awk '/pixelWidth|pixelHeight/ {print $2}')
  if [[ -z "$dimensions" || "$dimensions" == "1" ]]; then
    echo "Invalid downsized image for: $file (Resulted in $dimensions). Skipping."
    cp "$file" "$temp_file"  # Use original file as fallback
  fi
}

# Function to optimize PNG images
optimize_png() {
  local file="$1"
  echo "Optimizing PNG: $file"
  
  # Temporary file for downsizing and optimization
  local temp_file="${file}.optimized"
  
  # Downsize the image before optimization
  downsize_image "$file" "$temp_file"

  # Optimize PNG with optipng
  optipng -o3 "$temp_file" >/dev/null 2>&1

  # Compare file sizes and overwrite if optimized file is at least 20% smaller
  local original_size=$(stat -f%z "$file")
  local optimized_size=$(stat -f%z "$temp_file")
  if (( optimized_size <= original_size * 80 / 100 )); then
    mv "$temp_file" "$file"
    echo "PNG optimized and saved: $file"
    echo "Original size: $original_size bytes, Optimized size: $optimized_size bytes (reduced by $((100 - optimized_size * 100 / original_size))%)"
  else
    rm "$temp_file"
    echo "PNG optimization skipped (size reduction insufficient): $file"
    echo "Original size: $original_size bytes, Optimized size: $optimized_size bytes"
  fi
}

# Function to optimize JPG images
optimize_jpg() {
  local file="$1"
  echo "Optimizing JPG: $file"
  
  # Temporary file for downsizing and optimization
  local temp_file="${file}.optimized"
  
  # Downsize the image before optimization
  downsize_image "$file" "$temp_file"

  # Optimize JPG with jpegoptim
  jpegoptim --max=60 --strip-all "$temp_file" >/dev/null 2>&1

  # Compare file sizes and overwrite if optimized file is at least 20% smaller
  local original_size=$(stat -f%z "$file")
  local optimized_size=$(stat -f%z "$temp_file")
  if (( optimized_size <= original_size * 80 / 100 )); then
    mv "$temp_file" "$file"
    echo "JPG optimized and saved: $file"
    echo "Original size: $original_size bytes, Optimized size: $optimized_size bytes (reduced by $((100 - optimized_size * 100 / original_size))%)"
  else
    rm "$temp_file"
    echo "JPG optimization skipped (size reduction insufficient): $file"
    echo "Original size: $original_size bytes, Optimized size: $optimized_size bytes"
  fi
}

# Export functions for `find` command in subshells
export -f optimize_png
export -f optimize_jpg
export -f downsize_image
export -f validate_image

# Recursively find and optimize PNG and JPG files
echo "Starting recursive optimization in directory: $DIR"

find "$DIR" -type f \( -iname "*.png" -exec bash -c 'optimize_png "$0"' {} \; \
                     -o -iname "*.jpg" -exec bash -c 'optimize_jpg "$0"' {} \; \)

echo "Optimization complete."

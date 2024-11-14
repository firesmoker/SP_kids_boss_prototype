#!/bin/bash

# Directory to start optimizing from, default is current directory
DIR="${1:-.}"

# Function to optimize PNG images
optimize_png() {
  local file="$1"
  echo "Optimizing PNG: $file"
  
  # Temporary file for optimization
  local temp_file="${file}.optimized"
  
  # Convert color profile to sRGB if necessary, save to temporary file
  magick "$file" -strip -colorspace sRGB "$temp_file"

  # Optimize PNG with optipng, saving to the temporary file
  optipng -o3 "$temp_file" >/dev/null 2>&1

  # Compare file sizes and overwrite if optimized file is at least 20% smaller
  original_size=$(stat -f%z "$file")
  optimized_size=$(stat -f%z "$temp_file")
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
  
  # Temporary file for optimization
  local temp_file="${file}.optimized"
  
  # Convert color profile to sRGB if necessary, save to temporary file
  magick "$file" -strip -colorspace sRGB "$temp_file"

  # Optimize JPG with jpegoptim, saving to the temporary file
  jpegoptim --max=60 --strip-all "$temp_file" >/dev/null 2>&1

  # Compare file sizes and overwrite if optimized file is at least 20% smaller
  original_size=$(stat -f%z "$file")
  optimized_size=$(stat -f%z "$temp_file")
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

# Recursively find and optimize PNG and JPG files
echo "Starting recursive optimization in directory: $DIR"

find "$DIR" -type f \( -iname "*.png" -exec bash -c 'optimize_png "$0"' {} \; \
                     -o -iname "*.jpg" -exec bash -c 'optimize_jpg "$0"' {} \; \)

echo "Optimization complete."

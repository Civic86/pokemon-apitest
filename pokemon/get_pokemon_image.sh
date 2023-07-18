#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <pokemon_name>"
  exit 1
fi

POKEMON_NAME=$1
API_URL="https://pokeapi.co/api/v2/pokemon/${POKEMON_NAME}/"
OUTPUT_DIR="./pokemon_images"

# Check if the output directory exists or create it
if [ ! -d "$OUTPUT_DIR" ]; then
  mkdir -p "$OUTPUT_DIR"
fi

# Fetch data from pokeapi
response=$(curl -s "$API_URL")

# Check if the Pokemon exists
if [[ $response == *"Not Found"* ]]; then
  echo "Pokemon not found."
  exit 1
fi

# Extract the image URL from the API response
image_url=$(echo "$response" | grep -o '"front_default": "[^"]*' | cut -d '"' -f 4)

if [ -z "$image_url" ]; then
  echo "Image URL not found in the API response."
  exit 1
fi

# Download the image
image_name="${POKEMON_NAME}.png"
curl -s "$image_url" -o "${OUTPUT_DIR}/${image_name}"

echo "Image downloaded: ${OUTPUT_DIR}/${image_name}"

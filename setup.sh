#!/bin/bash

# Define the URL and the output path
MODEL_URL="https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt"
OUTPUT_PATH="./models/sd-v1-4.ckpt"

# Create the models directory if it doesn't exist
mkdir -p ./models

# Download the model if it doesn't exist
if [ ! -f "$OUTPUT_PATH" ]; then
    echo "Downloading the model..."
    curl -L -o "$OUTPUT_PATH" "$MODEL_URL"
    if [ $? -eq 0 ]; then
        echo "Model downloaded successfully."
    else
        echo "Failed to download the model."
        exit 1
    fi
else
    echo "Model already exists."
fi

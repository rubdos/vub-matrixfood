#!/bin/bash

img_name="m1dnight/foodbot:latest"

docker build --no-cache -t "${img_name}" .

if [ "$1" == "--push" ]; then
   docker push "${img_name}"
fi

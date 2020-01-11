#!/bin/bash
set -e

language=$1
generated_folder=$2

options=""

# Check which language is chosen
case "$language" in
go)
  options="--go_out=plugins=grpc:${generated_folder}"
  ;;
nodejs)
  options="$options --js_out=import_style=commonjs,binary:${generated_folder}"
  options="$options --plugin=protoc-gen-ts=/home/john/node_modules/.bin/protoc-gen-ts"
  options="$options --ts_out=service=grpc-node:${generated_folder}"
  options="$options --plugin=protoc-gen-grpc=/home/john/node_modules/.bin/grpc_tools_node_protoc_plugin"
  options="$options --grpc_out=${generated_folder}"
  ;;
*)
  echo -e "\e[38;2;255;0;0mNot supported language ($language)!\e[0m"
  exit 1
  ;;
esac

echo "$(pwd) protoc ${options} *.proto"
protoc $options *.proto
echo -e "\033[0;32mProtofiles generated successfully 🎉\033[0m"

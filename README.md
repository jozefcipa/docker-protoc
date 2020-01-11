### A simple way for generating GRPC stubs
This image aims to provide an easy and straightforward way for generating GRPC stubs from Protobuf files.

This image currently supports **NodeJS** and **Go**.

#### Installation
```
  docker pull jozefcipa/protoc-{lang}
```

#### How to use
```
docker run \
  -v `pwd`/{PROTO_FILES_FOLDER}:/proto-defs \
  -v `pwd`/{OUT_FOLDER}:/out \
  -it jozefcipa/protoc-{LANG}
```

`PROTO_FILES_FOLDER` - relative path from your current directory to directory where `.proto` files are located

`OUT_FOLDER` - relative path from your current directory to directory where stub files will be generated

`LANG` - target language that files will be generated for (`nodejs` or `go`)

#### TODO
- Add [prototool](https://github.com/uber/prototool) support to enable features like *linting*, *checking for breaking changes* and more.

---

Inspired by [namely/docker-protoc](https://github.com/namely/docker-protoc)

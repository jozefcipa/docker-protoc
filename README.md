### A simple way for generating GRPC stubs

## TODO: this branch contains Work in progress
It includes `protoc-gen-doc` plugin but it's not 100% working yet. It seems like it overwrites generated doc file for every directory in proto definitions so it never contains all the data in it.

This image aims to provide an easy and straightforward way for generating GRPC stubs from Protobuf files.

This image supports **NodeJS** and **Go**.

#### Installation
```
  docker pull jozefcipa/protoc-{lang}
```

#### How to use
```
docker run \
  -v `pwd`/{PROTO_FILES_FOLDER}:/proto-defs \
  -v `pwd`/{OUT_FOLDER}:/gen \
  -it jozefcipa/protoc-{LANG}
```

`PROTO_FILES_FOLDER` - relative path from your current directory to directory where `.proto` files are located

`OUT_FOLDER` - relative path from your current directory to directory where stub files will be generated

`LANG` - target language that files will be generated for (`nodejs` or `go`)

---

Inspired by [namely/docker-protoc](https://github.com/namely/docker-protoc)

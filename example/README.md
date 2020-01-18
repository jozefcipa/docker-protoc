### Example

Run this script in project root
```
  docker run \
    -v `pwd`/example:/proto-defs \
    -v `pwd`/gen:/gen \
    -it jozefcipa/protoc-nodejs
```
After running this script you should see generated TS and JS files in `gen` folder.

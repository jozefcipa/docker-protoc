### Example

Run this script in project root
```
  docker run \
    -v `pwd`/example:/proto-defs \
    -v `pwd`/out:/out \
    -it jozefcipa/protoc-nodejs
```
After running this script you should see generated TS and JS files in `out` folder.

# Description
该目录提供了 swagger spec 文件的检查工具。

# Index
- Json 文件的合法性校验: [pretty-plugin](./pretty-plugin/README.md)
- Swagger 文件合法性校验: [swagger-validation](./swagger-validation/README.md)
- Swagger 文件对比: [openapi-diff](./swagger-validation/README.md)
- 代码生成工具: [snips](./code-gen/README.md)

# Build docker image
为了方便使用，提供一个打包所有工具的 Dockerfile
```sh
 docker build -t qingcloud/openapi-tools .
```
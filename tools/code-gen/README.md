# Code generation
基于qingStor 团队开发的snips项目。

基于 ingStor 团队开发的 snips 项目，根据[API文档规范的需求]()，做了一些简单修改。
- 原项目地址:  [Github/snips](https://github.com/qingstor/snips)
- 项目地址: [Gitlab/snips](https://git.internal.yunify.com/Ryan/snips)

## Build
```
$ go mod tidy
$ go build snips
```

## Template
- 按照业务需求编写生成模板(golang tmpl)
- 可参考[相关文档](/documentation/code-gen/snips.md)

## Usage

```
$ snips --help
A code generator for RESTful APIs.

For example:
  $ snips -f ./specs/qingstor/api.json
          -t ./templates/qingstor/go \
          -o ./publish/qingstor-sdk-go/service
  $ ...
  $ snips --file=./specs/qingstor/api.json \
          --template=./templates/qingstor/ruby \
          --output=./publish/qingstor-sdk-ruby/lib/qingstor/sdk/service
  $ ...

Copyright (C) 2016 Yunify, Inc.

Usage:
  snips [flags]

Flags:
  -f, --file string       Specify the spec file.
      --format string     Specify the format of spec file. (default "OpenAPI-v2.0")
  -o, --output string     Specify the output directory.
  -t, --template string   Specify template files directory.
  -v, --version           Show version.
```
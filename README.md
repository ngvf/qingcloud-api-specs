### QingCloud API Specification 规范
#### Description
为了统一规范并管理 API 接口，在此项目制定 云平台产品接口描述规范 及一些相关工具。


#### Specification
- API 接口都以 [OpenAPI Specification (Swagger) v2.0](https://swagger.io/specification/v2/) 为规范, 推荐使用json格式。
- 在此基础上，添加自定义参数，具体请参考[creating-swagger](./doc/creating-swagger.md)

| param | type | description | comment |
| --- | --- | --- | --- |
| x-scope | string |接口权限说明 | 可选 private，public，默认 public |
| x-description | object | 描述(i18n) | - |
| x-example | object | 请求示例 | - |

 
 
#### Directory Structure
1. **doc**: 相关文档目录，关于 spec 书写规范，检查清单等。

1. **spec**: API spec 的目录。

1. **tools**: 工具存放目录，代码生成，swagger 文件校验等。

1. **scripts**: 脚本存放目录。


#### Structure Of spec
```sh
.
./spec
├── access_key
│   ├── example
│   │   └── DescribeAccessKeys.json
│   └── access_key.json
├── image
│   ├── example
│   │   ├── DeleteImages.json
│   │   └── DescribeImages.json
│   └── image.json
├── api-profile.json
├── parameters.json
└── definitions.json
```

- 各模块，拥有单独的 swagger spec 存在在对应的文件夹中
- 每个模块用对应的 **请求示例文件** (example)，示例文件应和 API operationId 同名。
- **api-profile.json** 是所有 api 的 paths 汇总文件。
- **parameters.json** 和 **definitions.json** 为公用 parameters/definitions 的定义文件。


#### Usage

1. 请按照 doc 中的规范编写 API spec 文件。
2. 按照 [check-list](./doc/swagger-checklist.md) 对 spec 文件进行检查。
3. 根据检查后的反馈进行修改，然后 push。

CI
1. 生成 api spec 的 public 版本。
2. 生成 api doc。


#### Note
1. 各产品线 api specs 可以单独维护在其他 gitlab project 并作为此项目的 submodule 统一发布。
    > 开发前请阅读规范文档，开发后请按照检查清单进行自查
1. 建议基于接口描述来自动生成 **sdk/cli/request model(调用层)** 代码。 
1. 有些 **接口/参数/返回** 是区分普通用户和管理员权限的，可通过设置“x-scope”参数区分（用于生成 **公开版和私有版** 的代码或文档），目前 snips 支持在 manifest 配置 scope。
1. 基于接口描述生成 API 接口文档，在spec中需要有相应的 **示例** （x-example）和 **中英文描述说明**（英文默认使用 "description" 参数，中文以及其他语言在 "x-description" 中设置），目前 snips 支持在 manifest 配置 language。

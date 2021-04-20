# Index
## 编写 swagger-spec 的参考流程
### Step1
编写前，请了解[Openapi 规范](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md)和[Swagger 各对象说明及其对应在snips中的解析](creating-swagger.md)。
### Step2
开始编写时，可以参考 spec-sample-files 示例，同时按照 [Swagger 模块](https://git.internal.yunify.com/cloud-mgmt-dept/qingcloud-api-specs/doc/swagger-bootstrap.md) 进行。
### Step3
编写完成后，在 push 前，请按照 [Swagger 文件检查列表](https://git.internal.yunify.com/cloud-mgmt-dept/qingcloud-api-specs/doc/swagger-checklist.md) 进行自查。

其中具体规范：

1. 自动检测工具检查规范：[openapi-authoring-automated-guidelines](https://git.internal.yunify.com/cloud-mgmt-dept/qingcloud-api-specs/doc/openapi-authoring-automated-guidelines.md)
1. 编写行为规范：[openapi-authoring-manual-guidelines](https://git.internal.yunify.com/cloud-mgmt-dept/qingcloud-api-specs/doc/openapi-authoring-manual-guidelines.md)
1. api 重大改变说明：[breaking-changes-guildelines](https://git.internal.yunify.com/cloud-mgmt-dept/qingcloud-api-specs/doc/breaking-changes-guildelines.md)

## Swagger 生成代码
使用 QingStor 团队开发的工具 [snips](https://community.qingcloud.com/topic/746/%E8%87%AA%E5%8A%A8%E5%8C%96-sdk-%E4%BB%A3%E7%A0%81%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7-snips-%E5%8F%8A-qingstor-sdk-%E5%BC%80%E5%8F%91%E5%AE%9E%E8%B7%B5)，
进行代码生成，具体请参考[snips使用说明](https://git.internal.yunify.com/cloud-mgmt-dept/qingcloud-api-specs/doc/code-gen/snips.md)
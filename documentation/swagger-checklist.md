# Swagger Checklist #

## Introduction ##
在写完 swagger 文件后，请按照该清单事项进行检查，确认无误后再进行提交。

## Checklist ##
- 若有新添接口，请添加到 /spec/api-profile.json 中
- Json 文件的合法性校验，可使用工具 [pretty-plugin](../tools/pretty-plugin/README.md)
- Swagger 文件合法性校验，可使用用于 [swagger-validation](../tools/swagger-validation/README.md)，相关报错可参考[Automated Rules of Checklist](openapi-authoring-automated-guidelines.md)
- Swagger 文件规范检查，请参照 [Manual Rules of Checklist](openapi-authoring-manual-guidelines.md) 进行自查
- API 修改对比，向后兼容性检查，可使用工具 [openapi-diff](../tools/swagger-validation/README.md)，相关问题可参考[breaking-changes-guildelines](breaking-changes-guildelines.md)

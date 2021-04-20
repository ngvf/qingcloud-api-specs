# OpenAPI Specifications Authoring - Manual Guidelines #

本文档主要列举了写 openapi specs 时，应该遵守的规范，且这些是无法被自动工具检查出来的。

所以在提交前请按照文档所诉进行自查。

## Manual Rules

### Errors
- 同一类型（例如文件夹或文件名等）的命名规则请保持一致，避免依赖此规则的检查或解析工具运行失败。
- spec下的分类名（文件夹名）、服务名称（info-name）、tags，建议统一使用小写英文，并且对于名字最好使用单数。（例如 images --> image）
- 示例文件请统一放在对应分类下的 example 文件夹下，x-example 请严格按照示例中路径依赖的格式填写。且所处文件夹名称应与 tags 中的值一致。
- 示例文件名请与所对应的 operationId 同名。


### Warnings
- 各类单独使用的 definitions 或 parameters 请不要定义在 /spec 根目录下的对应文件中，这些文件应该用来定义通用的对象。

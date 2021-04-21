# OpenAPI Specifications Authoring - Automated Guidelines #

本文档列举了一系列违反 Openapi 规范，且可以被校验工具检测出的问题。

所有 Error 必须手动修改后，才可以提交审查。Warning 建议按照推荐方式修改。

## Index
* [OPENAPI Violations](#openapi-violations)
   * [OPENAPI Errors](#openapi-errors)
   * [OPENAPI Warnings](#openapi-warnings)
* [SDK Violations](#sdk-violations)
	* [SDK Errors](#sdk-errors)
	* [SDK Warnings](#sdk-warnings)
* [Documentation Violations](#documentation-violations)
	* [Documentation Errors](#documentation-errors)
	* [Documentation Warnings](#documentation-Warnings)


## Documentation Violations<a name="documentation-violations" />
### Documentation Errors<a name="documentation-errors" />
#### x-description-rule
**Output Message**: Please provide a x-description for {{property}}。

**Description**: 所有 description 需要有一个对应的 x-description。

**Why the rule is important**: 生成中文（或者其他非英文语言）的文档时，需要有对应的描述说明。

**How to fix the violation**:
```json
{
	"description": "Example1",
    "x-description": {
      "zh": "示例1"
    },
}
```

#### x-example-rule
**Output Message**: Please provide a x-example for {{property}}。

**Description**: 每个 operation 应该有一个对应的 x-example。

**Why the rule is important**: 生成文档时，需要提供对应的 Example。

**How to fix the violation**:
```json
{
	"x-example": {
       "$ref": "./example/DescribeImages.json"
    }
}
```

### Documentation Warnings<a name="documentation-Warnings" />

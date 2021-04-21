# Creating Swagger (Reference documentation)

[snips](https://community.qingcloud.com/topic/746/%E8%87%AA%E5%8A%A8%E5%8C%96-sdk-%E4%BB%A3%E7%A0%81%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7-snips-%E5%8F%8A-qingstor-sdk-%E5%BC%80%E5%8F%91%E5%AE%9E%E8%B7%B5) 
是 QingStor 团队开发的，基于 Openapi-Specs 来生成代码（文本）的工具。

本文档对 Swagger 文件 特定部分的进行了说明，以及相对应的在 snips 中处理时所约定的含义。

其中，Openapi 规范可参考 [Swagger RESTful API Documentation Specification](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md) 。

如果您对 Swagger 文件的特定部分或者 snips 如何使用他生成代码有任何疑问，可参考该文档。

1. [Swagger](#Swagger)
1. [Info Object](#InfoObject)
1. [Host](#Host)
1. [Schemes](#Schemes)
1. [Paths](#Paths)
1. [Path Item](#PathItem)
  1. [Operation and OperationId](#OperationOperationId)
  1. [Tags](#Tags)
  1. [Parameters](#Parameters)
    1. [Path Parameters](#PathParameters)
    1. [Query Parameters](#QueryParameters)
    1. [Body Parameters](#BodyParameters)
  1. [Responses](#Responses)
1. [Parameters](#Parameters)
1. [Definitions](#Definitions)
1. [Responses](#ResponsesPublic)
1. [Extensions](#Extensions)
  1. [x-scope](#x-scope)
  1. [x-description](#x-description)
  1. [x-example](#x-example)

## Swagger<a name="Swagger"></a>
Swagger Specification 使用的版本号。snips只支持2.0版本。
```json
{
  "swagger": "2.0"
}
```

## Info Object<a name="InfoObject"></a>
提供 API 的相关信息。

其中 **title** 字段会作为 snips 中的 Service.Name(主服务的名称), 而 **version** 字段会作为 相应的 Service.Version(主服务版本号)。
```json
"info": {
  "title": "MyServiceName",
  "version": "2013-02-08"
}
```

## Host<a name="Host"></a>
**host** 字段指定了域名， 对应 snips 中的 Service.Host.
``` json
{
  "host": "api.qingcloud.com"
}
```

## Schemes<a name="Schemes"></a>
定义传输协议，必须从以下选择：http、https、ws、wss。

对应 snips 中的 Service.Schemes.
```json
{
  "swagger": "2.0",
  "schemes": [
    "https",
    "http"
  ]
}
```

## Paths<a name="Paths"></a>
**Paths** 定义 API 的相对路径.
```json
"swagger": "2.0",
"paths": {
  "/DescribeImages": {
  ...
  },
  "/CreateVolumes": {
  ...
  }
}
```

## Path Item<a name="PathItem"></a>
每个 **Path** 下定义的操作。
```json
{
  "swagger": "2.0",
  "paths": {
    "/stations": {
      "get": {
      ...
      },
      "put": {
      ...
```


### Operation and OperationId<a name="OperationOperationId"></a>
每个操作(operation) 必须有个唯一的 operationId 。

对应 snips Service.Operations[\*].OperationId 或 SubService.Operations[\*].OperationId。
```json
"paths": {
  "/users": {
    "get": {
      "operationId": "ListUsers"
    }
  }
```

### Tags<a name="Tags"></a>
每个操作(operation)下可定义 **tags**，用于 operation 分组。

在 snips 中会把相同 **tags** 的 operation 归到 一个 SubService.Operations 中。如果没有 **tags** 的则会归到 Service.Operations。
```json
"paths": {
  "/users": {
    "get": {
      "operationId": "ListUsers",
      "tags": [
        "image"
      ]
    }
  }
```



### Parameters<a name="Parameters"></a>
每个 operation 的 **Parameters** 需要定义 name, description, schema, in(**path**, **query**,  **header**, **body** )

在 snips 中可通过 Operation.Request.Properties / Operation.Request.Query.Properties / Operation.Request.Headers.Properties / Operation.Request.Elements.Properties 访问

#### Path Parameters<a name="PathParameters"></a>
**Path Parameters** 是指用一对大括号{}来标记URL中可以被参数替换的部分，且该参数必须设置 `"required": true`。
```json
"paths": {
  "/users/{userId}": {
    "get": {
      "operationId": "users_getById",
      "parameters": [
        {
          "name": "userId",
          "in": "path",
          "required": true,
          "type": "string",
          "description": "Id of the user."
        }
      ]
    }
  }
}
```

#### Query Parameters<a name="QueryParameters"></a>
**Query** 是添加在URL上的查询参数。
```json
"paths": {
  "/CreateAccessKey": {
    "get": {
      "operationId": "CreateAccessKey",
      "parameters": [
        {
          "name": "access_key_name",
          "in": "query",
          "type": "string",
          "description": "name of access key."
        }
      ]
    }
  }
}
```

#### Body Parameters<a name="BodyParameters"></a>
附加到HTTP请求的payload。因为一个请求只能有一个payload，所以也只能有一个Body参数
```json
"paths": {
  "/DeleteImages": {
    "post": {
      "operationId": "DeleteImages",
      "parameters": [
        {
          "name":"body",
          "in":"body",
          "description":"body parameters",
          "x-description":{
              "zh":"body parameters"
          },
          "schema":{
              "type":"object",
              "properties":{
                  "images":{
                      "$ref":"#/definitions/images"
                  },
              }
              ......
          } 
        }
      ],
      ...
```

### Responses<a name="Responses"></a>
Responses Object必须包含至少一个响应码，而且应该是成功操作后的响应。

在 snips 中可通过 Operation.Responses[`status code`] 访问
```json
"/users/{userId}": {
  "get": {
    "operationId": "users_getUserById",
    "responses": {
      "200": {
        "schema": {
          "$ref": "#/definitions/user"
        }
      }
    }
  }
}
```

## Definitions<a name="Definitions"></a>
持有一个操作可以消费或者生产的数据类型。数据类型可以是原始类型、数组或者对象。
```json
"definitions": {
  "provider": {
    "type": "string",
    "description": "who provide this image, self, system.",
    "x-description": {
      "zh": "映像提供者。初始青云系统会提供一系列默认映像，其 provider 为 system 。 当用户捕获云服务器后，被捕获的“自有”映像的 provider 为 self 。"
    },
    "enum": [
    "system",
    "self"
    ]
  }
}
```

## Parameters<a name="Parameters"></a>
用于在操作中重用参数。参数定义可以参照这里定义的。
```json
"parameters": {
    "zone": {
        "name": "zone",
        "description": "QingCloud Zone ID",
        "x-description": {
        "zh": "青云区域ID"
      },
        "type": "string",
        "required": true,
        "in": "query"
    }
} 
```

## Responses<a name="ResponsesPublic"></a>
有可重用Responses的对象。


## Extensions<a name="Extensions"></a>
根据需求添加的自定义拓展参数。

### x-scope<a name="x-scope"></a>
接口权限说明，用于生成不同版本的 SDK/CLI/DOC。可选 private，public ，默认 public。

目前 snips 支持在 operation、parameters、schema 中添加。

```json
"/DescribeAccessKeys":{
  "get":{
      "tags":[
          "Accesskey"
      ],
      "x-scope":"private",
      "operationId":"DescribeAccessKeys"
  }
}
```

### x-description<a name="x-description"></a>
多语言描述说明(i18n)。

snips 解析的时候会根据语言配置文件替换 description
```json
"/DescribeVolumes": {
    "get": {
        "tags": [
            "Volume"
        ],
        "operationId": "DescribeVolumes",
        "summary": "DescribeVolumes",
        "description": "Describe volumes filtered by condition.",
        "x-description": {
            "zh": "获取一个或多个硬盘"
        }
}
```

### x-example<a name="x-example"></a>
请求示例，用于生成文档。可定义多个示例。

目前 snips 关于 x-example 的解析还有些问题，请严格按照 “$ref” 依赖路径的方式书写。
```json
"x-example": {
  "$ref": "./example/CreateVolumes.json"
} 
````

```json
{
  "default": {
    "description": "Example1",
    "x-description": {
      "zh": "示例1"
    },
    "parameters": {
    "action": "CreateVolumes",
    "volume_name": "demo",
    "size": 20,
    "zone": "pek3a"
  },
  "responses": {
    "200": {
      "body": {
        "action":"CreateVolumesResponse",
        "job_id":"j-bm6ym3r8",
        "volumes":["vol-j38f2h3h"],
        "ret_code":0
      }
    }
  }
  }
}

```
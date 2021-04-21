# Swagger Validation


## Description
本文档为自动校验工具的安装使用说明。

## Index
- [open-validation](#open-validation)
- [open-diff](#open-diff)

# Openapi-Validation<a name="open-validation"/>


使用的是 [IBM/openapi-validator](https://github.com/IBM/openapi-validator) 提供的关于 swagger 描述文件的合法性校验。

## Installation

### Install with NPM
```sh

npm install -g ibm-openapi-validator

```

### Docker

拉取镜像
```sh

docker pull jamescooke/openapi-validator

```

拉取后可直接运行，但是运行前，需要将本机目录挂载在容器内/data目录下，用于读取 api 描述文件以及 openapi-validator 的配置文件。
```sh

docker run --volume "$PWD":/data jamescooke/openapi-validator [options] [command] [<files>]

```

## Usage
### Command line
```sh
lint-openapi [options] [command] [<files>]
[options]
	-c (--config) <path/to/your/config> : Path to a validator configuration file. If provided, this is used instead of .validaterc.
	-d (--default_mode) : This option turns off configuration and runs the validator in default mode.
	-e (--errors_only) : Only print the errors, ignore the warnings.
	-j (--json) : Output results as a JSON object
	-n (--no_colors) : The output is colored by default. If this bothers you, this flag will turn off the coloring.
	-p (--print_validator_modules) : Print the name of the validator source file the error/warning was caught it. This can be helpful for developing validations.
	-v (--verbose) : Increase verbosity of reported results. Use this option to display the rule for each reported result.
	-r (--ruleset) <path/to/your/ruleset> : Path to Spectral ruleset file, used instead of .spectral.yaml if provided.
	-s (--report_statistics) : Print a simple report at the end of the output showing the frequency, in percentage, of each error/warning.
	--debug : Enable debugging output.
	--version : Print the current semantic version of the validator
	-h (--help) : This option prints the usage menu.
```

### Config
基于之前的规范，详情参考。需要加载两个配置文件。

简单介绍下较与默认配置，修改添加了哪些配置文件

#### **validterc**
统一命名风格，详情见[openapi-authoring-manual-guidelines](../doc/openapi-authoring-manual-guidelines.md)
```json

"shared": {
    "operations": {
      "operation_id_case_convention": [
        "warning",
        "upper_camel_case"
      ]
    },
    ...
    "paths": {
      "paths_case_convention": [
        "error",
        "upper_camel_case"
      ]
    }
```


#### **spectral.yaml**
自定义参数校验, 详情见[openapi-authoring-automated-guidelines.md](../doc/openapi-authoring-automated-guidelines.md.md)

```yaml 
extends: [[spectral:oas, off]]
rules:
  x-description-rule:
    description: Please provide a x-description for {{property}}.
    message: Please provide a x-description for {{property}}.
    given: 
      - $.paths[*][get,post,put,patch,delete,options]
      - $.paths[*].parameters[*]
      - $.paths[*][*].parameters[*]
      - $.paths[*][*].parameters[*].schema.properties[*]
      - $.paths[*][*].responses[*]
      - $.paths[*][*].responses[*].schema.properties[*]
      - $.definitions[*]
    severity: error
    then:
      field: x-description
      function: truthy

  description-rule:
    description: Please provide a description for {{property}}.
    message: Please provide a description for {{property}}.
    given: 
      - $.paths[*][*].parameters[*].schema.properties[*]
      - $.paths[*][*].responses[*].schema.properties[*]
    severity: error
    then:
      field: x-description
      function: truthy

```

### Example
、、、
errors

  Message :   Please provide a x-description for get.
  Path    :   paths./DeleteAccessKeys.get
  Line    :   36

  Message :   Please provide a description for volume_set.
  Path    :   paths./DescribeVolumes.get.responses.200.schema.properties.volume_set
  Line    :   40

  Message :   Parameter objects must have a `description` field.
  Path    :   paths./DescribeVolumes.get.parameters.0
  Line    :   40

warnings

  Message :   Operations must have a non-empty `produces` field.
  Path    :   paths./DescribeImages.get.produces
  Line    :   23

、、、


# openapi-diff<a name="open-diff"/>

使用的是 [OpenAPITools/openapi-diff/](https://github.com/OpenAPITools/openapi-diff/) 提供两个 swagger 描述文件的对比，用于查找本次更新是否有影响向后兼容的问题。

## Installation

### Docker Build

```sh
docker build -t local-openapi-diff .
```

运行前需要将本机路径挂载至容器内 /specs 路径，用于读取spec 文件

```sh
docker run --rm -t \
  -v $(pwd)/core/src/test/resources:/specs:ro \
  openapitools/openapi-diff:latest /specs/path_1.yaml /specs/path_2.yaml
```

## Usage
### Command line

```sh
$ openapi-diff --help
usage: openapi-diff <old> <new>
    --debug                     Print debugging information
    --error                     Print error information
 -h,--help                      print this message
    --header <property=value>   use given header for authorisation
    --html <file>               export diff as html in given file
    --info                      Print additional information
 -l,--log <level>               use given level for log (TRACE, DEBUG,
                                INFO, WARN, ERROR, OFF). Default: ERROR
    --markdown <file>           export diff as markdown in given file
    --off                       No information printed
    --query <property=value>    use query param for authorisation
    --state                     Only output diff state: no_changes,
                                incompatible, compatible
    --fail-on-incompatible      Fail only if API changes broke backward compatibility
    --fail-on-changed           Fail if API changed but is backward compatible
    --trace                     be extra verbose
    --version                   print the version information and exit
    --warn                      Print warning information

```

### Example
```
==========================================================================
==                            API CHANGE LOG                            ==
==========================================================================
                             Swagger Petstore                             
--------------------------------------------------------------------------
--                              What's New                              --
--------------------------------------------------------------------------
- GET    /pet/{petId}

--------------------------------------------------------------------------
--                            What's Deleted                            --
--------------------------------------------------------------------------
- POST   /pet/{petId}

--------------------------------------------------------------------------
--                          What's Deprecated                           --
--------------------------------------------------------------------------
- GET    /user/logout

--------------------------------------------------------------------------
--                            What's Changed                            --
--------------------------------------------------------------------------
- PUT    /pet
  Request:
        - Deleted application/xml
        - Changed application/json
          Schema: Backward compatible
- POST   /pet
  Parameter:
    - Add tags in query
  Request:
        - Changed application/xml
          Schema: Backward compatible
        - Changed application/json
          Schema: Backward compatible
- GET    /pet/findByStatus
  Parameter:
    - Deprecated status in query
  Return Type:
    - Changed 200 OK
      Media types:
        - Changed application/xml
          Schema: Broken compatibility
        - Changed application/json
          Schema: Broken compatibility
- GET    /pet/findByTags
  Return Type:
    - Changed 200 OK
      Media types:
        - Changed application/xml
          Schema: Broken compatibility
        - Changed application/json
          Schema: Broken compatibility
- DELETE /pet/{petId}
  Parameter:
    - Add newHeaderParam in header
- POST   /pet/{petId}/uploadImage
  Parameter:
    - Changed petId in path
- POST   /user
  Request:
        - Changed application/json
          Schema: Backward compatible
- POST   /user/createWithArray
  Request:
        - Changed application/json
          Schema: Backward compatible
- POST   /user/createWithList
  Request:
        - Changed application/json
          Schema: Backward compatible
- GET    /user/login
  Parameter:
    - Delete password in query
- GET    /user/logout
- GET    /user/{username}
  Return Type:
    - Changed 200 OK
      Media types:
        - Changed application/xml
          Schema: Broken compatibility
        - Changed application/json
          Schema: Broken compatibility
- PUT    /user/{username}
  Request:
        - Changed application/json
          Schema: Backward compatible
--------------------------------------------------------------------------
--                                Result                                --
--------------------------------------------------------------------------
                 API changes broke backward compatibility                 
--------------------------------------------------------------------------
```

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

使用的是 [Sayi/swagger-diff](https://github.com/Sayi/swagger-diff) 提供两个 swagger 描述文件的对比，用于查找本次更新是否有影响向后兼容的问题。

## Installation

### Docker Build

```sh
docker build -t sayi/openapi-diff .
```

运行前需要将本机路径挂载至容器内 /specs 路径，用于读取spec 文件

```sh

docker run --rm -t \
  -v $(pwd)/core/src/test/resources:/specs:ro \
  sayi/openapi-diff:latest -old /specs/path_1.yaml -new /specs/path_2.yaml
```

## Usage
### Command line

```sh
$ java -jar swagger-diff.jar --help
Usage: java -jar swagger-diff.jar [options]
  Options:
  * -old
      old api-doc location:Json file path or Http url
  * -new
      new api-doc location:Json file path or Http url
    -v
      swagger version:1.0 or 2.0
      Default: 2.0
    -output-mode
      render mode: markdown or html
      Default: markdown
    --help

    --version
      swagger-diff tool version

```

### Example
```
### What's New
---
* `GET` /pet/{petId} Find pet by ID

### What's Deprecated
---
* `POST` /pet/{petId} Updates a pet in the store with form data

### What's Changed
---
* `PUT` /pet Update an existing pet  
    Parameter

        Add body.newFeild //a feild demo by sayi
        Add body.category.newCatFeild
        Delete body.category.name
* `POST` /pet Add a new pet to the store  
    Parameter

        Add tags //add new query param demo
        Add body.newFeild //a feild demo by sayi
        Add body.category.newCatFeild
        Delete body.category.name
* `DELETE` /pet/{petId} Deletes a pet  
    Parameter

        Add newHeaderParam
* `POST` /pet/{petId}/uploadImage uploads an image for pet  
    Parameter

        petId change into not required Notes ID of pet to update change into ID of pet to update, default false
* `POST` /user Create user  
    Parameter

        Add body.newUserFeild //a new user feild demo
        Delete body.phone
* `GET` /user/login Logs user into the system  
    Parameter

        Delete password //The password for login in clear text
* `GET` /user/{username} Get user by user name  
    Return Type

        Add newUserFeild //a new user feild demo
        Delete phone
* `PUT` /user/{username} Updated user  
    Parameter

        Add body.newUserFeild //a new user feild demo
        Delete body.phone
```

## TODO
- [ ] 修改跨文件 ref 路径问题
- [ ] 添加 "backward compatibility" 提醒
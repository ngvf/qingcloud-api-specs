## Description
基于snips项目，做了一些简单修改。
- 原项目地址:  [Github/snips](https://github.com/qingstor/snips)
- 项目地址: [Gitlab/snips](https://git.internal.yunify.com/Ryan/snips)


## Template 
参考：
> - simple-templates
> - [golang template 语法](https://colobu.com/2019/11/05/Golang-Templates-Cheatsheet/)


### Function
```
var funcMap = template.FuncMap{
	"snakeCase": 		utils.SnakeCase,
	"camelCase": 		utils.CamelCase,

	"lower":          	lower,
	"upper":          	upper,
	"lowerFirst":     	utils.LowerFirstCharacter,
	"lowerFirstWord": 	utils.LowerFirstWord,
	"upperFirst":     	utils.UpperFirstCharacter,
	"short":          	utils.ShotCutWord,
	"normalized":     	normalized,
	"dashConnected":  	dashConnected,

	"commaConnected":          commaConnected,
	"commaConnectedWithQuote": commaConnectedWithQuote,

	"replace":     				replace,
	"passThrough": 				passThrough,
	"exist":       				exist,

	"firstPropertyIDInCustomizedType": firstPropertyIDInCustomizedType,

	"statusText": statusText,

	"jsonPretty": jsonPretty,
}
```

## Updated Items
- 项目依赖管理由 **golide** 改为 **go mod**
- 字典模块 添加 **shortCutWordMap**，适用于 CLI 长短参数映射，例如(-i --image)
- 模板类型 添加 **operation**（subService的子节点），适用于 单个operation 生成一个类(文件)
- 解析模块 添加对于 **"x-scope"** 的解析，用于生成 不同版本（public or private）的 sdk/cli/doc。
- 解析模块 添加对于 **"x-description"** 的解析，用于显示 多语言的说明/描述。
- 自定义函数 添加 **"upper"**（切换大写） 和 **"short"**（生成缩写/短命令）。
- 配置文件 添加 对于输出路径的结构自定义
- 添加对 **"x-example"** 的解析
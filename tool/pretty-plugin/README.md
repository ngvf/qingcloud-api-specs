# Json Pretty Plugin #

## Description
Json 合法性检查，格式化工具 

## Usage
```sh
Usage:
  json-pretty [flags]

Flags:
  -d, --dirPath 	string      Specify the json dir path.
  -f, --filePath 	string   	Specify the json file path.
  -h, --help              	    help for json-pretty
  -r, --replace     bool        Replace original with update. Default false
```
### Tips
- 如果同时传了 filePath 和 dirPath ，将忽略 dirPath 。
- replace 为 false 的时候，会在相同目录生成 .tmp 文件；
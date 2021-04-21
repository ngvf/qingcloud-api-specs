# Description
该目录提供调用工具检查的脚本。

# Use
```sh 
sh ./check-script.sh
```

# Conf
```sh
WORK_PATH=/path/api-specs/			# 本地 api specs 路径
FILE_NAME=api-profile.json			# api-profile 文件名

TEMP_PATH=/temp/path/api-specs/		# 临时目录(最好是空目录)，用于拉取远端代码
GIT_URL=git@git.internal.yunify.com:xx/api-specs.git
GIT_BRANCH=dev
``` 

# Example
```shell
Starting...
-----------------------------------------------------
 [Info]: Passed json validatation
-----------------------------------------------------

warnings

  Message :   Schema properties specified as 'required' should be defined
  Path    :   paths./DeleteImages.get.parameters.0.schema.required[0]
  Line    :   26

 [Info]: Passed swagger validatation
-----------------------------------------------------
Initialized empty Git repository in /Users/liruiheng/Work/Temp/.git/
Updating origin
remote: Counting objects: 33, done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 33 (delta 12), reused 0 (delta 0)
Unpacking objects: 100% (33/33), done.
From git.internal.yunify.com:Ryan/qingcloud-api-specs
 * [new branch]      dev        -> origin/dev
 * [new branch]      master     -> origin/master
 * [new tag]         BUILD_20210420 -> BUILD_20210420
From git.internal.yunify.com:Ryan/qingcloud-api-specs
 * branch            dev        -> FETCH_HEAD
==========================================================================
==                            API CHANGE LOG                            ==
==========================================================================
                                QingCloud
--------------------------------------------------------------------------
--                            What's Changed                            --
--------------------------------------------------------------------------
- GET    /CreateVolumes
  Request:
        - Changed */*
          Schema: Broken compatibility
--------------------------------------------------------------------------
--                                Result                                --
--------------------------------------------------------------------------
                 API changes broke backward compatibility
--------------------------------------------------------------------------

 [Error]: API changes broke backward compatibility. You may need to update version
```
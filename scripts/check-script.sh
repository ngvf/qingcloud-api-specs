#!/bin/bash


function echo_color() {
    if [ $# -ne 2 ];then
            echo "Usage:$0 content {red|pink|yellow|green}"
            exit 1
    fi
    if [ $2 == 'red' ];then
            echo "\033[31m $1 \033[0m"
    elif [ $2 == 'green' ];then
            echo "\033[32m $1 \033[0m"
    elif [ $2 == 'yellow' ];then
            echo "\033[33m $1 \033[0m"
    elif [ $2 ==  'blue' ];then
            echo "\033[34m $1 \033[0m"
    fi
}

SCRIPT_DIR="$( cd "$( dirname "$0"  )" && pwd  )"
source $SCRIPT_DIR/conf.ini
RET=$?
if [ ! $RET -eq 0 ]; then
	echo_color "[Error]: Not found config file" "red"
fi

echo "Starting..."
echo "-----------------------------------------------------"

RE_TEXT=$(docker run --volume $WORK_PATH:/data qingcloud/openapi-tools \
	./json-pretty  \
	-d /data/specs  \
	-r true)

RET=$?
if [ ! $RET -eq 0 ]; then
	echo $RE_TEXT
	echo_color "[Error]: Failed json validatation" "red"
    exit 1
else
	echo_color "[Info]: Passed json validatation" "green"
fi
echo "-----------------------------------------------------"

docker run --volume $WORK_PATH:/data:ro qingcloud/openapi-tools \
	lint-openapi \
	-r ./spectral.yml \
	-c ./validaterc \
	/data/specs/api-profile.json

RET=$?
if [ ! $RET -eq 0 ]; then
	echo_color "[Error]: Failed swagger validatation" "red"
    exit 1
else
	echo_color "[Info]: Passed swagger validatation" "green"
fi
echo "-----------------------------------------------------"

cd $TEMP_PATH
git init . 
git remote add -f origin git@git.internal.yunify.com:Ryan/qingcloud-api-specs.git
git config core.sparsecheckout true
echo "specs/" >> .git/info/sparse-checkout
git pull origin dev


docker run --volume $WORK_PATH:/data:ro \
	--volume $TEMP_PATH:/temp:ro \
  	qingcloud/openapi-tools \
  	java -jar ./openapi-diff-cli.jar \
  	--fail-on-incompatible \
  	/temp/specs/api-profile.json /data/specs/api-profile.json

RET=$?
if [ ! $RET -eq 0 ]; then
	echo $RE_TEXT
	echo_color "[Error]: API changes broke backward compatibility. You may need to update version" "red"
    exit 1
else
	echo_color "[Info]: Passed swagger comparison" "green"
fi

echo "-----------------------------------------------------"

echo_color "Finish~" "blue"

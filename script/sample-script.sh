#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$0"  )" && pwd  )"
source $SCRIPT_DIR/conf.ini

docker run --volume $WORK_PATH:/data qingcloud/openapi-tools-test \
	./json-pretty \
	-d /data/spec \
	-r true

RETURN=$?
if [ ! $RETURN -eq 0 ]; then
     exit 1
fi

docker run --volume $WORK_PATH:/data:ro qingcloud/openapi-tools-test \
	lint-openapi \
	-r ./spectral.yml \
	-c ./validaterc \
	/data/spec/api-profile.json

RETURN=$?
if [ ! $RETURN -eq 0 ]; then
     exit 1
fi

cd $TEMP_PATH
git init . 
git remote add -f origin git@git.internal.yunify.com:Ryan/qingcloud-api-specs.git
git config core.sparsecheckout true
echo "spec/" >> .git/info/sparse-checkout
git pull origin dev

docker run --volume $WORK_PATH:/data:ro \
	--volume $TEMP_PATH:/temp:ro \
  	qingcloud/openapi-tools-test \
  	java -jar ./swagger-diff.jar \
  	-new /data/spec/api-profile.json -old /temp/spec/api-profile.json
echo $?

# Gitlab-CI

## Description
该文档介绍如何使用 Gitlab-CI/CD 进行 swagger-validation 以及 code-gen。

## Create .gitlab-ci.yml
### api-specs-project
![](./specs-CI.png)

#### jobs
* swagger-validation: 校验 swagger 的合法性。
    - commit/push：适用于所有分支
    - merged result：适用于所有分支
          
* swagger-diff：用于对于 swagger 的修改项和兼容性问题。
    - merge request：仅对 protected 分支使用(例如：master，staging，dev)
    
* code-gen-trigger（建议）: 触发 code-gen 项目的生成代码 job。必须再通过 swagger-validation 后才会执行
    - merged result：仅对 protected 分支使用(例如：master，staging，dev)
    - commit/push：仅对 protected 分支使用(例如：master，staging，dev)
    
#### .gitlab-cl.yml
以下 _.gitlab-cl.yml_ 可供参考。
```yaml
image: qingcloud/openapi-tools  # pipeline 运行的镜像，以下所有 script 都在该镜像中执行。

stages:   # 用于定义场景阶段，决定执行顺序
  - validation
  - diff
  - code_gen

valid_job:
  stage: validation 
  tags:  # 指定哪个ci runner跑该工作
    - docker
  script:
    - REPO=$PWD
    - cd /app
    - lint-openapi $REPO/specs/api-profile.json -r spectral.yml -c validaterc
    
  
compare_job:
  stage: diff
  tags:
    - docker
  script:
    # 获取待 merge 的分支名称
    - 'CI_TARGET_BRANCH_NAME=$(curl -LsS -H "PRIVATE-TOKEN: $CI_ACCESS_TOKEN" "http://$CI_SERVER_HOST/api/v4/projects/$CI_PROJECT_ID/merge_requests?source_branch=$CI_COMMIT_REF_NAME" | jq --raw-output ".[0].target_branch")' 
    # 拉取代码
    - git clone -b $CI_TARGET_BRANCH_NAME http://gitlab-ci-token:${CI_JOB_TOKEN}@$CI_SERVER_HOST/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME.git ./target_branch
    - java -jar /app/openapi-diff-cli.jar --fail-on-incompatible 
      ./specs/api-profile.json ./target_branch/specs/api-profile.json
  rules:
    # 仅在 merge request 时触发
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'


code_gen_job:
  stage: code_gen
  tags:
    - docker
  script:
    # 调用 api 触发 code-gen pipeline
    - curl --request POST  -F token=${CI_DOC_PIPLINE_TOKEN}  -F ref=master -F "variables[CI_SPECS_TOKEN]=$CI_ACCESS_TOKEN"  -F "variables[CI_SPECS_PATH]=$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME"  http://$CI_SERVER_HOST/api/v4/projects/${CI_DOC_PROJECT_ID}/trigger/pipeline
    # - "curl --request POST --form token=${CI_SDK_PROJECT_TOKEN} --form ref=master http://$CI_SERVER_HOST/api/v4/projects/${CI_SDK_PROJECT_ID}/trigger/pipeline"
    # - "curl --request POST --form token=${CI_CLI_PROJECT_TOKEN} --form ref=master http://$CI_SERVER_HOST/api/v4/projects/${CI_CLI_PROJECT_ID}/trigger/pipeline"
  only:
    - master

```

### code-gen
![](./code-gen-CI.png)
#### jobs
* code-gen: 生成代码。
    - trigger：通过 api-specs 调用api触发，仅对 protected 分支使用(例如：master，staging，dev)

#### .gitlab-ci.yml
```yaml
image: qingcloud/openapi-tools

before_script:
  # 拉取 specs 代码
  - git clone -b master http://$CI_SPECS_USER:$CI_SPECS_TOKEN@$CI_SERVER_HOST/$CI_SPECS_PATH.git /app/api-specs

stages:
  - private
  - public

private_job:
  stage: private
  tags:
    - docker

  script:
    - SCOPE=private
    - DATE=$(date "+%Y%m%d%H%M%S")
    - NEW_BRANCH=${CI_COMMIT_REF_NAME}_${SCOPE}_${DATE}
    - git config --global user.email "${GITLAB_USER_EMAIL}"
    - git config --global user.name "${GITLAB_USER_NAME}"
    - git checkout -B $NEW_BRANCH
    - /app/snips -f /app/api-specs/specs/api-profile.json  -t ./api/template -o ./api  -s $SCOPE
    - git add ./api
    - git commit -m "[update] auto update ${SCOPE} ${DATE}" && 
      git push http://$CI_PERSONAL_USERNAME:$CI_PERSONAL_TORKEN@$CI_SERVER_HOST/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME.git -u $NEW_BRANCH &&
    # create merge request
    - 'curl "http://$CI_SERVER_HOST/api/v4/projects/$CI_PROJECT_ID/merge_requests" 
        --header "PRIVATE-TOKEN: $CI_PERSONAL_TORKEN" 
        --form "id=$CI_PROJECT_ID" 
        --form "title=auto update ${SCOPE} ${DATE}"
        --form "source_branch=$NEW_BRANCH" 
        --form "target_branch=$CI_COMMIT_REF_NAME"
        --form "remove_source_branch=true"'
  rules:
    - if: '$CI_PIPELINE_SOURCE == "trigger"'
```
## Variables
预定义的 CI/CD 的变量，在进行 CI/CD pipeline 时都是有效的。具体参数请参考 [官方文档](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html) 。
> 使用时请注意参数有效的 GitLab version（公司目前是 11.1.8）

### Custom variables
| key  | scope |comment | example | 
| ---  | --- | --- | --- |
| GITLAB_SERVER_HOST |  global  | gitlab 域名 | git.internal.yunify.com
| USER_PERSONAL_ACCESS_TOKEN | owned projects | 用于调用 api，读写仓库 |  |
| PROJECT_DEPLOY_TOKENS | project | 仅读仓库 |  |
| TARGET_PROJECT_PIPELINE_TOKEN | project | 跨项目触发 CI


## Gitlab Runner
```ini
[runners.docker]
    image = "qingcloud/openapi-tools"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    # 使用外部的 docker.sock ，也就是间接地使用了 runner 的宿主机的 docker
    volumes = ["/cache", "/run/docker.sock:/run/docker.sock"]
    # Runner会首先检查本地是否有该image，如果有则用本地的，如果没有则从远程拉取
    pull_policy = ["if-not-present"]
    shm_size = 0
```
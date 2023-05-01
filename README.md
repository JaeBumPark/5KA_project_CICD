# 5KA_project_CICD
- 카카오 클라우드 스쿨 2기 엔지니어 양성과정에서 Team project로 진행한 Project 중 CI/CD part에서 사용된 코드들 입니다.

- On-premise 환경에서 Opensource(Jenkins, Argocd, Gitlab)을 설치하는 manifestfile들과 AWS Eks 환경에서 Opensource(Jenkins, Argocd, Gitlab)을 설치하는 manifestfile들이 각각 On-premise_Opensource_install과 EKS_OpenSource_install repo로 나누어져 있습니다.

- CI를 위해 Jenkins가 참조하는 Source_template repo가 docker로 서비스를 빌드 할 경우, kaniko로 서비스를 빌드 하는 경우 2가지 방법을 고려하여 2가지 repo로 구성되어 있습니다.

- CD를 위해 Argocd가 참조하는 Deploy_template repo가 helm chart 형식으로 구성되어 있습니다.

## Architecture

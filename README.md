# Cloud, K8S를 이용한 개발환경 자동 구축 시스템
- 카카오 클라우드 스쿨 2기 엔지니어 양성과정에서 Team project로 진행한 Project 중 CI/CD part에서 사용된 코드들 입니다.

- On-premise 환경에서 Opensource(Jenkins, Argocd, Gitlab)을 설치하는 manifestfile들과 AWS Eks 환경에서 Opensource(Jenkins, Argocd, Gitlab)을 설치하는 manifestfile들이 각각 On-premise_Opensource_install과 EKS_OpenSource_install repo로 나누어져 있습니다.

- CI를 위해 Jenkins가 참조하는 Source_template repo가 docker로 서비스를 빌드 할 경우, kaniko로 서비스를 빌드 하는 경우 2가지 방법을 고려하여 2가지 repo로 구성되어 있습니다.

- CD를 위해 Argocd가 참조하는 Deploy_template repo가 helm chart 형식으로 구성되어 있습니다.

# 프로젝트 상세
## 1. 시연 영상

[![Video Label](http://img.youtube.com/vi/e50cfM8ad88/0.jpg)](https://youtu.be/e50cfM8ad88)

## 2. Service 기능

### 2-1. 회원가입 화면

<img width="1440" alt="Untitled (7)" src="https://user-images.githubusercontent.com/100124605/235409554-10ede4dc-8d78-42e2-ae55-9e79a4bd1bae.png">

- Service 접속 후 첫 이용시, 개발자의 id, password, 이름, 이메일 등 User 정보, 소속된 부서들을 기입하여 회원 가입
- 회원가입 시 해당 User 정보를 기반으로 Gitlab, Jenkins에 User를 생성하여 부서 내에서 진행되는 Project에 대해서만 권한을 가지도록 설정
- 소속 부서를 기입 후 회원가입 시 Gitlab, Jenkins 등의 Opensource 내의 해당 부서 별 프로젝트만 접근 할 수 있도록 생성된 user를 Opensource의 Group or Role에 가입시키는 방식으로 권한을 설정

### 2-2. 로그인 후 Projects 조회 및 생성 화면

<img width="1438" alt="Untitled (8)" src="https://user-images.githubusercontent.com/100124605/235409698-485d770d-4e9f-44ad-8194-2befb756f755.png">

- 회원가입 시 생성한 ID와 pwd로 로그인 시, 소속 부서 내에서 진행되고 있는 Project 들이 보여짐
- Project 생성 버튼 클릭 시 소속 부서내 새로운 Project가 생성

### 2-3. 로그인 후 Projects 조회 및 생성 화면

<img width="1439" alt="Untitled (9)" src="https://user-images.githubusercontent.com/100124605/235409785-a8c4611c-e43c-4991-9a2f-a971bf6319ef.png">

- Project내 Application 생성화면
- Application Project type 설정 후 생성 시  Gitlab에 존재하는 application이 사용하는 framework 별 Template code를 fork 하여 Gitlab 내에 /{team}/source/{application-name}, /{team}/helm/{application-name} 경로에 Application 별 Application Source code Repo, Deployment code ****Repo가 생성
- Jenkins의 경우 Application 생성 시 해당 Application 별 Pipeline이 생성

<img width="1440" alt="Untitled (2) (1)" src="https://user-images.githubusercontent.com/100124605/235409838-ae7c0a55-0ebe-4b60-809a-685df5c862b7.png">

- Application 생성 후 조회 화면
- Build 버튼 클릭 시 해당 Application의 Pipeline이 작동되며 Jenkins가 Application을 build
- Deploy 버튼 클릭 시 Argocd가 해당 Application을 User가 속해있는 부서 별 cluster에 Deploy
- GitLab(source), GitLab(gitops) 버튼 클릭 시 각각 해당 Application의 Application Source code Repo, Deployment code ****Repo로 이동, User는 Source code Repo에 있는 code를 git clone → 코드 수정 → push 하는 방법으로 code를 변경 후 Build 및 Deploy를 진행
- Jenkins, Argocd, Grafana, Kibana 버튼 클릭 시 각 Opensouce 별 url로 접속 가능

### 2-4. Service 동작도

![Untitled (10)](https://user-images.githubusercontent.com/100124605/235409907-e3b60c1d-bb99-42b8-b545-c69a6c02b69f.png)


## 3. CI/CD pipeline 구축 전략

![Untitled (11)](https://user-images.githubusercontent.com/100124605/235410038-7d848412-57ea-43c4-aa59-b7dc3998f8e3.png)

### 3-1.  GitOps 방식으로 CI/CD pipe line 구축

- 애플리케이션의 배포와 운영에 관련된 모든 요소를 코드화하여 확장성, 안정성, 보안성을 보장하는 GitOps-based CI/CD pipeline 구축
- Application Source code Repo 와  Deployment code ****Repo로 애플리케이션/ 배포 manifest code를 나누어 Git 형상 관리
- Deployment code ****Repo 내의 manifest file은 Helm chart 형식으로 작성하여 배포의 유연성과 수월한 버전 관리를 보장

### 3-2. Jenkins Master/agent를 나누어 Jenkis job 실행

- Build 환경의 보안, Pipeline 병렬 실행시 안정성 등의 이유로 Docker image build와 push가 일어나는 환경을 Central cluster에 Pod 형태로 구축하여 Jenkins Master와 Agent 실행 환경을 격리

### 3-3. Docker build tool로 Kaniko를 도입

- build 속도 최적화를 위해  agent pod으로 Kaniko를 띄워 build를 진행
- image build시  nexus cache repository를 참조하여 build 속도를 향상시키도록 구현

# Architecture

## 1. Service Architecture

![Untitled (12)](https://user-images.githubusercontent.com/100124605/235410219-36424ed5-c3ca-41cc-9d86-8a8e59fffaef.png)


- (1). 신입 개발자가 application의 code를 변경 및 수정
- (2). 변경된 code를 Gitlab Application Source code repository에 push
- (3). 중앙 관리 Cluster인 Central Cluster에 위치한Jenkins가 변경된 코드를 기반으로 application build → 변경 사항을 반영하여 Dockerfile을 이용해 Docker image build
- (4). Docker image를 nexus repository에 push & 생성된 Docker image의 tag 기반으로 Gitlab의 배포 환경 구성  저장소의 deploy manifest file 변경
- (5). Central Cluster에 위치한 Argocd가 Gitlab의 배포 환경 구성 저장소의 manifest를 참조해 새로 Push 된 Docker image 기반으로 Application을 K8s resource 형태로 deploy를 준비
- (6). Argocd가 신입 개발자가 소속된 부서에게 제공된 Cluster 내에 Application을 배포
- (7). 리소스 Monitoring tools는 Central Cluster와 부서 별 Cluster에 배포돼 있는 상태

## 2.  Infra Architecture

<img width="411" alt="Untitled (13)" src="https://user-images.githubusercontent.com/100124605/235410250-0c352352-1bdd-47b7-bdb1-00582578e716.png">

- 번호는 인터넷의 흐름을 표시
- 보안상에 이유로 Public, Private, Intra Subnet을 구성
- EKS Node group은 Private subnet에 배치 후 Public Subnet의 Bastion server로만 접속할 수 있도록 설정
- RDS는 Intra Subnet에 배치 후 Back-end와 통신하도록 설정
- Autoscaling을 통해 EKS의 Node 갯수를 관리
- 개발한 서비스와 Opensource들은 Kubernetes ingress와 ALB, SSL, Route 53을 연동시켜 URL로 접근할수 있도록 설정
- back-end, front-end, Open-source 구동 시 사용되는 Docker image들은 ECR에 팀원들만 사용할 수 있도록 권한을 제어하여 관리
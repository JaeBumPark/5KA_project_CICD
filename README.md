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
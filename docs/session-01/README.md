# 세션 1: Azure로 step by step 배포하기

첫 번째 세션에서는 Azure에 익숙해 지기 위한 첫 단계로, 포털과 Visual Studio Code를 이용한 수동 배포와 `bicep`, `Azure Developer CLI`, `Github Action`을 이용한 자동 배포를 학습합니다.

1. 수동으로 리소스들을 프로비저닝 하는 방법
2. Visual Studio Code를 이용해서 수동으로 배포하는 방법
3. IaC(Infra as Code)인 `bicep`과 `Azure Developer CLI`로 쉽게 자동 프로비저닝 하는 방법
4. `Github Action`으로 자동 배포하는 방법

## 사전 준비물


---

나중에 문서 작성할 때 아래 내용 참고하세요

- .NET API (깃헙 Issue API) 사용할 때 필요함
  - 애저 APIM 권한 부여 (Authorization): https://learn.microsoft.com/azure/api-management/authorizations-overview
  - GitHub OAuth App: https://docs.github.com/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app

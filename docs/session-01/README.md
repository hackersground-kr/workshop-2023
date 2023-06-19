# 세션 1: Azure로 step-by-step 배포하기

첫 번째 세션에서는 Azure에 익숙해 지기 위한 첫 단계로, 포털과 Visual Studio Code를 이용한 수동 배포와 `bicep`, `Azure Developer CLI`, `GitHub Action`을 이용한 자동 배포를 학습합니다.

1. [Azure 포털에서 리소스 생성하기](./01-portal-provision.md) & [Azure 포털에서 리소스 구성 설정하기](./02-portal-works.md)
2. [Visual Studio Code에서 원클릭 배포하기](./03-vscode.md) & [API Management 수동 설정하기](./04-apim-config.md)
3. [IaC(Infra as Code)인 `bicep`과 `Azure Developer CLI`로 쉽게 자동 프로비저닝 하는 방법](./05-bicep-azd-provision.md)
4. [`GitHub Action`으로 자동 배포하는 방법](./06-ghactions.md)

## 사전 준비물

* [Azure 구독](https://azure.microsoft.com/ko-kr/free/?WT.mc_id=dotnet-91712-juyoo)
* [ChatGPT API Key](https://platform.openai.com/account/api-keys)
* Fork한 workshop 레포
* `session01/manual` 브랜치 생성

<!-- ---

나중에 문서 작성할 때 아래 내용 참고하세요

- .NET API (깃헙 Issue API) 사용할 때 필요함
  - 애저 APIM 권한 부여 (Authorization): https://learn.microsoft.com/azure/api-management/authorizations-overview
  - GitHub OAuth App: https://docs.github.com/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app -->

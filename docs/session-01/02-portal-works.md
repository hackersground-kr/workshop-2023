# Azure Portal에서 리소스 구성 설정하기

각 앱마다 설정해야 하는 부분들을 배포 전에 매뉴얼하게 설정합니다.

## API Key 생성하기
랜덤으로 uuid string을 API key로 사용합니다. 이 key 값이 있어야 API를 호출할 수 있습니다.
```bash
api_key=$(uuidgen)
echo $api_key
```

echo로 출력한 api_key 값을 복사합니다.

## Issue API 구성 설정하기
* 환경 변수 설정
  * `설정` > `구성` > `애플리케이션 설정` > `고급 편집` 에 아래의 환경 변수들을 추가합니다.
  ```json
  {
    "name": "Auth__ApiKey",
    "value": "{{api_key값}}",
    "slotSetting": false
  },
  {
    "name": "GitHub__Agent",
    "value": "GitHub Issues Bot",
    "slotSetting": false
  },
  {
    "name": "OpenApi__IncludeOnDeployment",
    "value": "true",
    "slotSetting": false
  },
  {
    "name": "OpenApi__Server",
    "value": "https://{{앱 이름}}.azurewebsites.net",
    "slotSetting": false
  },
  {
    "name": "OpenApi__Title",
    "value": "GitHub Issues API",
    "slotSetting": false
  },
  {
    "name": "OpenApi__Version",
    "value": "v1",
    "slotSetting": false
  }
  ```

## Chat API 구성 설정하기
* 환경 변수 설정
  * `설정` > `구성` > `애플리케이션 설정` > `고급 편집` 에 아래의 환경 변수들을 추가합니다.
  ```json
  {
    "name": "AOAI_API_DEPLOYMENT_ID",
    "value": "gpt-3.5-turbo",
    "slotSetting": false
  },
  {
    "name": "AOAI_API_ENDPOINT",
    "value": "https://api.openai.com/v1/chat/completions",
    "slotSetting": false
  },
  {
    "name": "AOAI_API_KEY",
    "value": "{{API_KEY 수동 입력}}",
    "slotSetting": false
  },
  {
    "name": "AOAI_API_VERSION",
    "value": "to_be_replaced",
    "slotSetting": false
  },
  {
    "name": "Auth__ApiKey",
    "value": "{{api_key값}}",
    "slotSetting": false
  },
  {
    "name": "SCM_DO_BUILD_DURING_DEPLOYMENT",
    "value": "1",
    "slotSetting": false
  }
  ```

## Storage API 구성 설정하기
* AzureSQL DB 연결 문자열 가져오기
    * `SQL 데이터베이스` > `연결 문자열` > `ODBC` 값 복사

* 연결 문자열 설정
  * `설정` > `구성` > `애플리케이션 설정` > `연결 문자열`
  * `새 연결 문자열`
    * 이름: `STORAGE`
    * 값: `AzureSQL DB 연결 문자열` 붙여넣은 후에 `Pwd={your_password_here}` 부분에 실제 DB 비밀번호 입력
    * 형식: `SQLAzure`

* 환경 변수 설정
  * `설정` > `구성` > `애플리케이션 설정` > `애플리케이션 설정` > `고급 편집` 에 아래의 환경 변수들을 추가합니다.
  ```json
  {
    "name": "Auth__ApiKey",
    "value": "{{api_key값}}",
    "slotSetting": false
  },
  {
    "name": "SCM_DO_BUILD_DURING_DEPLOYMENT",
    "value": "1",
    "slotSetting": false
  }
  ```

* 시작 명령 설정
  * `설정` > `구성` > `일반 설정` > `시작 명령`
  ```bash
  pip install -r requirements.txt && python -m uvicorn main:app --host 0.0.0.0
  ```

## API Management 구성 설정하기

API Management는 API들이 배포된 후에 OpenAPI 문서를 이용해서 편리하게 API를 import 해 올 것입니다.

우선은 API를 가져오기 전에 전체 API들을 위한 Policy 설정을 합니다.

* `APIs` > `API` > `All APIs`
  * Inbound의 `Add Policy` > `cors` 선택
    * `Basic` 옵션 선택
    * `Allowed origins`: `https://{{apim이름}}.azure-api.net`, `https://{{정적웹앱 URL}}`
  * Inbound의 `Add Policy` > `set-header` 선택
    * name: `x-webapi-key`
    * value: `{{api_key값}}`
    * action: `override`

<!-- 정적 웹 앱의 `API` 메뉴로 들어갑니다.

만약 `링크`가 활성화되어 있지 않다면 해당 메뉴 상단에 `업그레이드하려면 클릭하세요` 를 선택해서 요금제를 업그레이드 합니다.

요금제를 업그레이드 하면 `Production` 하단의 `링크`가 활성화 됩니다.

`링크`를 클릭하여 `API 관리`(==`API Managment`) 리소스 종류를 연결합니다.  -->


[Azure 포털에서 리소스 프로비저닝하기](./01-portal-provision.md) 👈 이전 | 다음 👉 [VSCode에서 원클릭 배포하기](./03-vscode.md)
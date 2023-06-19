# Visual Studio Code에서 원클릭 배포하기

## 로컬에서 앱 실행하기
세션2의 Codespace를 이용할 때는 모든 언어 구성 팩, 프레임워크나 라이브러가 모두 설치되어 있기 떄문에 간편하게 실행할 수 있습니다. 

하지만 사용자의 로컬 환경에서 이 앱을 모두 실행해서 테스트 하기 위해서는 .NET7, Java17, Python 3.11, Javascript 가 모두 설치 되어 있어야 하며 각 언어에 부합하는 툴체인과 라이브러리도 필요합니다.

그렇기 때문에 이번 세션에서는 Visual Studio Code를 이용하여 바로 배포를 진행 한 후 테스트를 진행합니다.

만약 로컬에서 앱을 실행해 보고 싶다면 아래와 같은 방법을 따릅니다.

1. Issue API .NET 실행
    ```bash
    cd issue-api
    dotnet build
    dotnet run
    ```
2. Chat API Java 실행
    
    `application-dev.properties` 파일 생성
    ```bash
    cd chat-api/src/main/resources
    touch application-dev.properties
    ```

    `application-dev.properties` 파일에 아래 내용 추가
    ```
    AOAI_API_ENDPOINT=https://api.openai.com/v1/chat/completions
    AOAI_API_KEY=API_KEY_HERE
    AOAI_API_DEPLOYMENT_ID=gpt-3.5-turbo

    Auth__ApiKey=apikey
    ```
    스프링 부트 앱 실행
    ```bash
    cd chat-api
    ./mvnw spring-boot:run
    ```
    Chat API는 `/chat-api` 에 추가 `README.md`가 있으니 참고하세요.

3. Storage API Python 실행
   ```bash
    cd storage-api
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    uvicorn main:app --reload #FastAPI 앱 실행
    ```
4. Frontend React 실행
    ```bash
    cd web
    npm install
    npm run start
    ```

## Azure extension 설치하기

Visual Studio Code에는 무료로 사용할 수 있는 수많은 확장 extension이 있습니다.

우리는 Azure로 원클릭 배포를 하기 위해 Azure extension을 설치합니다.

Visual Studio Code 좌측에 `Extension` 메뉴를 클릭해 `Azure`를 검색합니다.

![Azure Extension](images/azureextension.png)

설치 Extension들:

* Azure Tools
* Azure App Service
* Azure Static Web Apps
* Azure API Management

## API 웹 앱 배포하기

본인의 구독 밑에서 포털에서 만들어 둔 앱 서비스를 찾아 마우스 오른쪽을 클릭해 `Deploy to Web App`을 누릅니다.

![앱 서비스 배포](images/webapp_deploy.png)

`Deploy to Web App`을 누르면 아래와 같은 화면이 나옵니다.


여기서 각 앱 서비스에 맞는 경로를 선택합니다.

* Issue API: `issue-api`
* Chat API: `chat-api`
* Storage API: `storage-api`

## 정적 웹 앱 배포하기


## API Management 설정하기



[Azure Portal에서 리소스 구성하기](./02-portal-works.md) 👈 이전 | 다음 👉 [Bicep & Azure Developer CLI로 한 번에 프로비저닝하기](./04-bicep-azd-provision.md)
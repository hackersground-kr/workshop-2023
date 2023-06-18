# Read Me First
The following was discovered as part of building this project:

* The original package name 'com.workshop.chat-api' is invalid and this project uses 'com.workshop.chatapi' instead.

# Getting Started

### 실행 전 `application-dev.properties` 파일 생성하기
```bash
cd /src/resources
touch application-dev.properties
```

### 스프링부트 앱 로컬에서 실행하기

```bash
cd chat-api
./mvnw spring-boot:run
```

### AOAI_API_KEY를 잘 입력했는데 OpenAI api key invalid error가 뜰 때

dev 프로필을 찾지 못해서 발생하는 것.

```bash
./mvnw clean install
```

빌드 파일을 지운 다음 새롭게 install, 재실행.
만약 재실행 시 profile activation이 자동으로 되지 않으면 해당 명령어로 재실행

```bash
./mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=dev
```

### Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/docs/3.1.0/maven-plugin/reference/html/)
* [Create an OCI image](https://docs.spring.io/spring-boot/docs/3.1.0/maven-plugin/reference/html/#build-image)
* [Spring Boot DevTools](https://docs.spring.io/spring-boot/docs/3.1.0/reference/htmlsingle/#using.devtools)
* [Spring Web](https://docs.spring.io/spring-boot/docs/3.1.0/reference/htmlsingle/#web)

### Guides
The following guides illustrate how to use some features concretely:

* [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/)
* [Serving Web Content with Spring MVC](https://spring.io/guides/gs/serving-web-content/)
* [Building REST services with Spring](https://spring.io/guides/tutorials/rest/)


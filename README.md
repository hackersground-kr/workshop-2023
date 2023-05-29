# 해커그라운드 사전 워크샵

해커그라운드 해커톤을 위한 사전 워크샵입니다

## 시스템 아키텍처

TBD

## 사전 준비사항

- [GitHub Account](https://github.com/signup)
- [Azure Free Account](https://azure.microsoft.com/free?WT.mc_id=dotnet-91712-juyoo)
- [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=dotnet-91712-juyoo)
- [GitHub CLI](https://cli.github.com)
- [Azure CLI](https://learn.microsoft.com/cli/azure/what-is-azure-cli?WT.mc_id=dotnet-91712-juyoo)
- [Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/overview?WT.mc_id=dotnet-91712-juyoo)

## 시작하기 &ndash; 애저 포털 이용하기

➡️ [애저 포털 이용하기](./docs/session01.md)

## 시작하기 &ndash; GitHub 코드스페이스 & 코파일럿 이용하기

➡️ [GitHub 코드스페이스 & 코파일럿 이용하기](./docs/session01.md)

## 시작하기 &ndash; 한 번에 둘러보기

1. 자신의 GitHub 계정으로 이 리포지토리를 포크합니다.
1. 아래 순서대로 애저에 리소스를 프로비저닝합니다.

    ```powershell
    # On Windows
    $RANDOM_KEY = $(New-Guid).Guid
    $AZURE_ENV_NAME = "hg$(Get-Random -Max 9999)"
    ```

    ```bash
    # On Linux
    RANDOM_KEY=$(cat /proc/sys/kernel/random/uuid)
    AZURE_ENV_NAME="hg$(echo $RANDOM)"

    # On MacOS
    RANDOM_KEY=$(cat /compat/linux/proc/sys/kernel/random/uuid)
    AZURE_ENV_NAME="hg$(echo $RANDOM)"
    ```

    ```bash
    azd auth login
    azd init -e $AZURE_ENV_NAME
    azd env set AZURE_APPSERVICE_KEY $RANDOM_KEY
    azd up
    ```

1. 아래 순서대로 애저에 애플리케이션을 배포합니다.

    ```powershell
    # On Windows
    $GITHUB_USERNAME = "{{자신의 GitHub ID}}"
    ```

    ```bash
    # On Linux/MacOS
    GITHUB_USERNAME="{{자신의 GitHub ID}}"
    ```

    ```bash
    azd pipeline config

    gh auth login
    gh workflow run "Azure Dev" --repo $GITHUB_USERNAME/workshop
    ```

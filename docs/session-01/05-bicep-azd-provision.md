# Bicep & Azure Developer CLI로 한 번에 프로비저닝하기

## Azure Developer CLI 설치
* Windows
  ```powershell
  # with winget
  winget install microsoft.azd

  # with Chocolatey
  choco install azd

  # with Script
  powershell -ex AllSigned -c "Invoke-RestMethod 'https://aka.ms/install-azd.ps1' | Invoke-Expression"

  ```

* Linux
  ```bash
  curl -fsSL https://aka.ms/install-azd.sh | bash
  ```

* Mac
  ```bash
  # with Homebrew
  brew tap azure/azd && brew install azd

  # with Script
  curl -fsSL https://aka.ms/install-azd.sh | bash
  ```

## 리소스 프로비저닝하기
* 변수 설정
  ```powershell
  # On Windows
  $RANDOM_KEY = $(New-Guid).Guid
  $AZURE_ENV_NAME = "hg$(Get-Random -Max 9999)"
  $AZURE_SQLADMIN_USERNAME = "{{ SQL Server 관리자 계정 이름 }}"
  $AZURE_SQLADMIN_PASSWORD = "{{ SQL Server 관리자 계정 암호 }}"
  ```

  ```bash
  # On Linux/MacOS
  RANDOM_KEY=$(uuidgen)
  AZURE_ENV_NAME="hg$(echo $RANDOM)"
  AZURE_SQLADMIN_USERNAME="{{ SQL Server 관리자 계정 이름 }}"
  AZURE_SQLADMIN_PASSWORD="{{ SQL Server 관리자 계정 암호 }}"
  ```

* Azure 로그인 및 환경(env) 설정
  ```bash
  azd auth login
  azd init -e $AZURE_ENV_NAME
  azd env set AZURE_APPSERVICE_KEY $RANDOM_KEY
  azd env set AZURE_SQLADMIN_USERNAME $AZURE_SQLADMIN_USERNAME
  azd env set AZURE_SQLADMIN_PASSWORD $AZURE_SQLADMIN_PASSWORD
  azd up
  ```

## 리소스 확인 및 대기
* Azure Portal에서 리소스 확인
* 리소스가 모두 프로비저닝 되기까지 기다립니다.
* Azure Portal로 수동으로 프로비저닝한 것과 동일한 포맷을 유지하고 있음을 확인할 수 있습니다. 

[API Management 수동 설정하기](./04-apim-config.md) 👈 이전 | 다음 👉 [GitHub Action으로 CI/CD 파이프라인 태우기](./06-ghactions.md)

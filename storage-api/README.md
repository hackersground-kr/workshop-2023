## 로컬에서 앱 실행
```zsh
//가상 환경 생성
virtualenv venv
//가상 환경 실행
source venv/bin/activate

pip3 install -r requirements.txt
uvicorn main:app --reload
```
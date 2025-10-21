# 로컬에서 Jekyll 사이트 테스트하기

## 방법 1: Ruby 설치 (Windows)

### 1단계: Ruby 설치
1. [RubyInstaller for Windows](https://rubyinstaller.org/downloads/) 다운로드
2. **Ruby+Devkit 3.1.X (x64)** 권장 버전 설치
3. 설치 마지막에 `ridk install` 실행 (1, 2, 3 옵션 모두 선택)

### 2단계: Jekyll과 Bundler 설치
```powershell
gem install jekyll bundler
```

### 3단계: 의존성 설치
```powershell
cd c:\Users\user\A\io\dkswndud1992.github.io
bundle install
```

### 4단계: 로컬 서버 실행
```powershell
bundle exec jekyll serve
```

사이트 주소: http://localhost:4000

### 실시간 변경 감지와 함께 실행
```powershell
bundle exec jekyll serve --livereload
```

---

## 방법 2: Docker 사용 (더 간단)

### 1단계: Docker Desktop 설치
1. [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop) 다운로드 및 설치
2. Docker Desktop 실행

### 2단계: Jekyll 컨테이너로 실행
```powershell
docker run --rm -it `
  -p 4000:4000 -p 35729:35729 `
  -v ${PWD}:/srv/jekyll `
  jekyll/jekyll:latest `
  jekyll serve --livereload
```

사이트 주소: http://localhost:4000

### 간단한 명령어 (docker-compose 사용)
프로젝트 루트에 `docker-compose.yml` 파일이 있다면:
```powershell
docker-compose up
```

---

## 방법 3: GitHub Codespaces (클라우드)

1. GitHub 저장소 페이지로 이동
2. **Code** 버튼 클릭 → **Codespaces** 탭
3. **Create codespace on main** 클릭
4. 터미널에서 실행:
   ```bash
   bundle install
   bundle exec jekyll serve
   ```

---

## 트러블슈팅

### 오류: `cannot load such file -- webrick`
```powershell
bundle add webrick
```

### 포트가 이미 사용 중일 때
```powershell
bundle exec jekyll serve --port 4001
```

### 빌드 오류 확인
```powershell
bundle exec jekyll build --verbose
```

### Gemfile.lock 제거 후 재설치
```powershell
Remove-Item Gemfile.lock
bundle install
```

---

## 추천 방법

- **개발 경험이 많다면**: Ruby 직접 설치 (방법 1)
- **간단하게 사용하고 싶다면**: Docker 사용 (방법 2)
- **설치 없이 바로 사용하고 싶다면**: GitHub Codespaces (방법 3)

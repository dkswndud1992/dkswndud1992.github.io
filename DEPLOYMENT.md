# 🚀 배포 가이드

GitHub Pages에 블로그를 배포하는 방법입니다.

## ✅ 배포 전 체크리스트

- [ ] `_config.yml`에서 `url` 확인
- [ ] `_config.yml`에서 `github_username` 확인
- [ ] 모든 링크가 작동하는지 확인
- [ ] 로컬에서 빌드 테스트 완료
- [ ] 이미지 경로 확인
- [ ] 오타 및 문법 확인

## 📋 단계별 배포 가이드

### 1. 로컬 테스트 (선택사항)

```powershell
# Ruby가 설치되어 있어야 합니다
bundle install
bundle exec jekyll serve

# 브라우저에서 http://localhost:4000 접속
```

### 2. Git에 커밋

```powershell
# 변경사항 확인
git status

# 모든 파일 추가
git add .

# 커밋
git commit -m "Update blog content"

# GitHub에 푸시
git push origin main
```

### 3. GitHub Pages 활성화

1. GitHub Repository로 이동
2. **Settings** 탭 클릭
3. 왼쪽 메뉴에서 **Pages** 클릭
4. **Source** 섹션:
   - Branch: `main` 선택
   - Folder: `/ (root)` 선택
5. **Save** 버튼 클릭

### 4. 배포 확인

- 배포는 보통 **5-10분** 소요
- Actions 탭에서 빌드 진행 상황 확인 가능
- 완료 후 `https://dkswndud1992.github.io` 접속

## 🔧 문제 해결

### 페이지가 표시되지 않는 경우

1. **Repository 이름 확인**
   - 반드시 `username.github.io` 형식이어야 함
   - 예: `dkswndud1992.github.io`

2. **빌드 에러 확인**
   - Repository → Actions 탭 확인
   - 에러 메시지 확인 후 수정

3. **캐시 문제**
   - 브라우저 캐시 삭제 (Ctrl + Shift + Delete)
   - 시크릿 모드로 접속

### 스타일이 적용되지 않는 경우

1. **`style.scss` 위치 확인**
   - `assets/css/style.scss`에 있어야 함
   - Front matter (`---`) 확인

2. **`_config.yml` 확인**
   ```yaml
   theme: jekyll-theme-minimal
   ```

3. **캐시 강제 새로고침**
   - Ctrl + F5 (Windows)
   - Cmd + Shift + R (Mac)

### 포스트가 표시되지 않는 경우

1. **파일명 형식 확인**
   - `YYYY-MM-DD-title.md` 형식
   - 예: `2025-10-21-first-post.md`

2. **날짜 확인**
   - 미래 날짜는 표시되지 않음
   - Front matter의 date 확인

3. **Front Matter 확인**
   ```yaml
   ---
   layout: post
   title: "제목"
   date: 2025-10-21
   ---
   ```

## 🔄 업데이트 워크플로우

### 새 포스트 작성

```powershell
# 1. 새 파일 생성
# _posts/YYYY-MM-DD-title.md

# 2. Front matter 작성
# ---
# layout: post
# title: "제목"
# date: YYYY-MM-DD
# tags: [태그1, 태그2]
# ---

# 3. 내용 작성

# 4. Git 커밋 & 푸시
git add _posts/YYYY-MM-DD-title.md
git commit -m "Add new post: title"
git push origin main
```

### 페이지 수정

```powershell
# 1. 파일 수정 (예: about.md)

# 2. 로컬 테스트 (선택)
bundle exec jekyll serve

# 3. Git 커밋 & 푸시
git add about.md
git commit -m "Update about page"
git push origin main
```

## 🌐 커스텀 도메인 설정 (선택사항)

### 1. 도메인 구매
- [Namecheap](https://www.namecheap.com/)
- [GoDaddy](https://www.godaddy.com/)
- [Google Domains](https://domains.google/)

### 2. DNS 설정

도메인 제공업체에서 다음 레코드 추가:

```
Type: A
Name: @
Value: 185.199.108.153
Value: 185.199.109.153
Value: 185.199.110.153
Value: 185.199.111.153

Type: CNAME
Name: www
Value: dkswndud1992.github.io
```

### 3. GitHub 설정

1. Repository Settings → Pages
2. Custom domain에 도메인 입력
3. Enforce HTTPS 체크

### 4. CNAME 파일 생성

Repository 루트에 `CNAME` 파일 생성:

```
yourdomain.com
```

## 📊 Google Search Console 등록

### 1. 소유권 확인

`_layouts/default.html`에 추가:

```html
<meta name="google-site-verification" content="YOUR_CODE" />
```

### 2. Sitemap 제출

- URL: `https://dkswndud1992.github.io/sitemap.xml`
- `jekyll-sitemap` 플러그인이 자동 생성

## 🔍 Google Analytics 설정 (선택사항)

### 1. GA 계정 생성

https://analytics.google.com/

### 2. 측정 ID 받기

예: `G-XXXXXXXXXX`

### 3. `_config.yml`에 추가

```yaml
google_analytics: G-XXXXXXXXXX
```

## 📈 배포 후 해야 할 일

- [ ] 사이트 정상 작동 확인
- [ ] Google Search Console 등록
- [ ] Google Analytics 설정 (선택)
- [ ] 소셜 미디어에 공유
- [ ] README.md 업데이트
- [ ] 정기적인 백업 설정

## 💡 유용한 팁

### 빠른 배포

`.github/workflows/deploy.yml` 생성으로 자동 배포:

```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/jekyll-build-pages@v1
```

### 초안 작성

`_drafts/` 폴더 사용:

```
_drafts/
  └── my-draft-post.md
```

로컬에서만 보기:

```powershell
bundle exec jekyll serve --drafts
```

## 🚨 주의사항

1. **Private Repository**: GitHub Free 계정에서는 공개 Repository만 Pages 사용 가능
2. **파일 크기**: 개별 파일 100MB 제한
3. **Repository 크기**: 1GB 권장
4. **빌드 시간**: 최대 10분
5. **대역폭**: 월 100GB 소프트 제한

## 📞 도움이 필요하면?

- [GitHub Pages 문서](https://docs.github.com/pages)
- [Jekyll 문서](https://jekyllrb.com/docs/)
- [GitHub Community](https://github.community/)

---

**Happy Deploying! 🎉**

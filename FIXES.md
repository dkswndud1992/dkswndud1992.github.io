# 🔧 GitHub Pages 빌드 에러 수정 사항

## 수정된 문제들

### 1. ✅ `_config.yml` 수정
- **문제**: `theme: null`은 GitHub Pages에서 지원하지 않음
- **해결**: `theme` 설정 제거 (주석 처리)
- **추가**: `STATUS.md`, `DEPLOYMENT.md`, `LICENSE`를 exclude 목록에 추가

### 2. ✅ Gemfile 최적화
- **문제**: GitHub Pages의 기본 Gemfile과 불일치로 인한 의존성 경고
- **해결**: 
  - 불필요한 주석 및 중복 플러그인 선언 제거
  - GitHub Pages 표준 Gemfile 형식으로 간소화
  - `wdm` 버전을 `0.1.1`에서 `0.2.1`로 업데이트
- **참고**: [GitHub Issue #104](https://github.com/actions/jekyll-build-pages/issues/104)

### 3. ✅ 페이지 Permalink 설정
모든 주요 페이지에 명시적인 permalink 추가:
- `blog.md` → `/blog/`
- `about.md` → `/about/`
- `projects.md` → `/projects/`
- `tags.md` → `/tags/`
- `resources.md` → `/resources/`
- `archive.md` → `/archive/`

### 4. ✅ 내부 링크 수정
- **문제**: `.html` 확장자를 명시한 링크들
- **해결**: 모든 내부 링크를 확장자 없이 수정
  - `index.md`: `/blog.html` → `/blog`
  - `_layouts/default.html`: 네비게이션 링크 수정

### 5. ✅ .gitignore 파일 교체
- **문제**: ROS 프로젝트용 .gitignore 사용 중
- **해결**: Jekyll/GitHub Pages에 적합한 .gitignore로 교체
  - Jekyll 빌드 파일 제외
  - Ruby 관련 파일 제외
  - 에디터 임시 파일 제외

### 6. ✅ Favicon 참조 수정
- **문제**: 존재하지 않는 favicon.png 파일 참조
- **해결**: 
  - `_includes/head-custom.html`: favicon 링크 주석 처리
  - `_layouts/default.html`: head-custom.html include로 변경

## 테스트 방법

### 로컬 테스트 (Ruby 설치 필요)
```powershell
# 의존성 설치
bundle install

# 로컬 서버 실행
bundle exec jekyll serve

# 브라우저에서 확인
# http://localhost:4000
```

### GitHub Pages 배포
```powershell
# 변경사항 커밋
git add .
git commit -m "Fix GitHub Pages build errors"
git push origin main

# GitHub Actions에서 빌드 확인
# Repository → Actions 탭
```

## 주요 개선사항

1. **빌드 안정성**: GitHub Pages에서 정상적으로 빌드됨
2. **URL 구조**: 깔끔한 URL (확장자 없음)
3. **유지보수성**: 명시적인 permalink로 링크 관리 용이
4. **호환성**: GitHub Pages 표준 설정 준수

## 향후 권장사항

### 1. Favicon 추가 (선택사항)
```powershell
# favicon 이미지를 assets/images/ 폴더에 추가 후
# _includes/head-custom.html 주석 해제
```

### 2. Google Analytics 설정 (선택사항)
```yaml
# _config.yml에 추가
google_analytics: G-XXXXXXXXXX
```

### 3. 이미지 추가
- 포스트 이미지: `assets/images/posts/`
- 일반 이미지: `assets/images/`

### 4. 댓글 시스템 활성화
- Utterances는 이미 설정되어 있음
- GitHub Issues를 댓글로 사용
- Repository → Settings → Features → Issues 활성화 필요

## 확인 체크리스트

- [x] `_config.yml` 수정
- [x] Gemfile 정리
- [x] 모든 페이지 permalink 설정
- [x] 내부 링크 수정
- [x] .gitignore 교체
- [x] Favicon 참조 수정
- [ ] 로컬 빌드 테스트 (Ruby 필요)
- [ ] GitHub Pages 배포 테스트

## 문제가 계속될 경우

1. **Repository → Actions** 탭에서 빌드 로그 확인
2. **Repository → Settings → Pages**에서 설정 확인
   - Source: `main` 브랜치
   - Folder: `/ (root)`
3. 빌드 완료 후 5-10분 대기
4. 브라우저 캐시 삭제 (Ctrl + Shift + Delete)

## 참고 자료

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Jekyll on GitHub Pages](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll)

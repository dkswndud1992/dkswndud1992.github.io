---
layout: post
title: "GitHub Pages 블로그 시작하기"
date: 2024-10-05
author: botgymc
tags: [GitHub, Jekyll, 블로그, 튜토리얼]
---

# GitHub Pages로 무료 블로그 만들기

Jekyll과 GitHub Pages를 사용하여 무료로 개인 블로그를 만드는 방법을 알아봅니다.

## 🎯 왜 GitHub Pages인가?

### 장점 ✅
- **완전 무료** 호스팅
- **Git 버전 관리** 내장
- **커스텀 도메인** 지원
- **HTTPS** 자동 지원
- **Markdown** 작성 가능

### 단점 ❌
- 정적 사이트만 가능
- 빌드 시간 존재
- 서버 사이드 로직 불가

## 🚀 시작하기

### 1. Repository 생성

```
Repository 이름: username.github.io
예: dkswndud1992.github.io
```

⚠️ **중요**: Repository 이름은 반드시 `username.github.io` 형식이어야 합니다!

### 2. 로컬에 Clone

```bash
git clone https://github.com/username/username.github.io.git
cd username.github.io
```

### 3. Jekyll 설정

#### `_config.yml` 생성

```yaml
title: 내 블로그
author: Your Name
description: Jekyll과 GitHub Pages로 만든 블로그
theme: jekyll-theme-minimal

plugins:
  - jekyll-feed
  - jekyll-seo-tag
```

#### `index.md` 생성

```markdown
---
layout: default
title: 홈
---

# 환영합니다!

이것은 내 블로그입니다.
```

### 4. 첫 포스트 작성

`_posts/2025-10-05-first-post.md`:

```markdown
---
layout: post
title: "첫 번째 포스트"
date: 2025-10-05
---

# Hello World!

첫 번째 블로그 포스트입니다.
```

### 5. Git Push

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

## 🎨 테마 적용하기

### 지원되는 테마

GitHub Pages가 기본 지원하는 테마들:
- `minimal`
- `cayman`
- `architect`
- `slate`
- `modernist`

### `_config.yml`에 추가

```yaml
theme: jekyll-theme-minimal
```

### 커스텀 테마 사용

```yaml
remote_theme: owner/repo
```

## 📝 포스트 작성 규칙

### 파일명 형식

```
YYYY-MM-DD-title.md
예: 2025-10-05-first-post.md
```

### Front Matter

모든 포스트는 YAML front matter로 시작합니다:

```yaml
---
layout: post
title: "포스트 제목"
date: 2025-10-05
author: 작성자
tags: [태그1, 태그2]
---
```

## 🛠️ 로컬 개발 환경

### Ruby 설치

Windows: [RubyInstaller](https://rubyinstaller.org/)
macOS: `brew install ruby`
Linux: `sudo apt-get install ruby-full`

### Jekyll 설치

```bash
gem install bundler jekyll
```

### 로컬 서버 실행

```bash
bundle exec jekyll serve
```

브라우저에서 `http://localhost:4000` 접속

## 🔧 유용한 플러그인

### `Gemfile`:

```ruby
source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
end
```

## 📊 SEO 최적화

### 메타 태그 추가

```html
<head>
  {% seo %}
</head>
```

### `sitemap.xml` 자동 생성

`jekyll-sitemap` 플러그인 사용

### Google Analytics

```yaml
google_analytics: G-XXXXXXXXXX
```

## 🎯 체크리스트

- [ ] Repository 생성
- [ ] `_config.yml` 설정
- [ ] 첫 포스트 작성
- [ ] 테마 적용
- [ ] 로컬 테스트
- [ ] Git Push
- [ ] 사이트 확인 (5-10분 소요)

## 💡 팁 & 트릭

> **Tip 1**: 이미지는 `assets/images/` 폴더에 저장하세요.

> **Tip 2**: 긴 빌드 시간이 걸린다면 로컬에서 먼저 테스트하세요.

> **Tip 3**: `_drafts/` 폴더를 사용하면 초안 작성이 가능합니다.

## 🚫 주의사항

1. **Private repo는 GitHub Pages 무료 사용 불가** (Pro 계정 필요)
2. **Repository 크기 제한**: 1GB
3. **월간 대역폭**: 100GB
4. **빌드 시간**: 최대 10분

## 🔗 참고 자료

- [GitHub Pages 공식 문서](https://docs.github.com/pages)
- [Jekyll 문서](https://jekyllrb.com/docs/)
- [Liquid 템플릿 문법](https://shopify.github.io/liquid/)

---

**다음 포스트**: "Jekyll 테마 커스터마이징하기"

Happy blogging! 🎉

# 로봇공학 학습 블로그 🤖

Jekyll과 GitHub Pages로 만든 개인 블로그입니다.

## 🌐 사이트 주소

https://dkswndud1992.github.io

## 📚 주요 콘텐츠

- **로봇공학 커리큘럼**: 체계적인 학습 가이드
- **블로그 포스트**: 학습 내용 및 프로젝트 기록
- **프로젝트 포트폴리오**: 진행한 프로젝트 소개

## 🛠️ 기술 스택

- **정적 사이트 생성기**: Jekyll
- **호스팅**: GitHub Pages
- **테마**: Minimal Theme (커스터마이징)
- **언어**: Markdown, HTML, SCSS

## 🚀 로컬 개발 환경 설정

### 1. Ruby 설치
Windows의 경우 [RubyInstaller](https://rubyinstaller.org/)를 사용하세요.

### 2. 의존성 설치
```bash
gem install bundler
bundle install
```

### 3. 로컬 서버 실행
```bash
bundle exec jekyll serve
```

브라우저에서 `http://localhost:4000`으로 접속합니다.

## 📁 디렉토리 구조

```
.
├── _config.yml          # 사이트 설정
├── _layouts/            # HTML 레이아웃
│   ├── default.html
│   └── post.html
├── _posts/              # 블로그 포스트
│   └── YYYY-MM-DD-title.md
├── assets/              # CSS, 이미지 등
│   └── css/
│       └── style.scss
├── index.md             # 메인 페이지
├── blog.md              # 블로그 목록
├── about.md             # 소개 페이지
└── 404.html             # 404 에러 페이지
```

## ✍️ 새 포스트 작성하기

`_posts/` 디렉토리에 `YYYY-MM-DD-제목.md` 형식으로 파일을 만듭니다:

```markdown
---
layout: post
title: "포스트 제목"
date: 2025-10-21
tags: [태그1, 태그2]
---

여기에 내용을 작성합니다.
```

## 📝 할 일

- [ ] 프로필 이미지 추가
- [ ] 프로젝트 페이지 작성
- [ ] Google Analytics 설정
- [ ] RSS 피드 활성화
- [ ] 댓글 시스템 추가 (Disqus/Utterances)

## 📄 라이선스

MIT License

## 📧 연락처

- GitHub: [@dkswndud1992](https://github.com/dkswndud1992)

---

*Made with ❤️ using Jekyll and GitHub Pages*

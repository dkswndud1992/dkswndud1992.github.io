# 이미지 폴더

이 폴더에는 사이트에서 사용되는 이미지들이 저장됩니다.

## 📁 구조

```
assets/images/
├── favicon.png          # 사이트 파비콘 (16x16 또는 32x32)
├── logo.png            # 사이트 로고
├── profile.jpg         # 프로필 사진
├── og-image.png        # Open Graph 이미지 (SNS 공유용, 1200x630)
└── posts/              # 블로그 포스트 이미지들
    ├── 2025-10-21-image1.png
    └── ...
```

## 🎨 파비콘 생성

온라인 도구를 사용하여 파비콘 생성:
- [Favicon.io](https://favicon.io/)
- [RealFaviconGenerator](https://realfavicongenerator.net/)

## 📷 권장 이미지 크기

| 용도 | 크기 |
|------|------|
| 파비콘 | 32x32 또는 16x16 |
| 로고 | 200x200 |
| 프로필 사진 | 400x400 |
| OG 이미지 | 1200x630 |
| 포스트 썸네일 | 800x600 |

## 🔗 플레이스홀더 이미지

개발 중에는 다음 서비스를 사용할 수 있습니다:
- https://via.placeholder.com/800x600
- https://picsum.photos/800/600
- https://placehold.co/800x600

## 💡 사용 예시

Markdown:
```markdown
![설명]({{ '/assets/images/posts/example.png' | relative_url }})
```

HTML:
```html
<img src="{{ '/assets/images/logo.png' | relative_url }}" alt="로고">
```

## ⚠️ 주의사항

- 이미지 파일명은 영문과 숫자, 하이픈(-), 언더스코어(_)만 사용
- 한글 파일명은 피하기
- 큰 이미지는 최적화 후 업로드 (1MB 이하 권장)
- WebP 포맷 사용 고려 (더 작은 파일 크기)

## 🛠️ 이미지 최적화 도구

- [TinyPNG](https://tinypng.com/)
- [Squoosh](https://squoosh.app/)
- [ImageOptim](https://imageoptim.com/) (Mac)

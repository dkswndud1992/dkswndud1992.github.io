# 블로그 포스트 이미지

이 폴더에는 블로그 포스트에서 사용되는 이미지들을 저장합니다.

## 📝 이미지 명명 규칙

포스트 날짜와 설명적인 이름을 사용하세요:

```
YYYY-MM-DD-descriptive-name.png
```

예시:
- `2025-10-21-ros-architecture.png`
- `2025-10-15-opencv-result.jpg`
- `2025-10-10-robot-demo.gif`

## 🎯 권장 사항

- **포맷**: PNG (스크린샷, 다이어그램), JPG (사진), GIF (애니메이션)
- **크기**: 최대 800-1000px 너비
- **파일 크기**: 500KB 이하 (최적화 후)

## 💡 사용 방법

Markdown 포스트에서:

```markdown
![이미지 설명]({{ '/assets/images/posts/2025-10-21-example.png' | relative_url }})
```

센터 정렬:

```html
<p align="center">
  <img src="{{ '/assets/images/posts/example.png' | relative_url }}" alt="설명">
</p>
```

크기 조절:

```html
<img src="{{ '/assets/images/posts/example.png' | relative_url }}" 
     alt="설명" 
     width="600">
```

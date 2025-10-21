---
title: "OpenCV 기초: 이미지 처리 시작하기"
date: 2024-10-10
author: Bot-gym-c
tags: [OpenCV, Python, 컴퓨터비전, 튜토리얼]
---

# OpenCV로 시작하는 이미지 처리

컴퓨터 비전의 기초인 OpenCV를 사용한 이미지 처리 방법을 알아봅니다.

## 🔧 설치

```bash
pip install opencv-python numpy matplotlib
```

## 📷 이미지 읽기 및 표시

```python
import cv2
import matplotlib.pyplot as plt

# 이미지 읽기
img = cv2.imread('image.jpg')

# BGR to RGB 변환 (OpenCV는 BGR 사용)
img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

# 이미지 표시
plt.imshow(img_rgb)
plt.axis('off')
plt.title('Original Image')
plt.show()
```

## 🎨 기본 이미지 처리

### 1. 그레이스케일 변환

```python
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
plt.imshow(gray, cmap='gray')
plt.title('Grayscale')
plt.show()
```

### 2. 블러 효과

```python
# Gaussian Blur
blurred = cv2.GaussianBlur(img, (15, 15), 0)

# Median Blur
median = cv2.medianBlur(img, 15)
```

### 3. 에지 검출

```python
# Canny Edge Detection
edges = cv2.Canny(gray, 100, 200)

plt.subplot(1, 2, 1)
plt.imshow(gray, cmap='gray')
plt.title('Original')

plt.subplot(1, 2, 2)
plt.imshow(edges, cmap='gray')
plt.title('Edges')
plt.show()
```

## 🔍 이미지 변환

### 크기 조정

```python
# 절대 크기
resized = cv2.resize(img, (300, 300))

# 상대 크기 (50%)
resized = cv2.resize(img, None, fx=0.5, fy=0.5)
```

### 회전

```python
height, width = img.shape[:2]
center = (width//2, height//2)

# 45도 회전
M = cv2.getRotationMatrix2D(center, 45, 1.0)
rotated = cv2.warpAffine(img, M, (width, height))
```

## 📊 히스토그램

```python
# 컬러 히스토그램
colors = ('b', 'g', 'r')
for i, color in enumerate(colors):
    hist = cv2.calcHist([img], [i], None, [256], [0, 256])
    plt.plot(hist, color=color)
    plt.xlim([0, 256])

plt.title('Color Histogram')
plt.xlabel('Pixel Value')
plt.ylabel('Frequency')
plt.show()
```

## 🎯 실전 예제: 얼굴 검출

```python
# Haar Cascade 분류기 로드
face_cascade = cv2.CascadeClassifier(
    cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
)

# 그레이스케일 변환
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# 얼굴 검출
faces = face_cascade.detectMultiScale(
    gray, 
    scaleFactor=1.1, 
    minNeighbors=5
)

# 얼굴에 사각형 그리기
for (x, y, w, h) in faces:
    cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 2)

plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
plt.title(f'Detected {len(faces)} faces')
plt.show()
```

## 📝 주요 함수 정리

| 함수 | 기능 |
|------|------|
| `cv2.imread()` | 이미지 읽기 |
| `cv2.imshow()` | 이미지 표시 |
| `cv2.cvtColor()` | 색상 공간 변환 |
| `cv2.GaussianBlur()` | 가우시안 블러 |
| `cv2.Canny()` | 에지 검출 |
| `cv2.resize()` | 크기 조정 |

## 🚀 다음 단계

- [ ] 이미지 필터링 심화
- [ ] 객체 검출 (YOLO, SSD)
- [ ] 특징점 추출 (SIFT, ORB)
- [ ] 이미지 세그멘테이션

## 🔗 참고 자료

- [OpenCV Documentation](https://docs.opencv.org/)
- [PyImageSearch](https://www.pyimagesearch.com/)

---

*다음 포스트: "OpenCV로 실시간 비디오 처리하기"*

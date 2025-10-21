---
layout: default
title: 홈
---

<div class="text-center">
  <h1>🤖 안녕하세요!</h1>
  <p style="font-size: 1.2em; color: #4ea9da;">로봇 공학 및 프로그래밍 학습 블로그입니다.</p>
</div>

---

## 🎯 주요 콘텐츠

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 30px 0;">
  <div style="padding: 20px; background-color: #252525; border-left: 4px solid #4ea9da; border-radius: 5px;">
    <h3>📝 <a href="{{ '/blog' | relative_url }}">블로그</a></h3>
    <p>학습 내용과 프로젝트 기록</p>
  </div>
  
  <div style="padding: 20px; background-color: #252525; border-left: 4px solid #4ea9da; border-radius: 5px;">
    <h3>📚 <a href="{{ '/resources' | relative_url }}">학습 자료</a></h3>
    <p>유용한 강의 및 참고 자료</p>
  </div>
  
</div>

---

## 📌 최근 포스트

{% for post in site.posts limit:3 %}
<div style="margin: 20px 0; padding: 15px; background-color: #252525; border-left: 4px solid #4ea9da; border-radius: 5px;">
  <h3 style="margin-top: 0;">
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </h3>
  <p style="color: #888; font-size: 0.9em;">
    📅 {{ post.date | date: '%Y년 %m월 %d일' }}
    {% if post.tags %}
      • 🏷️
      {% for tag in post.tags limit:3 %}
        <span style="color: #4ea9da;">{{ tag }}</span>{% unless forloop.last %}, {% endunless %}
      {% endfor %}
    {% endif %}
  </p>
  {% if post.excerpt %}
    <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
  {% endif %}
</div>
{% endfor %}

<p style="text-align: center; margin-top: 30px;">
  <a href="{{ '/blog' | relative_url }}" style="display: inline-block; padding: 10px 30px; background-color: #4ea9da; color: #1e1e1e; text-decoration: none; border-radius: 5px; font-weight: bold;">
    더 많은 포스트 보기 →
  </a>
</p>

---

## 💡 주요 기술 스택

<div style="display: flex; flex-wrap: wrap; gap: 10px; margin: 20px 0;">
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">🐍 Python</span>
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">⚙️ C++</span>
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">🤖 ROS</span>
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">👁️ OpenCV</span>
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">🧠 TensorFlow</span>
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">🔥 PyTorch</span>
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">📊 NumPy</span>
  <span style="padding: 8px 15px; background-color: #2a2a2a; border: 1px solid #333; border-radius: 20px;">🐙 Git</span>
</div>

---

## 🔗 연결

<div style="margin: 20px 0;">
  <a href="https://github.com/{{ site.github_username }}" style="margin-right: 20px;">
    <img src="https://img.shields.io/badge/GitHub-dkswndud1992-181717?style=for-the-badge&logo=github" alt="GitHub">
  </a>
  <a href="{{ '/feed.xml' | relative_url }}">
    <img src="https://img.shields.io/badge/RSS-Feed-FFA500?style=for-the-badge&logo=rss" alt="RSS">
  </a>
</div>

---

<div style="text-align: center; color: #666; font-size: 0.9em; margin-top: 40px;">
  <p><em>Last updated: {{ site.time | date: '%Y년 %m월 %d일' }}</em></p>
</div>

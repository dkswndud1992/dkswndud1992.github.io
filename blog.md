---
layout: default
title: 블로그
---

# 📝 블로그 포스트

{% if site.posts.size > 0 %}
  <ul class="post-list">
  {% for post in site.posts %}
    <li>
      <h3>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </h3>
      <p class="post-meta">
        {{ post.date | date: '%Y년 %m월 %d일' }}
        {% if post.tags %}
          • 
          {% for tag in post.tags %}
            <span class="tag">{{ tag }}</span>
          {% endfor %}
        {% endif %}
      </p>
      {% if post.excerpt %}
        <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
      {% endif %}
    </li>
  {% endfor %}
  </ul>
{% else %}
  <p>아직 블로그 포스트가 없습니다.</p>
{% endif %}

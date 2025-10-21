---
layout: default
title: 태그
---

# 🏷️ 태그별 포스트

{% assign tags_list = site.posts | map: 'tags' | join: ',' | split: ',' | uniq | sort %}

{% if tags_list.size > 0 %}
  <div class="tag-cloud">
    {% for tag in tags_list %}
      {% if tag != "" %}
        <a href="#{{ tag | slugify }}" class="tag-link">{{ tag }}</a>
      {% endif %}
    {% endfor %}
  </div>

  <hr>

  {% for tag in tags_list %}
    {% if tag != "" %}
      <h2 id="{{ tag | slugify }}">{{ tag }}</h2>
      <ul class="post-list">
        {% for post in site.posts %}
          {% if post.tags contains tag %}
            <li>
              <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
              <span class="post-date">• {{ post.date | date: '%Y년 %m월 %d일' }}</span>
            </li>
          {% endif %}
        {% endfor %}
      </ul>
    {% endif %}
  {% endfor %}
{% else %}
  <p>아직 태그가 없습니다.</p>
{% endif %}

<style>
.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin: 20px 0;
}

.tag-link {
  display: inline-block;
  padding: 5px 15px;
  background-color: #2a2a2a;
  color: #4ea9da;
  text-decoration: none;
  border-radius: 20px;
  border: 1px solid #333;
  transition: all 0.3s;
}

.tag-link:hover {
  background-color: #4ea9da;
  color: #1e1e1e;
  transform: translateY(-2px);
}

.post-list {
  list-style: none;
  padding-left: 0;
}

.post-list li {
  margin: 10px 0;
  padding: 10px;
  background-color: #252525;
  border-left: 3px solid #4ea9da;
}

.post-date {
  color: #888;
  font-size: 0.9em;
}
</style>

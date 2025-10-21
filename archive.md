---
layout: default
title: 아카이브
---

# 📚 포스트 아카이브

연도별로 정리된 블로그 포스트입니다.

{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}

{% for year in posts_by_year %}
  <h2>{{ year.name }}년 ({{ year.items | size }}개)</h2>
  
  {% assign posts_by_month = year.items | group_by_exp: "post", "post.date | date: '%m'" %}
  
  {% for month in posts_by_month %}
    <h3>{{ month.items[0].date | date: '%m월' }}</h3>
    <ul class="archive-list">
      {% for post in month.items %}
        <li>
          <time datetime="{{ post.date | date_to_xmlschema }}">
            {{ post.date | date: '%d일' }}
          </time>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          {% if post.tags %}
            <span class="tags">
              {% for tag in post.tags limit:3 %}
                <span class="tag-mini">{{ tag }}</span>
              {% endfor %}
            </span>
          {% endif %}
        </li>
      {% endfor %}
    </ul>
  {% endfor %}
  
  <hr>
{% endfor %}

<style>
.archive-list {
  list-style: none;
  padding-left: 0;
}

.archive-list li {
  margin: 12px 0;
  padding: 10px;
  background-color: #252525;
  border-radius: 5px;
  display: flex;
  align-items: center;
  gap: 15px;
}

.archive-list time {
  color: #4ea9da;
  font-weight: bold;
  min-width: 40px;
}

.archive-list a {
  flex-grow: 1;
}

.tags {
  display: flex;
  gap: 5px;
}

.tag-mini {
  font-size: 0.75em;
  padding: 2px 8px;
  background-color: #1e1e1e;
  border: 1px solid #333;
  border-radius: 10px;
  color: #888;
}
</style>

---
layout: page
title: media
---
{% for post in site.categories.blog %}


  <a href="{{ site.github.url }}{{ post.url }}">
    <div class="featured-posts" {% if post.image %}style="background-image:url({{ site.github.url }}/assets/img/{{ post.image }})"{% endif %}>
      <h2><span>{{ post.title }}</span></h2>
    </div>
  </a>
{% endfor %}
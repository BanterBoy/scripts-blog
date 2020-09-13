---
layout: page
title: Scripts
permalink: scripts.html
---

<!-- #### [ExchangeServerConnections.ps1](/_posts/ExchangeServerConnections.md)
Brief overview of script

#### [Get-CidrIPRange.ps1](/_posts/Get-CidrIPRange.md)
Brief overview of script

#### [Get-ipInfo.ps1](/_posts/Get-ipInfo.md)
Brief overview of script

#### [Get-LatestFiles.ps1](/_posts/Get-LatestFiles.md)
Brief overview of script

#### [Get-UpTime.ps1](/_posts/Get-UpTime.md)
Brief overview of script

#### [Test-EmailAddress.ps1](/_posts/Test-EmailAddress.md)
Brief overview of script
 -->

<div class="post">
  <h1 class="post-title">{{ page.title }}</h1>
  <span class="post-date">{{ page.date | date_to_string }}</span>
</div>

<div class="related">
  <h2>Related Posts</h2>
  <ul class="related-posts">
    {% for post in site.related_posts limit:3 %}
      <li>
        <h3>
          <a href="{{ post.url }}">
            {{ post.title }}
            <small>{{ post.date | date_to_string }}</small>
          </a>
        </h3>
      </li>
    {% endfor %}
  </ul>
</div>

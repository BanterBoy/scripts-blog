---
layout: post
title: "The Arctic Code Vault"
excerpt: "What it is and my how I found out I am a contributor"
header:
  overlay_image: 
  overlay_filter: rgba(90, 104, 129, 0.7)
  teaser: 
classes: wide
categories:
  - Blog
tags:
  - GitHub
  - PowerShell
---

<script src="https://formspree.io/js/formbutton-v1.0.0.min.js" defer></script>
<script>
  window.formbutton=window.formbutton||function(){(formbutton.q=formbutton.q||[]).push(arguments)};
/* customize formbutton here*/     
  formbutton("create", {
    action: "https://formspree.io/xvowjgjd",
    buttonImg: "<i class='fas fa-envelope' style='font-size:20px'/>",
    theme: "minimal",
    title: "Contact Me!",
    fields: [
      { 
        type: "email", 
        label: "Email:", 
        name: "email",
        required: true,
        placeholder: "your@email.com"
      },
      {
        type: "textarea",
        label: "Message:",
        name: "message",
        required: true,
        placeholder: "What's on your mind?",
      },
      { type: "submit" }      
    ],
    styles: {
      fontFamily: "Roboto",
      fontSize: "1em",
      title: {
        background: "#999999",
      },
      button: {
        background: "#999999",
      }
    },
    initiallyVisible: false
  });
</script>

{: .text-right}
<span style="font-size:11px;"><button onclick="window.print()"><i class="fas fa-print" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Print</button></span>

A few weeks ago, I awoke to a message from one of my friends [<icon class="fab fa-twitter"></icon> @InfosecSapper][1]{:target="_blank"}

GitHub's Arctic Code Vault is similar in nature to the [Library of Alexandria][2]{:target="_blank"}, which was the most famous library of Classical antiquity. There have been a number of attempts to create a modern day Universal Library over the years but the most memorable for me was Google's attempt which sadly ended under a [storm of litigation][3]{:target="_blank"}. There are many articles written about this, with one of perhaps the saddest quotes I have heard in one of them

> Somewhere at Google there is a database containing 25 million books and nobody is allowed to read them.  
> <cite><a href="https://www.theatlantic.com/technology/archive/2017/04/the-tragedy-of-google-books/523320/" target="_blank">James Somer</a></cite>

GitHub created the "[GitHub Archive Program][4]{:target="_blank"}" in 2019 with the idea of preserving the work of many opensource developers for future generations and ensuring it would be stored for many years to come....for at least 1,000 years.

The [blog article from GitHub][5]{:target="_blank"} explains the process in much more detail than I have here but if you are not in the mood for some light reading they also have a TLDR video which will give you an insight into their incredible work.

<iframe width="560" height="315" src="https://www.youtube.com/embed/fzI9FNjXQ0o" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
<br>
GitHub have deposited archived data, 21TB of repository data to 186 reels of piqlFilm (digital photosensitive archival film), in a similar fashion to the [Svalbard Global Seed Vault][6]{:target="_blank"} and is located down the road in a decommissioned coal mine.

I hope you take the time to read the additional links in the article. Whilst I was amused at the notion code I had written would be stored in the vault, having spent the time reading and understanding why they are doing this, I am somewhat humbled that my code will be around many years after I am gone.

In truth, it is a massive kick up the ass to make sure that it is properly formatted and documented so that it will at least make sense, should anyone ever be interested in what I have written.

{: .text-center}
<a href="#" class="btn btn--info btn--small"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a>

[1]: https://twitter.com/InfosecSapper
[2]: https://www.britannica.com/topic/Library-of-Alexandria
[3]: https://www.edsurge.com/news/2017-08-10-what-happened-to-google-s-effort-to-scan-millions-of-university-library-books
[4]: https://archiveprogram.github.com/
[5]: https://github.blog/2020-07-16-github-archive-program-the-journey-of-the-worlds-open-source-code-to-the-arctic/
[6]: https://www.seedvault.no/

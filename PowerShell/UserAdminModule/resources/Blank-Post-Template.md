---
layout: single
title: "Blank Post Template"
excerpt: "Empty Page to start"
header:
  overlay_image: /assets/images/powershell-banner.png
  overlay_filter: rgba(90, 104, 129, 0.8)
  teaser: /assets/images/default-teaser-image.png
  caption: "[**Luke Leigh**](https://www.linkedin.com/in/lukeleigh/)"
  # actions:
  #   - label: "More Info"
  #     url: "https://github.com/BanterBoy"
classes: wide
date: 2020-01-01T08:30:00
last_modified_at: 2020-08-27T08:30:00
categories:
  - Template
tags:
  - 
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

# <i class="fas fa-book" aria-hidden="true" style="color: white; margin-right:5px;"></i> Heading

{: .text-right}
<span style="font-size:11px;"><button onclick="window.print()"><i class="fas fa-print" aria-hidden="true" style="color: black; margin-right:5px;"></i>Print</button></span>

[GitHub][1]{:target="_blank"}

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

{: .text-center}
<a href="#" class="btn btn--info btn--small"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a>

[1]: https://github.com/BanterBoy

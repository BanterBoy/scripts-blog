---
layout: post
title: "Learning PowerShell From Scripting To CmdLet Part 1"
excerpt: "Part one in a series of posts detailing my journey in learning PowerShell"
header:
  overlay_image: 
  overlay_filter: rgba(90, 104, 129, 0.7)
  teaser: 
classes: wide
categories:
  - Blog
  - Series
tags:
  - Learning
  - PowerShell
  - Scripting
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

About 8 years ago, I started to learn *PowerShell*. All of my previous scripting experience with Batch Files and VBScript and of course the necessity to use additional 3rd party executables, seems like such a long time ago.

When I first began learning, I had yet to progress to some form of version control system like GitHub and all my scripts and snippets were stored locally either in a PS1 or TXT file. Anything I considered to be valuable or useful for future consumption was saved to my Microsoft OneDrive account.

Despite having a reasonable filing system and mostly using sensible filenames, there was the odd occasion where snippets of code would end up in a notes file or be saved in the wrong place. At home I was lucky enough to have a NAS solution and this also became a repository for more of the scripts I had written. As a consequence of using multiple locations, I would sometimes need to do a little searching to find some of the files. As many IT Admins will know, Windows Search can be a little flaky and also a little slow. Having spent enough time scripting in *PowerShell*, it was now quite easy for me to find what I was looking for using my own script. It was simple enough and also saved time from having to search manually.

```powershell
$DaysPast = Read-Host "Enter Number of Days"
$Start = (Get-Date).AddDays(-$DaysPast)
$Path = Read-Host "Enter Search Path"
$Extension = Read-Host "Enter Extension"
    Get-ChildItem -Path $Path -Include $Extension -Recurse |
    Where-Object { $_.LastWriteTime -ge "$Start" } |
    Select-Object Directory,Name,LastWriteTime |
    Sort-Object LastWriteTime -Descending |
    Format-Table -AutoSize
Write-Host "Search of -"$Path "- Completed!"
```

This worked for me for some time but as I progressed with learning more about *PowerShell*, I found that scripts had their limitations but it was relatively easy to turn the above into a Function by wrapping the content.

```powershell
Function Find-Files {
	$DaysPast = Read-Host "Enter Number of Days"
	$Start = (Get-Date).AddDays(-$DaysPast)
	$Path = Read-Host "Enter Search Path"
	$Extension = Read-Host "Enter Extension"

Get-ChildItem -Path $Path -Include $Extension -Recurse |
Where-Object { $_.LastWriteTime -ge "$Start" } |
Select-Object Directory,Name,LastWriteTime |
Sort-Object LastWriteTime -Descending |
Format-Table -AutoSize

Write-Host "Search of -"$Path "- Completed!"
}
```

This provided the basic capability of a function, was easier to use and could be added to my *PowerShell* profile (more on that another time) making it readily available whenever I opened a *PowerShell* session. Now I could just type Find-Files and enter the details for the search.


Writing my own Functions seemed to be the next thing I needed to learn.

More to come in part 2

{: .text-center}
<a href="#" class="btn btn--info btn--small"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a>

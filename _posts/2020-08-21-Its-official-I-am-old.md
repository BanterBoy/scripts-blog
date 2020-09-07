---
layout: post
title: "It's Official"
excerpt: "I am definitely old - or at least middle aged! <br> IT Resources, PowerShellGet and the PowerShell Gallery"
header:
  overlay_image: 
  overlay_filter: rgba(90, 104, 129, 0.7)
  teaser: 
toc: true
toc_label: PowerShellGet
toc_icon: book-reader
toc_sticky: true
categories:
  - Blog
  - Module
tags:
  - PowerShell
  - Scripting
  - Resources
  - PowerShell Gallery
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

# Background

Being a bit of an insomniac sometimes means that what starts out as a 24 hour day, sometimes turns into a very long day with a period of dark requiring some illumination in the middle. Sadly this is followed by another seemingly endless day before you next have the luxury of some sleep. Stress can be a key factor in prompting this onslaught of being awake and honestly, the combination of a pandemic and the extended period of searching for a new job have likely caused the latest. The fortunate side of being awake has meant that I have had the opportunity to watch a few box sets, so like any other time, I chose a random movie collection to while away the hours and I also decided to write an article for my blog.

When I started blogging, my first idea was to write a series of articles about my transition from scripting in PowerShell to developing PowerShell Modules. During my research for part two in the series, compiling a list of resources that have helped me in the past, I was surprised to find that Microsoft are retiring the [Microsoft TechNet Script Center][1]{:target="_blank"}. They have a link to an article on their [Microsoft docs blog site][2]{:target="_blank"} explaining that they will no longer be maintaining this resource <span style="font-style: oblique; font-size:11px;">(date to be finalised)</span>

It's a massive shame but somewhat understandable. [Ed Wilson - The Scripting Guy][3]{:target="_blank"}, who I followed for many years, retired some three years ago and the [Scripting Guy Blog Site][4]{:target"_blank"} has since been maintained by a team of Premier Field Engineers, with many good articles and tips. This is still available and hopefully continues for some time to come. You can also follow them on [<i class="fab fa-fw fa-twitter-square" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>@scriptingguys][5]{:target="_blank"}

When I read the blog post, it felt like the end of an era and certainly made me feel old. I also laughed as it made me think of the [BOFH][6]{:target="_blank"} retiring and his PFY being promoted. "The PFY had a good teacher, who also taught me a thing or two". The Script Center has been somewhere that I and no doubt many IT Admins relied on for VBScripts, Batch Files and also PowerShell, offering scripts for reporting, user administration and many other automated task. Like any good resource, these scripts and snippets have been hacked and altered and used to automate more and more and turn our often arduous tasks into something orchestrated and hassle free. As the tech industry has changed, many of the contributors and indeed myself have moved on and are using repositories like [<i class="fab fa-fw fa-github" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>GitHub][7]{:target="_blank"}, [<i class="fab fa-fw fa-gitlab" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>GitLab][8]{:target="_blank"}, [<i class="fab fa-fw fa-bitbucket" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>BitBucket][9]{:target="_blank"} etc to host their code, so whilst this resource will no longer be available, there are plenty of places to get your coding fix.

Microsoft's documentation transition wasn't something they did in a rush and [<i class="fab fa-fw fa-microsoft" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>docs.microsoft.com][10]{:target="_blank"} is something of a premiere resource when it comes to all things Microsoft.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## PowerShell Gallery

Anybody looking for their next useful PowerShell script or indeed module has far more locations than there ever used to be. My favourite and certainly the easiest to access from PowerShell due to the package management features, is the [PowerShell Gallery][11]{:target="_blank"} where there are a variety of modules, from [Database Management][12]{:target="_blank"} to [ChatOps][13]{:target="_blank"} and certainly far too many to list here.

<i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i><span style="font-style: oblique; font-size:16px;">[dbatools][14]{:target="_blank"}</span>
<br>
<i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i><span style="font-style: oblique; font-size:16px;">[dbatools documentation][15]{:target="_blank"}</span>

<i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i><span style="font-style: oblique; font-size:16px;">[PoshBot][16]{:target="_blank"}</span>
<br>
<i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i><span style="font-style: oblique; font-size:16px;">[PoshBot documentation][17]{:target="_blank"}</span>
<br>


{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## Modules and Package Management

The **PowerShellGet** module has a handful of commands that enable you to search for and install the many different modules.

### Get-Command

```powershell
Get-Command -Module PowerShellGet

CommandType     Name                                Version    Source
-----------     ----                                -------    ------
Function        Find-Command                        2.2.4.1    PowerShellGet
Function        Find-DscResource                    2.2.4.1    PowerShellGet
Function        Find-Module                         2.2.4.1    PowerShellGet
Function        Find-RoleCapability                 2.2.4.1    PowerShellGet
Function        Find-Script                         2.2.4.1    PowerShellGet
Function        Get-CredsFromCredentialProvider     2.2.4.1    PowerShellGet
Function        Get-InstalledModule                 2.2.4.1    PowerShellGet
Function        Get-InstalledScript                 2.2.4.1    PowerShellGet
Function        Get-PSRepository                    2.2.4.1    PowerShellGet
Function        Install-Module                      2.2.4.1    PowerShellGet
Function        Install-Script                      2.2.4.1    PowerShellGet
Function        New-ScriptFileInfo                  2.2.4.1    PowerShellGet
Function        Publish-Module                      2.2.4.1    PowerShellGet
Function        Publish-Script                      2.2.4.1    PowerShellGet
Function        Register-PSRepository               2.2.4.1    PowerShellGet
Function        Save-Module                         2.2.4.1    PowerShellGet
Function        Save-Script                         2.2.4.1    PowerShellGet
Function        Set-PSRepository                    2.2.4.1    PowerShellGet
Function        Test-ScriptFileInfo                 2.2.4.1    PowerShellGet
Function        Uninstall-Module                    2.2.4.1    PowerShellGet
Function        Uninstall-Script                    2.2.4.1    PowerShellGet
Function        Unregister-PSRepository             2.2.4.1    PowerShellGet
Function        Update-Module                       2.2.4.1    PowerShellGet
Function        Update-ModuleManifest               2.2.4.1    PowerShellGet
Function        Update-Script                       2.2.4.1    PowerShellGet
Function        Update-ScriptFileInfo               2.2.4.1    PowerShellGet
```

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

### Find-Module

Using the functions exposed by the PowerShellGet module, it is very simple to search the PowerShell Gallery for modules that will add functionality to your scripts and allow you to automate things like the creation and management of WiFi profiles.

```powershell
PS C:\GitRepos> Find-Module -Name *wifi*

Version              Name                                Repository           Description
-------              ----                                ----------           -----------
1.7.5                WifiTools                           PSGallery            A set of tools that can simplify handle Wi-Fi profiles, connection. Also additional tools …
0.5.0.0              wifiprofilemanagement               PSGallery            Leverages the native WiFi functions to manage WiFi profiles
1.0.0                WiFiProfileManagementDsc            PSGallery            PowerShell DSC resource for manage WiFi profile.
0.2.1                WiFi                                PSGallery            Manage wireless profiles on the Windows operating system.
1.0                  Get-WifiPassword                    PSGallery            Returns list of known wifi networks with their passwords. The module uses netsh utility.
0.0.2                ProductivityTools.PSGetCurrentWifi… PSGallery            It returns current wifi password

PS C:\GitRepos>
```

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

### Install-Module

Once you have found what you are looking for, it can then be installed like so:-

```powershell
Install-Module -Name WifiTools -Scope CurrentUser
```

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

### Publish-Module

You may also have seen in PowerShellGet's command list, you can also publish your modules to the Gallery. All of this can be performed from the command line, meaning you never really have to leave the shell.

```powershell
Publish-Module -Name <moduleName> -NuGetApiKey ********-****-****-****-************
```
I am sure however that I will cover more about that another time. There are already however, plenty of other bloggers who have written about this subject already. This is a well written article that you should consider reading if you are in the market to publish your module to the gallery or if you are just interested in the process.

<span style="font-style: oblique; font-size:16px;">[<i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>ramblingcookiemonster - Building a PowerShell Module][18]{:target="_blank"}</span>

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## Where and Why

PowerShell has been around now for some time and there are plenty of resources for finding, installing, creating and publishing modules; many of which have been around for some time and plenty to show you how to create your own.

### Where

Below I have listed some of the resources I have used in the past. Thankfully educating yourself these days is made much easier, as technology has moved on from my early days of studying and having to get a book from the library or the local bookstore <span style="font-style: oblique; font-size:11px;">(yes I am that old)</span>.  It is now available to be consumed in various formats; Blog posts, YouTube videos, electronic books and I am sure if you want to, good old fashioned books are still available.

<span style="font-style: oblique; font-size:16px;"><i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>[An Introduction to PowerShell Modules][19]{:target"_blank"}</span>
<br>
<span style="font-style: oblique; font-size:16px;"><i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>[Creating New PowerShell Projects][20]{:target"_blank"}</span>
<br>
<span style="font-style: oblique; font-size:16px;"><i class="fab fa-fw fa-youtube" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>[Don Jones Toolmaking][21]{:target"_blank"}</span>
<br>
<span style="font-style: oblique; font-size:16px;"><i class="fab fa-fw fa-leanpub" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>[The PowerShell Scripting and Toolmaking Book][22]{:target"_blank"}</span>
<br>
<span style="font-style: oblique; font-size:16px;"><i class="fab fa-fw fa-amazon" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>[Learn Windows PowerShell in a Month of Lunches][23]{:target"_blank"}</span>

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

### Why

I have had numerous conversations in the past with IT Admins, advocating the need to learn PowerShell and great fun in helping my colleagues at work with any and all PowerShell questions. I am sure we have all had conversations in the past that have been similar in experience to this post - <span style="font-style: oblique; font-size:16px;"><i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>[PowerShell Is Too Hard][24]{:target"_blank"}</span>. Thankfully I have also had plenty where the outcome has been fruitful and I have been able to help some find the value in spending the time learning to use PowerShell to automate the monotonous or just lengthy tasks they need to perform on a regular basis. I have even managed to coerce one of my [friends][25]{:target="_blank"} who is a Software Developer into creating his own <span style="font-style: oblique; font-size:16px;"><i class="fas fa-fw fa-external-link-alt" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>[modules][26]{:target"_blank"}</span>. Hopefully in continuing to write articles, I can convince or help more people to learn the benefits of PowerShell and its many uses.

{: .text-right}
<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a></span>

## Future Articles

I know many people think they don't have much to offer but having started blogging I look forward to offering if not a completely unique perspective, yet another place people can go to learn more about PowerShell.

I can tell you are all on the edge of your seats and looking forward to the next instalment. I hope to write about some of the following, preferably during the day <i class="fas fa-fw fa-smile-wink" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>

 * Building a Jekyll Blog Dev Server.
 * PowerShell Profiles (everyone should have one)
 * My son's recent lesson on 2FA and why its important
 * Modules, CmdLets, Functions and Scripts.....
 * and no doubt many other IT/PowerShell related posts

Having reached the end of this post with the 5th movie from the Fast and Furious box set playing in the background, I have a much greater appreciation for those who are already blogging and whose sites I have frequented in the past. I hope this also becomes just as useful to anyone who turns up for a read.

{: .text-center}
<a href="#" class="btn btn--info btn--small"><i class="fas fa-caret-up" aria-hidden="true" style="color: #303030; margin-right:5px;"></i>Back to Top</a>

[1]: https://gallery.technet.microsoft.com/scriptcenter
[2]: https://docs.microsoft.com/en-gb/teamblog/technet-gallery-retirement?source=docs
[3]: https://www.linkedin.com/in/mredwilson/
[4]: https://devblogs.microsoft.com/scripting/
[5]: https://twitter.com/scriptingguys
[6]: https://www.theregister.com/data_centre/bofh/earlier/10/
[7]: https://github.com/
[8]: https://gitlab.com/
[9]: https://bitbucket.org/
[10]: https://docs.microsoft.com/
[11]: https://www.powershellgallery.com/
[12]: https://www.powershellgallery.com/packages?q=database
[13]: https://www.powershellgallery.com/packages?q=chat
[14]: https://dbatools.io
[15]: https://dbatools.io/download/
[16]: https://github.com/poshbotio/PoshBot
[17]: https://poshbot.readthedocs.io/en/latest/
[18]: http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/
[19]: https://www.red-gate.com/simple-talk/sysadmin/powershell/an-introduction-to-powershell-modules/
[20]: https://jdhitsolutions.com/blog/powershell/4994/creating-new-powershell-projects/
[21]: https://www.youtube.com/watch?v=KprrLkjPq_c
[22]: https://leanpub.com/powershell-scripting-toolmaking
[23]: https://www.amazon.co.uk/Learn-Windows-PowerShell-Month-Lunches/dp/1617294160
[24]: http://ramblingcookiemonster.github.io/PowerShell-Is-Too-Hard/
[25]: https://robgreen.me/
[26]: https://www.powershellgallery.com/profiles/robgreen

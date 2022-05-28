---
layout: post
title: Test-DNSRecord.ps1
---

### something exciting

A simple wrapper for the function Resolve-DNSName to perform DNS queries against specific DNS Servers. This in no way replaces Resolve-DNSName but provides some simple enhanced queries that do not require you to remember the names or IP Addresses of the Name Servers that you wish to query. This tool does not include all of the functionality of Resolve-DNSName but will speed up everyday DNS queries and diagnostics.

The parameters enable you to select from a list of Pubic DNS servers to test DNS resolution for a domain. The DNSProvider switch parameter can also be used to select you internal DNS servers and to test against the domains own Name Servers.

The DNSProvider Switch utilises external servers and queries to populate the switch with the relevant internal/external/zone servers to perform the query. Further information can be found in the parameter section.

The internalDNSservers option for the DNSProviders switch performs an AD query to determine the hostname of the Domain Controllers, performs a DNS query against each Domain Controller and displays the results.

The list of popular Public DNS Servers was taken from the article - <a href="https://www.lifewire.com/free-and-public-dns-servers-2626062">https://www.lifewire.com/free-and-public-dns-servers-2626062</a> which also provides some useful information regarding DNS and why you might select different public dns servers for your name resolution.

---

- [something exciting](#something-exciting)
  - [Examples](#examples)
    - [Example 1](#example-1)
    - [Example 2](#example-2)
    - [Example 3](#example-3)
    - [Example 4](#example-4)
    - [Example 5](#example-5)
  - [OutPut](#output)
  - [Script](#script)
  - [Download](#download)
  - [gist-it](#gist-it)
  - [Report Issues](#report-issues)

<small><i>[Table of contents generated with markdown-toc][1]{:target="\_blank"}</i></small>

---

#### Examples

<br>

##### EXAMPLE 1

```text
Test-DNSRecord

cmdlet Test-DNSRecord at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
recordName[0]: !?
Please enter DNS record name to be tested. Expected format is either a fully qualified domain name (FQDN) or an IP address (IPv4 or IPv6) e.g. example.com or
151.101.0.81)
recordName[0]: example.com
recordName[1]:

 Name                Type   TTL   Section    IPAddress
 ----                     ----    ---    -------    ---------
 example.com    A      20738 Answer     93.184.216.34
 example.com    A      9744  Answer     93.184.216.34

This example shows Test-DNSRecord without any options. As recordname is a mandatory field, you are prompted to enter a FQDN or an IP.
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<br>

##### EXAMPLE 2

```text
Test-DNSRecord -recordName example.com -Type A -DNSProvider GooglePrimary

Name           Type   TTL   Section    IPAddress
----                ----   ---   -------    ---------
example.com    A      20182 Answer     93.184.216.34

This example shows an 'A' record query against Google's Primary Public DNS server.
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<br>

##### EXAMPLE 3

```text
Test-DNSRecord -recordName bbc.co.uk -Type CNAME -DNSProvider AllPublic

Name         Type TTL   Section    PrimaryServer       NameAdministrator           SerialNumber
----              ---- ---   -------    -------------       -----------------           ------------
bbc.co.uk    SOA  899   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  899   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  898   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800
bbc.co.uk    SOA  900   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800

This example shows the results from a CNAME lookup queried against the complete list of Public DNS Servers defined in the DNSProviders parameter.
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<br>

##### EXAMPLE 4

```text
Test-DNSRecord -recordName bbc.co.uk -Type CNAME -DNSProvider GooglePrimary -Verbose
VERBOSE: bbc.co.uk
VERBOSE: Checking Google Primary...

Name         Type TTL   Section    PrimaryServer       NameAdministrator           SerialNumber
----              ---- ---   -------    -------------       -----------------           ------------
bbc.co.uk    SOA  899   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800

This example displays the output with the verbose option enabled. The function performs the search and details which DNS Provider is being queried.
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<br>

##### EXAMPLE 5

```text
Test-DNSRecord -recordName bbc.co.uk -Type CNAME -DNSProvider InternalDNSserver -Verbose

VERBOSE: bbc.co.uk
VERBOSE: Checking DANTOOINE.domain.leigh-services.com...

Name         Type TTL   Section    PrimaryServer       NameAdministrator           SerialNumber
----              ---- ---   -------    -------------       -----------------           ------------
bbc.co.uk    SOA  899   Authority  ns.bbc.co.uk        hostmaster.bbc.co.uk        2021011800

This example displays the output with the verbose option enabled. The function performs the search and details which DNS Provider is being queried. The InternalDNSserver DNS Provider, performs an AD query and uses the internal AD Servers for DNS resolution.
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### OutPut

System.String. The output returned from Test-DNSRecord is a string

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

```powershell

```

functions/dns/Test-DNSRecord.ps1

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

You can of course copy any part of the script from the text above, or you can simply press the download button and download the entire script. Choice is yours....its just nice to have choices 😎

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/dns/Test-DNSRecord.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### gist-it

I have used <i>[gist-it][2]{:target="\_blank"}</i> to display the files from my GitHub repository and embed it into the web page. This is very similar to <i>[GitHub Gists][3]{:target="\_blank"}</i>

Gist-it uses <i>[google-code-prettify][4]{:target="\_blank"}</i> for Syntax highlighting.

The `view raw` link at the bottom right of the script will take you to a raw text version of the script which you can copy and paste.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-DNSRecord.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://gist-it.appspot.com/
[3]: https://gist.github.com
[4]: https://github.com/googlearchive/code-prettify

_[Back to Top]: Click to go back to the top of the page
_[ Download]: Click this button to Download the file.
_[Back to Functions]: Click here to go back to the Functions Index
_[Table of contents generated with markdown-toc]: Click here to create your own.

```

```

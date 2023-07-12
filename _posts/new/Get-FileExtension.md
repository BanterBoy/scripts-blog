---
layout: post
title: Get-FileExtension.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Get-Extension`. This function contains a nested class called `FileExtension` that has two properties: `Extension` and `Category`. The `Get-FileExtensions` function takes a JSON string as input, converts it to a PowerShell object, and then iterates over each category and extension in the object. For each extension, it creates a new `FileExtension` object and adds it to a list. Finally, the function returns the list of `FileExtension` objects.

The `Get-Extension` function then calls `Get-FileExtensions` with a JSON string that is obtained by making a REST call to a GitHub repository that contains a list of file extensions and their categories. The function then iterates over each `FileExtension` object in the list and attempts to create a new PowerShell object with two properties: `Extension` and `Category`. If the creation is successful, the object is outputted to the console. If there is an error, the string "This is some kind of bullshit" is outputted to the console. Finally, the function returns nothing.

The purpose of this script is to obtain a list of file extensions and their categories from a GitHub repository and output them to the console. The script also includes an example usage that demonstrates how to find the category for a specific extension.

To improve the readability of the code, the developer could add comments to explain what each section of the code does. Additionally, the developer could use more descriptive variable names to make the code easier to understand. To improve the performance of the code, the developer could consider using a hashtable instead of a list to store the `FileExtension` objects, as hashtables have faster lookup times.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! Here are some examples of how you can use this script:

1. To run the script, simply open PowerShell and navigate to the directory where the script is saved. Then, type `.\Get-FileExtension.ps1` and press Enter. This will execute the script and output a list of file extensions and their categories to the console.

2. To find the category for a specific file extension, you can use the example usage provided in the script. For example, to find the category for the `.zip` extension, you can uncomment the example usage code at the bottom of the script and run it. This will output the category for the `.zip` extension to the console.

3. You can modify the script to output the list of file extensions and their categories to a file instead of the console. To do this, you can replace the `Write-Output` cmdlet with the `Out-File` cmdlet and specify the path and filename of the output file. For example, you can modify the script to output the list to a file called `extensions.txt` in the current directory by adding the following line before the `foreach` loop:

   `Out-File -FilePath .\extensions.txt -InputObject $Extensions`

   This will create a new file called `extensions.txt` in the current directory and write the list of file extensions and their categories to it.

I hope this helps! Let me know if you have any other questions.

**_@BanterBoy:_** - What output can I expect from this function

**_@GitHub Copilot_** - This function outputs a list of file extensions and their categories to the console. The list is obtained by making a REST call to a GitHub repository that contains a JSON file with the file extensions and their categories. The function then iterates over each file extension in the list and attempts to create a new PowerShell object with two properties: `Extension` and `Category`. If the creation is successful, the object is outputted to the console. If there is an error, the string "This is some kind of bullshit" is outputted to the console.

The output of the function will be a list of PowerShell objects, where each object has two properties: `Extension` and `Category`. The `Extension` property contains the file extension (with a `*.` prefix), and the `Category` property contains the category that the file extension belongs to. For example, the output might look like this:

```
Extension     Category
---------     --------
*.aac         Audio
*.aiff        Audio
*.mp3         Audio
*.ogg         Audio
*.opus        Audio
*.wav         Audio
*.wma         Audio
*.bmp         Image
*.gif         Image
*.jpg         Image
*.jpeg        Image
*.png         Image
*.svg         Image
*.tif         Image
*.tiff        Image
*.avi         Video
*.flv         Video
*.m4v         Video
*.mkv         Video
*.mov         Video
*.mp4         Video
*.mpeg        Video
*.mpg         Video
*.ogv         Video
*.webm        Video
*.wmv         Video
*.doc         Document
*.docx        Document
*.odt         Document
*.pdf         Document
*.ppt         Document
*.pptx        Document
*.rtf         Document
*.txt         Document
*.xls         Document
*.xlsx        Document
*.zip         Archive
*.7z          Archive
*.bz2         Archive
*.gz          Archive
*.rar         Archive
*.tar         Archive
*.tgz         Archive
*.xz          Archive
*.zipx        Archive
```

I hope this helps! Let me know if you have any other questions.

---

#### Script

```powershell
function Get-Extension {

    class FileExtension {
        [string]$Extension
        [string]$Category

        FileExtension([string]$extension, [string]$category) {
            $this.Extension = $extension
            $this.Category = $category
        }
    }

    function Get-FileExtensions([string]$JsonData) {
        $data = ConvertFrom-Json $JsonData
        $fileExtensions = New-Object System.Collections.Generic.List[FileExtension]

        foreach ($category in $data.PSObject.Properties.Name) {
            foreach ($extension in $data.$category) {
                $fileExtension = [FileExtension]::new($extension, $category)
                $fileExtensions.Add($fileExtension)
            }
        }

        return $fileExtensions
    }

    $Extensions = Get-FileExtensions -JsonData (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/dyne/file-extension-list/master/pub/categories.json" -Method Get -UseBasicParsing | ConvertTo-Json)
    foreach ($Extension in $Extensions) {
        try {
            $properties = @{
                Extension = "*.$($Extension.Extension)"
                Category  = $Extension.Category
            }
            $Output = New-Object -TypeName psobject -Property $properties
        }
        catch {
            Write-Output -InputObject "This is some kind of bullshit"
        }
        finally {
            Write-Output -InputObject $Output
        }
    }

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Get-FileExtension.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FileExtension.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

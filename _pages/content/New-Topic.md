---
layout: post
title: New-Topic
permalink: /content/_pages/New-Topic.html
# This template provides a basic structure for Dynamics 365 articles.
# required metadata
---

# Metadata and Markdown template

This Dynamics 365 for Operations template contains examples of Markdown syntax, as well as guidance on setting the metadata. To get the most of it, you must view both the [raw Markdown](https://raw.githubusercontent.com/MicrosoftDocs/Dynamics-365-Operations/master/template.md?token=AUBjQ-wxx8wHU3pnuQiYvPdvbodbxP2uks5Ypg9_wA%3D%3D) and the [rendered view](https://github.com/MicrosoftDocs/Dynamics-365-Operations/edit/master/template.md) (for instance, the raw Markdown shows the metadata block, while the rendered view does not).

When creating a Markdown file, you should copy this template to a new file, fill out the metadata as specified below, set the H1 heading above to the title of the article, and delete the content.

## Metadata

The full metadata block is above (in the [raw Markdown](https://raw.githubusercontent.com/MicrosoftDocs/Dynamics-365-Operations/master/template.md?token=AUBjQ-wxx8wHU3pnuQiYvPdvbodbxP2uks5Ypg9_wA%3D%3D)), divided into required fields and optional fields. **DO NOT** use a colon (:) in any of the metadata elements.

Here are some key things to note about metadata.

- **Required metadata**

  - **title** - The title will appear in search engine results. You can also add a pipe (|) followed by the product name (for example, `title: Action search | Microsoft Docs`). The title doesn't need be identical to the title in your H1 heading and it should contain 65 characters or less (including | PRODUCT NAME).
    - **description** - This is the full description that appears in the search results. Usually this is the first paragraph of your topic.
    - **author** - This is your GitHub alias, which is required for ownership and sorting in GitHub.
    - **manager** - Use "annbe" in this field.
    - **ms.date** - This should be the first proposed publication date.
    - **ms.topic** - Enter "article" here.
    - **ms.prod**
    - **ms.service** - Always use "Dynamics365Operations".
    - **ms.technology**

- **Optional metadata**
  - **audience** - Use of these values: Application User, Developer, or IT Pro.
    - **ms.reviewer** - This is the Microsoft alias of your Content Strategist.
    - **ms.custom**
    - **ms.search.region** - Use "global" or enter a country-region value.
    - **ms.author** - Use your Microsoft alias.

## Basic Markdown, GFM, and special characters

`some | text`

All basic and GitHub Flavoured Markdown (GFM) is supported. For more information, see:

- [Baseline Markdown syntax](https://daringfireball.net/projects/markdown/syntax)
- [GFM documentation](https://guides.github.com/features/mastering-markdown)

Markdown uses special characters such as \*, \`, and \# for formatting. If you wish to include one of these characters in your content, you must do one of two things:

- Put a backslash before the special character to "escape" it (for example, `\*` for a \*)
- Use the [HTML entity code](http://www.ascii.cl/htmlcodes.htm) for the character (for example, `&#42;` for a \*).

## File name

File names use the following rules:

- Contain only lowercase letters, numbers, and hyphens.
- No spaces or punctuation characters. Use the hyphens to separate words and numbers in the file name.
- Use action verbs that are specific, such as develop, buy, build, troubleshoot. No -ing words.
- No small words - don't include a, and, the, in, or, etc.
- Must be in Markdown and use the .md file extension.
- Keep file names short. They are part of the URL for your articles.

## Headings

Use sentence-style capitalization. Do not overcapitalize.

Headings should use atx-style, that is, use 1-6 hash characters (#) at the start of the line to indicate a heading, corresponding to HTML headings levels H1 through H6. Examples of first- and second-level headers are used above.

There **must** be only one first-level heading (H1) in your topic, which will be displayed as the on-page title.

If your heading finishes with a `#` character, you need to add an extra `#` character in the end in order for the title to render correctly. For example, `# Define a data method in C# #`.

Second-level headings will generate the on-page TOC that appears in the "In this article" section under the on-page title.

### Third-level heading

#### Fourth-level heading

##### Fifth level heading

###### Sixth-level heading

## Text styling

_Italics_
Use for files, folders, paths (for long items, split onto their own line) - new terms - URLs (unless rendered as links, which is the default).

**Bold**
Use for UI elements.

## Links

### Internal links

To link to a header in the same Markdown file (also known as anchor links), you'll need to find the ID of the header that you're trying to link to. To confirm the ID, view the source of the rendered article, find the ID of the header (for example, `id="blockquote"`), and link using # + id (for example, `#blockquote`).

**Note:** You need to follow the casing of the header ID. In the following examples, the README.md file is all caps, so that's how this needs to be written in Markdown. Most IDs are lowercase.

The ID is auto-generated based on the header text. So, for example, given a unique section named `## Step 2`, the ID would look like this `id="step-2"`.

- Example: [Chapter 1](#chapter-1)

To link to a Markdown file in the same repo, use [relative links](https://www.w3.org/TR/WD-html40-970917/htmlweb.html#h-5.1.2), including the ".md" at the end of the filename.

- Example: [Readme](README.md)

To link to a header in a Markdown file in the same repo, use relative linking + hashtag linking.

- Example: [Links](#links)

### External links

To link to an external file, use the full URL as the link.

- Example: [GitHub](http://www.github.com)

If a URL appears in a Markdown file, it will be transformed into a clickable link.

- Example: http://www.github.com

## Lists

### Ordered lists

1. This
1. Is
1. An
1. Ordered
1. List

#### Ordered list with an embedded list

1. Here
1. comes
1. an
1. embedded
   1. Miss Scarlet
   1. Professor Plum
1. ordered
1. list

### Unordered Lists

- This
- is
- a
- bulleted
- list

##### Unordered list with an embedded list

- This
- bulleted
- list
  - Mrs. Peacock
  - Mr. Green
- contains
- other
  1. Colonel Mustard
  1. Mrs. White
- lists

## Horizontal rule

---

## Tables

| Tables           |      Are      |  Cool |
| ---------------- | :-----------: | ----: |
| col 3 is         | right-aligned | $1600 |
| col 2 is         |    centred    |   $12 |
| col 1 is default | left-aligned  |    $1 |

You can use a [Markdown table generator tool](http://www.tablesgenerator.com/markdown_tables) to help creating them more easily.

## Code

Use three backticks (&#96;&#96;&#96;) to begin and end a code example block . You an also indent a line to have it rendered as a code example.

```
function fancyAlert(arg) {
    if(arg) {
        $.docs({div:'#foo'})
    }
}
```

Use backticks (&#96;) for `inline code`. Use inline code for command-line commands, database table and column names, and language keywords.

## Blockquotes

> The drought had lasted now for ten million years, and the reign of the terrible lizards had long since ended. Here on the Equator, in the continent which would one day be known as Africa, the battle for existence had reached a new climax of ferocity, and the victor was not yet in sight. In this barren and desiccated land, only the small or the swift or the fierce could flourish, or even hope to survive.

## Images

### Static image or animated gif

![this is the alt text](/assets/images/marmoset/remove-blogserver-marmoset-tiltshift.png)

### Linked image

[![alt text for linked image](/assets/images/marmoset/remove-blogserver-marmoset-RGBshift.png)](https://dot.net)

## Videos

<video width="262" height="518" controls>
  <source src="/assets/video/9nLoBt9dej.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## docs.microsoft extensions

docs.microsoft provides a few additional extensions to GitHub Flavoured Markdown.

### Alerts

It's important to use the following alert styles so they render with the proper style in the documentation site. However, the rendering engine on GitHub doesn't differentiate them.

#### Note

> [!NOTE]
> This is a NOTE

#### Warning

> [!WARNING]
> This is a WARNING

#### Tip

> [!TIP]
> This is a TIP

#### Important

> [!IMPORTANT]
> This is IMPORTANT

---

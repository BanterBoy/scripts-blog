<#
    .SYNOPSIS
    A brief description of the function or script. This keyword can be used only once in each topic.

    .DESCRIPTION
    A detailed description of the function or script. This keyword can be used only once in each topic.

    .PARAMETER
    The description of a parameter. Add a ".PARAMETER" keyword for each parameter in the function or script syntax.

    Type the parameter name on the same line as the ".PARAMETER" keyword. Type the parameter description on the lines following the ".PARAMETER" keyword. Windows PowerShell interprets all text between the ".PARAMETER" line and the next keyword or the end of the comment block as part of the parameter description. The description can include paragraph breaks.


    Copy
    .PARAMETER  <Parameter-Name>
    The Parameter keywords can appear in any order in the comment block, but the function or script syntax determines the order in which the parameters (and their descriptions) appear in help topic. To change the order, change the syntax.

    You can also specify a parameter description by placing a comment in the function or script syntax immediately before the parameter variable name. If you use both a syntax comment and a Parameter keyword, the description associated with the Parameter keyword is used, and the syntax comment is ignored.

    .EXAMPLE
    A sample command that uses the function or script, optionally followed by sample output and a description. Repeat this keyword for each example.

    .INPUTS
    The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.

    .OUTPUTS
    The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.

    .NOTES
    Additional information about the function or script.

    .LINK
    The name of a related topic. The value appears on the line below the ".LINK" keyword and must be preceded by a comment symbol # or included in the comment block.

    Repeat the ".LINK" keyword for each related topic.

    This content appears in the Related Links section of the help topic.

    The "Link" keyword content can also include a Uniform Resource Identifier (URI) to an online version of the same help topic. The online version opens when you use the Online parameter of Get-Help. The URI must begin with "http" or "https".

    .COMPONENT
    The technology or feature that the function or script uses, or to which it is related. This content appears when the Get-Help command includes the Component parameter of Get-Help.

    .ROLE
    The user role for the help topic. This content appears when the Get-Help command includes the Role parameter of Get-Help.

    .FUNCTIONALITY
    The intended use of the function. This content appears when the Get-Help command includes the Functionality parameter of Get-Help.

#>

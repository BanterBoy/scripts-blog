<#
display a colorful Christmas countdown prompt

 Christmas in 17.09:44:21  PS C:\scripts>

this prompt requires a TrueType font
you would put this in your profile script so that it
only runs in December 1-24

#>

if ((Get-Date).Month -eq 1 -AND (Get-Date).Day -lt 25) {
    #dot source the emoji script
    . C:\GitRepos\Ventrica\NewWork\inProgress\PSEmoji.ps1
  
    #load the Christmas prompt
  
    Function Prompt {
        #get current year
        $year = (Get-Date).year
        #get a timespan between Christmas for this year and now
  
        $time = [datetime]"25 December $year" - (Get-Date)
        #turn the timespan into a string and strip off the milliseconds
        $timestring = $time.ToString().Substring(0, 11)
  
        #get random string of decorative characters
        #they can be pasted emojis or created from values
        $Snow = ""
        # $snow = ConvertTo-Emoji 0x2744
        # $sparkles = ""
        $sparkles = ConvertTo-Emoji 0x2728
        #$snowman = ""
        $snowman = ConvertTo-Emoji 0x26C4
        $santa = ConvertTo-Emoji 0x1F385
        $mrsClaus = ConvertTo-Emoji 0x1F936
        $tree = ConvertTo-Emoji 0x1F384
        $present = ConvertTo-Emoji 0x1F381
        $notes = ConvertTo-Emoji 0x1F3B5
        $bow = ConvertTo-Emoji 0x1F380
        $star = ConvertTo-Emoji 127775
        $shootingStar = ConvertTo-Emoji 127776
        $myChars = $santa, $mrsClaus, $tree, $present, $notes, $bow, $star, $shootingStar, $snow, $snowman, $sparkles
        #get a few random elements for the prompt
        $front = -join ($myChars | Get-Random -Count 2)
        $back = -join ($myChars | Get-Random -Count 2)
  
        #the text to display
        $text = "Christmas is coming in $timestring"
  
        #get each character in the text and randomly assign each a color using an ANSI sequence
        $colorText = $text.tocharArray() | ForEach-Object {
            $i = Get-Random -Minimum 1 -Maximum 50
            switch ($i) {
                { $i -le 50 -AND $i -ge 45 } { $seq = "$([char]0x1b)[1;5;38;5;199m" }
                { $i -le 45 -AND $i -ge 40 } { $seq = "$([char]0x1b)[1;5;38;11;199m" }
                { $i -le 40 -AND $i -ge 30 } { $seq = "$([char]0x1b)[1;38;5;50m" }
                { $i -le 20 -and $i -gt 15 } { $seq = "$([char]0x1b)[1;5;38;5;1m" }
                { $i -le 16 -and $i -gt 10 } { $seq = "$([char]0x1b)[1;38;5;47m" }
                { $i -le 10 -and $i -gt 5 } { $seq = "$([char]0x1b)[1;5;38;5;2m" }
                default { $seq = "$([char]0x1b)[1;37m" }
            }
            "$seq$_$([char]0x1b)[0m"
        } #foreach
  
        #write the prompt text to the host on its own line
        Write-Host "$front $($colortext -join '') $back" #-NoNewline #-foregroundcolor $color
  
        #the function needs to write something to the pipeline
        "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
  
    } #end function
  
} #If December
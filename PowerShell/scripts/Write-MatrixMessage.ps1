#Author: Kent Yeabower
#Date: 12-13-17

#This script takes certain functions from Oisin Grehan's Matrix.psm1 module and introduces functionality and code that 
#allows a user to write a Message on the screen using falling Matrix code, like the introduction in the movie "The Matrix."

#The following functions in this script were originally written by Oisin Grehan in his CMatrix script, and they are very well done:
#New-Rectangle
#Get-BufferCell
#New-BufferCell
#Set-BufferCell
#New-Column
#New-Module in the New-Column function
#Step function in the New-Column function
#Write-FrameBuffer
#Show-FrameBuffer

#I have taken Oisin's functions above and added my own functionality to some of them for the purposes of this script, which
#is to write a Message using the Matrix falling code, much like the intro of the first Matrix movie where the code falls into
#place and spells the phrase "The Matrix".

#I am a firm believer in giving credit where due, and Oisin's Matrix.psm1 module and functions are extremely well written and very
#concise. So, I have done my best in the script below to notate the code originally written by Oisin, as it is a very good design and 
#deserves due credit. I have left his original introduction comments just below also, for anyone that would like to go and 
#download a copy of his original Matrix.psm1 module. It is a very cool Matrix screensaver script that scrolls Matrix code in a 
#PowerShell console window after a certain amount of time of inactivity on the system.
#I have tried to credit the code below in sections, i.e. when you see a name (e.g. Oisin Grehan or Kent Yeabower), the code that follows
#was written by that person, until you see the next name notation.

#So, below is the first example of the credit notation format. With the notation of #<Oisin Grehan>, the code that follows was written
#by Oisin, until you see the notation #<Kent Yeabower>, which starts a section of code written by me, until you see the next notation
#of Oisin, etc.

#I have put extra notations for Oisin above the functions he wrote below, as I think they are very well written and concise, and I want to
#be sure he is recognized for that.

#Anyway, thanks again to Oisin for his original Matrix code script design, and I have learned a lot by studying it. I hope you enjoy the 
#additions I have made to it!
#NOTE: I have put get-help functionality into the main Write-MatrixMessage function below if you would like information on the
#additional parameters and functionality of the script.

#<Oisin Grehan>
Set-StrictMode -off

#
# Module: PowerShell Console ScreenSaver Version 0.1
# Author: Oisin Grehan ( http://www.nivot.org )
#
# A PowerShell CMatrix-style screen saver for true-console hosts.
#
# This will not work in Micrisoft's ISE, Quest's PowerGUI or other graphical hosts.
# It should work fine in PowerShell+ from Idera which is a true console.
#

if ($null -eq $host.ui.rawui.windowsize) {
    write-warning "Sorry, I only work in a true console host like powershell.exe."
    throw
}

#<Kent Yeabower>
#We're keeping these outside the module below so we can easily access them outside the module (that way
#we don't have to call them as methods of a custom object, which we would have to do if we kept them
#inside the New-Module script block below.


#<Oisin Grehan>
#
# Console Utility Functions
#

#<Oisin Grehan>
function New-Rectangle {
    param(
        [int]$left,
        [int]$top,
        [int]$right,
        [int]$bottom
    )
    
    $rect = new-object System.Management.Automation.Host.Rectangle
    $rect.left = $left
    $rect.top = $top
    $rect.right = $right
    $rect.bottom = $bottom
    
    $rect
}

#<Oisin Grehan>
function New-Coordinate { 
    param([int]$x, [int]$y) 
    
    new-object System.Management.Automation.Host.Coordinates $x, $y 
} 

#<Oisin Grehan>
function Get-BufferCell {
    param([int]$x, [int]$y)
    
    $rect = new-rectangle $x $y $x $y
    
    [System.Management.Automation.Host.buffercell[, ]]$cells = $host.ui.RawUI.GetBufferContents($rect)    
    
    $cells[0, 0]
}

#<Oisin Grehan>
function New-BufferCell {
    param(
        [string]$Character,
        [consolecolor]$ForeGroundColor = $(get-buffercell 0 0).foregroundcolor,
        [consolecolor]$BackGroundColor = $(get-buffercell 0 0).backgroundcolor,
        [System.Management.Automation.Host.BufferCellType]$BufferCellType = "Complete"
    )
    
    $cell = new-object System.Management.Automation.Host.BufferCell
    $cell.Character = $Character
    $cell.ForegroundColor = $foregroundcolor
    $cell.BackgroundColor = $backgroundcolor
    $cell.BufferCellType = $buffercelltype
    
    $cell
}

#<Oisin Grehan>
function Set-BufferCell {
    [outputtype([System.Management.Automation.Host.buffercell])]
    param(
        [int]$x,
        [int]$y,
        [System.Management.Automation.Host.buffercell]$cell
    )
    
    $rect = new-rectangle $x $y $x $y
        
    # return previous
    get-buffercell $x $y
	            
    # use "fill" overload with single cell rect    
    $host.ui.rawui.SetBufferContents($rect, $cell)


    #<Kent Yeabower>
    If ($MatrixMessageCoordinatesStatic[$x]) {          
        write-verbose "Setting Message cell (Timer is $($TimerMatrix.enabled)) in position ($x,$y) with $($cell.foregroundcolor) $($cell.character)"
    }
	
}

#<Oisin Grehan>
#
# Main entry point for starting the animation
#

#<Oisin Grehan>
function New-Column {
    param($x,
        #<Kent Yeabower>
        [hashtable]$MatrixMessageCoordinatesStatic,
        [hashtable]$MatrixMessageStringArrayHT
    )
    Write-Verbose "New-Column. Just entered new-column function"  

    #<Oisin Grehan>
    # return a new module that represents the column of letters and its state
    # we also pass in a reference to the main screensaver module to be able to
    # access our console framebuffer functions.
    #-#write-host "Inside New-Column function"
    #<Oisin Grehan>
    new-module -ascustomobject -Verbose -name "col_$x" -script {
        param(
            $startx,
            #<Kent Yeabower>
            [hashtable]$MatrixMessageCoordinatesStaticNewColumnModule,
            [hashtable]$MatrixMessageStringArrayHTNewColumnModule,
            [string]$VerbosePreferenceNewColumnModule,
            $ScreenBufferCellsNewColumnModule,
            $NewRectangleModule,
            $NewCoordinateModule,
            $GetBufferCellModule,
            $NewBufferCellModule,
            $SetBufferCellModule
        )

        #<Kent Yeabower>
        Write-Verbose "New-Column.New-Module. Just entered New-module" 

        #Set the Verbose preference of this module to the parent caller's preference.
        #Seems I can't use PSCmdlet methods here  since this is an -ascustomobject module?
        $VerbosePreference = $VerbosePreferenceNewColumnModule  

        #Loading functions into memory so they can be used below
        Invoke-Expression $NewRectangleModule
        Invoke-Expression $NewCoordinateModule
        Invoke-Expression $GetBufferCellModule
        Invoke-Expression $NewBufferCellModule
        Invoke-Expression $SetBufferCellModule
        
        #<Oisin Grehan>
        $script:xpos = $startx
        $script:ylimit = $host.ui.rawui.WindowSize.Height

        [int]$script:head = 1
        [int]$script:fade = 0
        [int]$script:fadelen = [math]::Abs($ylimit / 3)        
        [int]$script:blanklen = [math]::Abs($ylimit / 3)
        [int]$script:blank = 0
        
        #add a random number so the fade starts at random places for each column
        $script:fadelen += (Get-Random -Minimum 0 -Maximum $fadelen)

        #<Kent Yeabower>
        #We need to determine how long the faded characters will be printed before being blanked out
        #So, if the current column has a fadelen of 20, that means it will start fading once the head character reaches y position 10
        #We're going to say that let's print at least half that many, but that number at most
        $script:fadelenTOTAL = (get-random -min ($fadelen / 2) -Max $fadelen)

        Write-Verbose "New-Column.New-Module. Starting column $xpos. Head $head fade $fade fadelen $fadelen fadelentotal $fadelentotal"
        
        #Has to be script scope, can't be global
        $script:HeadCellFinished = $false

        #<Oisin Grehan>
        function Step {
                          
            #<Kent Yeabower>
            Write-Verbose "New-Column.New-Module.Step Just entered Step method"
            ##############################################################
            #   Leading Cell (White Cell) and Second Cell (Green Cell)   #
            ##############################################################                
            #Has to be script scope, can't be global
            $script:HeadCellFinished = $false
                
            #<Oisin Grehan>
            # reached the bottom yet?
            if ($head -le $ylimit) {                    
                Write-Verbose "New-Column.New-Module.Step Head value $head is less than ylimit value $ylimit"                                        
                #<Kent Yeabower>
                #######################################################################
                #   If Column is one of our message columns AND the Timer is expired  #
                #######################################################################
                $LeadingCharacterToAnimate = ""
                If ($MatrixMessageCoordinatesStaticNewColumnModule[$xpos] -and !($TimerMatrix.enabled)) {

                    write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. Column is one of our Message columns. Timer state is $($TimerMatrix.enabled). head $head fade $fade. Entry in Hash table is $($MatrixMessageCoordinatesStaticNewColumnModule[$xpos])"

                    #################################################
                    #   If the Leading Cell is on the Message Row   #
                    #################################################                                
                    #If the leading cell is on the Message row, then we need to animate it with the proper character
                    If ($MatrixMessageCoordinatesStaticNewColumnModule[$xpos] -eq $head) {
                        write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. Leading cell is on the Message Row (position $head). Timer state is $($TimerMatrix.enabled). Setting character to $MatrixMessageStringArrayHTNewColumnModule[$xpos]"
                        $LeadingCharacterToAnimate = $MatrixMessageStringArrayHTNewColumnModule[$xpos]
                    }#End of if the Leading Cell was on the Message Row
                }#End of if the current column is one of our message columns and the Timer was expired

                #<Kent Yeabower>
                ##########################################################################################################################################################
                #   If we aren't in a Message column with the timer expired, if the Message row character is not set for our Message, or if the Timer is still running   #
                ##########################################################################################################################################################
                #If we didn't match the above criteria to animate 
                If (!$LeadingCharacterToAnimate) {                                      
                    write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. Leading cell is on row $head, which is not equal to middle row. Timer state is $($TimerMatrix.enabled). Message row character is set to be $($MatrixMessageStringArrayHTNewColumnModule[$xpos]), which getting that current buffer cell ($xpos,$head), the current character at that position is a $($MessageRowBufferCell.foregroundcolor) $($MessageRowBufferCell.character)"                                    

                    #get the buffer cell of the message row for this column
                    $MessageRowBufferCell = $ScreenBufferCellsNewColumnModule[$($MatrixMessageCoordinatesStaticNewColumnModule[$xpos]), $xpos]
                                    
                    write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. Current character in the screen buffer variable on the message row of this column is a $($MessageRowBufferCell.foregroundcolor) $($MessageRowBufferCell.character). Checking to see if we need to animate a character in the screen buffer variable"
                    #If the Timer is expired, and the Message Row cell doesn't already contain the correct buffer cell for the Message, OR if the Timer is still enabled, then we know we can proceed on animating normally
                    If ((($MessageRowBufferCell.character -ne $MatrixMessageStringArrayHTNewColumnModule[$xpos]) -or ($MessageRowBufferCell.foregroundcolor -ne "White") -and !$TimerMatrix.enabled) -or $TimerMatrix.enabled) {                                        
                        $LeadingCharacterToAnimate = [char](get-random -min 65 -max 122)
                    }#End of if the Message Row cell doesn't contain the correct buffer cell for the message
                }#End of if the Leading Cell was NOT on the Message Row                                    

                ############################################################
                #   Do we need to animate the Leading and Trailing Cell?   #
                ############################################################
                If ($LeadingCharacterToAnimate) {                            
                    write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. ForegroundColor of ($xpos,$head) in ScreenBufferCellsNewColumnModule before updating variable is $($ScreenBufferCellsNewColumnModule[$head,$xpos].foregroundcolor)"
                            
                    #Using Oisin's New-BufferCell function to create a new cell to add to our screen buffer variable
                    #Note that writing to the [,] buffer cell array you put the y coordinate first, then the x coordinate                            
                    $ScreenBufferCellsNewColumnModule[$head, $xpos] = New-BufferCell -Character ($LeadingCharacterToAnimate) -Fore white
                    write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. ForegroundColor of ($xpos,$head) in ScreenBufferCellsNewColumnModule after updating variable is $($ScreenBufferCellsNewColumnModule[$head,$xpos].foregroundcolor)"

                    #Using Oisin's New-BufferCell function to create a new cell to add to our screen buffer variable
                    $ScreenBufferCellsNewColumnModule[$($head - 1), $xpos] = New-BufferCell -Character ([char](get-random -min 65 -max 122)) -Fore green                      
                }#End of if we needed to animate the Leading cell                                                              
            }#end of if the leading cell is not at the bottom of the screen yet                
            Else {
                write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. Head cell position is $head, which is past y limit $ylimit, and HeadCellFinished value is $script:HeadCellFinished"
                #We only want to update this variable once, so if it's just past the y limit, then set it to true
                If ($head -eq $ylimit + 1) {
                    write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. Head cell position is $head, which is equal to the ylimit ($ylimit) + 1. Setting HeadCellFinished to true since head cell is done animating"
                    #We want to update the variable value outside of this function
                    $script:HeadCellFinished = $true
                }
                If ($head -eq $ylimit + 2) {
                    write-verbose "New-Column.New-Module.Step.LeadingCell Column $xpos. Head cell position is $head, which is equal to the ylimit ($ylimit) + 2. Setting HeadCellFinished back to false to avoid unecessary decrements of variable columnsHeadCellActive"
                    #We want to update the variable value outside of this function
                    $script:HeadCellFinished = $false
                }
            }
            #<Oisin Grehan>
            $script:head++


            #<Kent Yeabower>
            ##############################
            #   Fade Cell (Dark Green)   #
            ##############################
                
            #<Oisin Grehan> - <Kent Yeabower> - I added in the ($fade -le $ylimit) piece so adding to the $ScreenBufferCellsNewColumnModule array below would be within the buffer cell range
            # time to start rendering the darker green "tail?"
            if (($head -gt $fadelen) -and ($fade -le $ylimit)) {                    
                    
                #<Kent Yeabower>
                #########################################################################################################################################################
                #   If (Column is one of our message columns AND Timer is expired AND the fade cell hasn't reached the Message Row), OR if the Timer is still running   #
                #########################################################################################################################################################             

                If ((($MatrixMessageCoordinatesStaticNewColumnModule[$xpos]) -and !($TimerMatrix.enabled) -and ($fade -lt $MatrixMessageCoordinatesStaticNewColumnModule[$xpos])) -or $TimerMatrix.enabled) {
                    ###############################
                    #   If the Timer is expired   #
                    ###############################
                    #We put this check inside the $head -gt $fadelen check above, so we're basically saying that
                    #if you were already writing the darker green characters, then also check this

                    write-verbose "New-Column.New-Module.Step.FadeCell Column $xpos. Timer state is $($TimerMatrix.enabled). head $head fade $fade fadelen $fadelen. Entry in Hash table is $($MatrixMessageCoordinatesStaticNewColumnModule[$xpos]). Calling Set-BufferCell for position ($xpos,$fade)."
                                    
                    #Using Oisin's New-BufferCell function to create a new cell to add to our screen buffer variable
                    $ScreenBufferCellsNewColumnModule[$fade, $xpos] = New-BufferCell -Character ([char](get-random -min 65 -max 122)) -Fore darkgreen
                                                                                                               
                }#End of if (Column is one of our message columns AND Timer is expired AND the fade cell hasn't reached the Message Row), OR if the Timer is still running
                #If the timer was expired, we don't want to animate the dark green past the Message Row.
                $script:fade++                          
            }#End of if the leading cell is far enough down to start writing dark green cells at the top

            #<Kent Yeabower>
            ##################
            #   BLANK Cell   #
            ##################
                
            #Here, I have added functionality to blank the cells out (after the faded dark green tail has reached
            #a certain length). This will help the falling code look a bit more like the movie.

            #Do we need to blank the previous cell yet?
            write-verbose "   New-Column.New-Module.Step.BlankCell Timer status is $($TimerMatrix.enabled). Checking on blanking Column $xpos cell $blank. head $head, fade $fade fadelen $fadelen fadelentotal $fadelentotal! hash table entry is $($MatrixMessageCoordinatesStaticNewColumnModule[$xpos])"
            If (($fade -gt $fadelenTOTAL) -and ($blank -le $ylimit)) {

                ####################################################################################################################
                #   If Column is one of our message columns AND the Timer is expired AND the blank cell is not on the Message Row  #
                ####################################################################################################################
                $BlankCellToAnimate = ""
                If ($MatrixMessageCoordinatesStaticNewColumnModule[$xpos] -and !$TimerMatrix.enabled -and ($MatrixMessageCoordinatesStaticNewColumnModule[$xpos] -ne $blank)) {
                    write-verbose "   New-Column.New-Module.Step.BlankCell Timer Expired. Literally blanking Column $xpos cell $blank. head $head, fade $fade fadelen $fadelen fadelentotal $fadelentotal! hash table entry is $($MatrixMessageCoordinatesStaticNewColumnModule[$xpos])"
                    $BlankCellToAnimate = [char]32                            
                }#End of if Column is one of our message columns AND the Timer is expired

                ##########################################################################################################################################################
                #   If we aren't in a Message column with the timer expired, if the Message row character is not set for our Message, or if the Timer is still running   #
                ##########################################################################################################################################################
                                
                #If we didn't match the above criteria to animate 
                If (!$BlankCellToAnimate) {
                    #get the current buffer cell
                    $MessageRowBufferCell = $ScreenBufferCellsNewColumnModule[$blank, $xpos]
                    write-verbose "   New-Column.New-Module.Step.BlankCell. Timer is expired and we're on the Message Row. The current BufferCell on the message row at position ($xpos,$blank) is a $($MessageRowBufferCell.foregroundcolor) $($MessageRowBufferCell.character)"
                            
                    #If the cell doesn't contain part of our message, then blank it anyway
                    If ((($MessageRowBufferCell.character -ne $MatrixMessageStringArrayHTNewColumnModule[$xpos]) -or ($MessageRowBufferCell.foregroundcolor -ne "White") -and !$TimerMatrix.enabled) -or $TimerMatrix.enabled) {
                        write-verbose "   New-Column.New-Module.Step.BlankCell Timer expired. Literally blanking Column $xpos SPECIAL cell $blank Char $($MessageRowBufferCell.character) Fore $($MessageRowBufferCell.foregroundcolor). head $head, fade $fade fadelen $fadelen fadelentotal $fadelentotal! hash table entry is $($MatrixMessageCoordinatesStaticNewColumnModule[$xpos])"
                        $BlankCellToAnimate = [char]32
                    }
                }#End of if we aren't in a Message column with the timer expired, if the Message row character is not set for our Message, or if the Timer is still running

                #############################################
                #   Do we need to animate the Blank Cell?   #
                #############################################
                If ($BlankCellToAnimate) {                       
                    write-verbose "   New-Column.New-Module.Step.BlankCell. Timer status is $($Timer.enabled). Literally blanking Column $xpos cell $blank. head $head, fade $fade fadelen $fadelen fadelentotal $fadelentotal! hash table entry is $($MatrixMessageCoordinatesStaticNewColumnModule[$xpos])"

                    #Using Oisin's New-BufferCell function to create a new cell to add to our screen buffer variable
                    $ScreenBufferCellsNewColumnModule[$blank, $xpos] = New-BufferCell -Character ($BlankCellToAnimate) -Fore black
                                                                                                             
                }#End of if we need to animate the blank cell
                $script:blank++
            }#End of if the leading cell is far enough down to start writing BLANK cells at the top
                
            $script:ScreenBufferCells = $ScreenBufferCellsNewColumnModule       

            ##########################################
            #   Are we done animating this column?   #
            ##########################################
            #<Oisin Grehan>
            # are we done animating?
            #If the blanked out cells have not reached the bottom, then keep animating

            #<Oisin Grehan> - #<Kent Yeabower> has edited this piece, replacing Oisin's $fade with $blank
            if ($blank -lt $ylimit) {
                return $true
            }#End of if the blank cells have reached the bottom of the screen
                 
            #<Oisin Grehan>       
            $false            
        }#End of Step function        

        #<Oisin Grehan>
        Export-ModuleMember -function Step -Variable HeadCellFinished
                
        #<Kent Yeabower> - added all arguments below for this module besides $x. which was original to the module from Oisin Grehan
    } -args $x, $MatrixMessageCoordinatesStatic, $MatrixMessageStringArrayHT, $VerbosePreference, $ScreenBufferCells, $NewRectangle, $NewCoordinate, $GetBufferCell, $NewBufferCell, $SetBufferCell
}

#<Oisin Grehan>
# TODO: actually write into buffercell[,] framebuffer
function Write-FrameBuffer {
    param($maxColumns)
    #-#write-host "Inside Write-FrameBuffer function" 
    # do we need a new column?
    
    #<Kent Yeabower>
    Write-Verbose "Write-FrameBuffer. Max Columns is $maxColumns, and columnsHeadCellActive is $columnsHeadCellActive"
    
    #<Oisin Grehan>
    if ($columnsHeadCellActive -lt $maxcolumns) {               
        
        #<Kent Yeabower>
        Write-Verbose "Write-FrameBuffer. ColumnsHeadCellActive less than Max Columns."        
        
        #########################
        #   Timer Still Going   #
        #########################

        #If the timer is still going, behave like normal
        If ($TimerMatrix.enabled) {
            
            #<Oisin Grehan>          
            # incur staggering of columns with get-random
            # by only adding a new one 50% of the time
            if ((get-random -min 0 -max 10) -lt 5) {
                    
                #<Kent Yeabower>
                #Making use of Oisin's get-random idea above. Here, some of the time, 
                #let's get a column in our Message X (column) positions (if we have a message)
                #i.e. let's animate a Message column some of the time.
                If ($MatrixMessage) {
                    If ((Get-Random -min 0 -max 30) -eq 1) {
                        $Min = $MatrixMessageXPositions[0]
                        $Max = $MatrixMessageXPositions[-1]
                    }
                }
                #If we didn't get a value from above, populate them with default values
                If (!$Min) {
                    $Min = 0
                    $Max = ($winsize.width - 1)
                }
                $MaxTries = $Max - $Min
                    
                Write-Verbose "Write-FrameBuffer. Min is $min, Max is $max"

                #<Oisin Grehan>
                # search for a column not current animating
                #we're searching in the range we defined above
                #Putting a try in here to avoid infinite loop
                    
                $Tries = 1
                #<Oisin Grehan> original Do/While loop - #<Kent Yeabower> added the $Tries counter to avoid an infinite loop with the above Message column possibility
                #<Kent Yeabower> also added the $Min and $Max variables in place of numbers
                do { 
                    $x = get-random -min $Min -max $Max
                    $Tries++
                } while ($columns.containskey($x) -and ($Tries -le $MaxTries))
                    
                #<Kent Yeabower>
                #If we weren't able to find a column that wasn't animating above, it is possible that we were
                #looking in the Message Column range, and that all the MEssage columns are already animating. Thus,
                #the $Tries variable saved us from an infinite loop, and we need to try again with a larger column range.
                If ($columns.containskey($x)) {
                    $Min = 0
                    $Max = ($winsize.width - 1)
                    #<Oisin Grehan> original Do/While loop - #<Kent Yeabower> added the $Min and $Max variables above in place of numbers
                    do {
                        $x = get-random -min $Min -max $Max
                    } while ($columns.containskey($x))
                }
                    
                #<Kent Yeabower>
                write-verbose "+++Write-FrameBuffer. Timer is $($TimerMatrix.enabled). Adding column $x. Increasing columnsHeadCellActive to $($columnsHeadCellActive+1)"
                #<Oisin Grehan> - #<Kent Yeabower> added the 2 parameters to the function new-column besides $x, which
                #was original to Oisin's module
                $columns.add($x, (new-column $x $MatrixMessageCoordinatesStatic $MatrixMessageStringArrayHT))
                #<Kent Yeabower>
                $columnsHeadCellActive++                                
            }#End of staggering column animation using  if ((get-random -min 0 -max 10) -lt 5)
        }#End of if the Timer was still going

        #<Kent Yeabower>
        ###################
        #   Timer Ended   #
        ###################

        #If the timer was not going, then we are ready to spell our message
        #So, we only want to add columns that correspond to the message column coordinates
        Else {                        
            If ($MatrixMessage) {                   
                $MatrixMessageColumnAdded = ""

                $MatrixMessageCoordinates.keys | get-random | ForEach-Object {                        

                    If (!$columns.containskey($_)) {
                        write-verbose "+++Write-FrameBuffer. Timer is $($TimerMatrix.Enabled). Message specified. No Column currently in Message column $_. Adding column. Increasing columnsHeadCellActive to $($columnsHeadCellActive+1)"
                        #<Oisin Grehan> - #<Kent Yeabower> added the 2 parameters to the function new-column besides $x, which
                        #was original to Oisin's module
                        $columns.add($_, (new-column $_ $MatrixMessageCoordinatesStatic $MatrixMessageStringArrayHT))
                            
                        #<Kent Yeabower>
                        $columnsHeadCellActive++
                        [int]$MatrixMessageColumnAdded = $_
                    }#End of if the chosen Message column is not currently animating                        
                }#End of looping through the Matrix Message Coordinates Hash Table keys

                #If we added a Message column to start animating, then remove it from the Coordinates Hash table so we won't animate it again
                If ($MatrixMessageColumnAdded) {
                    $MatrixMessageCoordinates.remove($MatrixMessageColumnAdded)
                }#End of if we added a Message column to start animating
            }#End of if a Message was specified to be written            
        }#End of if the Timer has ended
    }#End of if the number of animating columns is less than the maxcolumns parameter

    #<Oisin Grehan>
    $script:framenum++
}#End of Write-FrameBuffer function

#<Oisin Grehan>
# TODO: setbuffercontent with buffercell[,] framebuffer
function Show-FrameBuffer {
    param($frame)
    
    $completed = @()        

    # loop through each active column and animate a single step/frame
    foreach ($entry in $columns.getenumerator()) {
        
        #<Kent Yeabower>
        write-verbose "Show-FrameBuffer. Entry key (column number) is $($entry.key)."
        
        #<Oisin Grehan>
        $column = $entry.value
        
        #<Kent Yeabower>
        write-verbose "Show-FrameBuffer. Column $($entry.key). Value of HeadCellFinished for this column is $($column.HeadCellFinished) and columnsHeadCellActive value is $columnsHeadCellActive"
        #If the head cell of the column has reached the bottom of the screen, then decrement our active column counter
        If ($column.HeadCellFinished) {
            write-verbose "Show-FrameBuffer. Column $($entry.key). Reducing columnsHeadCellActive from current value $columnsHeadCellActive to $($columnsHeadCellActive-1)"
            $columnsHeadCellActive--
            write-verbose "Show-FrameBuffer. Column $($entry.key). New reduced value of columnsHeadCellActive is $columnsHeadCellActive"            
        }

        #<Oisin Grehan>
        # if column has finished animating, add to the "remove" pile
        if (-not $column.step()) {            
            
            #<Kent Yeabower>
            write-verbose "Show-FrameBuffer. Column $($entry.key) is done animating. Adding to array to remove."
            
            #<Oisin Grehan>
            $completed += $entry.key            

            #<Kent Yeabower>
            #If the Timer had expired, then also remove this column from the Coordinates Hash Table
            #This is so it won't drop another column on top of this one that would have already been
            #set correctly by the new-column function if the timer expired.
            If (!$TimerMatrix.enabled) {
                #So if we're dealing with a column that's part of our message
                If ($MatrixMessageCoordinatesStatic[$entry.key]) {
                    #get the current buffer cell
                    $MessageRowBufferCell = $ScreenBufferCells[$($MatrixMessageCoordinatesStatic[$entry.key]), $entry.key]
                    
                    write-verbose "Show-FrameBuffer. Column $($entry.key). Timer status is $($TimerMatrix.enabled). Current entry is a Message column. Got Message ROW buffer cell at position ($($entry.key), $($MatrixMessageCoordinatesStatic[$entry.key])), which is a $($MessageRowBufferCell.foregroundcolor) $($MessageRowBufferCell.character)"
                    #If the cell contains the correct character and color of our message, then we can get rid of the column in our Hash table
                    #of message coordinates
                    If (($MessageRowBufferCell.character -eq $MatrixMessageStringArrayHT[$entry.key]) -and ($MessageRowBufferCell.foregroundcolor -eq "White")) {
                        write-verbose "Show-FrameBuffer. Column $($entry.key). Message row buffer cell is correct. removing Column $($entry.key) from Column hash table."
                        $MatrixMessageCoordinates.remove($entry.key)
                    }
                    Else {
                        write-verbose "Show-FrameBuffer. Column $($entry.key). Message row buffer cell is not correct. Will not remove column $($entry.key) from Column hash table. Will continue to animate column $($entry.key)."
                    }
                }#End of if we're dealing with a column that's part of our message
            }#End of if the Timer was expired
        }#End of if the column has finished animating
    }#End of looking at the current column object in the $columns hash table

    #Updating the console buffer with the new buffer cells, i.e. actually animating the console one "frame"
    #This way, we could have all the columns updated and just write to the entire console buffer once per "frame", instead of writing each individual column once per frame.
    $host.ui.rawui.SetBufferContents($OriginCoordinate, $ScreenBufferCells)

    #<Oisin Grehan>
    # cannot remove from collection while enumerating, so do it here
    foreach ($key in $completed) {
        
        #<Kent Yeabower>
        write-verbose "---Show-FrameBuffer. Removing column $key (Timer is $($TimerMatrix.Enabled))."        

        #<Oisin Grehan>
        $columns.remove($key)
    }#End of removing the current completed column. Onto the next completed column until they're all removed.
}#End of Show-FrameBuffer function


#<Kent Yeabower>
#This is the main function in this script
function Write-MatrixMessage {
    <#

        .SYNOPSIS

        This script takes Oisin Grehan's Matrix.psm1 module and adds functionality that allows a user to write a Message
        on the PowerShell Console screen using falling Matrix code, much like the intro of the first Matrix movie where 
        the code falls into place and spells the phrase "The Matrix," then is erased.

        .DESCRIPTION

        The function uses a timer to determine how long to let the Matrix code fall normally before starting to fall letters into place to spell the desired Message.
        
        Note that you do not have to specify a message to be spelled, but can use the function to just let the Matrix code fall normally as long as you specify.

        .PARAMETER Message

        The Message you would like to write on the screen. The Message will need to fit within the console window specified. Wrapping text or multi-line messages are not supported.

        .PARAMETER MessageTimeOnScreen

        The number of milliseconds the Message will remain on the screen after being spelled out, before it is erased. Default value is 2000 milliseconds (2 seconds).

        .PARAMETER MaxColumns

        The maximum number of Matrix code columns to be animated on the screen at any given time. Note that a high number of columns will result in slower animation.
        
        Default Value is the Message length + 15, or if no Message is specified, a third of the console screen.

        .PARAMETER FrameWait

        The time in milliseconds to wait between animating each character in each column. Default value is 0 (i.e. no wait between animating characters).

        .PARAMETER TimerLength

        The time in milliseconds that the Matrix code will fall normally before spelling the desired Message. If no Message parameter is specified,
        this defines how long the Matrix code will fall normally before exiting the script. Default value is 2000 milliseconds (2 seconds).

        .PARAMETER ConsoleWidth

        This defines the width of the console window. Default value is 80.

        .PARAMETER ConsoleHeight

        This defines the height of the console window. Default value is 17.

        .PARAMETER MessageEraseColor

        This determines what color (White, Black) is used to erase each character of the Message after being spelled on the screen. Default color is White.

        .PARAMETER MessageCharacterEraseTime

        This determines how many milliseconds to wait between erasing each character of the message, with a randomizer of +/- 20ms. The default value is 100 (milliseconds).

        .PARAMETER ReturnConsoleToPreviousSize

        This specifies whether you would like to return the console to its previous size before the Write-MatrixMessage function was called.

        .EXAMPLE

        Spell the message "Wake Up Neo..." on the screen after 5 seconds of normal Matrix animation.

        Write-MatrixMessage -Message "Wake Up Neo..." -TimerLength 5000 -ReturnConsoleToPreviousSize

        .EXAMPLE

        Spell the message "The Matrix" on the screen after 3 seconds of normal Matrix animation, keep the message on the screen for 1.5 seconds, then erase the message with White.

        Write-MatrixMessage -Message "The Matrix" -TimerLength 3000 -MessageTimeOnScreen 1500 -MessageEraseColor White

        .EXAMPLE

        Display falling Matrix code for 10 seconds without writing a message, then quit.

        Write-MatrixMessage -TimerLength 10000

        .NOTES

        Becasue this script uses Buffer Cells, you will need to run this function in the PowerShell Console. It will not work in PowerShell ISE.

    #>

    [CmdletBinding(DefaultParameterSetName = "Matrix")]
    param(        
        [Parameter(ParameterSetName = 'MatrixMessage', Position = 0, Mandatory = $true)][string]$Message,        
        [Parameter(ParameterSetName = 'MatrixMessage')][int]$MessageTimeOnScreen = 2000,
        [Parameter(ParameterSetName = 'MatrixMessage')][ValidateSet('Black', 'White')][String[]]$MessageEraseColor = "White",
        [Parameter(ParameterSetName = 'MatrixMessage')][int]$MessageCharacterEraseTime = 100,               
        [int]$maxcolumns,
        [int]$FrameWait = 0,
        [int]$TimerLength = 2000,
        [int]$ConsoleWidth = 80,
        [int]$ConsoleHeight = 17,        
        [switch]$ReturnConsoleToPreviousSize
        
    )    

    $ErrorActionPreference = "stop"

    ##########################################################
    #   Define Functions as Parameters For New-Module above  #
    ##########################################################

    #This is so the New-Module above can "see" the functions:

    #New-Rectangle
    #Get-BufferCell
    #New-BufferCell
    #Set-BufferCell
    #New-Column
    #New-Module in the New-Column function
    #Step function in the New-Column function
    #Write-FrameBuffer
    #Show-FrameBuffer

    #Using Here Strings to capture the actual Function code text in variables per https://social.technet.microsoft.com/Forums/ie/en-US/485df2df-1577-4770-9db9-a9c5627dd04a/how-to-pass-a-function-to-a-scriptblock?forum=winserverpowershell
    #For more on Here Strings, see https://technet.microsoft.com/en-us/library/ee692792.aspx
    $NewRectangle = @"
Function New-Rectangle
{
    $(Get-Command New-Rectangle | Select-Object -ExpandProperty Definition)
}
"@

    $NewCoordinate = @"
Function New-Coordinate
{        
    $(Get-Command New-Coordinate | Select-Object -ExpandProperty Definition)
}
"@

    $GetBufferCell = @"
Function Get-BufferCell
{
    $(Get-Command Get-BufferCell | Select-Object -ExpandProperty Definition)
}
"@

    $NewBufferCell = @"
Function New-BufferCell
{
    $(Get-Command New-BufferCell | Select-Object -ExpandProperty Definition)
}
"@

    $SetBufferCell = @"
Function Set-BufferCell
{
    $(Get-Command Set-BufferCell | Select-Object -ExpandProperty Definition)
}
"@


    ####################################
    #   Resize-ConsolWindow Function   #
    ####################################

    function Resize-ConsoleWindow {
        [CmdletBinding()]
        Param(
            [Parameter(Position = 0)]$NewWidth,
            [Parameter(Position = 1)]$NewHeight
        )        

        ### Screen Width ###
        If ($NewWidth) {                
            #So if the screen width is going to be getting smaller
            If ($host.ui.RawUI.WindowSize.width -gt $NewWidth) {
                Write-Verbose "Write-MatrixMessage. Screen width decreasing. Setting WindowSize width first."
                #Then shrink the windowsize first, then shrink the buffersize
                $host.ui.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size ($NewWidth, $host.ui.RawUI.WindowSize.height)
                $host.ui.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size ($NewWidth, $host.ui.RawUI.WindowSize.height)
            }#End of if the screen width is going to be getting smaller
            #Else if the screen width is going to be getting larger
            ElseIf ($host.ui.RawUI.WindowSize.width -lt $NewWidth) {
                Write-Verbose "Write-MatrixMessage. Screen width increasing. Setting BufferSize width first."
                #Then expand the buffersize first, then the windowsize
                $host.ui.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size ($NewWidth, $host.ui.RawUI.WindowSize.height)                    
                $host.ui.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size ($NewWidth, $host.ui.RawUI.WindowSize.height)                    
            }#End of if the screen width is going to be getting larger            
        }#End of if a new console width was specified
    
        ### Screen Height ###
        If ($NewHeight) {                
            #So if the screen height is going to be getting smaller
            If ($host.ui.RawUI.WindowSize.height -gt $NewHeight) {
                Write-Verbose "Write-MatrixMessage. Screen height decreasing. Setting WindowSize width first."
                #Then shrink the windowsize first, then shrink the buffersize
                $host.ui.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size ($host.ui.RawUI.WindowSize.width, $NewHeight)
                $host.ui.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size ($host.ui.RawUI.WindowSize.width, $NewHeight)
            }#End of if the screen height is going to be getting smaller
            #Else if the screen height is going to be getting larger
            ElseIf ($host.ui.RawUI.WindowSize.height -lt $NewHeight) {
                Write-Verbose "Write-MatrixMessage. Screen size increasing. Setting BufferSize width first."
                #Then expand the buffersize first, then the windowsize
                $host.ui.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size ($host.ui.RawUI.WindowSize.width, $NewHeight)
                $host.ui.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size ($host.ui.RawUI.WindowSize.width, $NewHeight)
            }#End of if the screen height is going to be getting larger               
        }#End of if a new console height was specified         
    }#End of creating Resize-ConsoleWindow function


    #######################################
    #   Resize Console Before Animating   #
    #######################################        

    $script:PreviousWindowSize = $host.ui.rawui.WindowSize
    
    #Set the console size to what we want
    #We want it to be smaller in height so the Matrix code keeps scrolling faster, like in the movie intro.

    Write-Verbose "Write-MatrixMessage. Setting screen to size ($ConsoleWidth,$ConsoleHeight). Previous size was ($($PreviousWindowSize.width),$($PreviousWindowSize.height))."

    #Default values are Width of 80 and Height of 17
    Resize-ConsoleWindow $ConsoleWidth $ConsoleHeight

    ########################
    #   Script Variables   #
    ########################                        
        
    Write-Verbose "Write-MatrixMessage. Setting variables."

    #Setup the screen buffer variables
    $script:OriginCoordinate = New-Coordinate 0 0
    $script:ScreenBufferRectangle = New-Rectangle 0 0 $ConsoleWidth $ConsoleHeight
    #Blank out the screen before we load the buffer cells into an array
    $script:BlankCell = New-BufferCell -Character $([char]32) -ForeGroundColor Black -BackGroundColor Black
    $host.ui.RawUI.SetBufferContents($ScreenBufferRectangle, $BlankCell)

    #Now, load the blanked screen into a buffer cell array
    #We're creating a multi-dimensional array, in this case a 2-dimensional array (think of it like X and Y coordinates. A 3-dimensional array
    #would be like X, Y, and Z coordinates).
    [System.Management.Automation.Host.buffercell[, ]]$script:ScreenBufferCells = $host.ui.RawUI.GetBufferContents($ScreenBufferRectangle)

    $script:columnsHeadCellActive = 0
    #<Oisin Grehan>
    $script:winsize = $host.ui.rawui.WindowSize        
    $script:columns = @{} # key: xpos; value; column
    $script:framenum = 0        
    $prevbg = $host.ui.rawui.BackgroundColor
    $host.ui.rawui.BackgroundColor = "black"

    #<Kent Yeabower>
    #Message variables
    $global:MatrixMessage = $Message
        
    #Define the maxcolumns parameter if it wasn't specified in the Write-MatrixMessage function call
    If (!$PSBoundParameters.ContainsKey("maxcolumns")) {
        #If there was a message specified, then define max columns as message length plus a bit more
        If ($MatrixMessage) {
            $maxcolumns = $MatrixMessage.length + 15
        }
        #If there was no message specified, define max columns as a third of the screen
        Else {
            $maxcolumns = [math]::Round($ConsoleWidth / 3)
        }
    }
    Write-Verbose "Write-MatrixMessage. Max Columns value is $maxcolumns"

    ################################
    #   Matrix Message Variables   #
    ################################

    $global:MatrixMessageStringArray = $MatrixMessage.ToCharArray()

    $global:ScreenHeightMiddle = [math]::Round($ConsoleHeight / 2)

    $global:MatrixMessageXStart = [math]::Round(($ConsoleWidth - $MatrixMessage.length) / 2)

    $global:MatrixMessageXEnd = $MatrixMessageXStart + $MatrixMessage.Length - 1
        
    $global:MatrixMessageXPositions = @($MatrixMessageXStart..$MatrixMessageXEnd)
    #Creating this duplicate array as a generic list so we can remove spaces from it below if needed
    [System.Collections.Generic.List[System.Object]]$global:MatrixMessageXPositionsGenericList = @($MatrixMessageXStart..$MatrixMessageXEnd)


    ### Build Hash Tables ###

    #Create a Hash Table of the X,Y coordinate pairs
    $global:MatrixMessageCoordinates = @{}
        
    #Create a Hash Table of the X columns matched with the Message letter for that column
    #This is so we know what "column" to put each letter in the message
    $global:MatrixMessageStringArrayHT = @{}

    $CharNum = 0
    #Add the x positions to the array, and make the value of the hash table entry the Y value of the middle of the screen
    Foreach ($MatrixMessageXPosition in $MatrixMessageXPositions) {            

        #Is the character is not a space, then add entries to our hash tables for coordinates and string position
        If (!($MatrixMessageStringArray[$CharNum] -eq " ")) {
            $MatrixMessageCoordinates[$MatrixMessageXPosition] = $ScreenHeightMiddle
            $MatrixMessageStringArrayHT[$MatrixMessageXPosition] = $MatrixMessageStringArray[$CharNum]                
        }#End of if the current Message character is NOT a space
        Else {
            #If the X position contained a space, then remove it from our X Positions array above
            #We will use this array below to erase the message after it appears, so we don't want
            #the array to contain any space characters as we don't care about those
            #Note that we can remove elements from it since we defined it as a generic list above
            $MatrixMessageXPositionsGenericList.remove($MatrixMessageXPositions[$CharNum]) > $null                    
        }#End of if the current Message character is a space
        $charNum++                      
    }#End of looking at each X (column) position of our Message

    ### Clone Hash Table to create a static copy ###

    #We need to create a copy of the Coordinates hash table to use in the new-module above,
    #because in Write-FrameBuffer when we add the message columns after the Timer has expired,
    #we remove these columns from the $MatrixMessageCoordinates hash table so we can know which
    #columns we still need to add for the message
        
    #We will need to "deep" clone a hash table, and from my testing using the .Clone() method
    #does NOT work. I posted on Technet, and a user pointed me to this URL which gives
    #code for serializing and deserializing the hash table data, which actually creates
    #a "deep" clone:
    #http://stackoverflow.com/questions/7468707/deep-copy-a-dictionary-hashtable-in-powershell
    function Clone-Object {
        param($DeepCopyObject)
        $memStream = New-Object IO.MemoryStream
        $formatter = New-Object Runtime.Serialization.Formatters.Binary.BinaryFormatter
        $formatter.Serialize($memStream, $DeepCopyObject)
        $memStream.Position = 0
        $formatter.Deserialize($memStream)
    }

    $global:MatrixMessageCoordinatesStatic = Clone-Object $MatrixMessageCoordinates
                    
    
    #################################
    #   End of Defining Variables   #
    #################################    

    
    ##############################
    #   Create and Start Timer   #
    ##############################
        
    Clear-Host
    
    $done = $false        
    
    Write-Verbose "Write-MatrixMessage. Creating Timer."

    #Create our timer object
    $global:TimerMatrix = New-Object system.timers.timer

    #Set the timer to 5 seconds (in milliseconds)
    $TimerMatrix.Interval = $TimerLength

    #We don't want the timer to autoreset (i.e. we want the timer to quit when it reaches the interval mark)
    $TimerMatrix.AutoReset = $false

    #Now, enable the timer
    $TimerMatrix.Enabled = $true

    Write-Verbose "Write-MatrixMessage. Timer created and running. Ready to start animating!"

    
    ##############################
    #   While Timer is running   #
    ##############################

    #so, while the timer is going, animate the matrix code normally
    while ($TimerMatrix.Enabled) {
            
        #Here, keeping Oisin's original calls to Write-FrameBuffer and Show-FrameBuffer to
        #animate the matrix code normally while the timer is running.

        #<Oisin Grehan> - #<Kent Yeabower> - I use dotsourcing to execute the functions in the current scope, so they can
        #properly modify some script-scope variables.
        #https://social.technet.microsoft.com/Forums/scriptcenter/en-US/c5642062-4097-460f-8840-3471ee31a32a/powershell-incrementing-counter?forum=ITCG
        . Write-FrameBuffer -maxcolumns $maxcolumns
            
        . Show-FrameBuffer
        
        #<Kent Yeabower>
        If ($FrameWait -ne 0) {
            #<Oisin Grehan>
            Start-Sleep -Milliseconds $frameWait
        }               
    }#End of while the Timer is running

    #<Kent Yeabower>
    ########################################################################
    #   Timer Is Done. Drop Message into place and display for set time.   #
    ########################################################################

    #Now, once the timer is finished, we need to finish animating the columns on the screen and also write our message if there was one
    If ($MatrixMessage) {
        #If the user specified more than 1 color, just pick the first one.
        If ($MessageEraseColor.count -gt 1) {
            $MessageEraseColor = $MessageEraseColor[0]
        }
        #So, while we still have columns animating, let's finish them up
        While ($null -ne $columns.getenumerator()) {                                
                
            #Using Oisin's functions again to finish animating the columns when the Timer is done.
            #I have put code in the functions that will process the Matrix code differently
            #once the Timer is done (i.e. the functions will start working to spell the Message,
            #if there was one).

            #Also, as before I use dotsourcing to execute the functions in the current scope, so 
            #they can properly modify some script-scope variables.
            #https://social.technet.microsoft.com/Forums/scriptcenter/en-US/c5642062-4097-460f-8840-3471ee31a32a/powershell-incrementing-counter?forum=ITCG
            . Show-FrameBuffer

            . Write-FrameBuffer -maxcolumns $maxcolumns
        }
        Start-Sleep -Milliseconds $MessageTimeOnScreen       

        #####################
        #   Erase Message   #
        #####################

        #While there are Message characters to erase
        While ($MatrixMessageXPositionsGenericList) {
            $XPositionToRemove = ($MatrixMessageXPositionsGenericList | get-random)
            
            #Need to set the coordinate of the character to remove with a white backgroundcolor and space character, then black it out
            #Using Oisin's Set-BufferCell function
            Set-BufferCell $XPositionToRemove $MatrixMessageCoordinatesStatic[$XPositionToRemove] (
                New-BufferCell -Character ([char]32) -BackGroundColor $MessageEraseColor) > $null
                
            $TimeToWaitMS = $MessageCharacterEraseTime
            $TimeToWaitMS = Get-Random -Minimum 20 -Maximum ($TimeToWaitMS + 20)
            Start-Sleep -Milliseconds $TimeToWaitMS

            #If White was chosen as the Message erase color, we need to Black it out after we set it to white
            If ($MessageEraseColor -eq "White") {
                #If the user chose to erase the message with white blocks, then we need to black them out
                Set-BufferCell $XPositionToRemove $MatrixMessageCoordinatesStatic[$XPositionToRemove] (
                    New-BufferCell -Character ([char]32) -BackGroundColor Black) > $null

                Start-Sleep -Milliseconds ($TimeToWaitMS - 20)
            }#End of if White was chosen as the Message erase color

            #Then, remove the coordinate from the list
            $global:MatrixMessageXPositionsGenericList.Remove($XPositionToRemove) > $null
        }#End of while there are Message characters to erase
    }#End of if there was a message to write
    
    ################
    #   Clean Up   #
    ################
        
    #<Oisin Grehan>
    $host.ui.rawui.BackgroundColor = $prevbg

    #<Kent Yeabower>
    If ($ReturnConsoleToPreviousSize) {
        Resize-ConsoleWindow $PreviousWindowSize.width $PreviousWindowSize.height
    }

    #<Oisin Grehan>
    Clear-Host
}#End of Write-MatrixMessage function



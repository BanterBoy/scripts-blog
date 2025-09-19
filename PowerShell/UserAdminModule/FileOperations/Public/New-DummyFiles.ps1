<#
.SYNOPSIS
Creates a specified number of dummy files of various types in a given directory.

.DESCRIPTION
The `New-DummyFiles` function generates a specified number of dummy files with random content. The file types can be specified, and it supports multiple types such as txt, log, csv, xml, json, png, properties, and html. If the base directory does not exist, it will be created.

.PARAMETER baseDirectory
Specifies the base directory where the dummy files will be created. This parameter is mandatory.

.PARAMETER numFiles
Specifies the number of dummy files to create. This parameter is mandatory.

.PARAMETER fileTypes
Specifies the types of files to create. This parameter is optional and defaults to txt, log, csv, xml, json, png, properties, and html.

.EXAMPLE
New-DummyFiles -baseDirectory "C:\TestFiles" -numFiles 100
Creates 100 dummy files of various types in the directory "C:\TestFiles".

.EXAMPLE
New-DummyFiles -baseDirectory "C:\TestFiles" -numFiles 50 -fileTypes @("txt", "csv", "json")
Creates 50 dummy files with the specified file types (txt, csv, json) in the directory "C:\TestFiles".

.NOTES
Author: Your Name
Date: Today's Date

The function includes a progress bar to indicate the progress of file creation.
In case of an error during the file creation process, an error message will be displayed.

#>

function New-DummyFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$baseDirectory,
        [Parameter(Mandatory = $true)]
        [int]$numFiles,
        [Parameter(Mandatory = $false)]
        [string[]]$fileTypes = @("txt", "log", "csv", "xml", "json", "png", "properties", "html")
    )

    # Create the base directory if it doesn't exist
    if (-Not (Test-Path $baseDirectory)) {
        New-Item -Path $baseDirectory -ItemType Directory | Out-Null
    }

    try {
        # Create files
        for ($i = 0; $i -lt $numFiles; $i++) {
            # Update progress bar
            $percentComplete = ($i / $numFiles) * 100
            Write-Progress -Activity "Creating Dummy Files" -Status "Processing file $i of $numFiles" -PercentComplete $percentComplete

            # Select a random file type from the specified types
            $fileType = Get-Random -InputObject $fileTypes

            # Create the file
            $filePath = Join-Path -Path $baseDirectory -ChildPath ("file{0}.{1}" -f $i, $fileType)

            switch ($fileType) {
                'txt' {
                    $txtContent = @(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam.",
                        "Praesent ac sem eget est egestas volutpat. Vivamus vel nulla eget eros elementum pellentesque. Quisque porttitor eros nec tellus vestibulum. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Curabitur non nulla sit amet nisl tempus convallis quis ac lectus. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Sed porttitor lectus nibh. Vivamus suscipit tortor eget felis porttitor volutpat.",
                        "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla porttitor accumsan tincidunt. Cras ultricies ligula sed magna dictum porta. Curabitur aliquet quam id dui posuere blandit. Pellentesque in ipsum id orci porta dapibus. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus. Donec rutrum congue leo eget malesuada. Praesent sapien massa, convallis a pellentesque nec, egestas non nisi.",
                        "Donec sollicitudin molestie malesuada. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus. Donec rutrum congue leo eget malesuada. Vivamus suscipit tortor eget felis porttitor volutpat. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Curabitur aliquet quam id dui posuere blandit. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a.",
                        "Pellentesque in ipsum id orci porta dapibus. Curabitur aliquet quam id dui posuere blandit. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Donec sollicitudin molestie malesuada. Curabitur aliquet quam id dui posuere blandit. Vivamus suscipit tortor eget felis porttitor volutpat. Nulla porttitor accumsan tincidunt. Cras ultricies ligula sed magna dictum porta.",
                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.",
                        "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                        "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.",
                        "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.",
                        "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                        "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.",
                        "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.",
                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.",
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam.",
                        "Praesent ac sem eget est egestas volutpat. Vivamus vel nulla eget eros elementum pellentesque. Quisque porttitor eros nec tellus vestibulum. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Curabitur non nulla sit amet nisl tempus convallis quis ac lectus. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Sed porttitor lectus nibh. Vivamus suscipit tortor eget felis porttitor volutpat.",
                        "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla porttitor accumsan tincidunt. Cras ultricies ligula sed magna dictum porta. Curabitur aliquet quam id dui posuere blandit. Pellentesque in ipsum id orci porta dapibus. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus. Donec rutrum congue leo eget malesuada. Praesent sapien massa, convallis a pellentesque nec, egestas non nisi.",
                        "Donec sollicitudin molestie malesuada. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus. Donec rutrum congue leo eget malesuada. Vivamus suscipit tortor eget felis porttitor volutpat. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Curabitur aliquet quam id dui posuere blandit. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a.",
                        "Pellentesque in ipsum id orci porta dapibus. Curabitur aliquet quam id dui posuere blandit. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Donec sollicitudin molestie malesuada. Curabitur aliquet quam id dui posuere blandit. Vivamus suscipit tortor eget felis porttitor volutpat. Nulla porttitor accumsan tincidunt. Cras ultricies ligula sed magna dictum porta."
                    ) -join "`n"
                    $txtContent | Set-Content -Path $filePath | Out-Null
                }
                'log' {
                    $logContent = @(
                        "2021-01-01 08:00:00 INFO: Application started",
                        "2021-01-01 08:05:23 ERROR: An error occurred while trying to divide by zero. Math is hard.",
                        "2021-01-01 08:10:45 INFO: Application stopped",
                        "2021-01-01 08:15:12 DEBUG: Debugging info: Found the lost sock under the bed.",
                        "2021-01-01 08:20:00 WARN: Warning: Low disk space. Time to clean out those cat videos.",
                        "2021-01-01 08:25:35 INFO: Application restarted",
                        "2021-01-01 08:30:05 ERROR: Another error occurred. This one’s on us.",
                        "2021-01-01 08:35:50 INFO: Application running smoothly. Pigs have not yet flown.",
                        "2021-01-01 08:40:30 DEBUG: More debugging info: The cake is a lie.",
                        "2021-01-01 08:45:00 WARN: Another warning message. Beware of the dog. And the cat. And the goldfish.",
                        "2021-01-01 08:50:15 INFO: Routine operation completed. High-fives all around!",
                        "2021-01-01 08:55:25 DEBUG: Continuing debug: Found Waldo. He was in the database.",
                        "2021-01-01 09:00:40 ERROR: Yet another error. It’s like whack-a-mole with bugs.",
                        "2021-01-01 09:05:50 INFO: Routine task completed. Time for a coffee break.",
                        "2021-01-01 09:10:30 WARN: Routine warning. Remember, no capes!",
                        "2021-01-01 09:15:20 DEBUG: Debugging more info: Discovered the meaning of life. It’s 42.",
                        "2021-01-01 09:20:45 INFO: Task successful. Achievement unlocked!",
                        "2021-01-01 09:25:50 ERROR: Application crash. We blame the gremlins.",
                        "2021-01-01 09:30:15 WARN: Recovery warning: Brace for impact.",
                        "2021-01-01 09:35:00 INFO: Recovery successful. Whew!",
                        "2021-01-01 09:40:35 DEBUG: Debugging final issue: Located Jimmy Hoffa.",
                        "2021-01-01 09:45:50 INFO: Application closed. Don’t forget to tip your server.",
                        "2021-01-01 10:00:00 INFO: Morning meeting started. Time to pretend we know what we're doing.",
                        "2021-01-01 10:15:23 INFO: Morning meeting ended. Everyone is now a little more confused.",
                        "2021-01-01 10:30:45 DEBUG: Started investigating random crashes. Suspecting the printer again.",
                        "2021-01-01 10:45:12 WARN: Printer is out of paper. Again.",
                        "2021-01-01 11:00:00 INFO: Paper refilled. Printer is happy. For now.",
                        "2021-01-01 11:15:35 DEBUG: New bug discovered. It’s a feature.",
                        "2021-01-01 11:30:05 ERROR: Application crashed because of an unexpected null value. Thanks, null.",
                        "2021-01-01 11:45:50 INFO: Restarted the application. Fingers crossed.",
                        "2021-01-01 12:00:30 DEBUG: All systems go. Knock on wood.",
                        "2021-01-01 12:15:00 WARN: Lunch break imminent. Do not disturb.",
                        "2021-01-01 12:30:15 INFO: Lunch break started. The cafeteria is out of sandwiches.",
                        "2021-01-01 12:45:25 ERROR: Found a hair in the salad. Day ruined.",
                        "2021-01-01 13:00:40 INFO: Lunch break over. Back to reality.",
                        "2021-01-01 13:15:50 DEBUG: Post-lunch sluggishness detected. Coffee to the rescue.",
                        "2021-01-01 13:30:30 WARN: Coffee machine is empty. Panic ensues.",
                        "2021-01-01 13:45:20 INFO: Coffee machine refilled. Order restored.",
                        "2021-01-01 14:00:45 DEBUG: Afternoon productivity surge detected. Miracles do happen.",
                        "2021-01-01 14:15:50 ERROR: Application crashed. Did we try turning it off and on again?",
                        "2021-01-01 14:30:15 WARN: User error suspected. User denies everything.",
                        "2021-01-01 14:35:00 INFO: Restart successful. Crisis averted.",
                        "2021-01-01 14:40:35 DEBUG: Final debugging session. Last push before the weekend.",
                        "2021-01-01 14:45:50 INFO: Application closed. TGIF!",
                        "2021-01-01 15:00:00 INFO: Preparing for the weekly report. Time to make things look good.",
                        "2021-01-01 15:15:23 INFO: Weekly report completed. Everything is perfect on paper.",
                        "2021-01-01 15:30:45 DEBUG: Started end-of-day cleanup. Keyboard crumbs everywhere.",
                        "2021-01-01 15:45:12 WARN: Office plant looks sad. Needs water.",
                        "2021-01-01 16:00:00 INFO: Watered the office plant. It looks a bit happier.",
                        "2021-01-01 16:15:35 DEBUG: Tidying up the workspace. Found that missing pen.",
                        "2021-01-01 16:30:05 ERROR: Spilled coffee on the desk. Cleanup in progress.",
                        "2021-01-01 16:45:50 INFO: Desk cleaned. Crisis averted.",
                        "2021-01-01 17:00:30 DEBUG: Final checks before leaving. All systems normal.",
                        "2021-01-01 17:15:00 WARN: Reminder to turn off the lights. We are not made of money.",
                        "2021-01-01 17:30:15 INFO: Lights turned off. Heading out.",
                        "2021-01-01 17:45:25 ERROR: Forgot the phone at the desk. Heading back.",
                        "2021-01-01 18:00:40 INFO: Phone retrieved. Finally leaving.",
                        "2021-01-01 18:15:50 DEBUG: End of day log off. See you tomorrow!",
                        "2021-01-01 18:30:30 WARN: Traffic on the way home. Patience is a virtue.",
                        "2021-01-01 18:45:20 INFO: Home sweet home. Another day, another dollar."
                    ) -join "`n"
                    $logContent | Set-Content -Path $filePath | Out-Null
                }
                'csv' {
                    $csvContent = @(
                        "Name,Age,City,Occupation",
                        "John,30,New York,Engineer",
                        "Jane,25,Los Angeles,Doctor",
                        "Alice,35,Chicago,Teacher",
                        "Bob,40,Houston,Lawyer",
                        "Charlie,45,Philadelphia,Architect",
                        "David,50,Phoenix,Chef",
                        "Eve,55,San Antonio,Photographer",
                        "Frank,60,San Diego,Pilot",
                        "Grace,65,Dallas,Nurse",
                        "Helen,70,San Jose,Scientist",
                        "Ivy,28,Miami,Designer",
                        "Jack,33,Boston,Manager",
                        "Karen,38,Denver,Developer",
                        "Leo,43,Seattle,Consultant",
                        "Mona,48,Atlanta,Analyst",
                        "Nina,53,Orlando,Coordinator",
                        "Oscar,58,Portland,Director",
                        "Paul,63,Charlotte,Supervisor",
                        "Quinn,68,Nashville,Technician",
                        "Rita,73,Minneapolis,Assistant",
                        "Steve,78,Pittsburgh,Advisor"
                    ) -join "`n"
                    $csvContent | Set-Content -Path $filePath | Out-Null
                }
                'xml' {
                    $xmlContent = New-Object System.Xml.XmlDocument
                
                    $people = $xmlContent.CreateElement("people")
                    $xmlContent.AppendChild($people) | Out-Null
                
                    $persons = @(
                        @{name = "John Doe"; age = "30" },
                        @{name = "Jane Doe"; age = "25" },
                        @{name = "Alice Smith"; age = "35" },
                        @{name = "Bob Johnson"; age = "40" },
                        @{name = "Charlie Brown"; age = "45" },
                        @{name = "David Williams"; age = "50" },
                        @{name = "Eve Davis"; age = "55" },
                        @{name = "Frank Miller"; age = "60" },
                        @{name = "Grace Wilson"; age = "65" },
                        @{name = "Helen Taylor"; age = "70" },
                        @{name = "Ivy Harris"; age = "28" },
                        @{name = "Jack Clark"; age = "33" },
                        @{name = "Karen Lewis"; age = "38" },
                        @{name = "Leo Walker"; age = "43" },
                        @{name = "Mona Young"; age = "48" },
                        @{name = "Nina Allen"; age = "53" },
                        @{name = "Oscar King"; age = "58" },
                        @{name = "Paul Scott"; age = "63" },
                        @{name = "Quinn Green"; age = "68" },
                        @{name = "Rita Adams"; age = "73" },
                        @{name = "Steve Baker"; age = "78" },
                        @{name = "Tina Perez"; age = "83" },
                        @{name = "Uma Morgan"; age = "88" },
                        @{name = "Vince Cox"; age = "93" },
                        @{name = "Wade Diaz"; age = "98" },
                        @{name = "Xena Foster"; age = "103" },
                        @{name = "Yara Evans"; age = "108" },
                        @{name = "Zane Hill"; age = "113" }
                    )
                
                    foreach ($person in $persons) {
                        $personElement = $xmlContent.CreateElement("person")
                        $nameElement = $xmlContent.CreateElement("name")
                        $nameElement.InnerText = $person.name
                        $ageElement = $xmlContent.CreateElement("age")
                        $ageElement.InnerText = $person.age
                        $personElement.AppendChild($nameElement) | Out-Null
                        $personElement.AppendChild($ageElement) | Out-Null
                        $people.AppendChild($personElement) | Out-Null
                    }
                
                    $xmlContent.Save($filePath) | Out-Null
                }
                'json' {
                    $jsonObject = @(
                        @{ Name = 'John'; Age = 30; City = 'New York'; Occupation = 'Engineer' },
                        @{ Name = 'Jane'; Age = 25; City = 'Los Angeles'; Occupation = 'Doctor' },
                        @{ Name = 'Alice'; Age = 35; City = 'Chicago'; Occupation = 'Teacher' },
                        @{ Name = 'Bob'; Age = 40; City = 'Houston'; Occupation = 'Lawyer' },
                        @{ Name = 'Charlie'; Age = 45; City = 'Philadelphia'; Occupation = 'Architect' },
                        @{ Name = 'David'; Age = 50; City = 'Phoenix'; Occupation = 'Chef' },
                        @{ Name = 'Eve'; Age = 55; City = 'San Antonio'; Occupation = 'Photographer' },
                        @{ Name = 'Frank'; Age = 60; City = 'San Diego'; Occupation = 'Pilot' },
                        @{ Name = 'Grace'; Age = 65; City = 'Dallas'; Occupation = 'Nurse' },
                        @{ Name = 'Helen'; Age = 70; City = 'San Jose'; Occupation = 'Scientist' },
                        @{ Name = 'Ivy'; Age = 28; City = 'Miami'; Occupation = 'Designer' },
                        @{ Name = 'Jack'; Age = 33; City = 'Boston'; Occupation = 'Manager' },
                        @{ Name = 'Karen'; Age = 38; City = 'Denver'; Occupation = 'Developer' },
                        @{ Name = 'Leo'; Age = 43; City = 'Seattle'; Occupation = 'Consultant' },
                        @{ Name = 'Mona'; Age = 48; City = 'Atlanta'; Occupation = 'Analyst' },
                        @{ Name = 'Nina'; Age = 53; City = 'Orlando'; Occupation = 'Coordinator' },
                        @{ Name = 'Oscar'; Age = 58; City = 'Portland'; Occupation = 'Director' },
                        @{ Name = 'Paul'; Age = 63; City = 'Charlotte'; Occupation = 'Supervisor' },
                        @{ Name = 'Quinn'; Age = 68; City = 'Nashville'; Occupation = 'Technician' },
                        @{ Name = 'Rita'; Age = 73; City = 'Minneapolis'; Occupation = 'Assistant' },
                        @{ Name = 'Steve'; Age = 78; City = 'Pittsburgh'; Occupation = 'Advisor' },
                        @{ Name = 'Tina'; Age = 83; City = 'Salt Lake City'; Occupation = 'Editor' },
                        @{ Name = 'Uma'; Age = 88; City = 'Kansas City'; Occupation = 'Planner' },
                        @{ Name = 'Vince'; Age = 93; City = 'Las Vegas'; Occupation = 'Strategist' },
                        @{ Name = 'Wade'; Age = 98; City = 'New Orleans'; Occupation = 'Developer' },
                        @{ Name = 'Xena'; Age = 103; City = 'Buffalo'; Occupation = 'Coordinator' },
                        @{ Name = 'Yara'; Age = 108; City = 'Hartford'; Occupation = 'Manager' },
                        @{ Name = 'Zane'; Age = 113; City = 'Raleigh'; Occupation = 'Consultant' }
                    ) | ConvertTo-Json
                    $jsonObject | Set-Content -Path $filePath | Out-Null
                }
                'png' {
                    Add-Type -AssemblyName System.Drawing
                    $bitmap = New-Object System.Drawing.Bitmap(300, 300)
                    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
                    $graphics.Clear([System.Drawing.Color]::White)
                    $graphics.FillEllipse([System.Drawing.Brushes]::SkyBlue, 10, 10, 280, 280)
                    $graphics.DrawString("Dummy Image", [System.Drawing.Font]::new("Arial", 16), [System.Drawing.Brushes]::Black, [System.Drawing.PointF]::new(80, 140))
                    $graphics.DrawString("Generated by PowerShell", [System.Drawing.Font]::new("Arial", 12), [System.Drawing.Brushes]::Black, [System.Drawing.PointF]::new(50, 180))
                    $bitmap.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png) | Out-Null
                    $graphics.Dispose()
                    $bitmap.Dispose()
                }
                'properties' {
                    $propertiesContent = @(
                        "Name=John",
                        "Age=30",
                        "City=New York",
                        "Occupation=Engineer",
                        "",
                        "Name=Jane",
                        "Age=25",
                        "City=Los Angeles",
                        "Occupation=Doctor",
                        "",
                        "Name=Alice",
                        "Age=35",
                        "City=Chicago",
                        "Occupation=Teacher",
                        "",
                        "Name=Bob",
                        "Age=40",
                        "City=Houston",
                        "Occupation=Lawyer",
                        "",
                        "Name=Charlie",
                        "Age=45",
                        "City=Philadelphia",
                        "Occupation=Architect",
                        "",
                        "Name=David",
                        "Age=50",
                        "City=Phoenix",
                        "Occupation=Chef",
                        "",
                        "Name=Eve",
                        "Age=55",
                        "City=San Antonio",
                        "Occupation=Photographer",
                        "",
                        "Name=Frank",
                        "Age=60",
                        "City=San Diego",
                        "Occupation=Pilot",
                        "",
                        "Name=Grace",
                        "Age=65",
                        "City=Dallas",
                        "Occupation=Nurse",
                        "",
                        "Name=Helen",
                        "Age=70",
                        "City=San Jose",
                        "Occupation=Scientist"
                    ) -join "`n"
                    $propertiesContent | Set-Content -Path $filePath | Out-Null
                }
                'html' {
                    $htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dummy HTML File</title>
</head>
<body>
    <h1>Dummy HTML File</h1>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
    <p>Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam.</p>
    <p>Praesent ac sem eget est egestas volutpat. Vivamus vel nulla eget eros elementum pellentesque. Quisque porttitor eros nec tellus vestibulum. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Curabitur non nulla sit amet nisl tempus convallis quis ac lectus. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Sed porttitor lectus nibh. Vivamus suscipit tortor eget felis porttitor volutpat.</p>
    <p>Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla porttitor accumsan tincidunt. Cras ultricies ligula sed magna dictum porta. Curabitur aliquet quam id dui posuere blandit. Pellentesque in ipsum id orci porta dapibus. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus. Donec rutrum congue leo eget malesuada. Praesent sapien massa, convallis a pellentesque nec, egestas non nisi.</p>
    <p>Donec sollicitudin molestie malesuada. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus. Donec rutrum congue leo eget malesuada. Vivamus suscipit tortor eget felis porttitor volutpat. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Curabitur aliquet quam id dui posuere blandit. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a.</p>
    <p>Pellentesque in ipsum id orci porta dapibus. Curabitur aliquet quam id dui posuere blandit. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Donec sollicitudin molestie malesuada. Curabitur aliquet quam id dui posuere blandit. Vivamus suscipit tortor eget felis porttitor volutpat. Nulla porttitor accumsan tincidunt. Cras ultricies ligula sed magna dictum porta.</p>
    <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.</p>
    <p>Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?</p>
    <p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.</p>
    <p>Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.</p>
    <p>Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?</p>
    <p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.</p>
    <p>Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.</p>
    <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.</p>
</body>
</html>
"@
                    $htmlContent | Set-Content -Path $filePath | Out-Null
                }
            }
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Example usage
# New-DummyFiles -baseDirectory "C:\Path\To\Your\Directory" -numFiles 100

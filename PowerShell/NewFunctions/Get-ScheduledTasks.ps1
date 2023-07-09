function Get-ScheduledTasks {
    [CmdletBinding()]        
   
    # Parameters used in this function
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [ValidateScript( { 
                if (Test-Connection -ComputerName $_ -Quiet -Count 1 -ErrorAction SilentlyContinue ) {
                    $true
                }
                else {
                    throw "$_ is unavailable"
                }
            })]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,
   
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Select task state (Ready, Disabled, Running)")]
        [ValidateSet("Ready", "Disabled", "Running")]
        [string]$State = $null
    ) 
  
    # Error action set to Stop
    $ErrorActionPreference = "Stop"
  
    # Checking module
    Try {
        Import-Module ScheduledTasks
    }
    Catch {
        $_.Exception.Message
        Write-Warning "Scheduled Tasks module not installed"
        Break
    }
          
    # Looping each server
    ForEach ($Computer in $ComputerName) {
        Write-Output "Processing $Computer" 
      
        # Testing connection
        If (!(Test-Connection -ComputerName $Computer -BufferSize 16 -Count 1 -ErrorAction 0 -Quiet)) {
            Write-Warning   "Failed to connect to $Computer"
        }
        Else {
            $TasksArray = @()
  
            Try {
                $Tasks = Get-ScheduledTask -CimSession $Computer | Where-Object { $_.State -match "$State" }
            }
            Catch {
                $_.Exception.Message
                Continue
            }
 
            If ($Tasks) {
                # Loop through the servers
                $Tasks | ForEach-Object {
                    # Define current loop to variable
                    $Task = $_
  
                    # Creating a custom object 
                    $Object = New-Object PSObject -Property @{
                        Computer           = $Task.PSComputerName
                        TaskName           = $Task.TaskName
                        RunAsUser          = $Task.Principals.Principal.UserId
                        Actions            = $Task.Actions
                        Author             = $Task.Author
                        Date               = $Task.Date
                        Description        = $Task.Description
                        Documentation      = $Task.Documentation
                        Principal          = $Task.Principal
                        SecurityDescriptor = $Task.SecurityDescriptor
                        Settings           = $Task.Settings
                        Source             = $Task.Source
                        TaskPath           = $Task.TaskPath
                        Triggers           = $Task.Triggers
                        URI                = $Task.URI
                        Version            = $Task.Version
                        State              = $Task.State
                    }  
  
                    # Add custom object to our array
                    $TasksArray += $Object
                }
  
                # Display results in console
                $TasksArray 
            }
            Else {
                Write-Warning "Tasks not found"
            }
        }
    }   
}

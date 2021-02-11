# Simple Powershell form to 'wrap' the Exchange Message Tracking into a GUI for general ease of use
# change $msxserver to your exchange server, change $suffix to your fqdn

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
New-Variable -Name username  -Option AllScope
New-Variable -Name RecipientCheckbox -Option AllScope
New-Variable -Name SenderCheckbox -Option AllScope
New-Variable -Name emaildatefrom -Option AllScope
New-Variable -Name emaildateto -Option AllScope
$msxserver = "yourcasserver.domain.com"
$suffix = "@domain.com"

# Create the form 
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Exchange Message Tracking V0.1"
$objForm.Size = New-Object System.Drawing.Size(400,300) 
$objForm.StartPosition = "CenterScreen"

# Create username input box
$objLabel1 = New-Object System.Windows.Forms.Label
$objLabel1.Location = New-Object System.Drawing.Size(10,20) 
$objLabel1.Size = New-Object System.Drawing.Size(280,20) 
$objLabel1.Text = "Enter the email address to track;"
$objForm.Controls.Add($objLabel1) 
$objTextBox1 = New-Object System.Windows.Forms.TextBox 
$objTextBox1.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox1.Size = New-Object System.Drawing.Size(260,20)
$objTextBox1.TabIndex = 0 
$objForm.Controls.Add($objTextBox1)

# Create FROM date box
$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(10,70) 
$objLabel2.Size = New-Object System.Drawing.Size(280,20) 
$objLabel2.Text = "Enter the FROM date; format MM/dd/yyyy hh:mm:ss"
$objForm.Controls.Add($objLabel2)  
$objTextBox2 = New-Object System.Windows.Forms.TextBox 
$objTextBox2.Location = New-Object System.Drawing.Size(10,90) 
$objTextBox2.Size = New-Object System.Drawing.Size(260,20)
$objTextBox2.TabIndex = 1  
$objForm.Controls.Add($objTextBox2)

# Create TO date box
$objLabel3 = New-Object System.Windows.Forms.Label
$objLabel3.Location = New-Object System.Drawing.Size(10,120) 
$objLabel3.Size = New-Object System.Drawing.Size(280,20) 
$objLabel3.Text = "Enter the TO date; format MM/dd/yyyy hh:mm:ss"
$objForm.Controls.Add($objLabel3)  
$objTextBox3 = New-Object System.Windows.Forms.TextBox 
$objTextBox3.Location = New-Object System.Drawing.Size(10,140) 
$objTextBox3.Size = New-Object System.Drawing.Size(260,20)
$objTextBox3.TabIndex = 2
$objForm.Controls.Add($objTextBox3)

#Create a checkbox for Recipient
$RecipientCheckbox = New-Object System.Windows.Forms.Checkbox 
$RecipientCheckbox.Location = New-Object System.Drawing.Size(10,180) 
$RecipientCheckbox.Size = New-Object System.Drawing.Size(100,20)
$RecipientCheckbox.Text = "Recipient"
$RecipientCheckbox.TabIndex = 4
$objForm.Controls.Add($RecipientCheckbox)

#Create a checkbox for Sender
$SenderCheckbox = New-Object System.Windows.Forms.Checkbox 
$SenderCheckbox.Location = New-Object System.Drawing.Size(110,180) 
$SenderCheckbox.Size = New-Object System.Drawing.Size(160,20)
$SenderCheckbox.Text = "Sender"
$SenderCheckbox.TabIndex = 5
$objForm.Controls.Add($SenderCheckbox)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(120,220)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$username=$objTextBox1.Text;$emaildatefrom=$objTextBox2.Text;$emaildateto=$objTextBox3.Text;$objForm.Close()})
$OKButton.TabIndex = 9
$objForm.Controls.Add($OKButton)
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(195,220)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$CancelButton.TabIndex = 10
$objForm.Controls.Add($CancelButton)
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$username=$objTextBox1.Text;$emaildatefrom=$objTextBox2.Text;$emaildateto=$objTextBox3.Text;$objForm.Close()}})
	$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
{$objForm.Close()}})

# concatenate vars together and run cmdlet
$fulladdr = ($username+$suffix)
If ($RecipientCheckbox.Checked -eq $true)
  {
       	Get-MessageTrackingLog -Server $msxserver -Start "$emaildatefrom" -End "$emaildateto" -Recipient $fulladdr |select-object TimeStamp, Sender, Recipients, MessageSubject, EventID, ClientIP, ClientHostname |out-gridview
  }
  
If ($SenderCheckbox.Checked -eq $true)
  {
		Get-MessageTrackingLog -Server $msxserver -Start "$emaildatefrom" -End "$emaildateto" -Sender $fulladdr |select-object TimeStamp, Sender, Recipients, MessageSubject, EventID, ClientIP, ClientHostname |out-gridview
  }
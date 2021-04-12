# To use in report get computer name and shutdown time
$DeviceName=$env:computername
$Date=Get-date
Function Create-GetSchedTime { 
  Param($SchedTime )
  $script:StartTime = (Get-Date).AddSeconds($TotalTime)
  $RestartDate = ((get-date).AddSeconds($TotalTime)).AddMinutes(-5)
  $RDate = (Get-Date $RestartDate -f 'dd.MM.yyyy') -replace "\.","/"
  $RTime = Get-Date $RestartDate -f 'HH:mm'
  &schtasks /delete /tn "Shutdown" /f
  &schtasks /create /sc once /tn "Shutdown" /tr "'C:\Windows\system32\cmd.exe' /c shutdown -s -f -t 300" /SD $RDate /ST $RTime /f
}
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName( "Microsoft.VisualBasic") | Out-Null
$Title = "ATTENTION"
$Message = "Your device will be shutdown in 5 minutes :"
$Shutdown = "Shutdown"
$Postpone1H = "Postpone : 1 Hour"
$Postpone2H = "Postpone : 2 Hours"
$Form = $null
$ShutdownButton = $null
$Postpone1HButton = $null
$Label = $null
$TextBox = $null
$Result = $null
$timerUpdate = New-Object 'System.Windows.Forms.Timer'
# Time in seconds
$TotalTime = 301
Create-GetSchedTime -SchedTime $TotalTime 
$timerUpdate_Tick={
  # Define countdown timer
  [TimeSpan]$span = $script:StartTime - (Get-Date)
  # Update the display
  $hours = "{0:00}" -f $span.Hours
  $mins = "{0:00}" -f $span.Minutes
  $secs = "{0:00}" -f $span.Seconds
  $labelTime.Text = "{0}:{1}:{2}" -f $hours, $mins, $secs
  $timerUpdate.Start()
  if ($span.TotalSeconds -le 0){
# Add log file location to generate report
    Add-content "<log-file-location>" "Shutdown 5 minutes later,$DeviceName,$Date"
    $timerUpdate.Stop()
    &schtasks /delete /tn "Shutdown" /f
    shutdown -s -f /t 0
    }
}

#Store the control values
$Form_StoreValues_Closing={}

# Remove all event handlers from the controls
$Form_Cleanup_FormClosed=
  {
    try
    {
      $Form.remove_Load($Form_Load)
      $timerUpdate.remove_Tick($timerUpdate_Tick)
      $Form.remove_Closing($Form_StoreValues_Closing)
      $Form.remove_FormClosed($Form_Cleanup_FormClosed)
    }
    catch [Exception]{ }
  }
      
# Form
$Form = New-Object -TypeName System.Windows.Forms.Form
$Form.Text = $Title
$Form.Size = New-Object -TypeName System.Drawing.Size(422,205)
$Form.StartPosition = "CenterScreen"
$Form.Topmost = $true
$Form.KeyPreview = $true
$Form.ShowInTaskbar = $Formalse
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $Formalse
$Form.MinimizeBox = $Formalse
$Icon = [system.drawing.icon]::ExtractAssociatedIcon("C:\Windows\System32\UserAccountControlSettings.exe")
$Form.Icon = $Icon

# Shutdown Now
$ShutdownButton = New-Object -TypeName System.Windows.Forms.Button
$ShutdownButton.Size = New-Object -TypeName System.Drawing.Size(129,25)
$ShutdownButton.Location = New-Object -TypeName System.Drawing.Size(5,135)
$ShutdownButton.Text = $Shutdown
$ShutdownButton.Font = 'Tahoma, 10pt'
$ShutdownButton.Add_Click(
  {
    &schtasks /delete /tn "Post Maintenance Restart" /f
    shutdown -s -f /t 0
# Add log file location to generate report
    Add-content "<log-file-location>" "Shutdown Now,$DeviceName,$Date"
    $Form.Close()
  }
)
$Form.Controls.Add($ShutdownButton)

# Postpone for 1 Hour
$Postpone1HButton = New-Object -TypeName System.Windows.Forms.Button
$Postpone1HButton.Size = New-Object -TypeName System.Drawing.Size(129,25)
$Postpone1HButton.Location = New-Object -TypeName System.Drawing.Size(139,135)
$Postpone1HButton.Text = $Postpone1H
$Postpone1HButton.Font = 'Tahoma, 10pt'
$Postpone1HButton.Add_Click(
  {
    $Postpone1HButton.Enabled = $False
    $timerUpdate.Stop()
    $TotalTime = 3600
    Create-GetSchedTime -SchedTime $TotalTime
    $timerUpdate.add_Tick($timerUpdate_Tick)
# Add log file location to generate report
    Add-content "<log-file-location>" "Shutdown 1 Hour Later,$DeviceName,$Date"
    $timerUpdate.Start()
  }
)
$Form.Controls.Add($Postpone1HButton)

# Postpone for 2 Hours
$Postpone2HButton = New-Object -TypeName System.Windows.Forms.Button
$Postpone2HButton.Size = New-Object -TypeName System.Drawing.Size(129,25)
$Postpone2HButton.Location = New-Object -TypeName System.Drawing.Size(273,135)
$Postpone2HButton.Text = $Postpone2H
$Postpone2HButton.Font = 'Tahoma, 10pt'
$Postpone2HButton.Add_Click(
  {
    $Postpone1HButton.Enabled = $False
    $timerUpdate.Stop()
    $TotalTime = 7200
    Create-GetSchedTime -SchedTime $TotalTime
    $timerUpdate.add_Tick($timerUpdate_Tick)
    Add-content "<log-file-location>" "Shutdown 2 Hours Later,$DeviceName,$Date"
    $timerUpdate.Start()
  }
)
$Form.Controls.Add($Postpone2HButton)

# Message Area
$MessageArea = New-Object -TypeName System.Windows.Forms.Label
$MessageArea.Size = New-Object -TypeName System.Drawing.Size(330,25)
$MessageArea.Location = New-Object -TypeName System.Drawing.Size(10,15)
$MessageArea.Text = $Message
$MessageArea.Font = 'Tahoma, 10pt'
$Form.Controls.Add($MessageArea)

# Time Area
$TimeArea = New-Object 'System.Windows.Forms.Label'
$TimeArea.AutoSize = $True
$TimeArea.Font = 'Arial, 26pt, style=Bold'
$TimeArea.Location = '120, 60'
$TimeArea.Name = 'labelTime'
$TimeArea.Size = '43, 15'
$TimeAreae.TextAlign = 'MiddleCenter'
$Form.Controls.Add($TimeArea)

#Start the timer
$timerUpdate.add_Tick($timerUpdate_Tick)
$timerUpdate.Start()

# Show
$Form.Add_Shown({$Form.Activate()})

#Clean up the control events
$Form.add_FormClosed($Form_Cleanup_FormClosed)
#Add log file location to generate report
Add-content "<log-file-location" "Shutdown after 5 Minutes ,$DeviceName,$Date"
#Store the control values when form is closing
$Form.add_Closing($Form_StoreValues_Closing)
#Show the Form
$Form.ShowDialog() | Out-Null

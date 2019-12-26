<# 
.SYNOPSIS 
    Provides a graphical frontend for generating random datetime objects and timstomping file MAC properties with the resulting dates.  Also supports the ability to select specific dates.
    This module is intended to be used during Windows Red Team exercises or Penetration Testing engagements.  
    It is also designed for education purposes, to demonstrate the relationship between timestamps that can be manipulated in userspace and timestamps that are stored in the filesystem MFT.
    This utility can be wrapped in a binary and signed with a forged code-signing certificate for additional evasion capabilities.

    Vasken Houdoverdov
    github.com/vhoudoverdov

.DESCRIPTION 
    Provides a graphical frontend for generating random datetime objects and timstomping file MAC properties with the resulting dates.  Also supports the ability to select specific dates.
    Extends the functionality of the Timestomp module located in https://github.com/vhoudoverdov/Security-Utils/.EXAMPLE
#> 

. '.\TimestompUtils\TimestompUtils.ps1'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

$Form   = New-Object system.Windows.Forms.Form
$Form.ClientSize    = '630,181'
$Form.text  = "cTime PoSh for Windows Red Team"
$Form.TopMost   = $True
$Form.FormBorderStyle = 'Fixed3D'

$iconBase64 = Get-Content '.\icon-base64'
$iconBytes  = [Convert]::FromBase64String($iconBase64)
$stream = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage  = [System.Drawing.Image]::FromStream($stream, $true)
$Form.Icon  = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$DateTypeGroupBox   = New-Object system.Windows.Forms.Groupbox
$DateTypeGroupBox.height    = 121
$DateTypeGroupBox.width = 197
$DateTypeGroupBox.text  = "Date Type"
$DateTypeGroupBox.location  = New-Object System.Drawing.Point(15,29)

$RandomDateRadioButton  = New-Object system.Windows.Forms.RadioButton
$RandomDateRadioButton.text = "Random Date"
$RandomDateRadioButton.AutoSize = $true
$RandomDateRadioButton.width    = 104
$RandomDateRadioButton.height   = 20
$RandomDateRadioButton.location = New-Object System.Drawing.Point(14,20)
$RandomDateRadioButton.Font = 'Microsoft Sans Serif,10'
$RandomDateRadioButtonTooltip   = New-Object system.Windows.Forms.ToolTip
$RandomDateRadioButtonTooltip.ToolTipTitle  = "Generate a single random date"
$RandomDateRadioButtonTooltip.isBalloon = $false
$RandomDateRadioButtonTooltip.SetToolTip($RandomDateRadioButton,'Generate a single random datetime object, then timestomp each targets with this datetime.')

$RandomDatesRadioButton          = New-Object system.Windows.Forms.RadioButton
$RandomDatesRadioButton.text     = "Random Dates"
$RandomDatesRadioButton.AutoSize = $true
$RandomDatesRadioButton.width    = 104
$RandomDatesRadioButton.height   = 20
$RandomDatesRadioButton.location = New-Object System.Drawing.Point(14,47)
$RandomDatesRadioButton.Font     = 'Microsoft Sans Serif,10'
$RandomDatesRadioButtonTooltip  = New-Object system.Windows.Forms.ToolTip
$RandomDatesRadioButtonTooltip.ToolTipTitle = "Generate multiple random dates"
$RandomDatesRadioButtonTooltip.isBalloon    = $false
$RandomDatesRadioButtonTooltip.SetToolTip($RandomDatesRadioButton,"Generate a new random datetime object for each target, then timestomp each target with the corresponding datetime value.")

$DateSelectionRadioButton   = New-Object system.Windows.Forms.RadioButton
$DateSelectionRadioButton.text  = "Pick Date..."
$DateSelectionRadioButton.AutoSize  = $true
$DateSelectionRadioButton.width  = 104
$DateSelectionRadioButton.height = 20
$DateSelectionRadioButton.location  = New-Object System.Drawing.Point(14,74)
$DateSelectionRadioButton.Font   = 'Microsoft Sans Serif,10'
$DateSelectionRadioButtonTooltip    = New-Object system.Windows.Forms.ToolTip
$DateSelectionRadioButtonTooltip.ToolTipTitle   = "Pick a specific date"
$DateSelectionRadioButtonTooltip.isBalloon  = $false
$DateSelectionRadioButtonTooltip.SetToolTip($DateSelectionRadioButton,'Pick a specific date, then timestomp each target with this datetime.  Some entropy will be added to the time of this date for randomness.')

$PathDescriptorTextBox  = New-Object system.Windows.Forms.TextBox
$PathDescriptorTextBox.multiline = $true
$PathDescriptorTextBox.text = "Select target items..."
$PathDescriptorTextBox.width    = 289
$PathDescriptorTextBox.height   = 55
$PathDescriptorTextBox.location = New-Object System.Drawing.Point(220,34)
$PathDescriptorTextBox.Font = 'Microsoft Sans Serif,10'
$PathDescriptorTextBox.ReadOnly = $true;

$BrowseButton   = New-Object system.Windows.Forms.Button
$BrowseButton.text  = "Browse..."
$BrowseButton.width = 95
$BrowseButton.height    = 26
$BrowseButton.location  = New-Object System.Drawing.Point(520,33)
$BrowseButton.Font  = 'Microsoft Sans Serif,10'

$TimestompButton    = New-Object system.Windows.Forms.Button
$TimestompButton.BackColor  = "#c9c9c9"
$TimestompButton.text   = "Stomp"
$TimestompButton.width  = 150
$TimestompButton.height = 52
$TimestompButton.location   = New-Object System.Drawing.Point(469,116)
$TimestompButton.Font   = 'Global Sans Serif,17'

$Label1 = New-Object system.Windows.Forms.Label
$Label1.width   = 150
$Label1.height  = 20
$Label1.location  = New-Object System.Drawing.Point(220,94)
$Label1.Font    = 'Microsoft Sans Serif,10'

$ModifiedTimestampCheckbox = New-Object system.Windows.Forms.Checkbox
$ModifiedTimestampCheckbox.location  = New-Object System.Drawing.Point(390,90)
$ModifiedTimestampCheckbox.Text = "Modifed"

$AccessedTimestampCheckbox   = New-Object system.Windows.Forms.Checkbox
$AccessedTimestampCheckbox.location  = New-Object System.Drawing.Point(390,120)
$AccessedTimestampCheckbox.Text = "Accessed"

$CreatedTimestampCheckbox  = New-Object system.Windows.Forms.Checkbox
$CreatedTimestampCheckbox.location  = New-Object System.Drawing.Point(390,150)
$CreatedTimestampCheckbox.Text = "Created"

$Label2 = New-Object system.Windows.Forms.Label
$Label2.width   = 150
$Label2.height  = 20
$Label2.location  = New-Object System.Drawing.Point(220,118)
$Label2.Font    = 'Microsoft Sans Serif,10'

$Label3 = New-Object system.Windows.Forms.Label
$Label3.width   = 150
$Label3.height  = 20
$Label3.location  = New-Object System.Drawing.Point(220,140)
$Label3.Font    = 'Microsoft Sans Serif,10'

$global:TargetDirectory;
$global:SingularDate;

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{Multiselect = $true}

$BrowseButton.Add_Click(
{    
    [void]$FileBrowser.ShowDialog()
    $Continue = $True;
    while($Continue) 
    {
        if($FileBrowser.FileNames -like "*\*")
        {
            $Continue = $false;
            $TargetDirectory = $FileBrowser.FileNames;
            $PathDescriptorTextBox.text  = $TargetDirectory
        }
        else 
        {   $Continue = $false; }
    }
})

$RandomDateRadioButton.Add_Click(
{
    $Label1,$Label2,$Label3 | % {$_.Text = ""}
    $NewDate = New-RandomDate;
    $Label1.text = $NewDate;
    $global:SingularDate = $NewDate;
})

$RandomDatesRadioButton.Add_Click(
{
    $Label1.text = $(New-RandomDate)
    $Label2.text = $(New-RandomDate)
    $Label3.text = "..."
})

$DateSelectionRadioButton.Add_Click(
{
    $TimeInputTextBox   = New-Object system.Windows.Forms.TextBox
    $TimeInputTextBox.multiline = $true
    $TimeInputTextBox.text  = "00:00:00"
    $TimeInputTextBox.width = 80
    $TimeInputTextBox.height    = 30
    $TimeInputTextBox.location  = New-Object System.Drawing.Point(115,170)
    $TimeInputTextBox.Font  = 'Microsoft Sans Serif,14'
    $TimeInputTextBox.MaxLength = 8;

    $Label1,$Label2,$Label3 | % {$_.Text = ""}
    $CalendarForm = New-Object Windows.Forms.Form -Property @{
        StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
        Size          = New-Object Drawing.Size 320, 280
        Text          = 'Select a Date'
        Topmost       = $true
        FormBorderStyle = 'Fixed3D'
}

    $NewCalendar = New-Object Windows.Forms.MonthCalendar -Property @{
        ShowTodayCircle   = $false
        MaxSelectionCount = 1}

    $CalendarForm.Controls.AddRange(@($NewCalendar,$TimeInputTextBox))

    $OKButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 0, 200
        Size         = New-Object Drawing.Size 95, 43
        Text         = 'OK'
        DialogResult = [Windows.Forms.DialogResult]::OK}

    $CalendarForm.AcceptButton = $OKButton
    $CalendarForm.Controls.Add($OKButton)

    $CancelButton = New-Object Windows.Forms.Button -Property @{
        Location     = New-Object Drawing.Point 215, 200
        Size         = New-Object Drawing.Size 95, 43
        Text         = 'Cancel'
        DialogResult = [Windows.Forms.DialogResult]::Cancel}

    $CalendarForm.CancelButton = $CancelButton
    $CalendarForm.Controls.Add($CancelButton)

    $result = $CalendarForm.ShowDialog()

    if ($result -eq [Windows.Forms.DialogResult]::OK) 
    { 
        $Date = $NewCalendar.SelectionStart

        $NormalizedDate = Get-Date -Year $Date.Year -Month $Date.Month -Day $Date.Day `
            -Hour  $([regex]::Match($TimeInputTextBox.Text,'(?:([01]\d|2[0-3])):((?:[0-5]\d)):((?:[0-5]\d))').Groups[1].Value)`
            -Minute $([regex]::Match($TimeInputTextBox.Text,'(?:([01]\d|2[0-3])):((?:[0-5]\d)):((?:[0-5]\d))').Groups[2].Value) `
            -Second $([regex]::Match($TimeInputTextBox.Text,'(?:([01]\d|2[0-3])):((?:[0-5]\d)):((?:[0-5]\d))').Groups[3].Value)

        $Label1.text = $NormalizedDate;
        $global:SingularDate = $NormalizedDate
    }
})

$TimestompButton.Add_Click(
{ 
      
    if($FileBrowser.FileNames.Count -lt 1)
    {
        [System.Windows.MessageBox]::Show('First specify a set of targets to timestomp (click Browse...)')
    }
            
    else
    {
        $FileBrowser.FileNames | % {   
            if(![System.IO.File]::Exists($_)) 
            {
                [System.Windows.MessageBox]::Show('One or more target items are not valid paths.')
            }

        if($RandomDateRadioButton.Checked ) 
        {
            $FileBrowser.FileNames  | % {
                if($ModifiedTimestampCheckbox.Checked){Timestomp-Files -Modified -Path $_ -TargetDate $global:SingularDate}
                if($AccessedTimestampCheckbox.Checked){Timestomp-Files -Accessed -Path $_ -TargetDate $global:SingularDate}
                if($CreatedTimestampCheckbox.Checked){Timestomp-Files -Created -Path $_ -TargetDate $global:SingularDate}
        }
        }
        if($RandomDatesRadioButton.Checked ) 
        {
            $FileBrowser.FileNames  | % {
            
                if($ModifiedTimestampCheckbox.Checked){Timestomp-Files -Modified -Path $_}
                if($AccessedTimestampCheckbox.Checked){Timestomp-Files -Accessed -Path $_}
                if($CreatedTimestampCheckbox.Checked){Timestomp-Files -Created -Path $_}
                                        }
        }
        if($DateSelectionRadioButton.Checked ) 
        {
            $FileBrowser.FileNames  | % {
                if($ModifiedTimestampCheckbox.Checked){Timestomp-Files -Modified -Path $_ -TargetDate $global:SingularDate}
                if($AccessedTimestampCheckbox.Checked){Timestomp-Files -Accessed -Path $_ -TargetDate $global:SingularDate}
                if($CreatedTimestampCheckbox.Checked){Timestomp-Files -Created -Path $_ -TargetDate $global:SingularDate}
                                        }
        }
                                   }
    }
})

$Form.controls.AddRange(@($DateTypeGroupBox,$PathDescriptorTextBox,$BrowseButton,$TimestompButton,$Label1,$Label2,$Label3,$ModifiedTimestampCheckbox,$AccessedTimestampCheckbox,$CreatedTimestampCheckbox))
$DateTypeGroupBox.controls.AddRange(@($RandomDateRadioButton,$RandomDatesRadioButton,$DateSelectionRadioButton))

[void]$Form.ShowDialog()

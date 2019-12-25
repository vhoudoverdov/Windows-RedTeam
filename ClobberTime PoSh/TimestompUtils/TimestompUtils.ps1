<# 
.SYNOPSIS 
    Return a .NET DateTime object that falls within a specified range.
    Vasken Houdoverdov
.DESCRIPTION 
    Part of a module that facilitiates the generation of random DateTime objects and the modification of FileInfo objects to the resulting dates.
.EXAMPLE
    New-RandomDate
#> 
Function New-RandomDate {
$Ceiling = Get-Date -Year 2020 -Month 12 -Date 31
$Floor = Get-Date -Year 2000 -Month 12 -Date 31
Return $(New-Object DateTime($(Get-Random -Max $Ceiling.Ticks -Min $Floor.Ticks))).ToUniversalTime()
}

<# 
.SYNOPSIS 
    Utility for timestomping files in the specified path.  
    Several properties of object type System.IO.FileInfo are modified as a result.
    Vasken Houdoverdov
.DESCRIPTION 
    Part of a module that facilitiates the generation of random DateTime objects and the modification of FileInfo objects to the resulting dates.
.Example 
    Timestomp-Files $Path
#> 

Function Timestomp-Files {
Param([string]$Path,
      [Datetime]$TargetDate,
      [Switch]$Modified,
      [Switch]$Accessed,
      [Switch]$Created
     )

if($TargetDate -eq $NULL) {

if ($Path -isnot [System.IO.DirectoryInfo]){  
if($Modified)
{
$(Get-Item $Path).LastWriteTime = $(New-RandomDate)
$(Get-Item $Path).LastWriteTimeUTC = $(New-RandomDate)
}

if($Accessed)
{
$(Get-Item $Path).LastAccessTime = $(New-RandomDate)
$(Get-Item $Path).LastAccessTimeUTC = $(New-RandomDate)
}

if($Created)
{
$(Get-Item $Path).CreationTime = $(New-RandomDate)
$(Get-Item $Path).CreationTimeUTC = $(New-RandomDate)}
}

else
{  
if(!$(Test-Path $Path)){throw "The specified path wasn't found:  $Path"}
if(!$(Test-Path "$Path\*")){throw "The specified path was empty:  $Path"}
}
}

else
{
    if ($Path -isnot [System.IO.DirectoryInfo])
    {  
        if($Modified)
        {
            $(Get-Item $Path).LastWriteTime = $TargetDate
            $(Get-Item $Path).LastWriteTimeUTC = $TargetDate
        }

    if($Accessed)
        {
            $(Get-Item $Path).LastAccessTime = $TargetDate
            $(Get-Item $Path).LastAccessTimeUTC = $TargetDate
        }

    if($Created)
        {
            $(Get-Item $Path).CreationTime = $TargetDate
            $(Get-Item $Path).CreationTimeUTC = $TargetDate
        }
}

    else
    {
        if(!$(Test-Path $Path)){throw "The specified path wasn't found:  $Path"}
        if(!$(Test-Path "$Path\*")){throw "The specified path was empty:  $Path"}

    }
}
}

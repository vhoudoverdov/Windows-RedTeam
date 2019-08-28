# ClobberTime PoSh

Graphical frontend that provides functionality for manipulation of MAC (Modified, Accessed, Created) timestamps during Windows Red Team or Pentesting engagements, without modifying current system time.  Extends the functionality of the Timestomp module located in https://github.com/vhoudoverdov/Security-Utils/

This utility can be wrapped in a binary (exe) and signed with a forged software-signing certificate for additional evasion.

### Supported Operations
#### Timestomp one or more files with a single random date
This operation will generate one random DateTime object, and stomp all MAC properties of each target file with this date.

#### Timestomp one or more files with multiple random dates
This operation will generate multiple new random DateTime objects, one for each MAC property of each target file.  The result of this operation is that each individual MAC property of each target file will have a uniquely-generated random date.

#### Timestomp one or more files with a specified date
This operation will ask the user to specify a date using an on-screen calendar.  Since objects of type Windows.Forms.MonthCalendar return dates with zeroed time values, a small amount of entropy (a random value less than 8600 seconds) will be added to the selected date.

#### Author
Vasken Houdoverdov

github.com/vhoudoverdov

## Demo
###### Timestomp MAC properties of a single file with a random date

![](demo/demo-single-file-single-date.gif)

###### Timestomp MAC properties of multiple files with multiple random dates

![](demo/demo-multiple-files-multiple-dates.gif)

###### Timestomp MAC properties of a single file with a specified date. Some entropy (<8600 seconds of time) is added to the selected date as part of this operation.

![](demo/demo-single-file-specific-date.gif)

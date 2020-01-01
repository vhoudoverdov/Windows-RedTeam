# Windows-RedTeam

This repository contains custom resources I have developed for Red Team exercises or Pentesting engagements in Windows environments.

#### Author
Vasken Houdoverdov   -   github.com/vhoudoverdov

### ClobberTime

Graphical frontend that provides functionality for manipulation of MAC (Modified, Accessed, Created) timestamps during Windows Red Team or Pentesting engagements, without modifying current system time or any file hashes. Extends the functionality of the Timestomp module located in https://github.com/vhoudoverdov/Security-Utils/

This utility can be wrapped in a binary (exe) and signed with a forged software-signing certificate for additional evasion.

### PortKnock
PortKnock is a PowerShell interface for performing port-knock operations during Windows Red Team and Pentesting engagements.  It includes a client-side component that can initiate one or more port knocks, as well as a server-side component that can listen for the knocks.

This tool was designed specifically to provide a port knocking utility that allows source ports to be specified as part of the port-knock operation. It was also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.

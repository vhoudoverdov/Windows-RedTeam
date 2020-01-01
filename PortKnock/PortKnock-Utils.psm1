<# 
.SYNOPSIS 
    Provides an interface for port-knocking over TCP.  Designed for use during Windows Red Team and Pentesting engagements.
    This tool was designed specifically to provide a PowerShell-based port knocking utility that allows source ports to be specified as part of the port-knock operation.
    It was also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.

    Why is specifying a source port significant in port-knocking?
        A number of Linux rootkits and associated persistence mechanisms (userland backdoors) have been observed using logic that considers source ports from the client side.
        Examples of these rootkits include Venom [1][2] and similar Linux-based rootkits used during the 2014 Freenode compromise [3].
        This tool was designed to implement similar functionality using PowerShell and .NET, while also being an educational reference to this class of malware.
    
        Reference and further reading:
        [1] https://security.web.cern.ch/security/advisories/venom/venom.shtml
        [2] https://www.it.ucla.edu/security/advisories/new-linux-kernel-venom-rootkit-in-the-wild 
        [3] https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2014/october/analysis-of-the-linux-backdoor-used-in-freenode-irc-network-compromise/

.AUTHOR
    Vasken Houdoverdov
    github.com/vhoudoverdov

.DESCRIPTION 
    Provides an interface for port-knocking over TCP.  Designed for use during Windows Red Team and Pentesting engagements.
    This tool is also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.

.EXAMPLE
    Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 1337 -RemoteIp "151.101.1.140" -RemotePort 443

.EXAMPLE
    Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 1337 -RemoteIp "151.101.1.140" -RemotePort 8443 -Data "message"
#> 

Function Invoke-TcpPortKnock()
{
    Param (
        [String]$LocalIP, 
        [int]$LocalPort,
        [String]$RemoteIp,    
        [int]$RemotePort,
        [String]$Data
          )

    Try {
        $LocalIPEndPoint  = New-Object Net.IPEndPoint ([IPAddress]::Parse($LocalIP),$LocalPort)
        $RemoteIPEndPoint  = New-Object Net.IPEndPoint ([IPAddress]::Parse($RemoteIp),$RemotePort)
        $TcpClient = New-Object Net.Sockets.TcpClient($LocalIPEndPoint)
        $TcpClient.Connect($RemoteIPEndPoint) 
        if($TcpStream = $TcpClient.getStream().CanWrite -and $Data.Length -ge 0)
        {
            Try {
             $Bytes = [System.Text.Encoding]::Ascii.GetBytes($Data)
             $TcpClient.getStream().Write($Bytes,0,$Bytes.Count)
                }
            Catch { 
                Write-Host $_.Exception.Message
                  }
        }
        Write-Host “Knocked on $($RemoteIPEndPoint).”
        $TcpClient.close()
        }
    Catch {
        Write-Host “Couldn't knock on $($RemoteIPEndPoint): $($_.Exception.Message)"
          }
}

<# 
.SYNOPSIS 
    Provides an interface for port-knocking over UDP.  Designed for use during Windows Red Team and Pentesting engagements.
    This tool was designed specifically to provide a PowerShell-based port knocking utility that allows source ports to be specified as part of the port-knock operation.
    It was also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.
    
    Why is specifying a source port significant in port-knocking?
        A number of Linux rootkits and associated persistence mechanisms (userland backdoors) have been observed using logic that considers source ports from the client side.
        Examples of these rootkits include Venom [1][2] and similar Linux-based rootkits used during the 2014 Freenode compromise [3].
        This tool was designed to implement similar functionality using PowerShell and .NET, while also being an educational reference to this class of malware.
    
        Reference and further reading:
        [1] https://security.web.cern.ch/security/advisories/venom/venom.shtml
        [2] https://www.it.ucla.edu/security/advisories/new-linux-kernel-venom-rootkit-in-the-wild 
        [3] https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2014/october/analysis-of-the-linux-backdoor-used-in-freenode-irc-network-compromise/

.AUTHOR
    Vasken Houdoverdov
    github.com/vhoudoverdov

.DESCRIPTION 
    Provides an interface for port-knocking over UDP.  Designed for use during Windows Red Team and Pentesting engagements.
    This tool is also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.

.EXAMPLE
    Invoke-UdpPortKnock -LocalIP "10.32.0.2" -LocalPort 1337 -RemoteIp "8.8.8.8" -RemotePort 53

.EXAMPLE
    Invoke-UdpPortKnock -LocalIP "10.32.0.2" -LocalPort 1337 -RemoteIp "10.66.0.2" -RemotePort 1223 -Data "message"
#> 

Function Invoke-UdpPortKnock()
{
    Param (
        [String]$LocalIP, 
        [int]$LocalPort,
        [String]$RemoteIp,    
        [int]$RemotePort,
        [String]$Data
          )

    Try {
        $LocalIPEndPoint  = New-Object Net.IPEndPoint ([IPAddress]::Parse($LocalIP),$LocalPort)
        $RemoteIPEndPoint  = New-Object Net.IPEndPoint ([IPAddress]::Parse($RemoteIp),$RemotePort)
        $UdpClient = New-Object Net.Sockets.Udpclient($LocalPort)
        $UdpClient.Connect($RemoteIPEndPoint)
        if($Data.Length -ge 0)
        {
            Try {
                $Bytes = [System.Text.Encoding]::Ascii.GetBytes($Data)
                $UdpClient.Send($bytes, $bytes.length(), $RemoteIPEndPoint)
                }
            Catch{
                Write-Host "Couldn't write data to $($RemoteIPEndPoint).  $($_.Exception.Message)"}
        }
        Write-Host “Knocked on $($RemoteIPEndPoint).”
        $UdpClient.close()
        }
    Catch {
        Write-Host “Couldn't knock on $($RemoteIPEndPoint): $($_.Exception.Message)"
          }
}
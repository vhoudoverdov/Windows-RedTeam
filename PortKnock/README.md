# PortKnock

## Table of Contents
* [Intro](#intro)
* [Supported Operations](#operations)
* [Examples](#examples)
* [Malware Use Cases and Further Reading](#appendix)

### <a name="intro"></a>Intro
PortKnock is a PowerShell interface for performing port-knock operations during Windows Red Team and Pentesting engagements. It contains a client-side component that can invoke one or more port knocks, plus a corresponding server-side component that waits for the knocks.

This tool was designed specifically to provide a port knocking utility that allows source ports to be specified as part of the port-knock operation.
It was also designed as an educational tool for understanding advanced persistence mechanisms used by threat actors and malware.

#####  Author
Vasken Houdoverdov  - github.com/vhoudoverdov

### <a name="operations"></a>Supported Operations
#### <a name="client-operations"></a>Client-Side Operations

| Operation | Description |
| --- | --- |
| **Invoke a TCP port knock** | Construct and initiate a port knock over TCP. |
| **Invoke a UDP port knock** | Construct and initiate a port knock over UDP.|

#### <a name="server-operations"></a>Server-Side Operations

| Operation | Description |
| --- | --- |
| **Create a waiting TCP server** | Create a TCP server that listens for port knocks. |

### <a name="examples"></a>Examples
#### Invoke a TCP Port Knock Sequence
```
# C2 Server is waiting for a sequence of three TCP knocks whose source ports are prime numbers...

$CommandAndControl = "10.66.0.1"

Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 2137 -RemoteIp $CommandAndControl -RemotePort 8080
Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 4099 -RemoteIp $CommandAndControl -RemotePort 8080
Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 3761 -RemoteIp $CommandAndControl -RemotePort 8080
```


#### Invoke a UDP Port Knock Sequence
```
# C2 Server is waiting for a sequence of four UDP knocks whose source ports are identical, and where there is a two second delay between each knock...

$CommandAndControl = "10.66.0.1"

1..4 | % {
  Invoke-UdpPortKnock -LocalIP "10.32.0.2" -LocalPort 1337 -RemoteIp $CommandAndControl -RemotePort 8080
  Sleep 2;
}
```

#### Create a TCP Server
```
# Create a server that waits for port knocks.  The server-side logic dictates what operations occur when the right knocks are observed.

New-TcpServer -LocalPort 1337
```

### <a name="appendix"></a>Malware Use Cases and Further Reading
A number of interesting malwares have utilized port knocking in combination with source port interpretation.  Two examples of this type of malware are provided here.

#### Venom Rootkit (2017)

[CERN - Advisory: VENOM Linux rootkit](https://security.web.cern.ch/security/venom.shtml)

[UCLA - New Linux Kernel "VENOM" Rootkit in the Wild](https://www.it.ucla.edu/security/advisories/new-linux-kernel-venom-rootkit-in-the-wild)


#### Linux Malware from Freenode Intrusion (2014)

[Analysis of the Linux backdoor used in freenode IRC network intrusion](https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2014/october/analysis-of-the-linux-backdoor-used-in-freenode-irc-network-compromise/)

# PortKnock-ClientUtils

## Table of Contents
* [Intro](#intro)
* [Supported Operations](#operations)
* [Examples](#examples)
* [Malware Use Cases and Further Reading](#appendix)

### <a name="intro"></a>Intro
This is the client-side component of the PortKnock-Utils set of modules.  It provides an interface for creating one or more port knocks over TCP or UDP.  
Data can be passed as part of the knock if the server is expecting it.

This tool was designed specifically to provide a port knocking utility that allows source ports to be specified as part of the port-knock operation.
It was also designed as an educational tool for understanding advanced persistence mechanisms used by threat actors and malware.

#####  Author
Vasken Houdoverdov  - github.com/vhoudoverdov

### <a name="operations"></a>Supported Operations

| Operation | Description |
| --- | --- |
| **Invoke a TCP port knock** | Construct and initiate a port knock over TCP. |
| **Invoke a UDP port knock** | Construct and initiate a port knock over UDP.|

### <a name="examples"></a>Examples
#### Invoke a TCP Port Knock Sequence
```
# C2 Server is waiting for a sequence of three TCP knocks whose source ports are prime numbers...

$CommandAndControl = "10.66.0.1"

Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 2137 -RemoteIp $CommandAndControl -RemotePort 8080
Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 4099 -RemoteIp $CommandAndControl -RemotePort 8080
Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 3761 -RemoteIp $CommandAndControl -RemotePort 8080
```

#### Invoke a TCP Port Knock with Data
```
# C2 Server is waiting for a sequence of TCP knocks that contain Base64-encoded data

$CommandAndControl = "10.66.0.1"

Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 4444 -RemoteIp $CommandAndControl -RemotePort 8443 -Data "dXNlcm5hbWU6cm9vdA=="
Invoke-TcpPortKnock -LocalIP "10.32.0.2" -LocalPort 4444 -RemoteIp $CommandAndControl -RemotePort 8443 -Data "cGFzc3dvcmQ6bWFnaWM="
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

### <a name="appendix"></a>Malware Use Cases and Further Reading
A number of interesting malwares have utilized port knocking in combination with source port interpretation.  Two examples of this type of malware are provided here.

##### Venom Rootkit (2017)

[CERN - Advisory: VENOM Linux rootkit](https://security.web.cern.ch/security/venom.shtml)

[UCLA - New Linux Kernel "VENOM" Rootkit in the Wild](https://www.it.ucla.edu/security/advisories/new-linux-kernel-venom-rootkit-in-the-wild)

##### Linux Malware from Freenode Intrusion (2014)

[Analysis of the Linux backdoor used in freenode IRC network intrusion](https://www.nccgroup.trust/uk/about-us/newsroom-and-events/blogs/2014/october/analysis-of-the-linux-backdoor-used-in-freenode-irc-network-compromise/)

##### Umbreon Linux Rootkit (2016)
[Pokémon-themed Umbreon Linux Rootkit Hits x86, ARM Systems](https://blog.trendmicro.com/trendlabs-security-intelligence/pokemon-themed-umbreon-linux-rootkit-hits-x86-arm-systems/?_ga=2.180041126.367598458.1505420282-1759340220.1502477046)

##### Chaos Backdoor (2018)
[Chaos: a Stolen Backdoor Rising Again](https://www.gosecure.net/blog/2018/02/14/chaos-a-stolen-backdoor-rising/)

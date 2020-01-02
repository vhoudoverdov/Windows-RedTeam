# PortKnock-ServerUtils

## Table of Contents
* [Intro](#intro)
* [Supported Operations](#operations)
* [Examples](#examples)

### <a name="intro"></a>Intro
This is the server-side component of the PortKnock-Utils interface.  It is designed to create a listening TCP or UDP server that listens for the right port knocks before launching one or more actions.

#####  Author
Vasken Houdoverdov  - github.com/vhoudoverdov

### <a name="operations"></a>Supported Operations

| Operation | Description |
| --- | --- |
| **Create a Listening TCP Server** | Construct a TCP server on a given local port.  This server can perform one or more actions if the right knocks are observed. |


### <a name="examples"></a>Examples
#### Create a TCP Server
Create a server that waits for port knocks.  The server-side logic dictates what operations occur when the right knocks are observed.
```
New-TcpServer -LocalPort 1337
```

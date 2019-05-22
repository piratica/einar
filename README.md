# einar
Self-contained remote TAP built using (mostly) native Bash scripting.

## Inspiration ##
The inspiration behind this tool was a quick and easy way to get a (any) Linux based machine on a target network to get a foothold.  I wanted to minimize the dependencies and maximize the number of types of devices (computer, VM, Raspberry Pi, toaster, etc.) that could be used.  As a result, my goal is to build this using Bash (should be on most any Linux distro) and default commands / binaries.  The tool can then be extended but, to get on target and get information in and out, this was what I came up with.

## What's Here ##
There are 2 directories, client and server.  
The file(s) in server directory should be uploaded to the C2 server in a directory that's avaialble to the device.
The file(s) in the client directory should be uploaded to a directory (I use /opt/<something>) that the C2USER has access to.

## Disclaimer ##
I am not a programmer / developer
If you don't want stupid prizes, don't play stupid games.  
Don't do bad / illegal things with this
I am not a programmer / developer

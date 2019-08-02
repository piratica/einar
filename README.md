# einar *(one, alone+warrior)*
Self-contained remote TAP built using (mostly) native Bash scripting.  

*Einar is a Scandinavian given name deriving from the Old Norse name Einarr, which according to Guðbrandur Vigfússon is directly connected with the concept of the einherjar, warriors who died in battle and ascended to Valhalla in Norse mythology. Vigfússon comments that 'the name Einarr is properly = einheri" and points to a relation to the term with the Old Norse common nouns einarðr (meaning "bold") and einörð (meaning "valour").[1] *
https://en.m.wikipedia.org/wiki/Einar

# Inspiration ##
The inspiration behind this tool was a quick and easy way to get a (any) Linux based machine on a target network to get a foothold.  I wanted to minimize the dependencies and maximize the number of types of devices (computer, VM, Raspberry Pi, toaster, etc.) that could be used.  As a result, my goal is to build this using Bash (should be on most any Linux distro) and default commands / binaries.  The tool can then be extended but, to get on target and get information in and out, this was what I came up with.

## What's Here ##
There are 2 directories, client and server.  
The file(s) in server directory should be uploaded to the C2 server in a directory that's avaialble to the device.
The file(s) in the client directory should be uploaded to a directory (I use /opt/<something>) that the C2USER has access to.

## Quick Start ##
- Upload the contents of the server directory to your C2 server.  It needs to be available via HTTP(s) at this point.  I plan to include support for scp and possibly rsync (over SSH) later.
- On your device, create a non-privileged user
- Create a directory that all of this *stuff* is going to live in.  I use /opt/<something>
- Upload the contents of the client directory to the directory that you just created.
- Update the config.sh file with the necessary information
- $ sudo chmod +x provision.sh
- $ sudo ./provision
- Confirm that a <SERIAL>-cron.sh file was created in the root directory
- Tail your webserver logs on the C2 server to confirm that your device is polling the directory
- Create a file <SERIAL> in the webserver directory and the device should download it and run it (this doesn't work yet).  It's set this way so that, if you have multiple devices, you can store commands for all of them here.
- I'm working to do a SHA256 hash check on the command file to confirm that what the device downloads is what I wanted it to download.  Until I finish that, I don't want to let the device run the file.

## Disclaimer ##
I am not a programmer / developer
If you don't want stupid prizes, don't play stupid games.  
Don't do bad / illegal things with this
I am not a programmer / developer

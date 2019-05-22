# einar
Self-contained remote TAP built using (mostly) native Bash scripting.
There are 2 directories, client and server.  
The file(s) in server directory should be uploaded to the C2 server in a directory that's avaialble to the device.
The file(s) in the client directory should be uploaded to a directory (I use /opt/<something>) that the C2USER has access to.

# PowerBeacon
Small example of a reverse tcp shell in powershell with some persistence. Created for a malware analysis course. 

# Files
BuildEdge.ps1 uses ps2exe to build the executable. Writes a ps1 script with base64 encoded script and compiles it to an exedcutable. 

BuildEdge Clear.ps1 is the cleartext of the encoded script.

PowerBeacon is the module that everything will eventually get dropped into. Currently, it has a Connect cmdlet that is used with the TCP listener generated in the executable.

GenerateBeacon function should be ignored until it is updated with the finished BuildEdge script.

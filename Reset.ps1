rm HKCU:\Software\Microsoft\Windows\CurrentVersion\Run\mssedge
(Get-WmiObject -Class Win32_Service -Filter "Name='MicrosoftEdgeUpdater'").delete()
Stop-Process (Get-Process -Name mssedge).ID
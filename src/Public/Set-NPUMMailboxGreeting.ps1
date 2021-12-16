Function Set-NPUMMailboxGreeting {
    [CmdletBinding()]
    Param(
        [Alias('ComputerName', 'Host', 'IPAddress')]
        [string]$MSLServer
    )

    Test-ModuleInstalled Posh-SSH

    $FilePath = "C:\Greetings"

    If (!Test-Path -Path $FilePath){
        Set-OutputColour "Red" "All files must be placed in the Greetings folder directly on the C Drive i.e. C:\Greetings"
        Break
    }

    $files = Get-ChildItem -Path (Join-Path $FilePath -ChildPath *.wav)

    if (!$files) {
        Set-OutputColour "Red" "No files to upload"
        Break
    }

    if (!$MSLServer) {
        $MSLServer = Read-Host "Enter MiCollab Server IP Address"
    }
    
    $Credentials = Get-Credential root
        
    try {
        New-SFTPSession -ComputerName $MSLServer -Credential $Credentials
        New-SshSession -ComputerName $MSLServer -Credential $Credentials
    } Catch {
        Set-OutputColour "Red" "Server connection failed, please ensure SSH has been enabled on the server and you are connecting from a trusted network"
        Break
    }

    Invoke-SSHCommand -SessionId 0 -Command "mkdir /tmp/vf"

    ForEach ($File in $files) {
        If ($File.Name.Contains(' ')) {
            $File = Rename-Item -Path $File -NewName ($File.Name -replace ' ', '_')
        }
        $MailboxNumber = Read-Host "What mailbox number does "$File.Name" need to be uploaded to?"
        Set-SFTPFile -SessionId 0 -LocalFile $File -RemotePath /tmp/vf
        $FileName = '"/tmp/vf/' + $File.Name + '"'
        Invoke-SshCommand -SessionId 0 -Command "agreet_copy cmd=f m=$FileName m2=$MailboxNumber dg=1"
        # Remove-Item $File
    }

    Invoke-SSHCommand -SessionId 0 -Command "rm /tmp/vf/*.wav"
    Invoke-SSHCommand -SessionId 0 -Command "rmdir /tmp/vf"
    Remove-SFTPSession -Index 0
    Remove-SshSession -Index 0
}
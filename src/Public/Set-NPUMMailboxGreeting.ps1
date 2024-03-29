Function Set-NPUMMailboxGreeting {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="FQDN or IP Address of MSL Server")]
        [Alias('ComputerName', 'Host', 'IPAddress')]
        [string]$MSLServer
    )

    If (!(Get-Module -ListAvailable Posh-SSH)) {
        Write-Output "You must install the Posh-SSH module before you can continue"
        Write-Output "Y Install Posh-SSH"
        Write-Output "N Quit"
        do {
            $answer = Read-Host "Do you want to install Posh-SSH?"
            switch ($answer) {
                "Y" {Install-Module -Name Posh-SSH -Force
                    Import-Module -Name Posh-SSH
                    Break}
                "N" {Return}
            }
        } While ($True)
    }

    $FilePath = "C:\Greetings"
    $Credentials = Get-Credential root
        
    New-SFTPSession -ComputerName $MSLServer -Credential $Credentials
    New-SshSession -ComputerName $MSLServer -Credential $Credentials

    Invoke-SSHCommand -SessionId 0 -Command "mkdir /tmp/vf"

    ForEach ($File in (Get-ChildItem -Path (Join-Path $FilePath -ChildPath *.wav))) {
        If ($File.Name.Contains(' ')) {
            $File = Rename-Item -Path $File -NewName ($File.Name -replace ' ', '_')
        }
        $MailboxNumber = Read-Host "What mailbox number does "$File.Name" need to be uploaded to?"
        Set-SFTPFile -SessionId 0 -LocalFile $File -RemotePath /tmp/vf
        $FileName = '"/tmp/vf/' + $File.Name + '"'
        Invoke-SshCommand -SessionId 0 -Command "agreet_copy cmd=f m=$FileName m2=$MailboxNumber dg=1"
        Remove-Item $File
    }

    Invoke-SSHCommand -SessionId 0 -Command "rm /tmp/vf/*.wav"
    Invoke-SSHCommand -SessionId 0 -Command "rmdir /tmp/vf"
    Remove-SFTPSession -Index 0
    Remove-SshSession -Index 0
}
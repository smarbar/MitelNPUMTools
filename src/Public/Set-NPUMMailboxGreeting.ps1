<#
.SYNOPSIS
Uploads and activates Mitel NuPoint voicemail greetings on individual mailboxes
 
.DESCRIPTION
The Set-NPUMMailboxGreeting cmdlet will upload all wav files in the C:\Greetings folder and request the mailbox number to activate it on.

The Posh-SSH module must be installed. To do this on Powershell v4 and above run the following command 'install-module -Name Posh-SSH'

Greetings must be in the below format. 
CCITT u-law, 8KHz, 8 bit, mono.

.PARAMETER ComputerName
FQDN or IP Address of MSL server to create connection

.EXAMPLE
Set-NPUMMailBoxGreeting 192.168.1.10

.NOTES
A folder called Greetings needs to be created on the C Drive of your computer and the properly formated WAV files placed in here for upload. The upload
procedure will also delete these files so make sure they are a copy and orginial placed somewhere for safe keeping.
You will be prompted for the mailbox number for each file as it is being uploaded.
SSH must be enabled on the MSL server.

.Link
Posh-SSH

#>
Function Set-NPUMMailboxGreeting
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="FQDN or IP Address of MSL Server")]
        [Alias('ComputerName', 'Host', 'IPAddress')]
        [string]$MSLServer
    )

    If (!(Get-Module -ListAvailable Posh-SSH))
    {
        Write-Output "You must install the Posh-SSH module before you can continue"
        Write-Output "Y Install Posh-SSH"
        Write-Output "N Quit"
        do
        {
            $input = Read-Host "Do you want to install Posh-SSH?"
            switch ($input)
            {
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

    ForEach ($File in (Get-ChildItem -Path (Join-Path $FilePath -ChildPath *.wav)))
    {
        If ($File.Name.Contains(' '))
        {
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
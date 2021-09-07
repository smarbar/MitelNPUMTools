Function Set-BulkNPUMMailboxGreeting {
    <#
    .SYNOPSIS
    Bulk upload, import and activation of Mitel NuPoint voicemail greetings

    .DESCRIPTION
    The Set-BulkNPUMMailboxGreeting cmdlet will upload all wav files in the C:\Greetings folder and use the mbs.csv to activate each against the correct mailbox.

    The Posh-SSH module must be installed. To do this on Powershell v4 and above run the following command 'install-module -Name Posh-SSH'

    Greetings must be in the below format. 
    CCITT u-law, 8KHz, 8 bit, mono.

    A csv file named mbs.csv needs to be stored in the C:\Greetings folder along with the greetings. The csv needs to have two columns, one named 'Mailbox' and the other 'File'
    Mailbox is the mailbox number for the user and file is the file name of the new greeting.
    e.g.
    Mailbox | File
    ========|========
    1460    | 1460_John.wav
    1678    | Jim1678.wav

    .PARAMETER ComputerName
    FQDN or IP Address of MSL server to create connection

    .EXAMPLE
    Set-BulkNPUMMailboxGreeting 192.168.1.10

    .NOTES
    A folder called Greetings needs to be created on the C Drive of your computer and the properly formated WAV files placed in here for upload. The upload
    procedure will also delete these files so make sure they are a copy and orginial placed somewhere for safe keeping.
    SSH must be enabled on the MSL server.

    .Link
    Posh-SSH

    #>
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

    If (Get-ChildItem $FilePath | Where-Object { $_.Name.Contains(' ')}) {
        Write-Output "Filenames cannot include spaces, please change and try again"
        Write-Output "Dont forget to update the csv file with the new filename"
        Write-Output "You can run Test-BulkNPUM to highlight all those affected"
        return
    }

    $Credentials = Get-Credential root
    
    New-SFTPSession -ComputerName $MSLServer -Credential $Credentials
    New-SshSession -ComputerName $MSLServer -Credential $Credentials

    Invoke-SSHCommand -SessionId 0 -Command "mkdir /tmp/vf"

    foreach ($File in (Get-ChildItem -Path (Join-Path $FilePath -ChildPath *.wav))) {
        $FileName = '"/tmp/vf/' + $File.Name + '"'
        Set-SFTPFile -SessionId 0 -LocalFile $File -RemotePath /tmp/vf
        Remove-Item $File

    }
    
    $csvImport = Import-Csv $FilePath\mbs.csv
    foreach ($item in $csvImport) {
        $File = $item.File
        $Mailbox = $item.Mailbox
        $FileName = '"/tmp/vf/' + $File + '"'
        Invoke-SshCommand -ComputerName $Server -Command "agreet_copy cmd=f m=$FileName m2=$Mailbox dg=1"
    }
    
    Invoke-SSHCommand -SessionId 0 -Command "rm /tmp/vf/*.wav"
    Invoke-SSHCommand -SessionId 0 -Command "rmdir /tmp/vf"
    Remove-SFTPSession -Index 0
    Remove-SshSession -Index 0
}

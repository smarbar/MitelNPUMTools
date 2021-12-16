Function Set-BulkNPUMMailboxGreeting {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="FQDN or IP Address of MSL Server")]
        [Alias('ComputerName', 'Host', 'IPAddress')]
        [string]$MSLServer
    )

    # test ssh module installed
    # test greetings folder exists
    # test greetings folder has wav files present

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

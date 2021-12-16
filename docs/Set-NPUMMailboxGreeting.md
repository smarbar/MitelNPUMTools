---
external help file: MitelNPUMTools-help.xml
Module Name: MitelNPUMTools
online version:
schema: 2.0.0
---

# Set-NPUMMailboxGreeting

## SYNOPSIS
Uploads and activates Mitel NuPoint voicemail greetings on individual mailboxes

## SYNTAX

```
Set-NPUMMailboxGreeting [-MSLServer] <String> [<CommonParameters>]
```

## DESCRIPTION
The Set-NPUMMailboxGreeting cmdlet will upload all wav files in the C:\Greetings folder, it will then iterate through each file and prompt for the mailbox number to activate it on.

The Posh-SSH module must be installed.
To do this on Powershell v4 and above run the following command 'install-module -Name Posh-SSH'

Greetings must be in the following format. 
CCITT u-law, 8KHz, 8 bit, mono.

## EXAMPLES

### EXAMPLE 1
```
Set-NPUMMailBoxGreeting 192.168.1.10
```

## PARAMETERS

### -MSLServer
FQDN or IP Address of MSL Server

```yaml
Type: String
Parameter Sets: (All)
Aliases: ComputerName, Host, IPAddress

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
A folder called Greetings needs to be created on the C Drive of your computer and the properly formated WAV files placed in here for upload.
You will be prompted for the mailbox number for each file as it is being uploaded.
SSH must be enabled on the MSL server.

## RELATED LINKS

[[https://github.com/smarbar/MSTeamsDirectRouting/tree/main/docs/Connect-Tdr.md](https://github.com/smarbar/MitelNPUMTools/tree/main/docs/Set-NPUMMailboxGreeting.md)
[https://github.com/smarbar/MSTeamsDirectRouting/tree/main/docs](https://github.com/smarbar/MitelNPUMTools/tree/main/docs)


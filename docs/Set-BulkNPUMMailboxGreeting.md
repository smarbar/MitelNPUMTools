---
external help file: MitelNPUMTools-help.xml
Module Name: MitelNPUMTools
online version:
schema: 2.0.0
---

# Set-BulkNPUMMailboxGreeting

## SYNOPSIS
Bulk upload, import and activation of Mitel NuPoint voicemail greetings

## SYNTAX

```
Set-BulkNPUMMailboxGreeting [-MSLServer] <String> [<CommonParameters>]
```

## DESCRIPTION
The Set-BulkNPUMMailboxGreeting cmdlet will upload all wav files in the C:\Greetings folder and use the mbs.csv to activate each against the correct mailbox.

The Posh-SSH module must be installed.
To do this on Powershell v4 and above run the following command 'install-module -Name Posh-SSH'

Greetings must be in the below format. 
CCITT u-law, 8KHz, 8 bit, mono.

A csv file named mbs.csv needs to be stored in the C:\Greetings folder along with the greetings.
The csv needs to have two columns, one named 'Mailbox' and the other 'File'
Mailbox is the mailbox number for the user and file is the file name of the new greeting.
e.g.
| Mailbox | File |
| --- | --- |
| 1460 | 1460_John.wav |
| 1678 | Jim1678.wav |

## EXAMPLES

### EXAMPLE 1
```
Set-BulkNPUMMailboxGreeting 192.168.1.10
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
The upload
procedure will also delete these files so make sure they are a copy and orginial placed somewhere for safe keeping.
SSH must be enabled on the MSL server.

## RELATED LINKS

[https://github.com/smarbar/MSTeamsDirectRouting/tree/main/docs/Connect-Tdr.md](https://github.com/smarbar/MitelNPUMTools/tree/main/docs/Set-BulkNPUMMailboxGreeting.md)
[https://github.com/smarbar/MSTeamsDirectRouting/tree/main/docs](https://github.com/smarbar/MitelNPUMTools/tree/main/docs)


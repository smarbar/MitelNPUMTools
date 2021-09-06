

<#
.SYNOPSIS
Tests the audio files specified in the CSV exists and are available for upload

.DESCRIPTION
The Test-BulkNPUM cmdlet will test that the audio files specified in the CSV exists and are available for upload.

Greetings must be in the below format. 
CCITT u-law, 8KHz, 8 bit, mono.

A csv file named mbs.csv needs to be stored in the C:\Greetings folder along with the greetings. The csv needs to have two columns, one named 'Mailbox' and the other 'File'
Mailbox is the mailbox number for the user and file is the file name of the new greeting. Please ensure there are no spaces in the audio filename, this will be highlighted in the test results.
e.g.
Mailbox | File
--------|----------
1460    | 1460_John.wav
1678    | Jim1678.wav

.EXAMPLE
Test-BulkNPUMCSVFile

.NOTES
A folder called Greetings needs to be created on the C Drive of your computer and the properly formated WAV files placed in here for upload. A CSV file named mbs.csv also needs to be placed here 


#>
Function Test-BulkNPUMUpload
{
    $FilePath = "C:\Greetings"
    $csvImport = Import-Csv $FilePath\mbs.csv
    foreach ($item in $csvImport)
    {
        $File = $item.File
        $TestPath = Join-Path -Path $FilePath -ChildPath $File
        If (!(Test-Path -Path $TestPath))
        {
            Write-Output "Error:   $File does not exist"
        }
        ELSEIF ($file -match ' ')
        {
            Write-Output "Warning: $File has spaces in the name"
        }
    }
}
function Test-BulkNPUMUpload {
    $FilePath = "C:\Greetings"
    $csvImport = Import-Csv $FilePath\mbs.csv
    foreach ($item in $csvImport) {
        $File = $item.File
        $TestPath = Join-Path -Path $FilePath -ChildPath $File
        If (!(Test-Path -Path $TestPath)) {
            Write-Output "Error:   $File does not exist"
        }
        ELSEIF ($file -match ' ') {
            Write-Output "Warning: $File has spaces in the name"
        }
    }
}
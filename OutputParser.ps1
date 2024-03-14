function Parse-Output {
    Param($text)
    $divider = ":"
    $entries = @()
    foreach ($line in $text) {
        if ($null = $line) {
            $entry = [PSCustomObject]::new 
            }
        $line = $line.Replace('[\s]', '')
        $infoPair = $line.Split($divider)
        if (-not $infoPair[0] -or -not $infoPair[1]) {
            $property = "MISSING"
            $value = "MISSING"
        }
        $property = $infoPair[0]
        $value = $infoPair[1]
        Add-Member -inputObject $entry -NotePropertyName $property -NotePropertyValue $value
        $entries += $entry
    }
    $entries
}

Parse-Output(Get-Content 'C:\Users\Curtis\OneDrive\Desktop\Nerd Shit\Scripting\Objects-From-Text\Test Data')

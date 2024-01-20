function ObjectsFromList{
    Param ($text)
    # Create a class with the properties matching the desired fields from the input data, 
    # the desired properties must be known beforehand and defined as part of the class below.
    class Entry {
        [string] $UUID
        [string] $VendorID
        [string] $ProductID
        [string] $Port
        [string] $Revision
        [string] $USBversionspeed
        [string] $manufacturer
        [string] $Product
        [string] $Address
        [string] $Currentstate
    }
    # Initialize variables
    $divider = ':'
    $entries = @()
    $invalidEntries = 0
    # Creates an initial object to work with
    $currentEntry = [Entry]::new()
    # Loop through every line of the input
    foreach ($line in $text -split "`r`n") {
        $trim = $line.Replace(" ","")
        # If the trimmed line is not empty and contains text on either side of the divider, set the
        # current object's property to the text before the divider and value to the text after.
        if (![string]::IsNullOrWhiteSpace($trim)) {
            $split = $trim -split $divider
            if ($split.Count -eq 2) {
                $property = $split[0] -replace '[^a-zA-Z0-9]', ''
                $value = $split[1].Trim()
                # If there is no property matching the current line, incriment a counter
                try {
                $currentEntry.$property = $value
                }
                catch {
                    $invalidEntries +=
                    continue
                }
            }
        } else {
            # Save the current entry and create a new one
            if ($currentEntry.PSObject.Properties.Count -gt 0) {
                $entries += $currentEntry
            }
            $currentEntry = [Entry]::new()
        }
    }
 
    # Add the last entry (if any)
    if ($currentEntry.PSObject.Properties.Count -gt 0) {
        $entries += $currentEntry
    }
    
    [string] $broken = [string] $invalidEntries + " listed properties were not added"
    return $entries
    return Write-Output $broken
}
$example = 
"UUID:               2249cb6f-a286-4afa-882a-2129a9607f5f
VendorId:           0x03f0 (03F0)
ProductId:          0x034a (034A)
Revision:           1.33 (0133)
Port:               3
USB version/speed:  1/Low
Manufacturer:       Chicony
Product:            HP Elite USB Keyboard
Address:            {36fc9e60-c465-11cf-8056-444553540000}\0021
Current State:      Busy"

ObjectsFromList($example)



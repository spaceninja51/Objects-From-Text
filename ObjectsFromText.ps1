<# This function iterates though text, creating a new object at each blank line. All lines containing text are checked for a divider charcter ($divider), 
if the character is found the text before the divider is checked against the properties defined in the Entry class. All properties must be set to the same name from the input dataset
If the text matches a property, the text after the divider is set to that property's value for the current object. if either side of the divider character is blank, 
the entry is added to the invalid entries array.

All valid objects are added to the $entries array with their corresponding values

Invalid objects are added to the $invalidEntries array

Output arrays: $entries $invalidEntries #>
function ObjectsFromList {
    Param ($text)

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

    $divider = ":"
    $entries, $invalidEntries = @()
    $currentEntry = [Entry]::new()

    foreach ($line in $text -split "`r`n") {
        if (![string]::IsNullOrWhiteSpace($line.Trim())) {
            $split = $line.Split($divider)
            if ($split.Count -eq 2) {
                $property = $split[0].Replace('[^a-zA-Z0-9]', '')
                $value = $split[1].Trim()
                try {
                    if ($currentEntry.PSObject.Properties.Match($property).Count -gt 0) {
                        $currentEntry.$property = $value
                    } else {
                        $invalidEntries += "Property '$property' does not exist in the Entry class and was not set to the listed value '$value'."
                    }
                } catch {
                    $invalidEntries += "Error setting property '$property' to value '$value'."
                }
            }
        } else {
            if ($currentEntry.PSObject.Properties.Count -gt 0) {
                $entries += $currentEntry
            }
            $currentEntry = [Entry]::new()
        }
    }

    return {
        $entries
        $invalidEntries
    }
}

#below is an example of data that can be passed to the function
$example = "
UUID: 0000:00:14.0
VendorID: 8086
ProductID: 8d31
Port: 00
Revision: 00
USB versionspeed: 3.10
manufacturer: Intel Corp.
Product: DSL6540 USB 3.1 Controller
Address: 0000:00:14.0
Current state: 4"

ObjectsFromList($example)
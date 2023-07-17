function Convert-APIDateTime {
    <#
        .SYNOPSIS
        Converts a string to a datetime object

        .DESCRIPTION
        The Rubrik API endpoints often return dates within the response. These dates are treated as strings within the response. 
        This function may be used to convert these returned date strings into a properly formated datetime object. Two date
        string formats are supported: 'ddd MM dd HH:mm:ss UTC yyyy' & 'yyyy-MM-ddTHH:mm:ss.fffZ'

        .EXAMPLE
        Convert-APIDateTime "Thu Aug 08 20:31:36 UTC 2019" 

        Thursday, August 8, 2019 8:31:36 PM

        .EXAMPLE
        Convert-APIDateTime "2023-07-17T09:59:58.453Z" 

        Monday, July 17, 2023 9:59:58 AM
    #>
    [cmdletbinding()]
    param(
        [parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string] $DateTimeString
    )

    begin {
        [System.Globalization.DateTimeFormatInfo]::InvariantInfo.get_abbreviatedmonthnames() | ForEach-Object -Begin {
            $MonthHash = @{}
            $Count = 0
        } -Process {
            $Count++
            if ($_) {
                $MonthHash.$_ = $Count.ToString().Padleft(2,'0')
            }
        }
    }

    process {

        if ($DateTimeString -match '^\w{3} \w{3} \d{2} \d{2}:\d{2}:\d{2} UTC \d{4}$') {

            $NewDateTimeString = $DateTimeString.Substring(4) -replace 'UTC '
            $MonthHash.GetEnumerator() | ForEach-Object {
                $NewDateTimeString = $NewDateTimeString -replace $_.Key,$_.Value
            }
            try {
                [DateTime]::ParseExact($NewDateTimeString,'MM dd HH:mm:ss yyyy',$null).ToLocalTime().ToUniversalTime()
            } catch {
                Write-Error "$($NewDateTimeString): $($_.Exception.Message)"
            }
            
        } elseif ($DateTimeString -match '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$') {

            try {
                (Get-Date $DateTimeString -ea Stop).ToUniversalTime()
            } catch {
                Write-Error "$($DateTimeString): $($_.Exception.Message)"
            }

        } else {
            Write-Error "Unhandled date string format: $($DateTimeString)"
        }
    }
}
Remove-Module -Name 'Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './Rubrik/Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Private/Convert-APIDateTime' -Tag 'Private', 'Convert-APIDateTime' -Fixture {
    Context -Name 'Convert different date time objects' -Fixture {
      
        $cases = 'Mon Jan 10 17:12:14 UTC 2019',
        'Mon Mar 11 09:12:14 UTC 2017',
        'Mon Sep 12 23:12:14 UTC 2018',
        '2023-07-17T09:59:58.453Z',
        'Mon Dec 13 14:12:14 UTC 2006' | ForEach-Object {
            @{'DateTimeString' = $_}
            
        }

        It -Name "Get-RubrikAPIData - <DateTimeString> test" -TestCases $cases {
            param($DateTimeString)
            $Date = Convert-APIDateTime -DateTimeString $DateTimeString.ToString()
            $Date | Should -BeOfType DateTime
            $Date.Kind | Should -Be 'Utc'
        }
    }
    
    Context -Name 'Error handling' -Fixture {
        It -Name 'February 30 - Should not have output' -Test {
            Convert-APIDateTime -DateTimeString 'Mon Feb 30 09:12:14 UTC 2017' -ea 0 |
                Should -BeExactly $null
        }
        It -Name 'Movember - Should not have output' -Test {
            Convert-APIDateTime -DateTimeString 'Mon Mov 30 09:12:14 UTC 2018' -ea 0 |
                Should -BeExactly $null
        }
        It -Name '25th hour - Should not have output' -Test {
            Convert-APIDateTime -DateTimeString 'Mon Sep 30 25:12:14 UTC 2018' -ea 0 |
                Should -BeExactly $null
        }
    }
}
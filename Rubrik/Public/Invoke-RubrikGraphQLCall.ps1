function Invoke-RubrikGraphQLCall {
<#
.SYNOPSIS
Provides generic interface to make Rubrik GraphQL API calls

.DESCRIPTION
The Invoke-RubrikGraphQLCall allows users to make raw API endpoint calls to the Rubrik GraphQL interface. To find out more about the GraphQL endpoint take a look at the Rubrik GraphQL Playground project that is hosted on GitHub: https://github.com/rubrikinc/graphql-playground

.NOTES
Written by Jaap Brasser for community usage
Twitter: @jaap_brasser
GitHub: jaapbrasser

.LINK
https://rubrik.gitbook.io/rubrik-sdk-for-powershell/command-documentation/reference/invoke-rubrikgraphqlcall

.EXAMPLE
Invoke-RubrikGraphQLCall -Body '{"query":"{vmwareVcenterTotalCount}"}' -Verbose

Will retrieve the total count of VMware vCenter Servers connected to the Rubrik cluster as a PowerShell object

.EXAMPLE
Invoke-RubrikGraphQLCall -ReturnJSON -Body '{"query":"query{vms {\nnumProtected\n  numUnprotected\n}}"}'

Returns the number of protected and unprotected VMware VM objects as a JSON string

.EXAMPLE
Invoke-RubrikGraphQLCall -ReturnJSON -Verbose -Body '{"query":"query{\r\n  vmwareVirtualMachineConnection(name: \"jbrasser-win\", primaryClusterId: \"local\") {\nedges {\n  node {\n name,\n id,\n primaryClusterId,\n configuredSlaDomainId\n  }\n}\r\n  }\r\n}"}'

Returns the 'jbrasser-win' VM on the local Rubrik cluster as a JSON string, while displaying Verbose information

.EXAMPLE
Invoke-RubrikGraphQLCall -ReturnNode -Body '{"query":"query ( $name: String) {\nvmwareVirtualMachineConnection(name: $name, primaryClusterId: \"local\") {\n  edges {\nnode {\n  name,\n  id,\n  primaryClusterId,\n  configuredSlaDomainId\n}\n  }\n}\r\n}","variables":{"name":"jbrasser-lin"}}'

Returns the 'jbrasser-lin' VM on the local Rubrik cluster as the VM Object, using a variable as input for vmwareVirtualMachineConnection

.EXAMPLE
Invoke-RubrikGraphQLCall -ReturnNode -Body '{"query":"query{\r\n  vmwareVirtualMachineConnection{\nedges {\n  node {\nhostId\neffectiveSlaDomain {\nid\nname\n}\nprimaryClusterId\nconfiguredSlaDomainId\nid\nvmwareToolsInstalled\nisRelic\nname\nvcenterId\nfolderPath {\nid\nname\n}\ninfraPath {\nid\nname\n}\nagentStatus {\nagentStatus\ndisconnectReason\n}\nhostName\nclusterName\n  }\n}\r\n  }\r\n}","variables":{}}'

Returns all VMware VMs on the Rubrik Cluster and displays the individual objects by using the -ReturnNode parameter

.EXAMPLE
Invoke-RubrikGraphQLCall -ReturnNode -Body '{"query":"query OrganizationSummary(\n $name: String,\n $isGlobal: Boolean,\n $sortBy: String,\n $sortOrder: String,\n $first: Int,\n $after: String,\n) {\n organizationConnection(\n name: $name,\n isGlobal: $isGlobal,\n sortBy: $sortBy,\n sortOrder: $sortOrder,\n first: $first,\n after: $after\n ) {\n nodes {\n id\n name\n isGlobal\n exclusivenessLevel\n admins {\n id\n name\n }\n envoyStatus\n }\n pageInfo {\n endCursor\n hasNextPage\n }\n }\n}\n","variables":{"sortBy":"name","sortOrder":"asc","first":3,"name":"org","isGlobal":false}}'

Returns informations on Rubrik Organizations, filtered by name in ascending order and only including organizations with 'org' in their name property. Returns the individual organization objects using the -ReturnNode parameter

.EXAMPLE
(Invoke-RubrikGraphQLCall -Body '{"query":"query HostsWithSnappables(\n  $effectiveSlaDomainId: String,\n  $hostname: String,\n  $operatingSystemType: String,\n  $status: String,\n  $primaryClusterId: String,\n  $sortBy: String,\n  $sortOrder: String,\n  $templateId: String,\n  $snappableStatus: String,\n  $first: Int,\n  $after: String,\n) {\n    hostConnection(\n        effectiveSlaDomainId:  $effectiveSlaDomainId,\n        hostname: $hostname,\n        operatingSystemType: $operatingSystemType,\n        status: $status,\n        primaryClusterId: $primaryClusterId,\n        sortBy: $sortBy,\n        sortOrder: $sortOrder,\n        templateId: $templateId,\n        snappableStatus: $snappableStatus,\n        first: $first,\n        after: $after,\n    )\n    {\n        nodes {\n            id\n            hostname\n            primaryClusterId\n            operatingSystem\n            operatingSystemType\n            status\n            filesets\n            {\n                hostName\n                operatingSystemType\n                excludes\n                configuredSlaDomainName\n                effectiveSlaDomainId\n                isEffectiveSlaDomainRetentionLocked\n                primaryClusterId\n                hostId\n                includes\n                configuredSlaDomainId\n                configuredSlaDomainType\n                templateId\n                allowBackupNetworkMounts\n                exceptions\n                effectiveSlaDomainName\n                allowBackupHiddenFoldersInNetworkMounts\n                templateName\n                useWindowsVss\n                isRelic\n                name\n                id\n                isPassthrough\n                enableSymlinkResolution\n                enableHardlinkSupport\n                pendingSlaDomain {\n                  objectId,\n                  pendingSlaDomainId,\n                  pendingSlaDomainName,\n                  isPendingSlaDomainRetentionLocked\n                }\n            }\n            hostVfdDriverState\n            volumeGroup\n            {\n                isPaused\n                configuredSlaDomainName\n                effectiveSlaDomainId\n                isEffectiveSlaDomainRetentionLocked\n                primaryClusterId\n                slaAssignment\n                effectiveSlaSourceObjectId\n                volumes {\n                    mountPoints\n                    isCurrentlyPresentOnSystem\n                    id\n                    size\n                    includeInSnapshots\n                    fileSystemType\n                }\n                effectiveSlaSourceObjectName\n                hostId\n                configuredSlaDomainId\n                configuredSlaDomainType\n                effectiveSlaDomainName\n                hostname\n                isRelic\n                name\n                volumeIdsIncludedInSnapshots\n                id\n            }\n            storageArrayVolumeGroups\n            {\n                id\n                name\n                storageArrayId\n                storageArrayName\n                storageArrayType\n                hostId\n                hostname\n                proxyHostId\n                proxyHostname\n                volumes {\n                    id\n                    serial\n                    name\n                    storageArrayId\n                    storageArrayType\n                }\n                configuredSlaDomainId\n                configuredSlaDomainType\n                configuredSlaDomainName\n                effectiveSlaDomainId\n                isEffectiveSlaDomainRetentionLocked\n                effectiveSlaDomainName\n                slaAssignment\n                primaryClusterId\n            }\n        },\n        pageInfo {\n          endCursor\n          hasNextPage\n        }\n    }\n}\n","variables":{"first":50,"operatingSystemType":"Windows","primaryClusterId":"local","sortBy":"hostname","sortOrder":"asc","snappableStatus":"Protectable"}}').hostconnection.nodes | % {[pscustomobject]@{hostname=$_.Hostname;volumegroup=$_.volumegroup.name;volumegroupsla=$_.volumegroup.effectivesladomainname}}

Queries all hosts with volumegroups for the SLA set on that specific volumegroup. Returns 3 properties: hostname, volumegroup, volumegroupsla
#>

    [cmdletbinding()]
    Param (
        # GraphQL Body to send to GraphQL endpoint
        [Parameter(
            Mandatory,
            ParameterSetName='JSON'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName='Node'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName='Default'
        )]
        [ValidateNotNullorEmpty()]
        [string]$Body,
        # Return the JSON object instead of converting it to PowerShell custom objects
        [Parameter(
            Mandatory,
            ParameterSetName='JSON'
        )]
        [switch]$ReturnJSON,
        # Return the objects in the Node(s) property rather than returning the output as a single custom Object
        [Parameter(
            Mandatory,
            ParameterSetName='Node'
        )]
        [switch]$ReturnNode,
        # Rubrik server IP or FQDN
        [String]$Server = $global:RubrikConnection.server,
        # API version
        [ValidateNotNullorEmpty()]
        [String]$api = $global:RubrikConnection.api
    )

    begin {
        #connect to Rubrik if not already connected
        Test-RubrikConnection
    }

    process {
        #execute GraphQL operation
        try {

            #construct uri
            [string]$uri = New-URIString -server $Server -endpoint "/api/internal/graphql"
            Write-Verbose -Message "Body = $Body"

            if ($ReturnJSON) {
                $WebSplat = @{
                    Uri = $uri
                    Headers = $Header
                    ContentType = 'application/json'
                    Body = $Body
                    Method = 'POST'
                    UseBasicParsing = $true
                }

                if (Test-PowerShellSix) {
                    if ($rubrikOptions.ModuleOption.DefaultWebRequestTimeOut) {
                        $result = Invoke-WebRequest -SkipCertificateCheck -TimeoutSec $rubrikOptions.ModuleOption.DefaultWebRequestTimeOut @WebSplat |
                            Select-Object -ExpandProperty Content
                    } else {
                        $result = Invoke-WebRequest -SkipCertificateCheck @WebSplat |
                            Select-Object -ExpandProperty Content
                    }
                } else {
                    if ($rubrikOptions.ModuleOption.DefaultWebRequestTimeOut) {
                        $result = Invoke-WebRequest -TimeoutSec $rubrikOptions.ModuleOption.DefaultWebRequestTimeOut @WebSplat |
                            Select-Object -ExpandProperty Content
                    } else {
                        $result = Invoke-WebRequest @WebSplat |
                            Select-Object -ExpandProperty Content
                    }
                }
            } elseif ($ReturnNode) {
                $result = Submit-Request -uri $uri -header $Header -method POST -body $Body |
                    Select-Object -ExpandProperty data
                if (($newresult = $result.$($result.psobject.properties.name).nodes)) {
                    $result = $newresult
                } elseif (($newresult = $result.$($result.psobject.properties.name).edges.node)) {
                    $result = $newresult
                } else {
                    Write-Verbose -Message "Nodes property not found in $($result.psobject.properties.name), either no results or results are nested."
                }
            } else {
                $result = Submit-Request -uri $uri -header $Header -method POST -body $Body |
                    Select-Object -ExpandProperty data
            }
        }
        catch {
            throw $_
        }

        return $result
    }
}
Param(
    [Parameter(Mandatory=$true)]
    [string]$NodeName,
    [string]$GithubOwner = "opscode",
    [string]$GithubRepo = "chef",
    [string]$GitRevision = "platform/dsc-phase-1",
    [string]$PSVersion = 4,
    [switch]$ClientRunOnly
)

if ($ClientRunOnly.IsPresent) {
    knife winrm "name:$NodeName" "chef-client" -a cloud.public_fqdn
} else {
    $attributes = @"
    {
        \"dsc_test_bootstrap\": {
            \"github_owner\": \"$GithubOwner\",
            \"github_repo\": \"$GithubRepo\",
            \"git_revision\": \"$GitRevision\"
        }
    }
"@ -replace "`n"," "

    $recipes = @()

    switch ($PSVersion) {
        4 {$recipes += 'recipe[powershell::powershell4]'}
        5 {$recipes += 'recipe[powershell::powershell5]'}
        default {Throw "Unsupported powershell version"}
    }

    $recipes += @('recipe[dsc-test-bootstrap]')
    $recipes =  $recipes -join(',')

    knife azure server create --azure-dns-name $NodeName --run-list `'$recipes`' -j `"$attributes`"
}

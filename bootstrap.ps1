Param(
    [string]$NodeName,
    [string]$GithubOwner = "opscode",
    [string]$GithubRepo = "chef",
    [string]$GitRevision = "platform/dsc-phase-1"
)

$attributes = @"
{
    \"dsc_test_bootstrap\": {
        \"github_owner\": \"$GithubOwner\",
        \"github_repo\": \"$GithubRepo\",
        \"git_revision\": \"$GitRevision\"
    }
}
"@ -replace "`n"," "

#knife azure server create --azure-dns-name $NodeName --run-list `"recipe[dsc-test-bootstrap]`" -j `"$attributes`"
knife azure server create --azure-dns-name $NodeName --run-list `'recipe[dsc-test-bootstrap]`' -j `"$attributes`"

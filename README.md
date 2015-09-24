# dsc-test-bootstrap-cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/dsc-test-bootstrap.svg?branch=master)](https://travis-ci.org/chef-cookbooks/dsc-test-bootstrap)

The purpose of this cookbook is to bootstrap up machines
to test the DSC script resource

This cookbook installs powershell/git and pulls down
a version of chef specified by attributes. It then
uses that version of chef to run a recipe in local mode (Local mode is run
with a different lock file)


## Requirements
#### Platforms
- Windows 2012

#### Chef
- Chef 12+

#### Cookbooks
- windows
- powershell
- git
- chocolatey


## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['dsc-test-bootstrap']['github_owner']</tt></td>
    <td>String</td>
    <td>The owner of the github repository for chef</td>
  </tr>
  <tr>
    <td><tt>['dsc-test-bootstrap']['github_repo']</tt></td>
    <td>String</td>
    <td>The github repo containing chef</td>
  </tr>
  <tr>
    <td><tt>['dsc-test-bootstrap']['git_revision']</tt></td>
    <td>String</td>
    <td>The git revision to checkout</td>
  </tr>
</table>

## Usage
### Requirements
You will need to have knife, knife-azure, and knife-windows.
At the time of writing this(knife windows latest release was 0.6.0 42c358e),
knife-windows needed to be checked out and installed from
https://github.com/opscode/knife-windows
### bootstrap.ps1

Provided is a script to create a node in azure and register it to your chef server.

Below is an example of my knife.rb
```ruby
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
client_key               "#{current_dir}/jdmundrawala.pem"
validation_client_name   "mundrawala-test-validator"
validation_key           "#{current_dir}/mundrawala-test-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/mundrawala-test"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )

knife[:azure_publish_settings_file] = "c:/users/Jay\ Mundrawala/myazure.publishsettings"
knife[:azure_vm_size] = "Medium"
knife[:azure_source_image] = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201407.01-en.us-127GB.vhd"
knife[:azure_service_location] = "West US"
knife[:bootstrap_protocol] = "winrm"
knife[:winrm_user] = "myuser"
knife[:winrm_password] = "mypassword”
```

Start by getting the cookbook dependencies:
```
berks install
```

Upload the cookbooks to your chef server:
```
berks vendor
knife cookbook upload -a --cookbook-path .\berks-cookbooks\
```

Create a node in Azure and bootstrap it:
```
.\bootstrap.ps1 -NodeName mynode -PSVersion 5
```
Given the knife.rb file above, this command will create a server running
windows 2012 in Azure. It will clone https://github.com/opscode/chef, and
checkout platform/dsc-phase-1 because the defaults set in bootstrap.ps1
```
Param(
    [Parameter(Mandatory=$true)]
    [string]$NodeName,
    [string]$GithubOwner = "opscode",
    [string]$GithubRepo = "chef",
    [string]$GitRevision = "platform/dsc-phase-1",
    [string]$PSVersion = 4,
    [switch]$ClientRunOnly
)
```
Part of the bootstrap will run the version of chef client that was checked out
from github. This will run
```
bundle exec chef-client -z test_recipe.rb > log
```
test_recipe.rb is in the files/default directory.

Now say you make a change to files/default/test_recipe.rb (or anything in this
cookbook). If you do not require a clean machine, upload your updated cookbooks
to your chef server, and run
```
.\bootstrap.ps1 -NodeName mynode -ClientRunOnly
```


License & Authors
-----------------

**Author:** Jay Mundrawala (<jdm@chef.io>)

**Copyright:** 2008-2015, Chef Software, Inc.
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

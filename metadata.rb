name             'dsc-test-bootstrap'
maintainer       'Jay Mundrawala'
maintainer_email 'jdm@chef.io'
license          'All rights reserved'
description      'Installs/Configures dsc-test-bootstrap'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'powershell', '~> 3.0.7'
depends 'chocolatey', '~> 0.1.0'
depends 'windows', '~> 1.34.2'
depends 'git'

source_url 'https://github.com/chef-cookbooks/dsc-test-bootstrap' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/dsc-test-bootstrap/issues' if respond_to?(:issues_url)

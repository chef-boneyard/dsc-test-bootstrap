TDIR = 'C:\\dsc_test_files'

include_recipe 'chocolatey'

chocolatey 'git'

windows_path 'C:\Program Files (x86)\Git\cmd' do
  action :add
end

ruby_block "reset ENV['PATH']" do
  block do
    ENV['PATH'] = "C:\\Program Files (x86)\\Git\\cmd;#{ENV['PATH']}"
  end
end

chef_gem 'bundler'

directory TDIR

git "#{TDIR}/chef-client" do
  repository "https://github.com/#{node['dsc_test_bootstrap']['github_owner']}/#{node['dsc_test_bootstrap']['github_repo']}"
  revision node['dsc_test_bootstrap']['git_revision']
  action :sync
end

file "#{TDIR}/client.rb" do
  content <<-EOF
lockfile '#{TDIR}/chef-client/.lockfile'
cookbook_path '#{TDIR}/cookbooks'
  EOF
end

# Copy the fourth cookbook
directory "#{TDIR}\\cookbooks"
remote_directory "#{TDIR}\\cookbooks\\fourth"

# Copy the server specs
remote_directory "#{TDIR}\\specs"

# Install spec requirements
powershell_script 'setup specs' do
  cwd "#{TDIR}\\specs"
  code <<-EOH
    bundle install
  EOH
end

powershell_script 'setup chef client for testing' do
  cwd "#{TDIR}\\chef-client"
  code <<-EOH
    bundle install
  EOH
end

# bundle exec chef-client -z '#{Chef::Config[:file_cache_path]}/test_recipe.rb' -c '#{Chef::Config[:file_cache_path]}/client.rb' > log

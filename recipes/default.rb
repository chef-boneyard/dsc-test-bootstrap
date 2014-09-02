include_recipe 'powershell'
include_recipe 'chocolatey'
include_recipe 'git'

windows_path 'C:\Program Files (x86)\Git\bin' do
  action :add
end

ruby_block "reset ENV['PATH']" do
  block do
    ENV['PATH'] = "C:\\Program Files (x86)\\Git\\bin;#{ENV['PATH']}"
  end
end

chef_gem "bundler"

git "#{Chef::Config[:file_cache_path]}/chef-client" do
  repository "https://github.com/#{node[:dsc_test_bootstrap][:github_owner]}/#{node[:dsc_test_bootstrap][:github_repo]}"
  revision node[:dsc_test_bootstrap][:git_revision]
  action :sync
end

file "#{Chef::Config[:file_cache_path]}/client.rb" do
  content <<-EOF
lockfile '#{Chef::Config[:file_cache_path]}/chef-client/.lockfile'
  EOF
end


# Copy the server specs
remote_directory "c:\\specs"

# Install spec requirements
powershell_script "setup specs" do
  cwd "c:\\specs"
  code <<-EOH
    bundle install
  EOH
end

cookbook_file "test_recipe.rb" do
  path "#{Chef::Config[:file_cache_path]}/test_recipe.rb"
end

powershell_script "test_chef" do
  cwd "#{Chef::Config[:file_cache_path]}/chef-client"
  code <<-EOH
    bundle install
    bundle exec chef-client -z '#{Chef::Config[:file_cache_path]}/test_recipe.rb' -c '#{Chef::Config[:file_cache_path]}/client.rb' > log
  EOH
  notifies :write, "cat[log_chef_zero_run]"
end

cat "log_chef_zero_run" do
  path "#{Chef::Config[:file_cache_path]}/chef-client/log"
  action :nothing
end


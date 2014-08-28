include_recipe 'powershell'
include_recipe 'chocolatey'

# -- This is really hacky...is there a better way? --
chocolatey "git"

windows_path 'C:\Program Files (x86)\Git\cmd' do
  action :add
end

ruby_block "reset ENV['PATH']" do
  block do
    ENV['PATH'] = "C:\\Program Files (x86)\\Git\\cmd;#{ENV['PATH']}"
  end
end
# ---------------------------------------------------

chef_gem "bundler"

git "#{Chef::Config[:file_cache_path]}/chef-client" do
  repository "https://github.com/#{node[:dsc_test_bootstrap][:github_owner]}/#{node[:dsc_test_bootstrap][:github_repo]}"
  revision node[:dsc_test_bootstrap][:git_revision]
  action :sync
  notifies :run, "powershell_script[test_chef]"
end

file "#{Chef::Config[:file_cache_path]}/client.rb" do
  content <<-EOF
lockfile '#{Chef::Config[:file_cache_path]}/chef-client/.lockfile'
  EOF
end

cookbook_file "test_recipe.rb" do
  path "#{Chef::Config[:file_cache_path]}/test_recipe.rb"
  notifies :run, "powershell_script[test_chef]"
end

powershell_script "test_chef" do
  cwd "#{Chef::Config[:file_cache_path]}/chef-client"
  code <<-EOH
    bundle install
    bundle exec chef-client -z '#{Chef::Config[:file_cache_path]}/test_recipe.rb' -c '#{Chef::Config[:file_cache_path]}/client.rb' > log
  EOH
  action :nothing
  notifies :write, "cat[log_chef_zero_run]"
end

cat "log_chef_zero_run" do
  path "#{Chef::Config[:file_cache_path]}/chef-client/log"
  action :nothing
end


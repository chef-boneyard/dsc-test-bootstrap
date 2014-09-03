include_recipe 'fourth::get_dsc_reskit'

cookbook_file "#{Chef::Config[:file_cache_path]}/fourthcoffee.ps1"

dsc_script 'fourthcoffee' do
  command "#{Chef::Config[:file_cache_path]}/fourthcoffee.ps1"
end

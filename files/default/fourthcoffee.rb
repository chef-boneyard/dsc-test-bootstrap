include_recipe 'get_dsc_reskit'

dsc_script 'fourthcoffee' do
  command '#{Chef::Config[:file_cache_path]}/fourthcoffee.ps1'
end

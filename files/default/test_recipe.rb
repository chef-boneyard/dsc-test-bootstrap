directory Chef::Config[:file_cache_path] do
  recursive true
end

include_recipe 'fourth::get_dsc_reskit.rb'

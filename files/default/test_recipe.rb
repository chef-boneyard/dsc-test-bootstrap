directory Chef::Config[:file_cache_path] do
  recursive true
end

# Download Dsc Resource Kit
remote_file "#{Chef::Config[:file_cache_path]}/DSC_resource_kit.zip" do
  source "http://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d/file/124481/1/DSC%20Resource%20Kit%20Wave%206%2008282014.zip"
end

# Install Dsc Resource Kit
dsc_script 'get-dsc-resource-kit' do
  code <<-EOH
  Archive dsc-resource-kit-archive
  {
      Ensure = "Present"
      Path = "#{Chef::Config[:file_cache_path]}/DSC_resource_kit.zip"
      Destination = "C:\\Program Files\\WindowsPowerShell\\Modules"
  }
  EOH
end

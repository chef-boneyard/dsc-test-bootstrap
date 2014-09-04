require 'spec_helper'
%w(
  xActiveDirectory
  xAzure
  xComputerManagement
  xDatabase
  xDhcpServer
  xDnsServer
  xDscDiagnostics
  xDSCResourceDesigner
  xFailOverCluster
  xHyper-V
  xJea
  xMySql
  xNetworking
  xPhp
  xPSDesiredStateConfiguration
  xRemoteDesktopSessionHost
  xSmbShare
  xSqlPs
  xSystemSecurity
  xWebAdministration
  xWinEventLog
).each do |m|
  describe file("C:\\Program Files\\WindowsPowerShell\\Modules\\#{m}") do
    it { should be_directory }
  end
end

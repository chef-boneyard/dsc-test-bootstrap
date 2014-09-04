configuration FourthCoffee 
{ 
    Import-DscResource -Module xWebAdministration             

    # Install the IIS role 
    WindowsFeature IIS  
    {  
        Ensure          = "Present"  
        Name            = "Web-Server"  
    }  
  
    # Install the ASP .NET 4.5 role 
    WindowsFeature AspNet45  
    {  
        Ensure          = "Present"  
        Name            = "Web-Asp-Net45"  
    }  
  
    # Stop the default website 
    xWebsite DefaultSite  
    {  
        Ensure          = "Present"  
        Name            = "Default Web Site"  
        State           = "Stopped"  
        PhysicalPath    = "C:\inetpub\wwwroot"  
        DependsOn       = "[WindowsFeature]IIS"  
    }  
  
    # Copy the website content 
    Archive WebContent
    {
        Ensure          = "Present"
        Path            = "C:\Program Files\WindowsPowerShell\Modules\xWebAdministration\Examples\BakeryWebsite.zip"
        Destination     = "C:\inetpub\FourthCoffee"
        DependsOn       = "[WindowsFeature]AspNet45"
    }

if ($false) {
    File WebContent  
    {  
        Ensure          = "Present"  
        SourcePath      = "C:\Program Files\WindowsPowerShell\Modules\xWebAdministration\BakeryWebsite" 
        DestinationPath = "C:\inetpub\FourthCoffee" 
        Recurse         = $true  
        Type            = "Directory"  
#        DependsOn       = "[WindowsFeature]AspNet45"  
    }  
}
    # Create a new website 
    xWebsite BakeryWebSite  
    {  
        Ensure          = "Present"  
        Name            = "FourthCoffee" 
        State           = "Started"  
        PhysicalPath    = "C:\inetpub\FourthCoffee"  
#        DependsOn       = "[File]WebContent"  
        DependsOn       = "[Archive]WebContent"  
    }  
}


class Chef::Resource::Cat < Chef::Resource
  identity_attr :name
  provides :cat, :on_platforms => :all

  def initialize(name, run_context=nil)
    super
    @resource_name = :cat
    @level = :info
    @action = :write
    @allowed_actions.push(:write)
    @provider = Chef::Provider::Cat
    @name = name
  end

  def path(arg=nil)
    set_or_return(
      :path,
      arg,
      :kind_of => String
    )
  end

  # <Symbol> Log level, one of :debug, :info, :warn, :error or :fatal
  def level(arg=nil)
    set_or_return(
      :level,
      arg,
      :equal_to => [ :debug, :info, :warn, :error, :fatal ]
    )
  end
end

class Chef::Provider::Cat < Chef::Provider
  def whyrun_supported?
    true
  end

  def load_current_resource
    true
  end

  def action_write
    converge_by("Sending the contents of #{@new_resource.path} to Chef::Log::#{@new_resource.level}") do
      ::File.open(@new_resource.path, "r:UTF-16LE:UTF-8") do |f|
        f.each_line do |l|
          Chef::Log.send(@new_resource.level, l)
        end
      end
    end
    @new_resource.updated_by_last_action(true)
  end
end

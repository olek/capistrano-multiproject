Capistrano::Configuration.instance.load do
  namespace :multiproject do
    desc "[internal] Filter roles to only those that are used by the current project"
    task :filter_roles do
      project_roles_sym = project_roles.map { |o| o.to_sym }
      roles.delete_if { |k,v| !project_roles_sym.include?(k) }
      logger.info "Filtered roles down to '#{roles.keys.map { |o| o.to_s }.sort.join(', ')}'"
      if roles.empty? && project_roles == [project]
        abort "Define servers of role '#{project}' in stage '#{stage}' configuration, or specify project roles in project recipe (e.g. 'set :project_roles, [:foo, :bar]')"
      end
    end
  end

  on :start, 'multiproject:filter_roles', :except => (projects + stages + %w(?))
end


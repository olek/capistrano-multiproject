Capistrano::Configuration.instance.load do
  namespace :multiproject do
    desc "[internal] Filter roles to only those that are used by the current project"
    task :filter_roles do
      project_roles_sym = project_roles.map(&:to_sym)
      roles.select! { |k,v| project_roles_sym.include?(k) }
      logger.info "Filtered roles down to '#{roles.keys.join(', ')}'"
    end
  end

  on :start, 'multiproject:filter_roles', :except => (projects + stages + %w(?))
end


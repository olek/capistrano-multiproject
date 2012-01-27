Capistrano::Configuration.instance.load do
  namespace :multiproject do
    desc "[internal] Generate arteficial any_server role that enumerates all known servers"
    task :any_server_role do
      project_roles_sym = project_roles.map(&:to_sym)
      servers = roles.values.map(&:servers).flatten.sort.uniq.map(&:to_s)
      top.role :any_server, *servers, :no_release => true
    end
  end

  on :start, 'multiproject:any_server_role', :except => (projects + stages + %w(?))
end



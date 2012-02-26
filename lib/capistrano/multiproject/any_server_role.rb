Capistrano::Configuration.instance.load do
  namespace :multiproject do
    desc "[internal] Generate arteficial any_server role that enumerates all known servers"
    task :any_server_role do
      project_roles_sym = project_roles.map { |o| o.to_sym }
      servers = roles.values.map { |o| o.servers }.map { |o| o.to_s }.flatten.sort.uniq
#      ruby 1.8 hates having hash after expanding array, while 1.9 is totally cool with that
#      top.role(:any_server, *servers, { :no_release => true })
      servers.each { |s| top.server s, :any_server, :no_release => true }
    end
  end

  on :start, 'multiproject:any_server_role', :except => (projects + stages + %w(?))
end



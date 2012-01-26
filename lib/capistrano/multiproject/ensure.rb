Capistrano::Configuration.instance.load do
  namespace :multiproject do
    desc "[internal] Ensure that project/stage has been selected"
    task :ensure do
      unless exists?(:stage)
        warn "No stage configuration specified. Please specify one of:"
        stages.each { |name| puts "  * #{name}" }
        warn "(e.g. 'cap #{stages.first} #{ARGV.last}')"
        abort
      end

      unless exists?(:project)
        warn "No project configuration specified. Please specify one of:"
        projects.each { |name| puts "  * #{name}" }
        warn "(e.g. 'cap #{stage} #{projects.first} #{ARGV.last}')"
        abort
      end
    end
  end

  on :start, 'multiproject:ensure', :except => (projects + stages + %w(?))
end

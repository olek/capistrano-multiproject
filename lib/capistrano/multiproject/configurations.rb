Capistrano::Configuration.instance.load do

  def _cset(name, *args, &block)
    unless exists?(name)
      set(name, *args, &block)
    end
  end

  set(:application) { project }

  _cset(:project_roles) { abort "Project roles must be specified in project recipe (e.g. 'set :project_roles, [:foo, :bar]')" }

  # configurations root directory
  config_root = File.expand_path(fetch(:config_root, "config/deploy"))

  projects_dir = File.join(config_root, 'projects')
  stages_dir = File.join(config_root, 'stages')

  project_files = Dir["#{projects_dir}/*.rb"]
  stage_files = Dir["#{stages_dir}/*.rb"]

  hash_creating_block = lambda do |paths|
    paths.inject({}) do |memo, path|
      memo.merge path.sub(/^.*\/(.+)\.rb$/, '\1') => path
    end
  end

  projects_hash = hash_creating_block.call(project_files)
  stages_hash = hash_creating_block.call(stage_files)

  # ensure that configuration segments don't override any method, task or namespace
  overriding_tasks = (projects_hash.keys + stages_hash.keys) & all_methods
  unless overriding_tasks.empty?
    abort "Config task(s) #{overriding_tasks.inspect} override existing method/task/namespace"
  end

  task_creating_block = lambda do |kind, task_name, task_file|
    desc "Load #{kind} #{task_name} configuration"
    task(task_name, :multiproject => true, :kind => kind) do
      top.set(kind, task_name)
      top.load(:file => task_file)
    end
  end

  projects_hash.each do |task_name, task_file|
    task_creating_block.call(:project, task_name, task_file)
  end

  stages_hash.each do |task_name, task_file|
    task_creating_block.call(:stage, task_name, task_file)
  end

  set(:projects, projects_hash.keys)
  set(:stages, stages_hash.keys)
end

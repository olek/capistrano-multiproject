Capistrano::Configuration.instance.load do
  # a capistrano task to list other tasks, filtering them based on context
    desc "Contextual task list"
    task '?' do
      tasks = top.task_list(:all)

      hidden_tasks = fetch(:hidden_tasks, [])
      hidden_tasks << '?'

      set(:verbose, false) unless exists?(:verbose)

      unless verbose
        tasks =
          if exists?(:project) && exists?(:stage)
            tasks.reject do |t|
              t.description.empty? ||
              t.description =~ /^\[internal\]/ ||
              t.options[:multiproject] ||
              hidden_tasks.include?(t.fully_qualified_name)
            end
          elsif exists?(:project) && !exists?(:stage)
            tasks.select { |t| t.options[:multiproject] && t.options[:kind] == :stage }
          elsif exists?(:stage) && !exists?(:project)
            tasks.select { |t| t.options[:multiproject] && t.options[:kind] == :project }
          else
            tasks.select { |t| t.options[:multiproject] && t.options[:kind] == :stage }
          end
      end

      longest = tasks.map { |task| task.fully_qualified_name.length }.max
      tasks.sort! { |a,b| a.fully_qualified_name <=> b.fully_qualified_name }

      max_length = 76
      tasks.each do |task|
        description = task.desc
        description ||= ''
        description = description.gsub(/\n/,' ')
        description = description.squeeze(' ')
        description = description.strip
        description = description[0..max_length] + "..." if description.size > max_length
        puts "%-#{longest}s  # %s" % [task.fully_qualified_name, description]
      end
      puts "\n"
    end
end

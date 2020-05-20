namespace :task do
  task :tail, :file do |_task, args|
    if args[:file]
      on roles(:app) do
        execute "tail -f #{shared_path}/log/#{args[:file]}.log"
      end
    else
      puts "** Please specify a logfile e.g: 'rake logs:tail[logfile]'"
      puts "** will tail 'shared_path/log/logfile.log'"
    end
  end
end

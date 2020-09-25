namespace :task do
  desc 'Tail passed log file - usage rake logs:tail[logfile]'
  task :tail, :file do |_task, args|
    if args[:file]
      on roles(:app) do
        within shared_path do
          execute :tail, "-f log/#{args[:file]}.log"
        end
      end
    else
      puts "** Please specify a logfile e.g: 'rake logs:tail[logfile]'"
      puts "** will tail 'shared_path/log/logfile.log'"
    end
  end
end

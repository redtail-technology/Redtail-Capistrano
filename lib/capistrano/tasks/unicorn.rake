namespace :unicorn do
  task :create_socket_folder do
    on roles(:all) do
      # For some reason I cannot use relative paths here... even when using a within block...
      execute "if [ ! -e #{shared_path}/tmp/sockets ]; then mkdir #{shared_path}/tmp/sockets; fi"
    end
  end

  task :restart_workers do
    on roles(:all) do
      invoke! 'environment:set_web_site_location'
      invoke! 'unicorn:restart'
    end
  end

  before 'deploy:finished', 'unicorn:create_socket_folder'
end

namespace :environment do
  desc 'Copy Redtail revision over as version'
  task :copy_redtail_revision do
    on roles(:app) do
      execute "echo -n #{fetch(:redtail_revision)} > #{fetch(:release_path)}/config/version.txt"
    end
  end

  desc 'Set web site location'
  task :set_web_site_location do
    on roles(:app) do
      execute "export WEB_SITE_LOCATION=#{fetch(:web_site_location)}"
    end
  end

  before 'deploy:updated', 'environment:copy_redtail_revision'
  before 'deploy:updated', 'environment:set_web_site_location'
end

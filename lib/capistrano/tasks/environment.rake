namespace :environment do
  task :copy_redtail_revision do
    on roles(:app) do
      within release_path do
        execute :echo, "-n #{fetch(:redtail_revision)} > config/version.txt"
      end
    end
  end

  task :set_web_site_location do
    on roles(:app) do
      execute "export WEB_SITE_LOCATION=#{fetch(:web_site_location)}"
    end
  end

  before 'deploy:updated', 'environment:copy_redtail_revision'
  before 'deploy:updated', 'environment:set_web_site_location'
end

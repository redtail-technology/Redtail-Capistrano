def handle_asset_precompile(revisions)
  changed_files = `git diff --name-only #{revisions.first}`.split
  if webpacker_assets_changed?(changed_files)
    puts '** Webpacker assets have changed since last deploy'
    puts '** Invoking asset precompile'
    invoke 'assets:pre_compile'
  elsif assets_changed?(changed_files)
    puts '** Assets have changed since last deploy'
    puts '** Invoking asset precompile without webpacker'
    set :webpacker_precompile, false
    invoke 'assets:pre_compile'
  else
    puts '** Assets have not changed since last deploy'
    puts '** Skipping asset precompile'
  end
end

def assets_changed?(changed_files)
  changed_files.grep(%r(^(Gemfile\.lock|app/assets|vendor/assets))).any?
end

def webpacker_assets_changed?(changed_files)
  changed_files.grep(%r(^(app/javascript|config/webpack|yarn\.lock))).any?
end

namespace :assets do
  task :set_precompile_method do
    on roles :app do
      if capture("if [ -e #{current_path} ]; then echo 'true'; fi").strip == 'true'
        Rake::Task['deploy:assets:precompile'].clear_actions
      else
        Rake::Task['assets:auto_skip_precompile'].clear_actions
      end
    end
  end

  task :auto_skip_precompile do
    revisions = []
    on roles :app do
      within current_path do
        revisions << capture(:cat, 'REVISION').strip
      end
    end

    next if revisions.uniq.length > 1

    handle_asset_precompile(revisions)
  end

  task :pre_compile do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with webpacker_precompile: fetch(:webpacker_precompile, true),
             rails_env: fetch(:rails_env),
             rails_groups: fetch(:rails_assets_groups),
             current_revision: fetch(:current_revision, '') do
          execute :rake, 'assets:precompile'
        end
      end
    end
  end

  before 'deploy:started', 'assets:set_precompile_method'
  before 'deploy:updated', 'assets:auto_skip_precompile'
end

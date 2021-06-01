namespace :dotenv do
  desc "Set custom dotenv variables - usage: set :dotenv_vars, { foo: 'bar' }"
  task :set_custom_vars do
    on roles(:app) do
      within current_path do
        env_vars = fetch(:dotenv_vars, {})
        if env_vars.empty?
          info 'No custom dotenv variables'
        else
          env_vars.each do |key, value|
            execute :sed,
                    '-i -e', "s/#{key.upcase}=.*/#{key.upcase}=#{value}/",
                    ".env.#{fetch(:rails_env)}"
          end
        end
      end
    end
  end
end
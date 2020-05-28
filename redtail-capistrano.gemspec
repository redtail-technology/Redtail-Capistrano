lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "redtail-capistrano"
  gem.version       = '1.4.0'
  gem.authors       = ["Colin Rice"]
  gem.email         = ["colin.rice@redtailtechnology.com"]
  gem.description   = "Redtail specific Capistrano tasks"
  gem.summary       = "Redtail specific Capistrano tasks"
  gem.homepage      = "https://github.com/redtail-technology/redtail-capistrano"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'capistrano', '~> 3.x'
  gem.add_runtime_dependency 'capistrano3-unicorn'
end

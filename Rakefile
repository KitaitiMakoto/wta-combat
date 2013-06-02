desc 'Compile assets'
task :assets => %w[assets:stylesheets assets:scripts]

namespace :assets do
  desc 'Compile SCSS files to CSS'
  task :stylesheets do
    sh 'compass compile --sass-dir=stylesheets'
  end

  desc 'Compile CoffeeScript files to JavaScript'
  task :scripts do
    sh 'coffee --compile scripts'
  end
end

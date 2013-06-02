require 'yaml'
require 'pathname'
require 'set'
require 'net/ftp'

HTMLS = FileList['*.html']
STYLESHEETS = FileList['stylesheets/**/*.css']
SCRIPTS = FileList['scripts/**/*.js'] +
  %w[
    jquery/jquery.min.js
    underscore/underscore-min.js
    backbone/backbone-min.js
    mustache/mustache.js
  ].map {|file| File.join('components', file)}

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

desc 'Deploy'
task :deploy => :assets do
  files = (HTMLS + STYLESHEETS + SCRIPTS).map {|name| Pathname(name)}
  dirs = []
  files.each do |file|
    file.dirname.ascend do |dir|
      dirs << dir
    end
  end
  dirs.uniq!
  dirs.sort_by! {|dir| dir.to_path.split('/').length}
  hosts = YAML.load_file('hosts.yaml')
  hosts.each do |host|
    $stderr.puts "Logging in #{host['host']}..."
    Net::FTP.open host['host'], host['user'], host['password'] do |ftp|
      $stderr.puts 'Logged in'
      ftp.passive = true
      $stderr.puts "chdir #{host['dir']}"
      ftp.chdir host['dir']

      dirs.each do |dir|
        begin
          ftp.ls dir.to_path
        rescue => Net::FTPPermError
          $stderr.puts "mkdir #{dir}"
          ftp.mkdir dir.to_path
        end
      end

      files.each do |file|
        $stderr.puts "put #{file} -> #{file}"
        ftp.put file.to_path, file.to_path
      end
    end
  end
end

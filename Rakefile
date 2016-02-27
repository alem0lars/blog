require "yaml"
require "ostruct"
require "shellwords"

def load_data(name)
  OpenStruct.new(YAML.load_file("./data/#{name}.yml"))
end

def args
  $args.each { |a| task a.to_sym do ; end } # Hack to prevent errors.
  $args[1..-1].dup
end

def execute(command)
  puts("Executing command: #{command}")
  system(command)
end

def run_task(name, *args)
  $args = [name] + args.flatten.map { |a| a.split(" ") }.flatten
  Rake::Task[name].invoke()
end

$args   = ARGV
$site   = load_data(:site)
$target = $site.title.gsub(/\s+/, "-")

namespace :docker do

  desc "Perform build"
  task :build do
    execute("docker build -t #{$target} .")
  end

  desc "Execute a command"
  task :cmd do
    execute("docker run -it #{$target} #{args.join(" ")}")
  end

  desc "Open a shell"
  task :sh do
    run_task "docker:cmd", "/bin/bash"
  end

  desc "Run development server"
  task :serve do
    run_task "docker:cmd", "middleman serve"
  end

end
Rake::Task["assets:precompile"].clear
Rake::Task["assets:clean"].clear

namespace :assets do
  task "precompile" do
    puts "Not pre-compiling assets..."
  end

  task "clean" do
    puts "Not cleaning assets..."
  end
end

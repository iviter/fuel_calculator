task :test do
  puts "Running tests..."

  Dir.glob('tests/**/*_test.rb').each do |file|
    puts "Executing: #{file}"
    system("ruby #{file}")
  end
end

task default: :test

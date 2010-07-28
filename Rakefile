require "rake"
require "rake/testtask"
require "rake/gempackagetask"
require "rake/clean"

CLEAN << "pkg" << "doc" << "coverage" << ".yardoc"

Rake::GemPackageTask.new(eval(File.read("friendly_id_datamapper.gemspec"))) { |pkg| }
Rake::TestTask.new(:test) { |t| t.pattern = "test/*_test.rb" }

begin
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.options = ["--output-dir=docs"]
  end
rescue LoadError
end

begin
  require "rcov/rcovtask"
  Rcov::RcovTask.new do |r|
    r.test_files = FileList["test/**/*_test.rb"]
    r.verbose = true
    r.rcov_opts << "--exclude gems/*"
  end
rescue LoadError
end

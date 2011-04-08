require File.expand_path('../lib/friendly_id/datamapper_adapter/version', __FILE__)

spec = Gem::Specification.new do |s|
  s.name              = "friendly_id_datamapper"
  s.rubyforge_project = "[none]"
  s.version           = FriendlyId::DataMapperAdapter::Version::STRING
  s.authors           = ["Norman Clarke", "Alex Coles"]
  s.email             = ["norman@njclarke.com", "alex@alexbcoles.com"]
  s.homepage          = "http://github.com/myabc/friendly_id_datamapper"
  s.summary           = "A DataMapper adapter for FriendlyId"
  s.description       = "An adapter for using DataMapper::Resource with FriendlyId."
  s.test_files        = Dir.glob "test/**/*_test.rb"
  s.files             = Dir["lib/**/*.rb", "lib/**/*.rake", "*.md", "MIT-LICENSE", "Rakefile", "test/**/*.*"]
  s.add_dependency    "friendly_id",    "~> 3.1.0"
  s.add_dependency    'dm-core',        '~> 1.0.0'
  s.add_dependency    'dm-validations', '~> 1.0.0'
  s.add_dependency    'dm-transactions','~> 1.0.0'
end

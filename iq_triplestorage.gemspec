require File.expand_path("../lib/iq_triplestorage", __FILE__)

Gem::Specification.new do |s|
  s.name        = "iq_triplestorage"
  s.version     = IqTriplestorage::VERSION
  s.platform    = Gem::Platform::RUBY

  s.summary     = "IqTriplestorage - library for interacting with RDF triplestores / quadstores"
  s.homepage    = "http://github.com/innoq/iq_triplestorage"
  s.rubyforge_project = s.name
  s.authors     = ["FND"]

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end

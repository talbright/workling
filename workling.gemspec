# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{workling}
  s.version = "0.4.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rany Keddo"]
  s.date = %q{2009-02-25}
  s.description = %q{easily do background work in rails, without commiting to a particular runner. comes with starling, bj and spawn runners.}
  s.email = %q{nicolas@marchildon.net}
  s.files = ["CHANGES.markdown",
             "VERSION.yml",
             "README.markdown",
             "TODO.markdown",
             Dir.glob("lib/**/*.rb"),
             Dir.glob("script/*.rb")].flatten
  s.executables = ["workling_client"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/elecnix/workling}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{easily do background work in rails, without commiting to a particular runner. comes with starling, bj and spawn runners.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

# -*- encoding: utf-8 -*-
# stub: puma 3.6.0 ruby lib
# stub: ext/puma_http11/extconf.rb

Gem::Specification.new do |s|
  s.name = "puma".freeze
  s.version = "3.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Evan Phoenix".freeze]
  s.date = "2016-07-25"
  s.description = "Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications. Puma is intended for use in both development and production environments. In order to get the best throughput, it is highly recommended that you use a  Ruby implementation with real threads like Rubinius or JRuby.".freeze
  s.email = ["evan@phx.io".freeze]
  s.executables = ["puma".freeze, "pumactl".freeze]
  s.extensions = ["ext/puma_http11/extconf.rb".freeze]
  s.extra_rdoc_files = ["DEPLOYMENT.md".freeze, "History.txt".freeze, "Manifest.txt".freeze, "README.md".freeze, "docs/nginx.md".freeze, "docs/signals.md".freeze, "docs/systemd.md".freeze, "tools/jungle/README.md".freeze, "tools/jungle/init.d/README.md".freeze, "tools/jungle/upstart/README.md".freeze]
  s.files = ["DEPLOYMENT.md".freeze, "History.txt".freeze, "Manifest.txt".freeze, "README.md".freeze, "bin/puma".freeze, "bin/pumactl".freeze, "docs/nginx.md".freeze, "docs/signals.md".freeze, "docs/systemd.md".freeze, "ext/puma_http11/extconf.rb".freeze, "tools/jungle/README.md".freeze, "tools/jungle/init.d/README.md".freeze, "tools/jungle/upstart/README.md".freeze]
  s.homepage = "http://puma.io".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7".freeze)
  s.rubygems_version = "2.6.4".freeze
  s.summary = "Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications".freeze

  s.installed_by_version = "2.6.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<rack>.freeze, ["< 2.0", ">= 1.1"])
      s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 0.8"])
      s.add_development_dependency(%q<hoe>.freeze, ["~> 3.15"])
    else
      s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_dependency(%q<rack>.freeze, ["< 2.0", ">= 1.1"])
      s.add_dependency(%q<rake-compiler>.freeze, ["~> 0.8"])
      s.add_dependency(%q<hoe>.freeze, ["~> 3.15"])
    end
  else
    s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
    s.add_dependency(%q<rack>.freeze, ["< 2.0", ">= 1.1"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 0.8"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.15"])
  end
end

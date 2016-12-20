# -*- encoding: utf-8 -*-
# stub: stringex 2.6.1 ruby lib

Gem::Specification.new do |s|
  s.name = "stringex".freeze
  s.version = "2.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Russell Norris".freeze]
  s.date = "2016-07-14"
  s.description = "Some [hopefully] useful extensions to Ruby's String class. Stringex is made up of three libraries: ActsAsUrl [permalink solution with better character translation], Unidecoder [Unicode to ASCII transliteration], and StringExtensions [miscellaneous helper methods for the String class].".freeze
  s.email = "rsl@luckysneaks.com".freeze
  s.extra_rdoc_files = ["MIT-LICENSE".freeze, "README.rdoc".freeze]
  s.files = ["MIT-LICENSE".freeze, "README.rdoc".freeze]
  s.homepage = "http://github.com/rsl/stringex".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze, "--charset".freeze, "utf-8".freeze, "--line-numbers".freeze]
  s.rubygems_version = "2.6.4".freeze
  s.summary = "Some [hopefully] useful extensions to Ruby's String class".freeze

  s.installed_by_version = "2.6.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jeweler>.freeze, ["= 2.0.1"])
      s.add_development_dependency(%q<travis-lint>.freeze, ["= 1.7.0"])
      s.add_development_dependency(%q<RedCloth>.freeze, ["= 4.2.9"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["= 1.3.10"])
      s.add_development_dependency(%q<test-unit>.freeze, ["= 3.0.9"])
      s.add_development_dependency(%q<activerecord>.freeze, ["= 4.0.3"])
      s.add_development_dependency(%q<i18n>.freeze, ["= 0.6.9"])
    else
      s.add_dependency(%q<jeweler>.freeze, ["= 2.0.1"])
      s.add_dependency(%q<travis-lint>.freeze, ["= 1.7.0"])
      s.add_dependency(%q<RedCloth>.freeze, ["= 4.2.9"])
      s.add_dependency(%q<sqlite3>.freeze, ["= 1.3.10"])
      s.add_dependency(%q<test-unit>.freeze, ["= 3.0.9"])
      s.add_dependency(%q<activerecord>.freeze, ["= 4.0.3"])
      s.add_dependency(%q<i18n>.freeze, ["= 0.6.9"])
    end
  else
    s.add_dependency(%q<jeweler>.freeze, ["= 2.0.1"])
    s.add_dependency(%q<travis-lint>.freeze, ["= 1.7.0"])
    s.add_dependency(%q<RedCloth>.freeze, ["= 4.2.9"])
    s.add_dependency(%q<sqlite3>.freeze, ["= 1.3.10"])
    s.add_dependency(%q<test-unit>.freeze, ["= 3.0.9"])
    s.add_dependency(%q<activerecord>.freeze, ["= 4.0.3"])
    s.add_dependency(%q<i18n>.freeze, ["= 0.6.9"])
  end
end

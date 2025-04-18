# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)
require "customerio-rails/version"

Gem::Specification.new do |s|
  s.name = %q{customerio-rails}
  s.version = CustomerioRails::VERSION
  s.authors = ["Sylvain Utard"]
  s.description = %q{Drop-in ActionMailer adapter to send emails via Customer.io}
  s.homepage = %q{https://github.com/altertable-ai/customerio-rails}
  s.summary = %q{Customer.io adapter for ActionMailer}

  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.rdoc_options = ["--charset=UTF-8"]

  s.add_dependency('actionmailer', ">= 7.0.0")
  s.add_dependency('customerio', '>= 5.3.0')

  s.add_development_dependency("rake")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end

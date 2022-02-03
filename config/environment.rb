# Load the Rails application.
require_relative 'application'
# require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require Rails.root.join(Karafka.boot_file) if ENV['KARAFKA_ENV'].nil?
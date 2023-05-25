# frozen_string_literal: true

require 'simplecov'

SimpleCov.coverage_dir('plugins/gnosis/coverage')
SimpleCov.start do
  # add_filter do |source_file|
  #   source_file.lines.count < 5
  # end

  add_filter do |source_file|
    !source_file.filename.include?('gnosis')
  end
  
if Dir.pwd.match?(%r{plugins/gnosis})
    formatter SimpleCov::Formatter::SimpleFormatter
  else
    formatter SimpleCov::Formatter::MultiFormatter.new([
                                                         SimpleCov::Formatter::SimpleFormatter,
                                                         SimpleCov::Formatter::HTMLFormatter
                                                       ])
  end

  track_files 'app/**/*.rb'
end

SimpleCov.minimum_coverage 100

# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

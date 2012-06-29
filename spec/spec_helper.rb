require 'rubygems'
require 'bundler/setup'

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
$: << File.join(APP_ROOT, 'lib')

require 'ltx'

RSpec.configure do |config|
end

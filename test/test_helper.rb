require File.expand_path('lib/gdexpress.rb')
require 'sinatra/base'
require 'nokogiri'
require 'open-uri'
require 'pp'

require 'minitest/autorun'
require "minitest/reporters"
require 'webmock/minitest'

require 'fake_gd_express'


Minitest::Reporters.use!
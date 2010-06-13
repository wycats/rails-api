require "fileutils"
require "logger"

ENV["LOG"] = "1"

class StaticGenerator
  def initialize(location, dest = location)
    @session  = ActionDispatch::Integration::Session.new(Rails.application)
    @location = location
    @dest     = dest
    @logger   = Logger.new(STDOUT)
    @logger.level = ENV["LOG"] ? Logger::DEBUG : Logger::FATAL
    FileUtils.mkdir_p(Pathname.new(Rails.public_path).join(dest[1..-1]).dirname)
  end

  def generate
    location = @location.gsub(/#/, "---").gsub(/\[/, "%5B").gsub(/\]/, "%5D")
    dest     = @dest.gsub(/#/, "---").gsub(/\[/, "%5B").gsub(/\]/, "%5D")

    @logger.debug "Getting #{location}"

    @session.get(location, suffix: ".html")

    dest     = "#{Rails.public_path}#{dest}"

    File.open("#{dest}.html", "w") do |file|
      file.puts @session.response.body
    end
  end
end

task :generate => :environment do
  include MainHelper
  
  Dir["#{Rails.public_path}/{index.html,modules}"].each do |file|
    FileUtils.rm_rf(file)
  end

  klass               = RailsDocs::Namespace.new(YARD::Registry.at("ActionController::Base"))
  @class_methods      = klass.public_methods(:class)
  @instance_methods   = klass.public_methods(:instance)

  modules             = (@class_methods + @instance_methods).map do |m| 
    m.parent.path.gsub(/::ClassMethods$/, '')
  end.uniq!

  StaticGenerator.new("/", "/index").generate

  modules.each do |mod|
    StaticGenerator.new("/modules/#{mod}").generate
  end

  # (@class_methods + @instance_methods).each do |method|
  #   StaticGenerator.new("/modules/#{method.path}").generate
  # end

  # session = ActionDispatch::Integration::Session.new(Rails.application)
  # 
  # FileUtils.mkdir_p("#{Rails.public_path}/modules")
  # 
  # session.get("/", suffix: ".html")
  # 
  # File.open("#{Rails.public_path}/index.html", "w") do |file|
  #   file.puts session.response.body
  # end
  # 
  # (@class_methods + @instance_methods).each do |method|
  #   path = method.path.gsub(/#/, "---")
  #   session.get("/modules/#{Rack::Utils.escape(path)}", suffix: ".html")
  # 
  #   File.open("#{Rails.public_path}/modules/#{path}.html", "w") do |file|
  #     file.puts session.response.body
  #   end
  # end
end
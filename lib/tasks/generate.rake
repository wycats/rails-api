task :generate => :environment do
  klass               = RailsDocs::Namespace.new(YARD::Registry.at("ActionController::Base"))
  @class_methods      = klass.public_methods(:class)
  @instance_methods   = klass.public_methods(:instance)

  session = ActionDispatch::Integration::Session.new(Rails.application)

  FileUtils.mkdir_p("#{Rails.public_path}/modules")

  @class_methods.each do |method|
    session.get("/modules/#{method.path}")
    File.open("#{Rails.public_path}/modules/#{method.path}", "w") do |file|
      files.puts session.response.body
    end
  end
end
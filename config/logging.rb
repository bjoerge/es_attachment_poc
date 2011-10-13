Dir.mkdir('log') unless File.exist?('log')

environment = (ENV['RACK_ENV'] || "development").to_s.downcase

filename = "log/#{environment}.log"
logfile = File.new(filename, 'a+')
Log = Logger.new(filename)
Log.level = environment == "production" ? Logger::WARN : Logger::DEBUG
Log.datetime_format = "%Y-%m-%d %H:%M:%S.%L"

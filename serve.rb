require 'webrick'

server = WEBrick::HTTPServer.new(Port: 9099, DocumentRoot: File.expand_path('./storybook-static', __dir__))
trap 'INT' do
  server.shutdown
end
server.start

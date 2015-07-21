require 'webrick'
server = WEBrick::HTTPServer.new(:Port=>8080)
# miner game
server.mount_proc('/'){ |req, resp|
  if req.path == '/favicon.ico'
    resp.body = ERB.new(IO.read('favicon.ico')).result
  end
  if req.path == '/new'
    w = req.query["w"].to_i
    h = req.query["h"].to_i
    b = req.query["b"].to_i
    z = req.query["z"].to_i
  end
  if req.path == '/clicked'
    clicked_index = req.query["clicked_index"].to_i
    puts "clicked_index = #{clicked_index}"
  end
  resp['Content-Type'] = 'text/html'
  resp.body = ERB.new(IO.read('index.html.erb')).result(b)
}
server.start
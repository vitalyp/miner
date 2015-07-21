require 'webrick'
server = WEBrick::HTTPServer.new(:Port=>8080)

# preload network resources
main_css = IO.read('main.css')
ext_css = IO.read('ext.css')
favicon = IO.read('favicon.ico')

# define default game attributes
miner_game_w = 10
miner_game_h = 10
miner_game_b = 10
miner_game_z = 32

b_env = binding

server.mount_proc('/'){ |req, resp|
  case req.path
    when '/favicon.ico'
      resp['Content-Type'] = 'image/x-icon'
      resp.body = favicon
    when '/new'
      # new game action contains game-board parameters
      miner_game_w = req.query["w"].to_i
      miner_game_h = req.query["h"].to_i
      miner_game_b = req.query["b"].to_i
      miner_game_z = req.query["z"].to_i
      resp['Content-Type'] = 'text/html'
      resp.body = ERB.new(IO.read('index.html.erb')).result(b_env)
    when '/clicked'
      clicked_index = req.query["clicked_index"].to_i
      puts "clicked_index = #{clicked_index}"
    else
      resp['Content-Type'] = 'text/html'
      resp.body = ERB.new(IO.read('index.html.erb')).result(b_env)
  end
}
server.start
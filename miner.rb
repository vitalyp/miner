require 'webrick'
require './game_processor'
server = WEBrick::HTTPServer.new(:Port=>8080)
g_processor = GameProcessor.new

DEFAULT_HEIGHT = 10
DEFAULT_WIDTH = 10
DEFAULT_BOMBS = 10
DEFAULT_ZOOM = 32

# preload network resources
main_css = IO.read('main.css')
ext_css = IO.read('ext.css')
favicon = IO.read('favicon.ico')

# define default game attributes
miner_game_h = DEFAULT_HEIGHT
miner_game_w = DEFAULT_WIDTH
miner_game_b = DEFAULT_BOMBS
miner_game_z = DEFAULT_ZOOM

# deprecated?
new_game_path = Proc.new do |h,w,b,z|
  h ||= DEFAULT_HEIGHT
  w ||= DEFAULT_WIDTH
  b ||= DEFAULT_BOMBS
  z ||= DEFAULT_ZOOM
  '/new?h='+h+'&w='+w+'&b='+b+'&z='+z
end
b_env = binding

server.mount_proc('/'){ |req, resp|
  case req.path
    when '/favicon.ico'
      resp['Content-Type'] = 'image/x-icon'
      resp.body = favicon
    when '/new'
      # new game action contains game-board parameters
      miner_game_h = (req.query["h"] || DEFAULT_HEIGHT).to_i
      miner_game_w = (req.query["w"] || DEFAULT_WIDTH).to_i
      miner_game_b = (req.query["b"] || DEFAULT_BOMBS).to_i
      miner_game_z = (req.query["z"] || DEFAULT_ZOOM).to_i
      g_processor.init_game(miner_game_h, miner_game_w, miner_game_b)

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
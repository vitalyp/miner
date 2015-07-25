# Miner implementation # Game server
require 'webrick'
require 'securerandom'
require './game_processor'
game_server = WEBrick::HTTPServer.new(Port: 8080)

# preload network resources
main_css = IO.read('main.css')
ext_css = IO.read('ext.css')
favicon = IO.read('favicon.ico')
#session_key = nil
#game = nil
#b_env = binding

def get_or_create_session_key(req, resp)
  session_cookie = req.cookies.find{ |i| i.name == 'session_key'}
  return session_cookie.value if session_cookie
  cookie = WEBrick::Cookie.new('session_key', SecureRandom.hex)
  resp.cookies.push(cookie)
  cookie.value
end

game_server.mount_proc('/'){ |req, resp|
  session_key = get_or_create_session_key(req, resp)
  game = MinerGameContainer.find_or_create_by_sess_key(session_key)
      
  case req.path
    when '/favicon.ico'
      resp['Content-Type'] = 'image/x-icon'
      resp.body = favicon
    when '/new'
      # new game action contains game-board parameters
      miner_game_h = (req.query["h"] || MinerGameConfig::DEFAULTS[:map_rows]).to_i
      miner_game_w = (req.query["w"] || MinerGameConfig::DEFAULTS[:map_cols]).to_i
      miner_game_b = (req.query["b"] || MinerGameConfig::DEFAULTS[:map_bombs]).to_i
      miner_game_z = (req.query["z"] || MinerGameConfig::DEFAULTS[:map_cell_px]).to_i
      game.init_game(miner_game_h, miner_game_w, miner_game_b, miner_game_z)
      resp.set_redirect WEBrick::HTTPStatus::TemporaryRedirect, '/'
    when '/clicked'
      clicked_index = req.query["clicked_index"].to_i
      game.click_to(clicked_index)
      puts "clicked_index = #{clicked_index}"
      resp.set_redirect WEBrick::HTTPStatus::TemporaryRedirect, '/'
    else
      resp['Content-Type'] = 'text/html'
      b = binding
      b.local_variable_set(:game, game)
      b.local_variable_set(:session_key, session_key)
      b.local_variable_set(:miner_game_h, game.rows || MinerGameConfig::DEFAULTS[:map_rows])
      b.local_variable_set(:miner_game_w, game.cols || MinerGameConfig::DEFAULTS[:map_cols])
      b.local_variable_set(:miner_game_b, game.bombs || MinerGameConfig::DEFAULTS[:map_bombs])
      b.local_variable_set(:miner_game_z, game.zoom || MinerGameConfig::DEFAULTS[:map_cell_px])

      resp.body = ERB.new(IO.read('index.html.erb')).result(b)
  end
}
game_server.start
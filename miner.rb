require 'webrick'
require 'securerandom'
require './webrick_session'
require './game_processor'
require './miner_game_container'
include WebrickSession

game_server = WEBrick::HTTPServer.new(Port: 8080)

# preload network resources
main_css = IO.read('view/main.css')
ext_css = IO.read('view/ext.css')
favicon = IO.read('view/favicon.ico')

game_server.mount_proc('/'){ |req, resp|
  session_key = get_or_create_session_key(req, resp)
  game = MinerGameContainer.find_or_create_by_sess_key(session_key)
  case req.path
    when '/favicon.ico'
      resp['Content-Type'] = 'image/x-icon'
      resp.body = favicon
    when '/new'
      game.init_game(req.query['h'].to_i, req.query['w'].to_i, req.query['b'].to_i, req.query['z'].to_i) rescue
          MinerGameContainer.delete_by_sess_key(session_key)
      resp.set_redirect WEBrick::HTTPStatus::TemporaryRedirect, '/'
    when '/clicked'
      clicked_index = req.query["clicked_index"].to_i
      game.click_to(clicked_index)
      resp.set_redirect WEBrick::HTTPStatus::TemporaryRedirect, '/'
    else
      b = binding
      b.local_variable_set(:game, game)
      b.local_variable_set(:session_key, session_key)
      b.local_variable_set(:miner_game_h, game.rows || MinerGameConfig::DEFAULTS[:map_rows])
      b.local_variable_set(:miner_game_w, game.cols || MinerGameConfig::DEFAULTS[:map_cols])
      b.local_variable_set(:miner_game_b, game.bombs || MinerGameConfig::DEFAULTS[:map_bombs])
      b.local_variable_set(:miner_game_z, game.zoom || MinerGameConfig::DEFAULTS[:map_cell_px])
      resp['Content-Type'] = 'text/html'
      resp.body = ERB.new(IO.read('view/index.html.erb')).result(b)
  end
}
game_server.start
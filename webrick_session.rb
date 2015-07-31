# Extend module
# Provides Session cookies
module WebrickSession
  def get_or_create_session_key(req, resp)
    session_cookie = req.cookies.find{ |i| i.name == 'session_key'}
    return session_cookie.value if session_cookie
    cookie = WEBrick::Cookie.new('session_key', SecureRandom.hex)
    resp.cookies.push(cookie)
    cookie.value
  end
end

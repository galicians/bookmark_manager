require 'sinatra/base'

class BookMarker < Sinatra::Base
  get '/' do
    'Hello BookMarker!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

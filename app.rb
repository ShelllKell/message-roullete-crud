require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")

    erb :home, locals: {messages: messages}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/edit/:message" do
    message_id = params[:message]
    message_id[0] = ""
    message_array = @database_connection.sql("SELECT message FROM messages where id = #{message_id}")
    message = message_array[0]["message"]
    erb :edit_message, :locals => {:message => message}
  end


  patch "/messages/:id" do

    redirect "/messages"
  end


  get "/messages/:id" do

  end


  delete "/messages/:id" do
    message_id = params[:message]["id"]
    @database_connection.sql("DELETE * FROM messages where message = #{message_id}")
    redirect "/"
  end



end
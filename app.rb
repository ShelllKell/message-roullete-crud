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
    comments = @database_connection.sql("SELECT * FROM comments")
    p comments
    p messages
    erb :home, :locals => {:messages => messages, :comments => comments}
  end

  get "/messages/:id/edit" do
    message = @database_connection.sql("SELECT * FROM messages WHERE id = #{params[:id]}").first

    erb :edit, :locals => {:message => message}
  end

  get "/messages/:id/comments/new" do
    message = @database_connection.sql("SELECT * FROM messages WHERE id = #{params[:id]}").first
    erb :comment, :locals => {:message => message}
  end

  get "/messages/:id" do
    message = @database_connection.sql("SELECT * ")
    erb :home
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


  post "/messages/:id/comments" do
    @database_connection.sql("INSERT INTO comments (comment, message_id) VALUES ('#{params[:comment]}', #{params[:id]})")
    redirect "/"
  end


  patch "/messages/:id" do
    messages = params[:message]
    if messages.length <= 140
      @database_connection.sql("UPDATE messages SET message = '#{params[:message]}' WHERE id = #{params[:id]}")
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect back
    end
    redirect "/"
  end

  delete "/messages/:id" do
     @database_connection.sql("DELETE FROM messages where id = #{params[:id]}")
    redirect "/"
  end


end
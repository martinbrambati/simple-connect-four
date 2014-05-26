require 'sinatra'
enable :sessions
set :server, 'thin'
connections = []

get '/users/:id' do
  halt erb(:login) unless params[:id]
  erb :chat, :locals => { :user => params[:id].gsub(/\W/, '') }
end

get '/stream', :provides => 'text/event-stream' do
  stream :keep_open do |out|
    connections << out
    out.callback { connections.delete(out) }
  end
end

post '/' do
  session[:matrix] = Hash.new if !session[:matrix]
  user, move = params[:msg].gsub(/\s+/, "").split(/:/)

  session[:has_move] = user if !session[:has_move]
  #App rules
  if (!session[:matrix].has_key? move && session[:has_move]!=user) #One at a time
    #Save play
    session[:matrix][move]=user 
    session[:has_move]=user

    #Winner found?, checks 3 up or 3 down
    message = params[:msg]
    c = move[1]
    r = move[0]
    mapa = (0...4).map{|i| true if session[:matrix][i.to_s+c.to_s]==user }
    message = "#{user}: winner" if mapa.compact.size==4

    connections.each { |out| out << "data: #{message}\n\n" }
  end



  #End app validation
  
  204 # response without entity body
end

__END__

@@ layout
<html>
  <head>
    <title>Super Simple game Connect Four</title>
    <meta charset="utf-8" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
  </head>
  <body><%= yield %></body>
</html>

@@ login
<form action='/'>
  <label for='user'>User Name:</label>
  <input name='user' value='' />
  <input type='submit' value="GO!" />
</form>

@@ chat
<style>
  /*
  Simple Grid
  Learn More - http://dallasbass.com/simple-grid-a-lightweight-responsive-css-grid/
  Project Page - http://thisisdallas.github.com/Simple-Grid/
  Author - Dallas Bass
  Site - dallasbass.com
*/

*, *:after, *:before {
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

body {
  margin: 0px;
}

[class*='col-'] {
  float: left;
  padding-right: 20px;
}

[class*='col-']:last-of-type {
  padding-right: 0px;
}

.grid {
  width: 100%;
  max-width: 1140px;
  min-width: 755px;
  margin: 0 auto;
  overflow: hidden;
}

.grid:after {
  content: "";
  display: table;
  clear: both;
}

.grid-pad {
  padding: 20px 0 0px 20px;
}

.grid-pad > [class*='col-']:last-of-type {
  padding-right: 20px;
}

.push-right {
  float: right;
}

/* Content Columns */

.col-1-1 {
  width: 100%;
}
.col-2-3, .col-8-12 {
  width: 66.66%;
}

.col-1-2, .col-6-12 {
  width: 50%;
}

.col-1-3, .col-4-12 {
  width: 33.33%;
}

.col-1-4, .col-3-12 {
  width: 25%;
  border: 1px solid gray;
}

.col-1-5 {
  width: 20%;
}

.col-1-6, .col-2-12 {
  width: 16.667%;
}

.col-1-7 {
  width: 14.28%;
}

.col-1-8 {
  width: 12.5%;
}

.col-1-9 {
  width: 11.1%;
}

.col-1-10 {
  width: 10%;
}

.col-1-11 {
  width: 9.09%;
}

.col-1-12 {
  width: 8.33%
}

/* Layout Columns */

.col-11-12 {
  width: 91.66%
}

.col-10-12 {
  width: 83.333%;
}

.col-9-12 {
  width: 75%;
}

.col-5-12 {
  width: 41.66%;
}

.col-7-12 {
  width: 58.33%
}

@media handheld, only screen and (max-width: 767px) {

  
  .grid {
    width: 100%;
    min-width: 0;
    margin-left: 0px;
    margin-right: 0px;
    padding-left: 0px;
    padding-right: 0px;
  }
  
  [class*='col-'] {
    width: auto;
    float: none;
    margin-left: 0px;
    margin-right: 0px;
    margin-top: 10px;
    margin-bottom: 10px;
    padding-left: 20px;
    padding-right: 20px;
  }
}
</style>
<div class="grid grid-pad">
        <div class="col-1-4" id="00">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="01">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="02">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="03">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
      </div>

      <div class="grid grid-pad">
        <div class="col-1-4" id="10">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="11">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="12">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="13">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
      </div>

      <div class="grid grid-pad">
        <div class="col-1-4" id="20">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="21">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="22">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="23">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
      </div>

      <div class="grid grid-pad">
        <div class="col-1-4" id="30">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="31">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="32">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
        <div class="col-1-4" id="33">
          <div class="content">
            <h3>

            </h3>
          </div>
        </div>
      </div>
<pre id='chat'>  
</pre>

<script>
  // reading
  var es = new EventSource('/stream');
  var userColor = ["red","green"]
  es.onmessage = function(e) { 
    $('#chat').append(e.data + "\n");
    
    if(e.data.indexOf("winner")>0){
      alert(e.data.split(":")[0].trim()+" wins!");
    }

    $('#'+e.data.split(":")[1].trim()).css('background',userColor[parseInt(e.data.split(":")[0].trim())-1]);
  };

  // writing
  $(document).ready(function(){
    $(".col-1-4").each(function(){
      $(this).on('click',function(e) {
        $.post('/', {msg: "<%= user %>: " + $(this).attr("id")});
        $('#msg').val(''); $('#msg').focus();
        //e.preventDefault();
      });
    });
  });
</script>
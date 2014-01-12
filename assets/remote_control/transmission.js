$(function() {
  var conn;
  var title        = 'Remote control - ';
  var msg          = $("#msg");
  var log          = $("#log");
  var ws_server    = $("body").data('ip');
  var modes        = ['prez', 'window', 'tab'];
  var current_mode;

  if (window["WebSocket"]) {
    conn = new WebSocket("ws://" + ws_server + ":8080/ws");
  } else {
    appendLog($("<div><b>Your browser does not support WebSockets.</b></div>"))
  }

  conn.onopen = function(){
    set_current_mode();
  }

  function set_current_mode(mode_id){
    mode_id = typeof mode_id !== 'undefined' ? mode_id : 0;

    current_mode = modes[mode_id];
    document.title = title + current_mode;
    conn.send(current_mode);
  }

  function next_mode(){
    current_mode_index = modes.indexOf(current_mode);
    if (current_mode_index + 1 < modes.length)
      set_current_mode(current_mode_index + 1)
    else
      set_current_mode(0)
  }

  $(".btn").click(function(evt) {
    conn.send($(this).data('command'));
  });

  $("#btn-select").click(function(evt){
    next_mode();
  });
});
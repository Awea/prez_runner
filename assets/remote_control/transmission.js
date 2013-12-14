$(function() {
  var conn;
  var msg       = $("#msg");
  var log       = $("#log");
  var ws_server = $("body").data('ip');

  function appendLog(msg) {
    var d = log[0]
    var doScroll = d.scrollTop == d.scrollHeight - d.clientHeight;
    msg.appendTo(log)
    if (doScroll) {
      d.scrollTop = d.scrollHeight - d.clientHeight;
    }
  }

  $(".controls div").click(function(evt) {
    evt.preventDefault();
    conn.send($(this).data('command'));
  });

  if (window["WebSocket"]) {
    conn = new WebSocket("ws://" + ws_server + ":8080/ws");
    conn.onclose = function(evt) {
      appendLog($("<div><b>Connection closed.</b></div>"))
    }
    conn.onmessage = function(evt) {
      appendLog($("<div/>").text(evt.data))
    }
  } else {
    appendLog($("<div><b>Your browser does not support WebSockets.</b></div>"))
  }
});
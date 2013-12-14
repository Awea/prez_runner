$(function() {
  var ws_server = $("body").data('ip');
  
  if (window["WebSocket"]) {
    conn = new WebSocket("ws://" + ws_server + ":8080/ws");
    conn.onmessage = function(evt) {
      console.log(evt);
      switch(evt.data){
        case 'left':
          Reveal.left();
          break;
        case 'right':
          Reveal.right();
          break;
        case 'up':
          Reveal.up();
          break;
        case 'down':
          Reveal.down();
          break;
        default:
          break;
    }
  }
} else {
  console.log("Your browser does not support WebSockets.")
}
});
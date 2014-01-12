$(function() {
  var ws_server = $("body").data('ip');
  var current_mode = 'prez';

  var is_prez_mode = function(){
    console.log(current_mode);
    return current_mode == 'prez';
  }
  
  if (window["WebSocket"]) {
    conn = new WebSocket("ws://" + ws_server + ":8080/ws");
    conn.onmessage = function(evt) {
      console.log(evt);
      switch(evt.data){
        case 'prez':
          current_mode = 'prez';
          break;
        case 'window':
          current_mode = 'window';
          break;
        case 'tab':
          current_mode = 'tab';
          break;
        case 'left':
          if (is_prez_mode())
            Reveal.left();
          break;
        case 'right':
          if (is_prez_mode())
            Reveal.right();
          break;
        case 'up':
          if (is_prez_mode())
            Reveal.up();
          break;
        case 'down':
          if (is_prez_mode())
            Reveal.down();
          break;
        default:
          console.log(evt.data);
          break;
    }
  }
} else {
  console.log("Your browser does not support WebSockets.")
}
});
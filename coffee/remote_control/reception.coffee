ws_server = $("body").data("ip")
current_mode = "prez"
is_prez_mode = ->
  console.log current_mode
  current_mode is "prez"

if window["WebSocket"]
  conn = new WebSocket("ws://" + ws_server + ":8080/ws")
  conn.onmessage = (evt) ->
    console.log evt
    switch evt.data
      when "prez"
        current_mode = "prez"
      when "window"
        current_mode = "window"
      when "tab"
        current_mode = "tab"
      when "left"
        Reveal.left()  if is_prez_mode()
      when "right"
        Reveal.right()  if is_prez_mode()
      when "up"
        Reveal.up()  if is_prez_mode()
      when "down"
        Reveal.down()  if is_prez_mode()
      else
        console.log evt.data
else
  console.log "Your browser does not support WebSockets."
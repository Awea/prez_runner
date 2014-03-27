require.config
  paths:
    jquery: "../components/jquery/jquery"

require ["jquery"], ($) ->

  conn = undefined
  title = "Remote control - "
  msg = $("#msg")
  log = $("#log")
  ws_server = $("body").data("ip")
  modes = ["prez", "window", "tab"]
  current_mode = undefined

  set_current_mode = (mode_id) ->
    mode_id = (if typeof mode_id isnt "undefined" then mode_id else 0)
    current_mode = modes[mode_id]
    document.title = title + current_mode
    conn.send current_mode

  next_mode = ->
    current_mode_index = modes.indexOf(current_mode)
    console.log current_mode
    if current_mode_index + 1 < modes.length
      set_current_mode current_mode_index + 1
    else
      set_current_mode 0

  if window["WebSocket"]
    conn = new WebSocket("ws://#{ws_server}:8080/ws")
  else
    alert 'websocket not supported'

  conn.onopen = ->
    set_current_mode()

  #conn.onmessage = (evt) ->
  #  console.log evt

  $(".btn").click (evt) ->
    conn.send $(this).data("command")

  $("#btn-select").click (evt) ->
    next_mode()
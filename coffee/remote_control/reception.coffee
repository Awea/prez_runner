ws_server = $("body").data("ip")
current_mode = "prez"
scroll_x = 0
scroll_y = 0

is_prez_mode = ->
  current_mode is "prez"

is_window_mode = ->
  current_mode is "window"

scroll = ({x, y}) ->
  if is_window_mode()
    x ?= 0
    y ?= 0
    scroll_x =+ x
    scroll_y =+ y
    console.log "#{scroll_x} #{scroll_y}"
    window.scrollBy(x, y)

reset_scroll = ->
  if scroll_x > 0 && scroll_y > 0
    window.scrollBy(scroll_x * -1, scroll_y * -1)
    scroll_x = 0
    scroll_y = 0

if window["WebSocket"]
  conn = new WebSocket("ws://" + ws_server + ":8080/ws")
  conn.onmessage = (evt) ->
    console.log evt
    switch evt.data
      when "prez"
        current_mode = "prez"
        reset_scroll()
      when "window"
        current_mode = "window"
      when "tab"
        current_mode = "tab"
      when "left"
        Reveal.left()  if is_prez_mode()
        scroll(x: -100) 
      when "right"
        Reveal.right()  if is_prez_mode()
        scroll(x: 100) 
      when "up"
        Reveal.up()  if is_prez_mode()
        scroll(y: -100) 
      when "down"
        Reveal.down()  if is_prez_mode()
        scroll(y: 100)
      when "B"
        if is_window_mode()
          Reveal.configure controls: true
          document.body.style.zoom=1.0 
      when "A"
        if is_window_mode()
          Reveal.configure controls: false 
          document.body.style.zoom=2.0 
      else
        console.log evt.data

else
  console.log "Your browser does not support WebSockets."

Reveal.addEventListener "slidechanged", (event) ->
  slideElement = event.currentSlide
  console.log slideElement
  notes = slideElement.querySelector("aside.notes")

  unless notes.classList.contains "already-opened"
    notes.classList.add("already-opened")
    slideData = link: [
      href: notes.dataset.urlopen
    ]

    conn.send JSON.stringify(slideData)
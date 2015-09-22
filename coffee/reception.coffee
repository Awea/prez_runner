ip_server = document.getElementsByTagName('body')[0].getAttribute('data-ip')

client = new Faye.Client("http://#{ip_server}:8080/faye")
client.disable('autodisconnect')

client.subscribe '/remote', (message) ->
  switch message.cmd
    when "left"
      Reveal.left()
    when "right"
      Reveal.right()
    when "up"
      Reveal.up()
    when "down"
      Reveal.down()
    else
      console.log message
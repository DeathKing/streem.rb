# channel to broadcast to all clients
broadcast = chan()
tcp_server(8008) | {|s|
  broadcast | s   # connect to broadcast channel
  s | broadcast   # broadcast incoming message
}

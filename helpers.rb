def setup_server(ip_address, port)
  $global_server_ip = ip_address
  $global_server_port = port
  server = UDPSocket.new
  server.bind($global_server_ip, $global_server_port)
  puts "Server started, cannot speak until spoken to..."
  return server
end

def display_sender_details(sender_info)
  sender_ip = sender_info[2]
  dynamic_port = sender_info[1]
  family_address = sender_info[0]

  sender_details = <<~DETAILS

    SENDER INFORMATION:
    -------------------
    IP address: #{sender_ip}
    Dynamic port: #{dynamic_port}
    Family address: #{family_address}

  DETAILS

  puts sender_details
end

def process_sender_info(sender_info)
  sender_ip = sender_info[2]

  # Print sender information and reset the client IP if it's a new sender
  if $global_client_ip != sender_ip
    $global_client_ip = sender_ip
    display_sender_details(sender_info)
  end
end
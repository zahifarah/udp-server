require 'socket'

$connection = 0
$client_ip = nil

def print_sender_info(sender_addrinfo)
  sender_ip = sender_addrinfo[2]
  dynamic_port = sender_addrinfo[1]
  family_address = sender_addrinfo[0]

  puts
  puts "SENDER INFORMATION:"
  puts "-------------------"
  puts "IP address: #{sender_ip}"
  puts "Dynamic port: #{dynamic_port}"
  puts "Family address: #{family_address}"
  puts
end

def sender_info(sender_addrinfo)
  sender_ip = sender_addrinfo[2]

  # Print sender information and reset the client IP if it's a new sender
  if $client_ip != sender_ip
    $client_ip = sender_ip
    print_sender_info(sender_addrinfo)
  end

  $connection += 1
end

SERVER_IP = "192.168.1.6"
SERVER_PORT = 5500

server = UDPSocket.new
server.bind(SERVER_IP, SERVER_PORT)

client_ip = nil
client_port = nil

threads = []

# This thread will handle receiving messages
threads << Thread.new do
  loop do
    text, sender_addrinfo = server.recvfrom(1024)

    sender_info(sender_addrinfo)

    puts "#{Time.now.strftime("%T")}: #{text}"
    puts

    client_ip = sender_addrinfo[3]
    client_port = sender_addrinfo[1]
  end
end

# This thread will handle sending messages
threads << Thread.new do
  loop do
    message_to_send = gets.chomp
    server.send(message_to_send + "\n", 0, client_ip, client_port) if client_ip && client_port && !message_to_send.empty?
  end
end

# Keep the main thread alive while the child threads do the work
threads.each(&:join)

require 'socket'
require_relative "helpers"

$global_server_ip = nil
$global_server_port = nil
$global_client_ip = nil

server = setup_server("192.168.1.35", 5500)

client_ip = nil
client_port = nil

threads = []

# This thread will handle receiving messages
threads << Thread.new do
  loop do
    text, sender_info = server.recvfrom(1024)
    process_sender_info(sender_info)

    puts "#{Time.now.strftime("%T")}: #{text}"
    puts

    client_ip = sender_info[3]
    client_port = sender_info[1]
  end
end

# This thread will handle sending messages
threads << Thread.new do
  loop do
    message_to_send = gets.chomp
    if client_ip && client_port && !message_to_send.empty?
      server.send(message_to_send + "\n", 0, client_ip, client_port)
    end
  end
end

# Keep the main thread alive while the child threads do the work
threads.each(&:join)

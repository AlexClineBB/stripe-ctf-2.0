for x in 0..99 do
  if(x % 5 == 0 && x % 3 == 0)
    puts "fizzbuzz"
  elsif (x % 5 == 0)
    puts "fizzbuzz"
  elsif (x % 3 == 0)
    puts "buzz"
  else
    puts x
  end
end
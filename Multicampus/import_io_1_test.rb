body = {
  "extractors":[
    {
      "tags":{
        "Source": "Amazon",
        "Action": "TestLogin"
      },
      "credentials":{
        "username": "david.mejia@negotiatus.com",
        "password": "Negotiatus!"
      }
    }
  ]
}

##################################################
##################BODY IS ABOVE###################
##################################################

# ( vvvv please ignore this shit code vvvv)

API_KEY = "bf43f9e61e764b758ba49ac0da6601e49134f54e4d2d7f9daea666a40fe5b5eedff551e9e4c9ef9c812e6840093c221b7ec6ab19b3eeb147b5b2db27f3b2802fd56ae5f0c26d247a5e27f7b06e9daf74"

require 'httparty'
require 'pry'
require 'awesome_print'

puts "Starting Import.io test!\n".blue

response = HTTParty.post(
  "https://run.import.io/crawl/start",
  timeout: 10,
  body: body.to_json,
  headers: {
    Authorization: API_KEY,
    "Content-Type" => "application/json"
  }
)

unless response.code == 200
  puts "Non-200 response code!"
  return
end

puts "ORIGINAL REQUEST--------------------".blue
ap body, index: false

puts "\n\n"

crawl_run_id      = JSON.parse(response.body)["results"].first["crawlRunId"]
state             = nil
original_response = nil

puts "Crawl run: #{crawl_run_id}\n".green
print "Waiting"

while true
  sleep 2

  response = HTTParty.get(
    "https://store.import.io/store/crawlrun/#{crawl_run_id}",
    timeout: 10,
    headers: {
      Authorization: API_KEY
    }
  )

  body  = JSON.parse(response.body)
  state = body["state"]
  unless state == "STARTED"
    original_response = response

    break
  end

  print "."

  sleep 3
end

%x(say "Import test completed.")

unless state == "FINISHED"
  puts "ERROR!\nAttempting result print:".red

  begin
    ap JSON.parse(original_response.body), index: false
  rescue
    puts "Couldn't.".red
  end

  return
end

response = HTTParty.get(
  "https://store.import.io/store/crawlrun/#{crawl_run_id}/_attachment/json",
  timeout: 10,
  headers: {
    Authorization: API_KEY
  }
)

puts "\n\nBODY BELOW--------------------".blue
ap JSON.parse(response.body), index: false
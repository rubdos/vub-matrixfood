#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "pp"
require "time"
require "cgi"

require "json"
require "matrix_sdk"

VUB_RESTO_URL = URI("https://call-cc.be/files/vub-resto/etterbeek.en.json")

TUSSENFIX = "<br />"

def get_JSON()
  res = nil
  uri = URI(VUB_RESTO_URL)

  Net::HTTP.start(uri.host, uri.port,
                  :use_ssl => uri.scheme == "https") do |http|
    request = Net::HTTP::Get.new uri.request_uri

    res = http.request request
    return res.body
  end
end

def postit(data, location)
  client = MatrixSdk::Client.new ENV["HOST"]
  client.login ENV["USERNAME"], ENV["PASSWORD"]

  channel = client.find_room ENV["CHANNEL"]

  vandaag = Date.today
  dagstr = vandaag.strftime("%F")
  parsed_data = JSON.parse(data)

  parsed_data.each do |node|
    next unless node["date"] == dagstr
    lines = []

    items = node["menus"]
    until items.empty?
      dish = items.shift

      line = "<em>#{dish["name"]}</em>: #{dish["dish"]}\n"
      lines.push(line)
    end

    channel.send_html lines.join(TUSSENFIX)
    return
  end
end

if ENV["VUBFOOD_LOCATION"].nil?
  warn "location not set, assume etterbeek"
  location = :etterbeek
elsif ENV["VUBFOOD_LOCATION"].downcase == "etterbeek"
  location = :etterbeek
elsif ENV["VUBFOOD_LOCATION"].downcase == "jette"
  location = :jette
end

postit(get_JSON(), location)

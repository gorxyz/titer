#!/bin/lua
local argparse = require('argparse')
local http = require("socket.http")
local ltn12 = require("ltn12")

local titernik = [[
                `         '
;,,,             `       '             ,,,;
`YES8888bo.       :     :       .od8888YES'
  888IO8DO88b.     :   :     .d8888I8DO88
  8LOVEY'  `Y8b.   `   '   .d8Y'  `YLOVE8
 jTHEE!  .db.  Yb. '   ' .dY  .db.  8THEE!
   `888  Y88Y    `b ( ) d'    Y88Y  888'
    8MYb  '"        ,',        "'  dMY8
   j8prECIOUSgf"'   ':'   `"?g8prECIOUSk
     'Y'   .8'     d' 'b     '8.   'Y'
      !   .8' db  d'; ;`b  db '8.   !
         d88  `'  8 ; ; 8  `'  88b
        d88Ib   .g8 ',' 8g.   dI88b
       :888LOVE88Y'     'Y88LOVE888:
       '! THEE888'       `888THEE !'
          '8Y  `Y         Y'  Y8'
           Y                   Y
           !                   !
  https://github.com/sudurraaa/titernik
]]

local instagram_url = "https://www.instagram.com/accounts/login/"
local instagram_url_login = "https://www.instagram.com/accounts/login/ajax/"

local request_payload = [[queryParams={}&optIntoOneTap=false]]

local request_headers = {
	-- TODO add fake_agent() functin to generate random fake_agent
     ["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36",
     ["X-Requested-With"] = "XMLHttpRequest",
     ["Referer"] = instagram_url
}


local function attack(victim, wordlist, tor)
	print(victim .. wordlist .. tor)
	--local request_payload = [[phone=]] .. password
	--local request_response = {}
	--local request = http.request {
	--	url = 'https://my.telegram.org/auth/send_password',
	--	method = "POST",
	--	source = ltn12.source.string(request_payload),
	--	sink = ltn12.sink.table(request_response)
	--}
	--request_response = table.concat(request_response)
	---- print(login_response)
end

local function main() 
	local parser = argparse() {
		name = "titernik",
		description = titernik,
		epilog = "Usage: titernik -t blackarch -w wordlist.txt -p disable"
	}
	parser:option('-t --target', "Specify target instagram username")
	parser:option('-w --wordlist', "Specify wordlist file path")
	parser:option('-p --proxy', "Enable or Disable tor service")
		:choices {"enable", "disable"}
	parser:flag('-v --version', "Get current version of soft"):action(function()
		print("titernik v1.0.0")
		os.exit(0)
	end)
	parser:flag('-a --ascii', 'Print titernik ascii'):action(function()
		print(titernik)
		os.exit(0)
	end)
	local args = parser:parse()
	--attack(args.target, args.wordlist, args.proxy)	
end
main()

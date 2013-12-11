require 'ffi-rzmg'
require 'json'

class MatchListener
	def initialize
		@context = ZMQ::Context.new 1
		@inbound = @context.socket ZMQ::PULL
		@inbound.connect "ipc:///tmp/matchinsertion"
		@pull_thred = Thread.new do
			while true
				msg = ""
				@inbound.recv_string msg
				m = JSON.parse msg
				if m["type"] == "MATCH_INSERT"
#					Match.InsertMatch m["message"]
					puts "RECEIVED MATCH : " + msg
				end
			end
		end
	end
end

m = MatchListener.new

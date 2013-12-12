require 'rubygems'
require 'ffi-rzmq'
require 'json'
require 'logger'

logfile = File.open "/home/johannes/lanistatsit/log/matchinsertion.log", mode="a"
logfile.sync = true
log = Logger.new logfile
log.info "Starting match listener."

class MatchListener
	attr_accessor :pull_thread
	def initialize log
		@context = ZMQ::Context.new 1
		@inbound = @context.socket ZMQ::REP
		rc = @inbound.connect "ipc:///tmp/matchinsertion"
#		@poller = ZMQ::Poller.new
#		@poller.register_readable @inbound
		@pull_thread = Thread.new {
			while (ZMQ::Util.resultcode_ok? rc)
				begin
					msg = ""
					rc = @inbound.recv_string msg
					log.info "Received message"
					puts "Received message" + msg
					m = JSON.parse msg
					if m["type"] == "MATCH_INSERT"
						Match.InsertMatch m["message"], log
						@inbound.send_string "OK"
					else
						@inbound.send_string "NOT OK"
					end

				rescue 
					log.info "ERROR RAISED IN MATCH LISTENER"
					retry
				end
			end
			log.info "Exiting."
		}
	end
end

m = MatchListener.new log

require 'require_all'
require 'active_record'
require 'rubygems'
require 'ffi-rzmq'
require 'json'
require 'logger'
require_all '/home/johannes/lanistatsit/app/models/'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', host: 'localhost', database: '/home/johannes/lanistatsit/db/production.sqlite3')

logfile = File.open "/home/johannes/lanistatsit/log/matchinsertion.log", mode="a"
logfile.sync = true
log = Logger.new logfile
log.info "Starting match listener."

class MatchListener
	attr_accessor :pull_thread
	def initialize log
		@context = ZMQ::Context.new 1
		@inbound = @context.socket ZMQ::REP
#		rc = @inbound.connect "ipc:///tmp/matchinsertion"
		rc = @inbound.connect "tcp://127.0.0.1:5000"
		@pull_thread = Thread.new {
			while (ZMQ::Util.resultcode_ok? rc)
				begin
					msg = ""
					log.info "Receiving."
					rc = @inbound.recv_string msg
					log.info "Received message"
#					puts "Received message" + msg
					m = JSON.parse msg
					if m["type"] == "MATCH_INSERT"
						Match.InsertMatchFromJorn m["message"], log
						rc = @inbound.send_string "OK"
					else
						rc = @inbound.send_string "NOT OK"
					end

				rescue => detail
					log.info "ERROR RAISED IN MATCH LISTENER: " + detail.to_s
					log.info "ERROR TEXT: " + msg
					rc = @inbound.send_string "NOT OK"
					retry
				end
			end
			log.info "Exiting."
		}
	end
end

m = MatchListener.new log
m.pull_thread.join

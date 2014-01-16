class ReplayParser
  include SuckerPunch::Job

  def perform(matchid, path)
    bin_path = Rails.root.join('db', 'replay_parser')
    cmd = "bzcat " + path.to_s + "|" + bin_path.to_s
    jsonstring = ""
    begin
      PTY.spawn(cmd.to_s) do |stdin, stdout, pid|
        begin
          stdin.each { |line| jsonstring += line}
        rescue Errno::EIO
        end
      end
    rescue
      puts "Child process exited"
    end

    ok=false

    begin
      o = JSON.parse jsonstring
      ok=true
    rescue
      ok=false
    end

    match = Match.find(matchid)
    if ok and match.ProcessReplayInfo o
      match.replay_parsed=true
    else
      # Not a replay file or wrong replay
      FileUtils.rm match.replay_path
      match.replay_path=nil
      match.replay_parsed=false
    end
    match.save
  end
end

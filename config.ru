require './perfdashboard'

map "/assets" do
  run PerfDashboard.sprockets
end


map "/" do
  run PerfDashboard 
end

require 'rufus/scheduler'
scheduler = Rufus::Scheduler.start_new
 
scheduler.every '1s' do
    puts "Test!"      
    #do something here
end
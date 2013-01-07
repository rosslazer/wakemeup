class WakeController < ApplicationController

	#ask for timezone send data to controller
	def index

		# Obtain number user is calling from
	    usersnumber = params["From"]

		@ix = Telapi::InboundXml.new do
		  Gather(
		  	     :action      => 'http://afternoon-badlands-6611.herokuapp.com/wake/timezone.xml',
		         :method      => 'POST',
		         :numDigits   => '1',
		         :finishOnKey => '#') {
		  	Say "Hi there, thanks for using Wake Me Up. First, let's find out what time zone you are in."
		    Say "Please enter 1 for Eastern Standard Time, 2 for Central Standard Time, 3 for Mountain Standard time or 4 for Pacific Standard Time followed by pound sign."
  			}		 
  		end

	  	respond_to do |format|  
	    	format.xml { render :xml => @ix.response }  
		end

		#@caller = Caller.new
	    #@caller.number = usersnumber
	    #@caller.save

	    # Find or create instance of 'caller' in DB using the number a user calls in with
	    @caller = Caller.where(:number => usersnumber).first_or_create

	end # End of index method

	# Use timezone action to parse time zone and ask for time
	def timezone

		usersnumber = params["From"]

		@ix = Telapi::InboundXml.new do
		  	Gather(
		  		 :action      => 'http://afternoon-badlands-6611.herokuapp.com/wake/time.xml',
		         :method      => 'POST',
		         :numDigits   => '4',
		         :finishOnKey => '#') {
		  	Say 'Please enter four digits for your selected wakeup time. As an example, for ten thirty p m, enter 1 0 3 0.'
  		}	 
  		end

  		respond_to do |format|  
    		format.xml { render :xml => @ix.response }  
		end

		@timezone = params["Digits"]
		#@user = Caller.new
		@user = Caller.where(:number => usersnumber).first

		if @timezone == "1"
			@user.timezone = "EST"

		elsif @timezone == "2"
			@user.timezone = "CST"

		elsif @timezone == "3"
			@user.timezone = "MST"

		elsif @timezone == "4"
			@user.timezone = "PST"

		end
				
		@user.save

	end # End of timezone action

	def time
		usersnumber = params["From"]

		#check length of time, if 3 digits put ":" after 1st character else after 2nd character
		#then convert time to UTC
		@ix = Telapi::InboundXml.new do
		  Gather(:action      => 'http://afternoon-badlands-6611.herokuapp.com/wake/ampm.xml',
		         :method      => 'POST',
		         :numDigits   => '1',
		         :finishOnKey => '#') {
		    Say 'Please enter 1 for am or 2 for pm'
  		} 
  		end

  		respond_to do |format|  
    		format.xml { render :xml => @ix.response }  
		end

		time = params["Digits"] 
		user = Caller.where(:number => usersnumber).first

		if time.length == 3
			time[0] += ":"
		elsif time.length == 4
			time[1] += ":"
		end

		user.time = time
		user.save

	end # End of time action

	def ampm
		usersnumber = params["From"]

		#parse ampm and ask for confirm
		#check length of time, if 3 digits put ":" after 1st character else after 2nd character
		#then convert time to UTC
		@ix = Telapi::InboundXml.new do
		  Gather(:action      => 'http://afternoon-badlands-6611.herokuapp.com/wake/confirm.xml',
		         :method      => 'POST',
		         :numDigits   => '1',
		         :finishOnKey => '#') {
		    Say 'Please enter 1 to confirm'
  		}	 
  		end

		respond_to do |format|  
			format.xml { render :xml => @ix.response }  
		end

		ampm = params["Digits"] 
		user = Caller.where(:number => usersnumber).first
		tod = ""

		if ampm == "1"
			user.ampm = "AM"
		elsif ampm == "2"
			user.ampm = "PM"
		end
			
		time = user.time
		#user.time = Time.zone.parse("#{time} #{user.ampm} #{user.timezone}")
		user.save

	end # End of ampm action

	def confirm
		usersnumber = params["From"]

		@ix = Telapi::InboundXml.new do
		  Gather(:action      => '',
		         :method      => 'POST',
		         :numDigits   => '1',
		         :finishOnKey => '#') {
		    Say 'Thank you for confirming'
  		}		 
  		end

	  	respond_to do |format|  
	   		format.xml { render :xml => @ix.response }  
		end

		user = Caller.where(:number => usersnumber).first

		#schedtime= Time.parse("#{Date.tomorrow} #{time} #{user.ampm} #{user.timezone}")
		schedtime= Time.parse("#{Date.today} #{user.time} #{user.ampm} #{user.timezone}")

		scheduler = Rufus::Scheduler.start_new

		#Date.tomorrow + " " + 
		#scheduler.at "#{Date.tomorrow} #{schedtime}" do
		scheduler.at "#{schedtime}" do

  		Telapi::Call.make(usersnumber, '(201) 604-4992', 'https://www.telapi.com/data/inboundxml/404c735f21d00fee39a13210d54844f3cec069c7')
	end

#Todo
#When calling the user ask them to press 1, if it is not pressed after 5 seconds
#it will hangup and call them again

#Cool idea
#Let the user record a message and it will call a friend if they do not pickup

#Another idea, we could use <GetSpeech> with a grammer file for the IVRs

	end

	def read_numebr

	end
	

end

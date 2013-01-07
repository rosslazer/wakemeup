class WakeController < ApplicationController

	def index
		#ask for timezone send data to controller

				@ix = Telapi::InboundXml.new do
		  Gather(:action      => 'http://afternoon-badlands-6611.herokuapp.com/wake/timezone.xml',
		         :method      => 'POST',
		         :numDigits   => '1',
		         :finishOnKey => '#') {
		    Say 'Please enter 1 for EST, 2 for CST, 3 for MST, 
		    and 4 for PST followed by pound'
  }
		
		 
  end


  respond_to do |format|  
    format.xml { render :xml => @ix.response }  
	end


		    usersnumber = params["From"]
			#@caller = Caller.new
		    #@caller.number = usersnumber
		    #@caller.save

		    @caller = Caller.where(:number => usersnumber).first_or_create


end


	def timezone
		#parse time zone and ask for time


		@ix = Telapi::InboundXml.new do
		  Gather(:action      => 'http://afternoon-badlands-6611.herokuapp.com/wake/time.xml',
		         :method      => 'POST',
		         :numDigits   => '4',
		         :finishOnKey => '#') {
		    Say 'Please enter your selected wakeup time.'
  }
		
		 
  end
  respond_to do |format|  
    format.xml { render :xml => @ix.response }  
	end


		usersnumber = params["From"]


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

	end

	def time

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
	usersnumber = params["From"]


	time = params["Digits"] 
	user = Caller.where(:number => usersnumber).first


	if time.length == 3
		time[0] += ":"
	elsif time.length == 4
		time[1] += ":"
	end
	user.time = Time.zone.parse("#{time} #{user.timezone}")
	user.save

	end

	def ampm
		#parse ampm and ask for confirm
	end

	def confirm
		#parse confirm and thank the user
	end

end

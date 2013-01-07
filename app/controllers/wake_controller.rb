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
			@caller = Caller.new
		    @caller.number = usersnumber
		    @caller.save!


end


	def timezone
		#parse time zone and ask for time

		usersnumber = params["From"]


		timezone = params["Digits"]
		@user = Caller.new
		@user = Caller.where(:number => usersnumber)

		@user.timezone = timezone
		@user.save!


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
	end

	def time
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
	end

	def ampm
		#parse ampm and ask for confirm
	end

	def confirm
		#parse confirm and thank the user
	end

end

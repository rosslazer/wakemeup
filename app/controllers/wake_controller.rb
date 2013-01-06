class WakeController < ApplicationController

	def index
		#ask for timezone send data to controller
				@ix = Telapi::InboundXml.new do
		  Gather(:action      => 'http://localhost/timezone',
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

end


	def timezone
		#parse time zone and ask for time
	end

	def time
		#parse time and ask for ampm
	end

	def ampm
		#parse ampm and ask for confirm
	end

	def confirm
		#parse confirm and thank the user
	end

end

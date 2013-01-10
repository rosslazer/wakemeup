class TextedController < ApplicationController

	def check
		#check to see if user already has a wake up call if they do then return
		#a nice messsage telling them their time and giving them the option
		#to reset it
		#else give them a format to send for a the time
		# ex. 10:30 PM EST
		# if Caller.where(:number => usersnumber).first
		#    "Sorry you already signed up to be woken at #{user.time} tomorrow"
		

	end
end

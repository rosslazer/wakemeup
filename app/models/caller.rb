class Caller < ActiveRecord::Base
   attr_accessible :number, :timezone, :time, :ampm

   validates :number, :uniqueness => true
end



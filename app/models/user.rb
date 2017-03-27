class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable
    
    enum role: [ :standard, :premium, :admin ] 
    after_initialize :set_role
         
	

	
	private
	
	def set_role
		self.role = "standard"
	end
end

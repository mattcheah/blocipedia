class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	has_many :wikis
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable
    
    enum role: [ :standard, :premium, :admin, :authenticating ] 
    after_create :set_role
         

	private
	
	def set_role
		self.role = "standard"
	end
end

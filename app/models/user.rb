class User < ActiveRecord::Base
	
	has_many :wikis
    has_many :collaborators
    has_many :wikis, through: :collaborators
    
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable
    
    enum role: [ :standard, :premium, :admin, :authenticating ] 
    after_create :set_role
    
	
	private
	
	def set_role
		self.role = "standard"
	end
end

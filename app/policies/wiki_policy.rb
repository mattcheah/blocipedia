class WikiPolicy < ApplicationPolicy
	attr_reader :user, :wiki
	
	def initialize(user, wiki)
		@user = user
		@wiki = wiki
	end
	
	def premium?
		@user.premium? || @user.admin?
	end
	
	def admin?
		@user.admin?
	end
	
end
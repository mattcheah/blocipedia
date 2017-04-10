class CollaboratorPolicy < ApplicationPolicy
	attr_reader :user, :wiki
	
	def initialize(user, wiki)
		@user = user
		@wiki = wiki
	end
	
	
	def create?
		user.admin? || ( @user.premium? && @user.id == @wiki.user_id )
	end
	
	def destroy?
		user.admin? || ( @user.premium? && @user.id == @wiki.user_id )
	end
	
end
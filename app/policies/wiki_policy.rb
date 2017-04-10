class WikiPolicy < ApplicationPolicy
	attr_reader :user, :wiki
	
	def initialize(user, wiki)
		@user = user
		@wiki = wiki
	end
	
	def new?
		user.present?
	end
	
	def create?
		user.present?
	end
	
	def edit?
		user.present?
	end
	
	def update?
		user.present?
	end
	
	def add_collaborator?
		user.premium? || user.admin?
	end
	
	def destroy?
		user.present? && user.admin?
	end
	
	class Scope
		attr_reader :user, :scope
		def initialize(user, scope)
			@user = user
			@scope = scope
		end
		
		def resolve
			wikis = []
			if user
				if user.admin? 
					wikis = scope.all
				elsif user.premium?
					all_wikis = scope.all
					all_wikis.each do |wiki|
						
						if (not wiki.private?) || wiki.user_id == user.id || wiki.collaborators.include?(user)
							wikis << wiki
						end
					end
				else
					all_wikis = scope.all
					all_wikis.each do |wiki|
						if (not wiki.private?) || wiki.collaborators.pluck(:user_id).include?(user.id)
							wikis << wiki
						end
					end
				end
			else 
				wikis = Wiki.where.not(private: true)
			end
			wikis
		end
	end
	
end
class CollaboratorsController < ApplicationController
	
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
	
	# POST adds a collaborator
	def create
		@wiki = Wiki.find(params[:id])
		unless CollaboratorPolicy.new(current_user, @wiki).create?
		  raise Pundit::NotAuthorizedError, "not allowed to update? this #{@wiki.inspect}"
		end
		
		@email = params[:email]
		@new_collaborator = User.find_by_email(@email)
		if @new_collaborator == nil
			flash[:alert] = "That user does not exist. Please enter a valid email"
			return redirect_to "/wikis/#{@wiki.id}/edit"
		end
		
		if @wiki.collaborators.pluck(:user_id).include?(@new_collaborator.id)
			flash[:alert] = "That user is already a collaborator on this wiki."
			redirect_to "/wikis/#{@wiki.id}/edit"
		else
			Collaborator.create(user_id: @new_collaborator.id, wiki_id: @wiki.id )
			flash[:notice] = "#{@new_collaborator.email} has been added as a collaborator to this wiki"
			redirect_to "/wikis/#{@wiki.id}/edit"
		end
	end
	
	# DELETE removes a collaborator 
	def destroy
		@collaborator = Collaborator.find(params[:id])
		@wiki = Wiki.find(@collaborator.wiki_id)
		unless CollaboratorPolicy.new(current_user, @wiki).destroy?
		  raise Pundit::NotAuthorizedError, "not allowed to update? this #{@wiki.inspect}"
		end
		
		
		if @collaborator.delete 
			flash[:notice] = "Collaborator successfully removed!"
		else
			flash[:alert] =  "Wiki could not be deleted, please try again"
		end
		redirect_to "/wikis/#{@wiki.id}/edit"
	end
	
	private

	def user_not_authorized(exception)
		policy_name = exception.policy.class.to_s.underscore
		
		flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
		
		redirect_to edit_wiki_path(@wiki.id)
	end
end

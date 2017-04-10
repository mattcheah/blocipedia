
class WikisController < ApplicationController
	
	#before_action :authenticate_user!, :except => [:index, :show]
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
	
	def index
		@wikis = policy_scope(Wiki)
	end
	
	def show

		@wiki = Wiki.find(params[:id])
	end
	
	def new
		@wiki = Wiki.new
		authorize @wiki
	end
	
	def create
		@wiki = Wiki.new(wiki_params)
		authorize @wiki
		
		@wiki.user_id ||= current_user.id
		@wiki.private ||= false
		
		if @wiki.save
			flash[:notice] = "You have successfully created a new wiki!"
			redirect_to @wiki
		else 
			flash[:alert] = "Oops, something went wrong. Please Try Again!"
			render :new
		end
	end
	
	def edit
		@wiki = Wiki.find(params[:id])
		@collaborators = User.where(id: @wiki.collaborators.pluck(:user_id))
		authorize @wiki
	end
	
	def update
		@wiki = Wiki.find(params[:id])
		authorize @wiki
		
		@wiki.assign_attributes(wiki_params)
		
		if @wiki.save
			flash[:notice] = "You have edited your wiki!"
			redirect_to @wiki
		else 
			flash.now[:alert] = "Oops, something went wrong. Please Try Again!"
			return
		end
	end
	
	def destroy
		@wiki = Wiki.find(params[:id])
		authorize @wiki
		
		if @wiki.delete
			flash[:notice] = "Wiki successfully deleted!"
			redirect_to wikis_url
		else
			flash.now[:alert] =  "Wiki could not be deleted, please try again"
			return redirect_to wikis_url
		end
	end
		
	private
	
	def wiki_params
		params.require(:wiki).permit(:title, :body, :private)
	end
	
	def user_not_authorized(exception)
		policy_name = exception.policy.class.to_s.underscore
		
		flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
		case exception.query
		when "destroy?"
			redirect_to(edit_wiki_path)
		else
			redirect_to(new_user_session_path)
		end
	end
	
end


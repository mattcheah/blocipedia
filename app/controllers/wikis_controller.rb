class WikisController < ApplicationController
	
	#before_action :authenticate_user!
	
	def index
		@wikis = Wiki.all
	end
	
	def show
		@wiki = Wiki.find(params[:id])
	end
	
	def new
		@wiki = Wiki.new
	end
	
	def create
		
		@wiki = Wiki.new(wiki_params)
		
		if @wiki.save
			flash[:notice] = "You have successfully created a new wiki!"
			redirect_to @wiki
		else 
			flash[:alert] = "Oops, something went wrong. Please Try Again!"
			render :new
		end
		
	end
	
	def edit
		unless WikiPolicy.new(current_user, @wiki).update?
			flash[:alert] = "You must be signed in to edit a wiki page!"
			redirect_to new_user_session_path
		end
		
		@wiki = Wiki.find(params[:id])	
		
	end
	
	def update
		@wiki = Wiki.find(params[:id])
		@wiki.assign_attributes(wiki_params)
		
		unless WikiPolicy.new(current_user, @wiki).update?
			flash[:alert] = "You must be signed in to edit a wiki page!"
			redirect_to new_user_session_path
		end

		
		if @wiki.save
			flash[:notice] = "You have edited your wiki!"
			redirect_to @wiki
		else 
			flash.now[:alert] = "Oops, something went wrong. Please Try Again!"
			render :edit
		end
	end
	
	def destroy
		@wiki = Wiki.find(params[:id])
		
		if @wiki.delete
			flash[:notice] = "Wiki successfully deleted!"
			redirect_to wikis_url
		else
			flash.now[:alert] =  "Wiki could not be deleted, please try again"
			render :show
		end
	end
		
	private
	
	def wiki_params
		params.require(:wiki).permit(:title, :body, :private)
	end
	
end

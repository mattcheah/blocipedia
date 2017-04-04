class WikisController < ApplicationController
	
	before_action :authenticate_user!, :except => [:index, :show]
	
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
		@wiki = Wiki.find(params[:id])	
	end
	
	def update
		@wiki = Wiki.find(params[:id])
		@wiki.assign_attributes(wiki_params)
		
		if @wiki.save
			flash[:notice] = "You have edited your wiki!"
			redirect_to @wiki
		else 
			flash.now[:alert] = "Oops, something went wrong. Please Try Again!"
			render :edit
		end
	end
	
	def destroy

		if current_user.admin?
			@wiki = Wiki.find(params[:id])
			
			if @wiki.delete
				flash[:notice] = "Wiki successfully deleted!"
				redirect_to wikis_url
			else
				flash.now[:alert] =  "Wiki could not be deleted, please try again"
				render :edit
			end
		else
			flash[:notice] = "You must be an admin to peform this action"
			redirect_to edit_wiki_path
		end
	end
		
	private
	
	def wiki_params
		params.require(:wiki).permit(:title, :body, :private)
	end
	
end

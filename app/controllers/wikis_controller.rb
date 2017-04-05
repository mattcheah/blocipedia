class WikisController < ApplicationController
	
	before_action :authenticate_user!, :except => [:index, :show]
	
	def index
		@wikis = authorized_wikis
	end
	
	def show
		@wiki = Wiki.find(params[:id])
		if @wiki.private? && (current_user.standard? || current_user.authenticating? )
			flash[:notice] = "You must be an admin or a premium user to view this private wiki"
			redirect_to wikis_path
		end
	end
	
	def new
		@wiki = Wiki.new
	end
	
	def create
		@wiki = Wiki.new(wiki_params)
		@wiki.user_id = current_user.id
		#@wiki.private = params[:private]
		
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
		#@wiki.private = params[:private]
		
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
	
	def authorized_wikis
		if current_user && (current_user.admin? || current_user.premium?)
			Wiki.all
		else 
			Wiki.where.not(private: true)
		end
	end
	
end

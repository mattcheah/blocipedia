class ChargesController < ApplicationController
	
	before_action :authenticate_user!
	
	def new
		redirect_to users_upgrade_path
	end

	def create
		
		@user = current_user
	  
	  customer = Stripe::Customer.create(
	  	email: current_user.email,
	  	card: params[:stripeToken]
	  )
	  
	  charge = Stripe::Charge.create(
	  	customer: customer.id,
	  	amount: 1500,
	  	description: "Blocipedia Premium Membership - #{current_user.email}",
	  	currency: "usd"
	  )
	  
	  if charge
		@user.premium!
	  end
	  
	  flash[:notice] = "Thanks for paying us bros."
	  redirect_to users_upgrade_path
	  
	  rescue Stripe::CardError => e
	  	flash[:alert] = e.message
	  	redirect_to users_upgrade_path
	
	end
  
end

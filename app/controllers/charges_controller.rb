class ChargesController < ApplicationController
  def new
  	redirect_to edit_user_registration_path
  end

  def create
  	
  	unless current_user.admin? || current_user.premium?
  		
  		a = Amount.new()
  	
	  	customer = Stripe::Customer.create(
	  		email: current_user.email,
	  		card: params[:stripeToken]
	  	)
	  	
	  	charge = Stripe::Charge.create(
	  		customer: customer.id,
	  		amount: a.default,
	  		description: "Blocipedia Premium Membership - #{current_user.email}",
	  		currency: "usd"
	  	)
	  	
	  	current_user.authenticating!
	  	
	  	flash[:notice] = "Thanks for paying us bros."
	  	redirect_to edit_user_registration_path
	
	end
  	
  	rescue Stripe::CardError => e
  		flash[:alert] = e.message
  		redirect_to new_charge_path

  end
  
end

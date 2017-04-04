class WebhooksController < ApplicationController
	require "json"
	protect_from_forgery :except => :receive
	
	
	def receive
		#Stripe.api_key = "sk_test_y1lQF6QIDRE9uZMRBpfACZqt"
		
		#event_json = JSON.parse(request.body.read)
		#event = Stripe::Event.retrieve(event_json["id"])
		if params[:type] == "charge.succeeded"
			@email = params[:data][:object][:source][:name]
			
			u = User.find_by_email(@email)
			if not u.admin?
				u.premium!
			end
		end
		
		render :status => 200
	end
	
end

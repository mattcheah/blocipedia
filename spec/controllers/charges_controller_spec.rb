require 'rails_helper'

RSpec.describe ChargesController, type: :controller do

  describe "GET #new" do
    it "returns http redirect" do
      get :new
      expect(response).to have_http_status(:redirect)
    end
  end
  
	context 'Guest User' do

		describe "POST #create" do
			it "returns http redirect" do
			  post :create
			  expect(response).to have_http_status(:redirect)
			end
		end
		
	end
	
	context 'Logged In User' do
		
		before do
			my_user = User.create!({email: 'my_user@bloccipedia.com', password: 'password', password_confirmation: 'password'})
			sign_in my_user
		end
		
		describe "POST #create" do
			it "returns http success" do
			  post :create, {"utf8"=>"✓", "authenticity_token"=>"xuyUFxj9WjFHjGvd3btLRMSQZdMy+13mFHNx0wm9qJrCGP2u7UG1ERRVw8/e6QvfPXjumvkS7vWe8p4NEfXG0g==", "stripeToken"=>"tok_1A4yGlKCnSRj9eZdt2HHe8Jx", "stripeTokenType"=>"card", "stripeEmail"=>"matt.cheah@gmail.com"}
			  expect(response).to have_http_status(:success)
			end
			
			it "changes the user role to authenticating" do
				post :create, {"utf8"=>"✓", "authenticity_token"=>"xuyUFxj9WjFHjGvd3btLRMSQZdMy+13mFHNx0wm9qJrCGP2u7UG1ERRVw8/e6QvfPXjumvkS7vWe8p4NEfXG0g==", "stripeToken"=>"tok_1A4yGlKCnSRj9eZdt2HHe8Jx", "stripeTokenType"=>"card", "stripeEmail"=>"matt.cheah@gmail.com"}
				expect(my_user.role).to eq "authenticating"
			end
			
			it "creates a charge object" do
				post :create, {"utf8"=>"✓", "authenticity_token"=>"xuyUFxj9WjFHjGvd3btLRMSQZdMy+13mFHNx0wm9qJrCGP2u7UG1ERRVw8/e6QvfPXjumvkS7vWe8p4NEfXG0g==", "stripeToken"=>"tok_1A4yGlKCnSRj9eZdt2HHe8Jx", "stripeTokenType"=>"card", "stripeEmail"=>"matt.cheah@gmail.com"}
				expect(assigns(:charge)).to be_a(Stripe::Charge) 
			end
		end

	end
	
end

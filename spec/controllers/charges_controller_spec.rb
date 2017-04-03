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
			  post :create
			  expect(response).to have_http_status(:success)
			end
		end
		
	end
	
end

require 'rails_helper'



RSpec.describe User::RegistrationsController, type: :controller do


	context "standard user" do
		before(:each) do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			@my_standard = create(:user, role: "standard")
			sign_in @my_standard
		end
		
		describe "GET upgrade" do
			it "returns http success" do
				get :upgrade, id: @my_standard.id
				expect(response).to have_http_status(:success)
			end
		end
		
		describe "GET downgrade" do
			it "maintains the standard role for the user" do
				post :downgrade, id: @my_standard.id
				expect(@my_standard.role).to eq "standard"
			end
			
			it "redirects to edit user registration path" do
				post :downgrade, id: @my_standard.id
				expect(response).to redirect_to edit_user_registration_path
			end
		end
		
	end
	
	context "premium user" do
		before(:each) do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			@my_premium = create(:user, role: "premium")
			sign_in @my_premium
		end
		
		describe "GET downgrade" do
			it "sets the user to standard" do
				post :downgrade, id: @my_premium.id
				expect(@my_premium.role).to eq "standard"
			end
			it "redirects to edit user registration path" do
				post :downgrade, id: @my_premium.id
				expect(response).to redirect_to edit_user_registration_path
			end
		end
	end
	
	context "admin" do
		before(:each) do
			@request.env["devise.mapping"] = Devise.mappings[:user]
			@my_admin = create(:user)
			@my_admin.admin!
			sign_in @my_admin
		end
		
		describe "GET downgrade" do
			it "does not allow the user to downgrade" do
				post :downgrade, id: @my_admin.id
				expect(@my_admin.role).to eq "admin"
			end
			it "redirects to edit user registration path" do
				post :downgrade, id: @my_admin.id
				expect(response).to redirect_to edit_user_registration_path
			end
		end
	end


end
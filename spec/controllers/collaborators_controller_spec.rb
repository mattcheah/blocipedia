require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
	
	context "signed in standard user" do
		before do
			@my_user = User.create!({email: 'my_user@bloccipedia.com', password: 'password', password_confirmation: 'password'})
			sign_in @my_user
		end
		
		describe "POST create" do
		
			it "returns http redirect" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				post :create, id: new_wiki.id, email: new_user.email
				expect(response).to have_http_status(:redirect)
			end
			
			it "renders the edit page" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				post :create, id: new_wiki.id, email: new_user.email
				expect(response).to redirect_to edit_wiki_path(id: new_wiki.id)
			end
			
			it "does not add a collaborator to the database" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				count = Collaborator.all.count
				post :create, id: new_wiki.id, email: new_user.email
				expect(Collaborator.all.count).to eq(count)
			end
			
		end
		
		describe "DELETE Destroy" do
			it "renders the edit page" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				c = Collaborator.create(user_id: new_user.id, wiki_id: new_wiki.id)
				delete :destroy, id: c.id
				expect(response).to redirect_to edit_wiki_path(id: new_wiki.id)
			end
			
			it "does not remove a collaborator from the database" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				c = Collaborator.create(user_id: new_user.id, wiki_id: new_wiki.id)
				count = Collaborator.all.count
				delete :destroy, id: c.id
				expect(Collaborator.all.count).to eq count
			end
		end
	end

	context "signed-in premium user" do
		
		before do
			@my_user = User.create!({email: 'my_user@bloccipedia.com', password: 'password', password_confirmation: 'password'})
			@my_user.premium!
			sign_in @my_user
		end
		
		describe "POST create" do
			
			it "renders the edit page" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				post :create, id: new_wiki.id, email: new_user.email
				expect(response).to redirect_to edit_wiki_path(id: new_wiki.id)
			end
			
			it "adds a collaborator to the database" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				post :create, id: new_wiki.id, email: new_user.email
				expect(User.find(Collaborator.last.user_id).email).to eq("collab@blocipedia.com")
			end
			
			it "does not add a collaborator when given an incorrect email address" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				count = Collaborator.all.count
				post :create, id: new_wiki.id, email: "bonk"
				expect(Collaborator.all.count).to eq(count)
				expect(Collaborator.users.pluck(:email).include?("bonk")).to be false
			end
				
			
		end
		
		describe "DELETE destroy" do
			it "renders the edit page" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				c = Collaborator.create(user_id: new_user.id, wiki_id: new_wiki.id)
				delete :destroy, id: c.id
				expect(response).to redirect_to edit_wiki_path(id: new_wiki.id)
			end
			
			it "removes a collaborator from the database" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				c = Collaborator.create(user_id: new_user.id, wiki_id: new_wiki.id)
				count = Collaborator.all.count
				delete :destroy, id: c.id
				expect(Collaborator.all.count).to eq(count-1)
				expect(Collaborator.all.users.pluck(:email).include?("collab@blocipedia.com")).to eq false
			end
			
			it "does not remove a user when given an invalid id" do
				new_user = create(:user, email: "collab@blocipedia.com")
				new_wiki = create(:wiki, user_id: @my_user.id)
				c = Collaborator.create(user_id: new_user.id, wiki_id: new_wiki.id)
				count = Collaborator.all.count
				delete :destroy, id: 123412
				expect(Collaborator.all.count).to eq(count)
			end
			
		end
	end
end

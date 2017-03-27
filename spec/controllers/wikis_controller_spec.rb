require 'rails_helper'

RSpec.describe WikisController, type: :controller do


	let(:my_wiki) {	Wiki.create!(title: "Wiki #1", body: "This is the body for Wiki #1, and this has a lot of information.", private: false, user: User.first) }
	let(:wikis) { Wiki.all }
	
	context "guest" do
		
		
		describe "GET index" do
			it "returns HTTP redirect" do
				get :index
				expect(response).to have_http_status(:redirect)
			end
			
			it "renders the sign in template" do
				get :index
				expect(response).to redirect_to("/users/sign_in")
			end
			
		end	
		
		describe "GET show" do
			it "returns HTTP redirect" do
				get :show, id: my_wiki.id
				expect(response).to have_http_status(:redirect)
			end
			
			it "renders the sign in  template" do
				get :show, id: my_wiki.id
				expect(response).to redirect_to("/users/sign_in")
			end
			
		end	
	end

	context "signed in user" do
		before do
			my_user = User.create!({email: 'my_user@bloccipedia.com', password: 'password', password_confirmation: 'password'})
			sign_in my_user
		end
		
		describe "GET index" do
			it "returns HTTP 200" do
				get :index
				expect(response).to have_http_status(:success)
			end
			
			it "renders the index template" do
				get :index
				expect(response).to render_template(:index)
			end
			
			it "assigns all wikis to @wikis" do
				get :index
				expect(assigns(:wikis)).to eq(wikis)
			end
		end	
		
		describe "GET show" do
			it "returns HTTP 200" do
				get :show, id: my_wiki.id
				expect(response).to have_http_status(:success)
			end
			
			it "renders the show template" do
				get :show, id: my_wiki.id
				expect(response).to render_template(:show)
			end
			
			it "assigns my_wiki to @wiki" do
				get :show, id: my_wiki.id
				expect(assigns(:wiki)).to eq(my_wiki)
			end
		end	
		
		describe "GET new" do
			it "returns HTTP 200" do
				get :new
				expect(response).to have_http_status(:success)
			end
			
			it "renders the show template" do
				get :new
				expect(response).to render_template(:new)
			end
			
			it "assigns all wiki to @wiki" do
				get :new
				expect(assigns(:wiki)).to be_a(Wiki)
			end
		end
		
		describe "POST create" do
			
			it "returns HTTP 302" do
				post :create, wiki: {title: "my test title", body: "my wiki body here", private: false}
				expect(response).to have_http_status(:redirect)
			end
			
			it "redirects to the created wiki page" do
				
				post :create, wiki: { title: "my test title", body: "my wiki body here", private: false}
				expect(response).to redirect_to('/wikis/'+Wiki.last.id.to_s)
			end
			
			it "changes the number of wikis by 1" do
				expect{
					post :create, wiki: {title: "my test title", body: "my wiki body here", private: false}
				}.to change{Wiki.count}.by(1)
			end
		
		end
		
		describe "GET edit" do
		
			it "returns HTTP 200" do
				get :edit, id: my_wiki.id
				expect(response).to have_http_status(200)
			end
			
			it 'assigns my_wiki to @wiki' do
				get :edit, id: my_wiki.id
				expect(assigns(:wiki)).to eq(my_wiki)
			end
			
		end
		
		describe "PUT update" do
			
			it "returns HTTP redirect" do
				put :update, id: my_wiki.id, wiki: {title: "my test title - updated!", body: "my wiki body here", private: false}
				expect(response).to have_http_status(:redirect)
			end
			
			it "updates the object with new attributes" do
				my_title = "New Title"
				my_body = "New Body"
				my_privates = true
				my_attrs = {title: my_title, body: my_body, private: my_privates }
				
				put :update, id: my_wiki.id, wiki: my_attrs
				expect(assigns(:wiki).title).to eq(my_title)
				expect(assigns(:wiki).body).to eq(my_body)
				expect(assigns(:wiki).private).to eq(my_privates)
			end
		
		end
		
		describe "DELETE destroy" do
			
			it "deletes the wiki object" do
				delete :destroy, id: my_wiki.id
				count = Wiki.where(id = my_wiki.id).count
				
				expect(count).to eq(0)
			end
			
			
			it "redirects to the :index template" do 
				delete :destroy, id: my_wiki.id
				expect(response).to redirect_to(wikis_url)	
			end
		end
	end
end

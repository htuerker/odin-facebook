require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:create_post) { create(:post, user: current_user ) }

  render_views

  describe 'GET #index' do
    context 'when user is anonymous' do
      it 'should redirect to sign in path' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before do
        sign_in current_user
        20.times do
          create(:post, user: current_user)
        end
      end

      it 'should render index template with user feed' do
        get :index
        expect(response).to render_template('index')
        expect(assigns(:posts)).to eq current_user.feed.paginate(page: 1, per_page: 10)
      end

      context 'when request type is xhr' do
        it 'should render index.js' do
          get :index, params: { posts_page: 1 }, xhr: true
          expect(response).to render_template('index')
          expect(assigns(:posts)).to eq current_user.feed.paginate(page: 1, per_page: 10)
        end
      end
    end
  end

  describe "GET #show" do
    let(:user_post) { create(:post, user: current_user) }
    context 'when user is anonymous' do
      it 'should redirect to sign in route' do
        get :show, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in user' do
      before do
        sign_in current_user
      end

      it 'should render show template' do
        get :show, params: { id: user_post.id }
        expect(assigns(:post)).to eq user_post
        expect(response).to render_template('show')
      end
    end
  end

  describe 'POST #create' do
    let(:new_post) { build(:post) }

    context 'when user is anonymous' do
      it 'should redirect to sign in route' do
        post :create, params: { post: new_post }
      end
    end

    context 'when user is signed in' do
      before do
        sign_in current_user
      end

      context 'when given parameter is valid' do
        it 'should create new post with flash message' do
          expect(new_post.valid?).to be true
          post :create, params: { post: { content: new_post.content } }
          expect(assigns(:post).persisted?).to be true
          expect(controller).to set_flash[:success]
          expect(response).to redirect_to(root_path)
        end

        context 'when request type is xhr' do
          it 'should render create.js' do
            post :create, params: { post: { content: new_post.content } }, xhr: true
            expect(assigns(:post).persisted?).to be true
            expect(response).to render_template('create')
          end
        end
      end

      context 'when given paremeter is invalid' do
        it 'should create new post with flash message' do
          new_post.content = ''
          expect(new_post.valid?).to be false
          post :create, params: { post: { content: new_post.content } }
          expect(assigns(:post).persisted?).to be false
          expect(controller).to set_flash[:danger]
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is anonymous' do
      it 'should redirect to sign in route' do
        new_post = create_post
        delete :destroy, params: { id: new_post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      context 'when user is authorized' do
        before do
          sign_in current_user
        end

        it 'should destroy given post' do
          new_post = create_post
          expect do
            delete :destroy, params: { id: new_post.id }
          end.to change { Post.count }.by(-1)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in other_user
        end

        it 'should raise not authorized error' do
          new_post = create_post
          expect do
            expect do
              delete :destroy, params: { id: new_post.id }
            end.to raise_error(Pundit::NotAuthorizedError)
          end.not_to change { Post.count }
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }

  render_views

  describe 'GET #index' do
    context 'when user is anonymous' do
      it 'should redirect to sign_in path' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before do
        sign_in current_user
      end

      it 'should render index template with signed in user\'s friendable users' do
        users = create_list(:user, 5)
        get :index
        expect(assigns(:users)).to eq users
        expect(response).to render_template('index')
      end
    end
  end

  describe 'GET #show' do
    context 'when user is anonymous' do
      it 'should redirect to sign_in path' do
        get :show, params: { id: current_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before do
        sign_in current_user
        20.times do
          create(:post, user: current_user)
          create(:post, user: other_user)
        end
      end

      context 'when parameter user is signed in user' do
        it 'should render me template' do
          get :show, params: { id: current_user.id }
          expect(response).to render_template('me')
          expect(assigns(:user)).to eq current_user
          expect(assigns(:posts)).to eq current_user.posts.paginate(page: 1, per_page: 10)
        end
      end

      context 'when paramter user another user' do
        it 'should render show template' do
          get :show, params: { id: other_user.id }
          expect(response).to render_template('show')
          expect(assigns(:user)).to eq other_user
          expect(assigns(:posts)).to eq other_user.posts.paginate(page: 1, per_page: 10)
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }

  render_views

  describe 'GET #index' do
    context 'when user is anonymous' do
      it 'should redirect to sign in route' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      let(:new_friend) { create(:user)}

      before do
        create(:friendship, user: current_user, friend: new_friend)
        sign_in current_user
      end

      it 'should render index template with user friends' do
        get :index, params: { user_id: current_user.id }
        expect(assigns(:friends)).to eq [new_friend]
        expect(response).to render_template('index')
      end
    end
  end

  describe 'POST #create' do
    context 'when user is anonymous' do
      it 'should redirect to sign in route' do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before do
        sign_in current_user
        FriendRequest.create(sender: other_user, receiver: current_user)
      end

      context 'when given parameter is valid' do
        context 'when request type is xhr' do
          it 'should create a friendship and render create.js' do
            expect do
              post :create, xhr: true, params: { friendship: { friend_id: other_user.id } }
            end.to change { Friendship.count }.by(1)

            expect(assigns(:friendship).persisted?).to be true
            expect(response).to render_template('create')
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is anonymous' do
      it 'should redirect to sign in route' do
        delete :destroy, params: { id: { }}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      context 'when user is authorized' do
        before do
          sign_in current_user
        end

        it 'should destroy given friendship' do
          friendship = create(:friendship, user: current_user, friend: other_user)
          expect do
            delete :destroy, params: { id: friendship.id }
          end.to change { Friendship.count }.by(-1)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in create(:user)
        end

        it 'should raise not authorized error' do
          friendship = create(:friendship, user: current_user, friend: other_user)
          expect do
            expect do
              delete :destroy, params: { id: friendship.id }
            end.to raise_error(Pundit::NotAuthorizedError)
          end.not_to change { Friendship.count }
        end
      end
    end
  end
end





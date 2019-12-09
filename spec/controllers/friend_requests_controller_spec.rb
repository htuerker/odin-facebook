require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }

  render_views

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
      end

      context 'when given parameter is valid' do
        context 'when request type is xhr' do
          it 'should create a friend request and render create.js' do
            expect do
              post :create, xhr: true, params: {
                friend_request: { receiver_id: other_user.id } }

            end.to change { FriendRequest.count }.by(1)

            expect(assigns(:friend_request).persisted?).to be true
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

        it 'should destroy given friend request' do
          friend_request = create(:friend_request, sender: current_user, receiver: other_user)
          expect do
            delete :destroy, params: { id: friend_request.id }
          end.to change { FriendRequest.count }.by(-1)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in create(:user)
        end

        it 'should raise not authorized error' do
          friend_request = create(:friend_request, sender: current_user, receiver: other_user)
          expect do
            expect do
              delete :destroy, params: { id: friend_request.id }
            end.to raise_error(Pundit::NotAuthorizedError)
          end.not_to change { FriendRequest.count }
        end
      end
    end
  end
end




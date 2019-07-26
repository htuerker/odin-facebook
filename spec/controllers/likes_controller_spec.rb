require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:created_post) { create(:post, user: current_user ) }

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
          it 'should create a like and render create.js' do
            expect do
              post :create, xhr: true, params: {
                like: { post_id: created_post.id } }

            end.to change { Like.count }.by(1)

            expect(assigns(:like).persisted?).to be true
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

        it 'should destroy given like' do
          like = create(:like, user: current_user, post: created_post)
          expect do
            delete :destroy, params: { id: like.id }
          end.to change { Like.count }.by(-1)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in other_user
        end

        it 'should raise not authorized error' do
          like = create(:like, user: current_user, post: created_post)
          expect do
            expect do
              delete :destroy, params: { id: like.id }
            end.to raise_error(Pundit::NotAuthorizedError)
          end.not_to change { Like.count }
        end
      end
    end
  end
end



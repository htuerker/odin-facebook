require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:created_post) { create(:post, user: current_user ) }

  render_views

  describe 'GET #index' do
    context 'when user is anonymous' do
      it 'should redirect to sign in path' do
        get :index, params: { post_id: created_post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed in' do
      before do
        sign_in current_user
      end

      context 'when request type is xhr' do
        before do
          create_list(:comment, 5, post: created_post)
        end

        it 'should render index.js with paginated comments' do
          get :index, params: { post_id: created_post.id }, xhr: true
          expect(response).to render_template('index')
          expect(assigns(:post)).to eq created_post
          expect(assigns(:comments)).to eq created_post.comments.paginate(page: 1, per_page: 3);
          get :index, params: { post_id: created_post.id, comments_page: 2 }, xhr: true
          expect(assigns(:comments)).to eq created_post.comments.paginate(page: 2, per_page: 3);
        end
      end
    end
  end

  describe 'POST #create' do
    let(:new_comment) { build(:comment) }

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
          it 'should create a post and render create.js' do
            expect do
              post :create, xhr: true, params: {
                comment: { content: new_comment.content, post_id: created_post.id } }

            end.to change { created_post.comments.count }.by(1)

            expect(assigns(:comment).persisted?).to be true
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

        it 'should destroy given comment' do
          comment = create(:comment, user: current_user, post: created_post)
          expect do
            delete :destroy, params: { id: comment.id }
          end.to change { Comment.count }.by(-1)
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in other_user
        end

        it 'should raise not authorized error' do
          comment = create(:comment, user: current_user, post: created_post)
          expect do
            expect do
              delete :destroy, params: { id: comment.id }
            end.to raise_error(Pundit::NotAuthorizedError)
          end.not_to change { Comment.count }
        end
      end
    end
  end
end


require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do

  let(:user) { create(:user) }
  let(:status) { create(:status, user_id: user.id) }
  let(:valid_attributes) { { body: "A new comment", status_id: status.id, user_id: user.id } }
  let(:invalid_attributes) { { content: "", status_id: status.id, user_id: user.id } }

  let(:valid_session) { {} }

  describe "POST create" do

    describe "with valid params" do
      describe "when not logged in" do
        it "redirects to the login page" do
          post :create, {status_id: status.id, :comment => valid_attributes}
          expect(response).to redirect_to(login_path)
        end

        it "does not create a Comment" do
          expect {
            post :create, {status_id: status.id, :comment => valid_attributes}
          }.to change(Comment, :count).by(0)
        end
      end

      describe "when logged in" do
        before do
          sign_in(user)
        end

        it "creates a new Comment" do
          expect {
            post :create, {status_id: status.id, :comment => valid_attributes}
          }.to change(Comment, :count).by(1)
        end

        it "does not create an invalid Comment" do
          expect {
            post :create, {status_id: status.id, :comment => invalid_attributes}
          }.to change(Comment, :count).by(0)
        end

        it "assigns a newly created comment as @comment" do
          post :create, {status_id: status.id, :comment => valid_attributes}
          expect(assigns(:comment)).to be_a(Comment)
          expect(assigns(:comment)).to be_persisted
        end

        it "redirects to the comment's status" do
          post :create, {status_id: status.id, :comment => valid_attributes}
          expect(response).to redirect_to(status_path(status))
        end
      end
    end
  end

  describe "DELETE destroy" do
    describe "when logged in" do
      before do
        sign_in(user)
      end

      it "destroys the requested comment" do
        comment = Comment.create! valid_attributes
        expect {
          delete :destroy, {status_id: status.id, :id => comment.to_param}
        }.to change(Comment, :count).by(-1)
      end

      it "redirects to the comments list" do
        comment = Comment.create! valid_attributes
        delete :destroy, {status_id: status.id, :id => comment.to_param}
        expect(response).to redirect_to(status_path(status))
      end
    end

    describe "when not logged in" do
      it "destroys the requested comment" do
        comment = Comment.create! valid_attributes
        expect {
          delete :destroy, {status_id: status.id, :id => comment.to_param}
        }.to change(Comment, :count).by(0)
      end

      it "redirects to the login page" do
        comment = Comment.create! valid_attributes
        delete :destroy, {status_id: status.id, :id => comment.to_param}
        expect(response).to redirect_to(login_path)
      end
    end
  end

end

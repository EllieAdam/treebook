require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe CommentsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Comment. As you add validations to Comment, be sure to
  # adjust the attributes here as well.
  let(:user) { create(:user) }
  let(:status) { create(:status, user_id: user.id) }
  let(:valid_attributes) { { body: "A new comment", status_id: status.id, user_id: user.id } }
  let(:invalid_attributes) { { content: "", status_id: status.id, user_id: user.id } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CommentsController. Be sure to keep this updated too.
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
require 'rails_helper'

RSpec.describe StatusesController, :type => :controller do

  let(:user) { create(:user) }
  let(:valid_attributes) { { content: "My status", user_id: user.id } }
  let(:invalid_attributes) { { content: "M", user_id: user.id } }

  let(:valid_session) { {} }

  before do
    sign_in(user)
  end

  describe "GET index" do
    it "assigns all statuses as @statuses" do
      status = Status.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:statuses)).to eq([status])
    end
  end

  describe "GET show" do
    it "assigns the requested status as @status" do
      status = Status.create! valid_attributes
      get :show, {:id => status.to_param}, valid_session
      expect(assigns(:status)).to eq(status)
    end
  end

  describe "GET new" do
    it "assigns a new status as @status" do
      xhr :get, :new, {}, valid_session
      expect(assigns(:status)).to be_a_new(Status)
    end
  end

  describe "GET edit" do
    it "assigns the requested status as @status" do
      status = Status.create! valid_attributes
      xhr :get, :edit, {:id => status.to_param}, valid_session
      expect(assigns(:status)).to eq(status)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Status" do
        expect {
          xhr :post, :create, {:status => valid_attributes}, valid_session
          }.to change(Status, :count).by(1)
        end

        it "assigns a newly created status as @status" do
          xhr :post, :create, {:status => valid_attributes}, valid_session
          expect(assigns(:status)).to be_a(Status)
          expect(assigns(:status)).to be_persisted
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved status as @status" do
          xhr :post, :create, {:status => invalid_attributes}, valid_session
          expect(assigns(:status)).to be_a_new(Status)
        end

        it "re-renders the 'new' template" do
          xhr :post, :create, {:status => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) { { content: "My new status", user_id: user.id } }

        it "updates the requested status" do
          status = Status.create! valid_attributes
          expect {
            xhr :put, :update, {:id => status.to_param, :status => new_attributes}, valid_session
            status.reload
            }.to change{status.content}
          end

          it "assigns the requested status as @status" do
            status = Status.create! valid_attributes
            xhr :put, :update, {:id => status.to_param, :status => valid_attributes}, valid_session
            expect(assigns(:status)).to eq(status)
          end
        end

        describe "with invalid params" do
          it "assigns the status as @status" do
            status = Status.create! valid_attributes
            xhr :put, :update, {:id => status.to_param, :status => invalid_attributes}, valid_session
            expect(assigns(:status)).to eq(status)
          end

          it "re-renders the 'edit' template" do
            status = Status.create! valid_attributes
            xhr :put, :update, {:id => status.to_param, :status => invalid_attributes}, valid_session
            expect(response).to render_template("edit")
          end
        end
      end

      describe "DELETE destroy" do
        it "destroys the requested status" do
          status = Status.create! valid_attributes
          expect {
            xhr :delete, :destroy, {:id => status.to_param}, valid_session
            }.to change(Status, :count).by(-1)
          end
        end

      end

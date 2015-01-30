require 'rails_helper'

RSpec.describe FriendshipsController, :type => :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  describe "GET index" do
    context "when logged in" do

      before do
        sign_in(user)
        @friendship1 = create(:pending_friendship, user: user, friend: user2)
        @friendship2 = create(:accepted_friendship, user: user, friend: user3)
        get :index
      end

      it "gets the index page without errors" do
        expect(response.status).to eq(200)
      end

      it "assigns a new @friendships variable" do
        expect(assigns(:friendships)).to eq([@friendship1, @friendship2])
      end

    end

    context "when not logged in" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET new" do
    context "when logged in" do
      render_views

      before do
        sign_in(user)
      end

      it "assigns a new friendship as @friendship" do
        get :new, { friend_id: user2 }
        expect(assigns(:friendship)).to be_a_new(Friendship)
      end

      it "returns success" do
        get :new, { friend_id: user2 }
        expect(response.status).to eq(200)
      end

      it "displays flash error when friend id is missing" do
        get :new
        expect(flash[:error]).to eq("Friend required.")
      end

      it "redirects when friend id is missing" do
        get :new
        expect(response).to redirect_to(statuses_path)
      end

      it "assigns the proper friend" do
        get :new, { friend_id: user2 }
        expect(assigns(:friendship).friend).to eq(user2)
      end

      it "assigns the currently logged in user" do
        get :new, { friend_id: user2 }
        expect(assigns(:friendship).user).to eq(user)
      end

      it "asks if the user is sure about the frienship" do
        get :new, { friend_id: user2 }
        expect(response.body).to include("Are you sure you want to request this friend?")
      end

      it "returns a 404 when friend is not found" do
        get :new, { friend_id: "invalid" }
        expect(response.status).to eq(404)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST create" do
    context "when logged in" do

      before do
        sign_in(user)
      end

      context "when friend id is missing" do

        it "displays flash error" do
          post :create
          expect(flash[:error]).to_not be_empty
        end

        it "redirects to statuses page" do
          post :create
          expect(response).to redirect_to(statuses_path)
        end

      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        post :create
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "a new instance" do

    before do
      @friendship = Friendship.create user: user, friend: user2
    end

    it "is pending when created" do
      expect(@friendship.state).to eq("pending")
    end

    context "#send_request_email" do
      it "delivers the request email" do
        expect(ActionMailer::Base.deliveries.size).to eq(0)
        expect{ @friendship.send_request_email }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end
  end

  describe "#accept" do

    before do
      @friendship1 = create(:pending_friendship, user: user, friend: user2)
      @friendship2 = create(:accepted_friendship, user: user, friend: user3)
    end

    context "when logged in" do

      before do
        sign_in(user)
        put :accept, id: @friendship1.id
        @friendship1.reload
      end

      it "sets the friendship state to accepted" do
        expect(@friendship1.state).to eq("accepted")
      end

      it "assigns a new @friendship variable" do
        expect(assigns(:friendship)).to eq(@friendship1)
      end

      it "sets a success flash message" do
        expect(flash[:success]).to eq("You are now friends with #{@friendship1.friend.name}")
      end

    end

    context "when not logged in" do
      it "redirects to the login page" do
        put :accept, id: @friendship1.id
        expect(response).to redirect_to(login_path)
      end
    end
  end

end

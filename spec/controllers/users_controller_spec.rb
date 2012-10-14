require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  def valid_attributes
    {:nickname => 'updated nickname'}
  end

  def valid_session
    {:user_id => user.id}
  end

  def other_session
    {:user_id => user2.id}
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      get :show, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end
  end

  describe "GET edit" do
    it "is available for valid session" do
      get :edit, {:id => user.id}, valid_session
      assigns(:user).should eq(user)
      response.status.should eq(200)
    end
    it "is NOT available for valid session" do
      get :edit, {:id => user.id}, other_session
      response.status.should eq(302)
      response.should redirect_to(root_path)
    end
  end

  describe "PUT update" do
    describe "with valid params and valid session" do
      it "updates the requested user" do
        put :update, {:id => user.id, :user => {'nickname' => 'changed'}}, valid_session
        User.find(user.id).nickname.should eq("changed")
      end
      it "assigns the requested user as @user" do
        put :update, {:id => user.id, :user => valid_attributes}, valid_session
        assigns(:user).should eq(user)
      end
      it "redirects to the user" do
        put :update, {:id => user.id, :user => valid_attributes}, valid_session
        response.should redirect_to(user)
      end
    end

    describe "with valid params and other session" do
      it "doesn't update the requested user" do
        put :update, {:id => user.id, :user => {'nickname' => 'changed'}}, other_session
        User.find(user.id).nickname.starts_with?("User").should be_true
      end
      it "redirects to root" do
        put :update, {:id => user.id, :user => valid_attributes}, other_session
        response.status.should eq(302)
        response.should redirect_to(root_path)
      end
    end

    describe "with valid params and no session" do
      it "updates the requested user" do
        put :update, {:id => user.id, :user => {'nickname' => 'changed'}}, {}
        User.find(user.id).nickname.starts_with?("User").should be_true
      end
      it "redirects to signin" do
        put :update, {:id => user.id, :user => valid_attributes}, {}
        response.status.should eq(302)
        response.location.starts_with?("http://test.host/signin").should be_true
      end
    end

    describe "with invalid nickname" do
      it "re-renders the 'edit' template" do
        put :update, {:id => user.id, :user => {:nickname => nil}}, valid_session
        response.should render_template("edit")
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template" do
        User.any_instance.stub(:update_attributes).and_return(false)
        put :update, {:id => user.id, :user => {:nickname => 'changed'}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    describe "with valid session" do
      it "destroys the requested user" do
        prepared_user = user
        expect {
          delete :destroy, {:id => prepared_user.id}, valid_session
        }.to change(User, :count).by(-1)
      end
      it "redirects to root" do
        delete :destroy, {:id => user.id}, valid_session
        response.should redirect_to root_path
      end
    end
    describe "with no session" do
      it "destroys the requested user" do
        prepared_user = user
        expect {
          delete :destroy, {:id => prepared_user.id}, {}
        }.to change(User, :count).by(0)
      end
      it "redirects to sigin" do
        delete :destroy, {:id => user.id}, {}
        response.status.should eq(302)
        response.location.starts_with?("http://test.host/signin").should be_true
      end
    end
    describe "with other session" do
      it "destroys the requested user" do
        prepared_user = user
        prepared_other_session = other_session
        expect {
          delete :destroy, {:id => prepared_user.id}, prepared_other_session
        }.to change(User, :count).by(0)
      end
      it "redirects to root" do
        delete :destroy, {:id => user.id}, other_session
        response.should redirect_to root_path
      end
    end
  end

end

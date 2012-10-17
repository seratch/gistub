require 'spec_helper'

describe GistsController do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  let(:gist) {
    gist = create(:gist, :user => user)
    history = create(:gist_history, :gist => gist)
    create(:gist_file, :gist_history => history)
    gist
  }
  let(:private_gist) {
    private_gist = create(:gist, :is_public => false, :user => user)
    history = create(:gist_history, :gist => private_gist)
    create(:gist_file, :gist_history => history)
    private_gist
  }
  let(:anonymous_gist) {
    anon_gist = create(:gist, :user => nil)
    history = create(:gist_history, :gist => anon_gist)
    create(:gist_file, :gist_history => history)
    anon_gist
  }

  def valid_attributes
    {
        :gist => {
            :title => 'Title'
        },
        :is_public => true,
        :gist_file_names => ["a.rb", "b.rb"],
        :gist_file_bodies => ["class A; end", "module B; end"]
    }
  end

  def valid_session
    {:user_id => user.id}
  end

  def other_session
    {:user_id => user2.id}
  end

  describe "GET show" do
    describe "with valid session" do
      it "assigns the requested gist as @gist" do
        get :show, {:id => gist.id}, valid_session
        assigns(:gist).should eq(gist)
      end
      it "returns own private gist" do
        get :show, {:id => private_gist.id}, valid_session
        assigns(:gist).should eq(private_gist)
      end
    end
    describe "with no session" do
      it "assigns the requested gist as @gist" do
        get :show, {:id => gist.id}, {}
        assigns(:gist).should eq(gist)
      end
      it "returns own private gist" do
        get :show, {:id => private_gist.id}, {}
        response.status.should eq(404)
      end
    end
    describe "with other session" do
      it "assigns the requested gist as @gist" do
        get :show, {:id => gist.id}, other_session
        assigns(:gist).should eq(gist)
      end
      it "returns own private gist" do
        get :show, {:id => private_gist.id}, other_session
        response.status.should eq(404)
      end
    end
  end

  describe "GET show_history" do
    describe "with valid session" do
      it "assigns the requested gist as @gist" do
        get :show_history, {
            :id => gist.id,
            :gist_history_id => gist.latest_history.id
        }, valid_session
        response.status.should eq(200)
        assigns(:gist).should eq(gist)
        assigns(:gist_history).should eq(gist.latest_history)
      end
      it "allows to access own private gist" do
        get :show_history, {
            :id => private_gist.id,
            :gist_history_id => private_gist.latest_history.id
        }, valid_session
        response.status.should eq(200)
        assigns(:gist).should eq(private_gist)
        assigns(:gist_history).should eq(private_gist.latest_history)
      end
      it "returns 404 if gist_history_id is invalid" do
        get :show_history, {
            :id => -1,
            :gist_history_id => -1
        }, valid_session
        response.status.should eq(404)
      end
      it "returns 404 if gist_id is invalid" do
        get :show_history, {
            :id => -1,
            :gist_history_id => gist.latest_history.id
        }, valid_session
        response.status.should eq(404)
      end
    end

    describe "with no session" do
      it "assigns the requested gist as @gist" do
        get :show_history, {
            :id => gist.id,
            :gist_history_id => gist.latest_history.id
        }, {}
        response.status.should eq(200)
        assigns(:gist).should eq(gist)
        assigns(:gist_history).should eq(gist.latest_history)
      end
      it "doesn't allow to access someone's private gist" do
        get :show_history, {
            :id => private_gist.id,
            :gist_history_id => private_gist.latest_history.id
        }, {}
        response.status.should eq(404)
      end
    end

    describe "with other session" do
      it "assigns the requested gist as @gist" do
        get :show_history, {
            :id => gist.id,
            :gist_history_id => gist.latest_history.id
        }, other_session
        response.status.should eq(200)
        assigns(:gist).should eq(gist)
        assigns(:gist_history).should eq(gist.latest_history)
      end
      it "doesn't allow to access someone's private gist" do
        get :show_history, {
            :id => private_gist.id,
            :gist_history_id => private_gist.latest_history.id
        }, other_session
        response.status.should eq(404)
      end
    end
  end

  describe "GET new" do
    it "assigns a new gist as @gist" do
      get :new, {}, {}
      assigns(:gist).should be_a_new(Gist)
      response.status.should eq(200)
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    it "redirects to root if the gist is not found" do
      get :edit, {:id => -1}, {}
      response.status.should eq(302)
      response.should redirect_to root_path
    end
    it "assigns the requested gist as @gist" do
      get :edit, {:id => gist.id}, {}
      assigns(:gist).should eq(gist)
      response.status.should eq(200)
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    describe "with valid session" do
      describe "when valid params are passed" do
        it "creates a new Gist" do
          expect {
            post :create, valid_attributes, valid_session
          }.to change(Gist, :count).by(1)
          assigns(:gist).should be_a(Gist)
          assigns(:gist).should be_persisted
          response.should redirect_to(Gist.last)
        end

        it "creates a new private Gist" do
          before = Gist.include_private.where(:user_id => user.id).count
          post :create, valid_attributes.merge(:is_public => false), valid_session
          after = Gist.include_private.where(:user_id => user.id).count
          (after - before).should eq(1)
        end

        it "renders 'new' template if no gist_file is passed" do
          post :create, {
              :gist => {
                  :title => 'Title'
              },
              :is_public => true,
              :gist_file_names => [],
              :gist_file_bodies => []
          }, valid_session
          response.status.should eq(200)
          response.should render_template("new")
        end
      end

      describe "when invalid params are passed" do
        it "assigns a newly created but unsaved gist as @gist" do
          Gist.any_instance.stub(:save).and_return(false)
          post :create, {:gist => {}}, valid_session
          assigns(:gist).should be_a_new(Gist)
        end

        it "re-renders the 'new' template" do
          Gist.any_instance.stub(:save).and_return(false)
          post :create, {:gist => {}}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "with no session" do
      describe "when valid params are passed" do
        it "creates a new Gist" do
          expect {
            post :create, valid_attributes, {}
          }.to change(Gist, :count).by(1)
        end
        it "doesn't create a new private Gist" do
          expect {
            post :create, valid_attributes.merge(:is_public => false), {}
          }.to change(Gist, :count).by(1)
        end

        it "assigns a newly created gist as @gist" do
          post :create, valid_attributes, {}
          assigns(:gist).should be_a(Gist)
          assigns(:gist).should be_persisted
        end

        it "redirects to the created gist" do
          post :create, valid_attributes, {}
          response.should redirect_to(Gist.last)
        end
      end

      describe "when invalid params are passed" do
        it "assigns a newly created but unsaved gist as @gist" do
          Gist.any_instance.stub(:save).and_return(false)
          post :create, {:gist => {}}, {}
          assigns(:gist).should be_a_new(Gist)
        end

        it "re-renders the 'new' template" do
          Gist.any_instance.stub(:save).and_return(false)
          post :create, {:gist => {}}, {}
          response.should render_template("new")
        end
      end
    end
  end

  describe "POST fork" do
    describe "with valid session" do
      it "creates a new forked gist" do
        prepared_gist = gist
        expect {
          post :fork, {:gist_id => prepared_gist.id}, valid_session
        }.to change(Gist, :count).by(1)
        Gist.where(:source_gist_id => prepared_gist.id, :user_id => user.id).size.should eq(1)
      end
      it "doesn't create a new forked gist if already forked" do
        post :fork, {:gist_id => gist.id}, valid_session
        expect {
          post :fork, {:gist_id => gist.id}, valid_session
        }.to change(Gist, :count).by(0)
        response.status.should eq(302)
      end
      it "returns 404 for the invalid target" do
        post :fork, {:gist_id => -1}, valid_session
        response.status.should eq(404)
      end
    end

    describe "with no session" do
      it "creates a new forked gist" do
        post :fork, {:gist_id => gist.id}, {}
        response.status.should eq(302)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do

      describe "with valid session" do
        it "updates the own public gist and redirects to the gist" do
          put :update, {:id => gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), valid_session
          updated = Gist.find_by_id(gist.id)
          updated.title.should eq('AAA')
          response.should redirect_to(gist)
        end

        it "updates the own private gist" do
          put :update, {:id => private_gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), valid_session
          updated = Gist.include_private.find_by_id(private_gist.id)
          updated.title.should eq('AAA')
        end

        it "updates the anonymous private gist" do
          put :update, {:id => anonymous_gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), valid_session
          updated = Gist.find_by_id(anonymous_gist.id)
          updated.title.should eq('AAA')
        end

        it "renders 'edit' template if no gist_file is passed" do
          put :update, {
              :id => gist.id,
              :gist => {
                  :title => 'Title'
              },
              :is_public => true,
              :gist_file_names => [],
              :gist_file_bodies => []
          }, valid_session
          response.status.should eq(200)
          response.should render_template("edit")
        end
      end

      describe "with other session" do
        it "updates the someone's public gist and redirects to gists_path" do
          put :update, {:id => gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), other_session
          not_updated = Gist.find_by_id(gist.id)
          not_updated.title.should_not eq('AAA')
          response.status.should eq(302)
          response.should redirect_to(gists_path)
        end
        it "doesn't update the someone's private gist" do
          put :update, {:id => private_gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), other_session
          not_updated = Gist.include_private.find_by_id(private_gist.id)
          not_updated.title.should_not eq('AAA')
          response.status.should eq(404)
        end
        it "updates the anonymous private gist" do
          put :update, {:id => anonymous_gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), other_session
          updated = Gist.find_by_id(anonymous_gist.id)
          updated.title.should eq('AAA')
        end
      end

      describe "with no session" do
        it "updates the someone's public gist" do
          put :update, {:id => gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), {}
          not_updated = Gist.find_by_id(gist.id)
          not_updated.title.should_not eq('AAA')
          response.status.should eq(302)
          response.status.should eq(302)
        end
        it "updates the someone's private gist" do
          put :update, {:id => private_gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), {}
          not_updated = Gist.include_private.find_by_id(private_gist.id)
          not_updated.title.should_not eq('AAA')
          response.status.should eq(404)
        end
        it "updates the anonymous private gist" do
          put :update, {:id => anonymous_gist.id}.merge(valid_attributes).merge(:gist => {:title => 'AAA'}), {}
          updated = Gist.find_by_id(anonymous_gist.id)
          updated.title.should eq('AAA')
        end
      end

    end

    describe "with invalid params" do
      it "assigns the gist as @gist" do
        Gist.any_instance.stub(:save).and_return(false)
        put :update, {:id => gist.id}.merge(valid_attributes), valid_session
        assigns(:gist).should eq(gist)
      end

      it "re-renders the 'edit' template" do
        Gist.any_instance.stub(:save).and_return(false)
        put :update, {:id => gist.id}.merge(valid_attributes), valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do

    describe "with valid session" do
      it "destroys own public gist" do
        prepared_gist = gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, valid_session
        }.to change(Gist, :count).by(-1)
      end
      it "destroys own private gist" do
        prepared_gist = private_gist
        before = Gist.include_private.where(:user_id => user.id).count
        delete :destroy, {:id => prepared_gist.id}, valid_session
        after = Gist.include_private.where(:user_id => user.id).count
        (before - after).should eq(1)
      end
      it "destroys anonymous gist" do
        prepared_gist = anonymous_gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, valid_session
        }.to change(Gist, :count).by(-1)
      end
      it "redirects to root" do
        delete :destroy, {:id => gist.id}, valid_session
        response.should redirect_to(root_path)
      end
    end

    describe "with other session" do
      it "doesn't destroy someone's public gist" do
        prepared_gist = gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, other_session
        }.to change(Gist, :count).by(0)
      end
      it "doesn't destroy someone's private gist" do
        prepared_gist = private_gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, other_session
        }.to change(Gist, :count).by(0)
        response.status.should eq(404)
      end
      it "doesn't destroy anonymous gist" do
        prepared_gist = anonymous_gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, other_session
        }.to change(Gist, :count).by(-1)
      end
    end

    describe "with no session" do
      it "doesn't destroy someone's public gist" do
        prepared_gist = gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, {}
        }.to change(Gist, :count).by(0)
      end
      it "doesn't destroy someone's private gist" do
        prepared_gist = private_gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, {}
        }.to change(Gist, :count).by(0)
        response.status.should eq(404)
      end
      it "doesn't destroy anonymous gist" do
        prepared_gist = anonymous_gist
        expect {
          delete :destroy, {:id => prepared_gist.id}, {}
        }.to change(Gist, :count).by(-1)
      end
    end

  end

  describe "GET add_gist_files_input" do
    it "returns js" do
      get :add_gist_files_input, {}, {}
      response.status.should eq(406)

      xhr :get, :add_gist_files_input, {}, {}
      response.status.should eq(200)
      response.content_type.should eq('text/javascript')
    end
  end

  describe "GET page" do
    it "returns js" do
      get :page, {}, {}
      response.status.should eq(406)

      xhr :get, :page, {:page => 2}, {}
      response.status.should eq(200)
      response.should render_template('page')
      assigns(:gists).should eq(Gist.recent.page(2).per(10))
    end
  end

  describe "GET mine" do
    describe "with valid session" do
      it "returns my gists" do
        get :mine, {}, valid_session
        response.status.should eq(200)
        assigns(:gists).should_not be_nil
      end
    end
    describe "without valid session" do
      it "returns my gists" do
        get :mine, {}, {}
        response.status.should eq(302)
        response.should redirect_to "#{signin_path}?return_to=http%3A%2F%2Ftest.host%2Fgists%2Fmine"
      end
    end
  end

  describe "GET mine_page" do

    describe "with valid session" do
      it "returns js" do
        get :mine_page, {}, valid_session
        response.status.should eq(406)

        xhr :get, :mine_page, {:page => 2}, valid_session
        response.status.should eq(200)
        response.should render_template('page')
        assigns(:gists).should eq(Gist.find_my_recent_gists(user.id).page(2).per(10))
      end
    end

    describe "without valid session" do
      it "returns js" do
        get :mine_page, {}, {}
        response.status.should eq(302)
        response.should redirect_to "#{signin_path}?return_to=http%3A%2F%2Ftest.host%2Fgists%2Fmine_page"

        xhr :get, :mine_page, {:page => 2}, {}
        response.status.should eq(302)
        response.should redirect_to "#{signin_path}?return_to=http%3A%2F%2Ftest.host%2Fgists%2Fmine_page"
      end
    end
  end

  describe "GET user_page" do
    it "returns js" do
      get :user_page, {:page => 2}, valid_session
      response.status.should eq(406)

      xhr :get, :user_page, {:page => 2, :user_id => user.id}, {}
      response.status.should eq(200)
      response.should render_template('user_page')
      assigns(:gists).should_not be_nil
    end

    it "returns 404 if user_id is invalid" do
      xhr :get, :user_page, {:page => 2, :user_id => -1}, {}
      response.status.should eq(404)
    end
  end

  describe "GET user_fav_page" do
    it "returns js" do
      get :user_fav_page, {:page => 2}, valid_session
      response.status.should eq(406)

      xhr :get, :user_fav_page, {:page => 2, :user_id => user.id}, {}
      response.status.should eq(200)
      response.should render_template('user_fav_page')
      assigns(:favorites).should_not be_nil
    end

    it "returns 404 if user_id is invalid" do
      xhr :get, :user_fav_page, {:page => 2, :user_id => -1}, {}
      response.status.should eq(404)
    end
  end

end

require 'spec_helper'

describe CommentsController do
  let(:gist) { create(:gist) }
  let(:user) { create(:user) }

  def valid_session
    {:user_id => user.id}
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Comment and redirects to the gist" do
        expect {
          post :create, {:gist_id => gist.id, :body => 'LGTM'}, valid_session
        }.to change(Comment, :count).by(1)
        response.should redirect_to(gist)
      end
    end

    describe "with invalid params" do
      it "re-renders the 'gists/show' template" do
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {:gist_id => gist.id, :comment => {}}, valid_session
        response.should render_template("../gists/show")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested comment and redirects to the gist page" do
      comment = create(:comment, :gist => gist, :user => user)
      expect {
        delete :destroy, {:gist_id => gist.id, :id => comment.id}, valid_session
      }.to change(Comment, :count).by(-1)
    end
    it "redirects to gist when deleting non-existing comment" do
      expect {
        delete :destroy, {:gist_id => gist.id, :id => -1}, valid_session
      }.to change(Comment, :count).by(0)
      response.should redirect_to(gist)
    end
  end

end

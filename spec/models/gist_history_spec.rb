# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GistHistory do

  it 'is available' do
    gist_history = create(:gist_history)
    gist_history.user.should_not be_nil
    gist_history.gist.should_not be_nil
    gist_history.gist_files.should_not be_nil
  end

  it 'returns headline' do
    gist_history = create(:gist_file).gist_history
    expected = <<BODY
class Sample
  def do_something
    puts "Hello!"
BODY
    gist_history.headline.should eq(expected.sub(/\n$/, ""))
  end

  it 'returns headline for 2 lines' do
    body = <<BODY
class Sample
end
BODY
    gist_history = create(:gist_file, :body => body).gist_history
    gist_history.headline.should eq(body.sub(/\n$/, ""))
  end

end

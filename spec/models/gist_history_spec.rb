# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GistHistory do

  it 'is available' do
    gist_history = create(:gist_history)
    expect(gist_history.user).not_to be_nil
    expect(gist_history.gist).not_to be_nil
    expect(gist_history.gist_files).not_to be_nil
  end

  it 'returns headline' do
    gist_history = create(:gist_file).gist_history
    expected = <<BODY
class Sample
  def do_something
    puts "Hello!"
BODY
    expect(gist_history.headline).to eq(expected.sub(/\n$/, ""))
  end

  it 'returns headline for 2 lines' do
    body = <<BODY
class Sample
end
BODY
    gist_history = create(:gist_file, :body => body).gist_history
    expect(gist_history.headline).to eq(body.sub(/\n$/, ""))
  end

end

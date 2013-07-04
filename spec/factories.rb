# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :gist do
    title "Gist by FactoryGirl (#{Time.now})"
    is_public true
    user
    created_at Time.now
    updated_at Time.now
  end

  factory :gist_history do
    gist
    user
  end

  factory :gist_file do
    gist_history
    name 'sample.rb'
    body <<BODY
class Sample
  def do_something
    puts "Hello!"
  end
end
BODY
  end

  factory :comment do
    gist
    user
    body 'Looks good to me! :)'
  end

  factory :favorite do
    gist
    user
  end

  factory :user do
    nickname "User#{Time.now.to_i}"
    omniauth_provider 'open_id'
    omniauth_uid Time.now.to_i.to_s
  end

end



require 'spec_helper'
require 'fixtures/models'

RSpec.shared_examples "queries" do |db_config|
  before(:all) do
    ActiveRecord::Base.establish_connection(adapter: db_config['adapter'], database: db_config['database'])
    load File.join(__dir__, '..', 'fixtures', 'schema.rb')
  end
  
  let!(:first_user) { User.create(email: "lorem") }
  let!(:first_user_microposts) do
    5.times.map do
      Micropost.create(user: first_user, content: rand(1..10).to_s)
    end
  end
  let!(:second_user) { User.create(email: "ipsum") }
  let!(:second_user_microposts) do
    5.times.map do
      Micropost.create(user: second_user, content: rand(1..10).to_s)
    end
  end
  let!(:third_user) { User.create(email: "dolor") }
  let!(:third_user_microposts) do
    5.times.map do
      Micropost.create(user: third_user, content: rand(1..10).to_s)
    end
  end

  it "returns correct results" do
    all_records = []
    group_records = {}
    ActiveRecordTemptable.with_temptable(first_user.feed) do |table|
      all_records = table.to_a
      group_records = table.group(:content).count.to_h
    end
    expect(all_records).to eq first_user.feed.to_a
    expect(group_records).to eq first_user.feed.group(:content).count
  end
end

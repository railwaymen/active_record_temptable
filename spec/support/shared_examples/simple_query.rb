require 'spec_helper'
require 'fixtures/models'

RSpec.shared_examples "queries" do |db_config|
  before(:all) do
    ActiveRecord::Base.establish_connection(adapter: db_config['adapter'], database: db_config['database'])
    load File.join(__dir__, '..', '..', 'fixtures', 'schema.rb')
  end

  def seed_db
    create_microposts = proc do |user|
      Micropost.create(user: user, content: rand(1..10).to_s)
    end
    @first_user = User.create(email: "lorem")
    @first_user_microposts = create_microposts[@first_user]
    @second_user = User.create(email: "ipsum")
    Relationship.create(follower: @first_user, followed: @second_user)
    @second_user_microposts = create_microposts[@second_user]
    @third_user = User.create(email: "dolor")
    @third_user_microposts = create_microposts[@third_user]
  end

  it "returns correct results" do
    seed_db
    all_records = []
    group_records = {}

    ActiveRecordTemptable.with_temptable(@first_user.feed, [:user_id]) do |table|
      all_records = table.to_a
      group_records = table.group(:user_id).count
    end
    expect(all_records).to eq @first_user.feed.to_a
    expect(group_records).to eq @first_user.feed.group(:user_id).count
  end
end

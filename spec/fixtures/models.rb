# From https://bitbucket.org/railstutorial/sample_app_4th_ed/

class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def feed
    following_ids = active_relationships.select(:followed_id)
    Micropost.where("user_id IN (#{following_ids.to_sql})
                     OR user_id = :user_id", user_id: id)
  end
end

class Micropost < ActiveRecord::Base
  belongs_to :user
end

class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
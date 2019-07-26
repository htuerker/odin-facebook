# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: %i[facebook]

  validates :first_name, presence: true, length: { maximum: 20 },
    format: { with: /\A\b[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*\b\z/i, message: 'must be valid name' }
  validates :last_name, presence: true, length: { maximum: 20 },
    format: { with: /\A\b[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*\b\z/i, message: 'must be valid name' }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :sent_friend_requests, foreign_key: :sender_id,
    class_name: 'FriendRequest', dependent: :destroy

  has_many :received_friend_requests, foreign_key: :receiver_id,
    class_name: 'FriendRequest', dependent: :destroy

  has_many :direct_friendships, class_name: 'Friendship', dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: :friend_id,
    dependent: :destroy

  has_many :direct_friends, through: :direct_friendships, source: :friend
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  mount_uploader :profile_photo, PhotoUploader
  mount_uploader :cover_photo, PhotoUploader

  def friends
    direct_friends.union(inverse_friends)
  end

  def feed
    friends_ids = friends.ids.join(',')
    if friends_ids.blank?
      Post.where('user_id = :user_id', user_id: id)
    else
      Post.where("user_id IN (#{friends_ids})
                OR user_id = :user_id", user_id: id)
    end
  end

  def friendable_users
    User.all.where.not('id IN(?)', [self.id] + self.friends.ids +
                       self.sent_friend_requests.pluck(:receiver_id) +
                       self.received_friend_requests.pluck(:sender_id))
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name.split(' ')[0]
      user.last_name = auth.info.name.split(' ')[-1]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end
end

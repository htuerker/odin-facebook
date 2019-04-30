class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: %i[facebook]

  validates :first_name, presence: true, length: { maximum: 20 },
    format: { with: /[a-z]+/i, message: "must be alphabetically"}
  validates :last_name, presence: true, length: { maximum: 20 },
    format: { with: /[a-z]+/i, message: "must be alphabetically" }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friend_requests_sent, foreign_key: :sender_id,
    class_name: "FriendRequest", dependent: :destroy

  has_many :friend_requests_received, foreign_key: :receiver_id,
    class_name: "FriendRequest", dependent: :destroy

  has_many :friendships, foreign_key: :user1_id, dependent: :destroy
  has_many :friendships_2, class_name: "Friendship", foreign_key: :user2_id,
    dependent: :destroy

  has_many :friends, through: :friendships, source: :user2

  def establish_friendship(other_user)
    begin
      self.friends.push(other_user)
      other_user.friends.push(self)
    rescue ActiveRecord::RecordNotUnique
      self.errors.add(:friends, "You're already friends")
      other_user.errors.add(:friends, "You're already friends")
    end
  end

  def destroy_friendship(other_user)
    self.friends.delete(other_user)
    other_user.friends.delete(self)
  end

  def feed
    friends_ids = self.friends.ids.join(',')
    unless friends_ids.blank?
      Post.where("user_id IN (#{friends_ids})
                OR user_id = :user_id", user_id: id)
    else
      Post.where("user_id = :user_id", user_id: id)
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name.split(" ")[0]
      user.last_name = auth.info.name.split(" ")[-1]
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end

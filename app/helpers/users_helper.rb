module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: get_full_name_for(user), class: "gravatar")
  end

  def get_full_name_for(user)
    user.first_name + " " + user.last_name
  end
end

# frozen_string_literal: true

module UsersHelper
  def profile_photo_for(user, options: { size: 80, circle: false })
    if user.profile_photo.present?
      url = user.profile_photo.url
    else
      url = "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=#{options[:size]}"
    end
    image_tag(url, alt: get_full_name_for(user),
                   class: "gravatar #{options[:circle] ? 'rounded-circle' : ''}",
                   style: "width:#{options[:size]}px;height:#{options[:size]}px;")
  end

  def get_full_name_for(user)
    user.first_name + ' ' + user.last_name
  end
end

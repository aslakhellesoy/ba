module BaTags
  include Radiant::Taggable

  def haml(haiku)
    Haml::Engine.new(haiku).render(self)
  end

  desc "Displays event details as hCal" 
  tag "hcal" do |tag|
    description = tag.attr['description']
    location = tag.attr['location']

    %{<div class="vevent">
  <h3 class="summary"><a href="#{url}" class="url">#{title}</a></h3>
  <p class="description">#{description}</p>
  <p>
    <abbr class="dtstart" title="#{starts_at.iso8601}">#{starts_at.to_s(:long)}</abbr>
  </p>
  <p><span class="location">#{location}</span></p>
</div>}
  end

  desc "Renders a signup form" 
  tag "signup" do |tag|
    %{<form action="#{url}attendance/" method="post">
  <p><label for="user_name">Name</label>
  <input id="user_name" name="user[name]" size="30" type="text" /></p>

  <p><label for="user_email">Email</label>
  <input id="user_email" name="user[email]" size="30" type="text" /></p>

  <p><label for="user_login">Login</label>
  <input id="user_login" name="user[login]" size="30" type="text" /></p>

  <p><label for="user_password">Password</label>
  <input id="user_password" name="user[password]" size="30" type="text" /></p>

  <p><label for="user_password_confirmation">Confirm Password</label>
  <input id="user_password_confirmation" name="user[password_confirmation]" size="30" type="text" /></p>

  <p><input name="commit" type="submit" value="Sign up" /></p>
</form>}
  end
end
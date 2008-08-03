class LoginPage < Page
  description %{
    This page displays a login form for the site (for Site users). There
    should only be one of it, and it should be at /login
  }

  before_validation_on_create :create_default_content

  def cache?; false; end
  
  def create_default_content
    self.parent = Page.find_by_url('/')
    self.slug = 'login'
    self.breadcrumb = self.title = 'Log in'
    self.status = Status[:published]

    parts << PagePart.new(:name => 'body', :content => %{
<form method="post" action="/site_session">
  <div style="margin: 0pt; padding: 0pt;">
    <input type="hidden" value="gibberishhhh" name="authenticity_token"/>
  </div>
  <p>
    <label for="email">Email</label><br/>
    <input id="email" type="text" name="email" value="<r:ba:request_param name="email" />"/>
  </p>
  <p>
    <label for="password">Password</label><br/>
    <input id="password" type="password" name="password"/>
  </p>
  <p>
    <label for="remember_me">Remember me:</label>
    <input id="remember_me" type="checkbox" value="1" name="remember_me" <r:ba:request_param name="remember_me" value="1">checked="checked" </r:ba:request_param>/>
  </p>
  <p>
    <input type="submit" value="Log in" name="commit"/>
  </p>
</form>
    })
  end
end
class AccountPage < Page
  description %{
    This page displays a form where logged in Site users
    can change their personal details.
  }

  before_validation_on_create :create_default_content

  def cache?
    false
  end

  def process(request, response)
    @site_user = controller.current_site_user
    if @site_user
      if request.post?
        attrs = request.parameters[:site_user]
        if @site_user.update_attributes(attrs)
          controller.flash[:account_success] = true
          controller.redirect_to(self.url)
        else
          controller.flash[:account_failure] = true
          super # Failed to update. Just show page again.
        end
      else
        super # Just show page.
      end
    else
      # Not logged in
      controller.redirect_to(LoginPage.find(:first).url)
    end
  end
  
  def create_default_content
    self.parent = Page.find_by_url('/')
    self.slug = 'account'
    self.breadcrumb = self.title = 'Account'
    self.status = Status[:published]

    parts << PagePart.new(:name => 'body', :content => read_file('default_account_part.html'))
  end
end
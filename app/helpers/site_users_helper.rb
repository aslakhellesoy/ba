module SiteUsersHelper
  
  #
  # Use this to wrap view elements that the site_user can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   SiteUser)  do link_to('List all site_users', site_users_path) end %> |
  # <%= if_authorized?(:edit,    @site_user) do link_to('Edit this site_user', edit_site_user_path) end %> |
  # <%= if_authorized?(:destroy, @site_user) do link_to 'Destroy', @site_user, :confirm => 'Are you sure?', :method => :delete end %> 
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  #
  # Link to site_user's page ('site_users/1')
  #
  # By default, their login is used as link text and link title (tooltip)
  #
  # Takes options
  # * :content_text => 'Content text in place of site_user.login', escaped with
  #   the standard h() function.
  # * :content_method => :site_user_instance_method_to_call_for_content_text
  # * :title_method => :site_user_instance_method_to_call_for_title_attribute
  # * as well as link_to()'s standard options
  #
  # Examples:
  #   link_to_site_user @site_user
  #   # => <a href="/site_users/3" title="barmy">barmy</a>
  #
  #   # if you've added a .name attribute:
  #  content_tag :span, :class => :vcard do
  #    (link_to_site_user site_user, :class => 'fn n', :title_method => :login, :content_method => :name) +
  #          ': ' + (content_tag :span, site_user.email, :class => 'email')
  #   end
  #   # => <span class="vcard"><a href="/site_users/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  #
  #   link_to_site_user @site_user, :content_text => 'Your site_user page'
  #   # => <a href="/site_users/3" title="barmy" class="nickname">Your site_user page</a>
  #
  def link_to_site_user(site_user, options={})
    raise "Invalid site_user" unless site_user
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= site_user.send(options.delete(:content_method))
    options[:title] ||= site_user.send(options.delete(:title_method))
    link_to h(content_text), site_user_path(site_user), options
  end

  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address 
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP :content_text => 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current site_user's page (using link_to_site_user) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_site_user(options={})
    if current_site_user
      link_to_site_user current_site_user, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_site_user
      [:content_method, :title_method].each{|opt| options.delete(opt)} 
      link_to_login_with_IP content_text, options
    end
  end

end

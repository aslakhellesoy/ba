# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class BaExtension < Radiant::Extension
  version "1.0"
  description "Event and Conference organizing."
  url "http://github.com/aslakhellesoy/ba/tree/master"
  
  define_routes do |map|
    map.logout '/logout', :controller => 'site_sessions', :action => 'destroy'
    map.register '/register', :controller => 'site_users', :action => 'create'
    map.signup '/signup', :controller => 'site_users', :action => 'new'
    map.activate '/activate/:activation_code', :controller => 'site_users', :action => 'activate', :activation_code => nil

    map.resources :site_users, :member => { :suspend   => :put,
                                            :unsuspend => :put,
                                            :purge     => :delete }
    map.resource :site_session

    # map.resources :presentations
    # map.resource :attendance
    # map.resource :attendance, :path_prefix => "*url" do |attendance|
    #   attendance.resources :presentations
    # end

    map.with_options(:controller => 'admin/price') do |prices|
      prices.price_index  'admin/price',                     :action => 'index'
      prices.price_edit   'admin/price/edit/:id',            :action => 'edit'
      prices.price_new    'admin/price/new',                 :action => 'new'
      prices.price_remove 'admin/price/remove/:id',          :action => 'remove'
    end

    map.with_options(:controller => 'admin/site_user') do |site_users|
      site_users.site_user_index  'admin/site_user',                     :action => 'index'
      site_users.site_user_edit   'admin/site_user/edit/:id',            :action => 'edit'
      site_users.site_user_new    'admin/site_user/new',                 :action => 'new'
      site_users.site_user_remove 'admin/site_user/remove/:id',          :action => 'remove'
    end

    map.with_options(:controller => 'admin/program') do |programs|
      programs.program_index       'admin/program',                   :action => 'index'
      programs.program_edit        'admin/program/:id',               :action => 'edit'
    end

    map.with_options(:controller => 'admin/email') do |email|
      email.email_new    'admin/email/new',                 :action => 'new'
    end
    
    map.namespace(:admin) do |admin|
      admin.resources :presentations
    end
  end
  
  def activate
    Page.class_eval do
      attr_accessor :controller
    end

    SiteController.class_eval do
      session :disabled => false # :on
      include AuthenticatedSystem
      before_filter :authenticate_from_activation_code
    
      public :redirect_to, :flash
    
      def process_page_with_set_controller(page)
        page.controller = self
        process_page_without_set_controller(page)
      end
      alias_method_chain :process_page, :set_controller

      def no_login_required?
        true
      end

      def authenticate_from_activation_code
        if params[:activation_code]
          logout_keeping_session!
          site_user = SiteUser.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
          if (!params[:activation_code].blank?) && site_user && !site_user.active?
            self.current_site_user = site_user
          end
        end
      end
    end
    
    admin.tabs.add "Prices",     "/admin/price",          :after => "Layouts",     :visibility => [:all]
    admin.tabs.add "Programs",   "/admin/program",        :after => "Prices",      :visibility => [:all]
    admin.tabs.add "Site Users", "/admin/site_user",      :after => "Programs",    :visibility => [:all]
    admin.tabs.add "Email",      "/admin/email/new",      :after => "Site Users",  :visibility => [:all]

    admin.instance_eval do
      def price
        @price ||= returning OpenStruct.new do |snippet|
          snippet.edit = Radiant::AdminUI::RegionSet.new do |edit|
            edit.main.concat %w{edit_header edit_form}
            edit.form.concat %w{edit_code edit_amount edit_max edit_currency edit_happening_page}
            edit.form_bottom.concat %w{edit_buttons}
          end
        end
      end
    end
    
    tweak_page_edit_ui
  end
  
  def deactivate
    admin.tabs.remove "Prices"

    SiteController.class_eval { session :off }
  end

private

  def tweak_page_edit_ui
    # Add fields for input of Happening attributes. See app/views/admin/_edit_page_happening.html.erb
    admin.page.edit.add :layout_row, "edit_page_happening"
    
    # Add javascript that only displays Happening when page type is HappeningPage
    Admin::PageController.class_eval do
      before_filter :edit_page_happening_js
      def edit_page_happening_js
        include_javascript 'admin/edit_page_happening.js'
      end
    end
  end
end

# This is for restful authentication (site site_users)
require 'aasm'
unless defined?(REST_AUTH_SITE_KEY)
  REST_AUTH_SITE_KEY         = '83750ca3f127dcabc9d78bf45a19941c16dcaec6'
  REST_AUTH_DIGEST_STRETCHES = 10
end
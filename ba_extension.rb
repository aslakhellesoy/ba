# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class BaExtension < Radiant::Extension
  version "1.0"
  description "Event and Conference organizing."
  url "http://github.com/aslakhellesoy/ba/tree/master"
  
  define_routes do |map|
    map.logout '/logout', :controller => 'site_sessions', :action => 'destroy'
    map.login '/login', :controller => 'site_sessions', :action => 'new'
    map.register '/register', :controller => 'site_users', :action => 'create'
    map.signup '/signup', :controller => 'site_users', :action => 'new'
    map.activate '/activate/:activation_code', :controller => 'site_users', :action => 'activate', :activation_code => nil

    map.resources :site_users, :member => { :suspend   => :put,
                                            :unsuspend => :put,
                                            :purge     => :delete }
    map.resource :site_session

    map.resources :presentations
    map.resource :attendance
    map.resource :attendance, :path_prefix => "*url" do |attendance|
      attendance.resources :presentations
    end

    map.with_options(:controller => 'admin/price') do |prices|
      prices.price_index  'admin/price',                     :action => 'index'
      prices.price_edit   'admin/price/edit/:id',            :action => 'edit'
      prices.price_new    'admin/price/new',                 :action => 'new'
      prices.price_remove 'admin/price/remove/:id',          :action => 'remove'
    end
  end
  
  def activate
    admin.tabs.add "Prices", "/admin/price", :after => "Layouts", :visibility => [:all]
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
    
    Page.class_eval do 
      include BaTags
    end

    tweak_page_edit_ui

    reload_class(HappeningPage)
    reload_class(PresentationPage)
  end
  
  def deactivate
    admin.tabs.remove "Prices"
  end

private

  # HACK
  # Radiant's Page#load_subclasses has been called at this point - before our own Page
  # subclasses have been loaded. Unfortunately the implementation is buggy - it scans
  # the database for Page subclasses and defines an empty class if it isn't already
  # defined. We therefore undefine the class constant and reference it again, which
  # will cause Rails to load it correctly.
  def reload_class(klass)
    if klass.missing?
      Object.send(:remove_const, klass.name.to_sym)
      eval(klass.name) # Rails' const_missing will find it again
    end
  end

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
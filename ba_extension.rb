# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class BaExtension < Radiant::Extension
  version "1.0"
  description "Event and Conference organizing."
  url "http://github.com/aslakhellesoy/ba/tree/master"
  
  define_routes do |map|
    map.resources :attendances, :member => {:already, :get}
    map.resources :attendances, :member => {:already, :get}, :path_prefix => "*url"
  end
  
  def activate
    # admin.tabs.add "Ba", "/admin/ba", :after => "Layouts", :visibility => [:all]
    Page.class_eval do 
      include BaTags
    end

    tweak_page_edit_ui
    reload_class(HappeningPage)
  end
  
  def deactivate
    # admin.tabs.remove "Ba"
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
# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class BaExtension < Radiant::Extension
  version "1.0"
  description "Event and Conference organizing"
  url "http://github.com/aslakhellesoy/ba/tree/master"
  
  # define_routes do |map|
  #   map.connect 'admin/ba/:action', :controller => 'admin/ba'
  # end
  
  def activate
    # admin.tabs.add "Ba", "/admin/ba", :after => "Layouts", :visibility => [:all]
    Page.class_eval { include BaTags }
    Page.class_eval { include BaPageExt }
  end
  
  def deactivate
    # admin.tabs.remove "Ba"
  end
  
end
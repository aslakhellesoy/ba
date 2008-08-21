require File.dirname(__FILE__) + '/../spec_helper'
  
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe SiteUsersController do
  fixtures :site_users

  it 'allows signup' do
    lambda do
      create_site_user
      response.should be_redirect
    end.should change(SiteUser, :count).by(1)
  end

  
  it 'signs up site_user in pending state' do
    create_site_user
    assigns(:site_user).reload
    assigns(:site_user).should be_pending
  end

  it 'signs up site_user with activation code' do
    create_site_user
    assigns(:site_user).reload
    assigns(:site_user).activation_code.should_not be_nil
  end
  it 'requires login on signup' do
    lambda do
      create_site_user(:email => nil)
      assigns[:site_user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(SiteUser, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_site_user(:password => nil)
      assigns[:site_user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(SiteUser, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_site_user(:password_confirmation => nil)
      assigns[:site_user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(SiteUser, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_site_user(:email => nil)
      assigns[:site_user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(SiteUser, :count)
  end
  
  
  it 'activates site_user' do
    SiteUser.authenticate('aaron@example.com', 'monkey').should be_nil
    get :activate, :activation_code => site_users(:aaron).activation_code
    response.should redirect_to('/login')
    flash[:notice].should_not be_nil
    flash[:error ].should     be_nil
    SiteUser.authenticate('aaron@example.com', 'monkey').should == site_users(:aaron)
  end
  
  it 'does not activate site_user without key' do
    get :activate
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  it 'does not activate site_user with blank key' do
    get :activate, :activation_code => ''
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  it 'does not activate site_user with bogus key' do
    get :activate, :activation_code => 'i_haxxor_joo'
    flash[:notice].should     be_nil
    flash[:error ].should_not be_nil
  end
  
  def create_site_user(options = {})
    post :create, :site_user => { :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69',
      :billing_address => 'Street', :billing_area_code => '0000', :billing_city => 'City' }.merge(options)
  end
end

describe SiteUsersController do
  describe "route generation" do
    it "should route site_users's 'index' action correctly" do
      route_for(:controller => 'site_users', :action => 'index').should == "/site_users"
    end
    
    it "should route site_users's 'new' action correctly" do
      route_for(:controller => 'site_users', :action => 'new').should == "/signup"
    end
    
    it "should route {:controller => 'site_users', :action => 'create'} correctly" do
      route_for(:controller => 'site_users', :action => 'create').should == "/register"
    end
    
    it "should route site_users's 'show' action correctly" do
      route_for(:controller => 'site_users', :action => 'show', :id => '1').should == "/site_users/1"
    end
    
    it "should route site_users's 'edit' action correctly" do
      route_for(:controller => 'site_users', :action => 'edit', :id => '1').should == "/site_users/1/edit"
    end
    
    it "should route site_users's 'update' action correctly" do
      route_for(:controller => 'site_users', :action => 'update', :id => '1').should == "/site_users/1"
    end
    
    it "should route site_users's 'destroy' action correctly" do
      route_for(:controller => 'site_users', :action => 'destroy', :id => '1').should == "/site_users/1"
    end
  end
  
  # describe "route recognition" do
  #   it "should generate params for site_users's index action from GET /site_users" do
  #     params_from(:get, '/site_users').should == {:controller => 'site_users', :action => 'index'}
  #     params_from(:get, '/site_users.xml').should == {:controller => 'site_users', :action => 'index', :format => 'xml'}
  #     params_from(:get, '/site_users.json').should == {:controller => 'site_users', :action => 'index', :format => 'json'}
  #   end
  #   
  #   it "should generate params for site_users's new action from GET /site_users" do
  #     params_from(:get, '/site_users/new').should == {:controller => 'site_users', :action => 'new'}
  #     params_from(:get, '/site_users/new.xml').should == {:controller => 'site_users', :action => 'new', :format => 'xml'}
  #     params_from(:get, '/site_users/new.json').should == {:controller => 'site_users', :action => 'new', :format => 'json'}
  #   end
  #   
  #   it "should generate params for site_users's create action from POST /site_users" do
  #     params_from(:post, '/site_users').should == {:controller => 'site_users', :action => 'create'}
  #     params_from(:post, '/site_users.xml').should == {:controller => 'site_users', :action => 'create', :format => 'xml'}
  #     params_from(:post, '/site_users.json').should == {:controller => 'site_users', :action => 'create', :format => 'json'}
  #   end
  #   
  #   it "should generate params for site_users's show action from GET /site_users/1" do
  #     params_from(:get , '/site_users/1').should == {:controller => 'site_users', :action => 'show', :id => '1'}
  #     params_from(:get , '/site_users/1.xml').should == {:controller => 'site_users', :action => 'show', :id => '1', :format => 'xml'}
  #     params_from(:get , '/site_users/1.json').should == {:controller => 'site_users', :action => 'show', :id => '1', :format => 'json'}
  #   end
  #   
  #   it "should generate params for site_users's edit action from GET /site_users/1/edit" do
  #     params_from(:get , '/site_users/1/edit').should == {:controller => 'site_users', :action => 'edit', :id => '1'}
  #   end
  #   
  #   it "should generate params {:controller => 'site_users', :action => update', :id => '1'} from PUT /site_users/1" do
  #     params_from(:put , '/site_users/1').should == {:controller => 'site_users', :action => 'update', :id => '1'}
  #     params_from(:put , '/site_users/1.xml').should == {:controller => 'site_users', :action => 'update', :id => '1', :format => 'xml'}
  #     params_from(:put , '/site_users/1.json').should == {:controller => 'site_users', :action => 'update', :id => '1', :format => 'json'}
  #   end
  #   
  #   it "should generate params for site_users's destroy action from DELETE /site_users/1" do
  #     params_from(:delete, '/site_users/1').should == {:controller => 'site_users', :action => 'destroy', :id => '1'}
  #     params_from(:delete, '/site_users/1.xml').should == {:controller => 'site_users', :action => 'destroy', :id => '1', :format => 'xml'}
  #     params_from(:delete, '/site_users/1.json').should == {:controller => 'site_users', :action => 'destroy', :id => '1', :format => 'json'}
  #   end
  # end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route site_users_path() to /site_users" do
      site_users_path().should == "/site_users"
      formatted_site_users_path(:format => 'xml').should == "/site_users.xml"
      formatted_site_users_path(:format => 'json').should == "/site_users.json"
    end
    
    it "should route new_site_user_path() to /site_users/new" do
      new_site_user_path().should == "/site_users/new"
      formatted_new_site_user_path(:format => 'xml').should == "/site_users/new.xml"
      formatted_new_site_user_path(:format => 'json').should == "/site_users/new.json"
    end
    
    it "should route site_user_(:id => '1') to /site_users/1" do
      site_user_path(:id => '1').should == "/site_users/1"
      formatted_site_user_path(:id => '1', :format => 'xml').should == "/site_users/1.xml"
      formatted_site_user_path(:id => '1', :format => 'json').should == "/site_users/1.json"
    end
    
    it "should route edit_site_user_path(:id => '1') to /site_users/1/edit" do
      edit_site_user_path(:id => '1').should == "/site_users/1/edit"
    end
  end
  
end

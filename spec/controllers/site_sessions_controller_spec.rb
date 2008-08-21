require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe SiteSessionsController do
  fixtures        :site_users
  before do 
    @site_user  = mock_site_user
    @login_params = { :email => 'quentin@example.com', :password => 'test' }
    SiteUser.stub!(:authenticate).with(@login_params[:email], @login_params[:password]).and_return(@site_user)

    home_page = Page.create!(
      :title => "Home Page",
      :breadcrumb => "Home Page",
      :slug => "/",
      :status => Status[:published],
      :published_at => Time.now.to_s(:db)
    )
    LoginPage.create
  end
  def do_create
    post :create, @login_params
  end
  describe "on successful login," do
    [ [:nil,       nil,            nil],
      [:expired,   'valid_token',  15.minutes.ago],
      [:different, 'i_haxxor_joo', 15.minutes.from_now], 
      [:valid,     'valid_token',  15.minutes.from_now]
        ].each do |has_request_token, token_value, token_expiry|
      [ true, false ].each do |want_remember_me|
        describe "my request cookie token is #{has_request_token.to_s}," do
          describe "and ask #{want_remember_me ? 'to' : 'not to'} be remembered" do 
            before do
              @ccookies = mock('cookies')
              controller.stub!(:cookies).and_return(@ccookies)
              @ccookies.stub!(:[]).with(:auth_token).and_return(token_value)
              @ccookies.stub!(:delete).with(:auth_token)
              @ccookies.stub!(:[]=)
              @site_user.stub!(:remember_me) 
              @site_user.stub!(:refresh_token) 
              @site_user.stub!(:forget_me)
              @site_user.stub!(:remember_token).and_return(token_value) 
              @site_user.stub!(:remember_token_expires_at).and_return(token_expiry)
              @site_user.stub!(:remember_token?).and_return(has_request_token == :valid)
              if want_remember_me
                @login_params[:remember_me] = '1'
              else 
                @login_params[:remember_me] = '0'
              end
            end
            it "kills existing login"        do controller.should_receive(:logout_keeping_session!); do_create; end
            it "authorizes me"               do do_create; controller.should be_authorized;   end    
            it "logs me in"                  do do_create; controller.should be_site_user_logged_in end    
            it "sets/resets/expires cookie"  do controller.should_receive(:handle_remember_cookie!).with(want_remember_me); do_create end
            it "sends a cookie"              do controller.should_receive(:send_remember_cookie!);  do_create end
            it 'redirects to the home page'  do do_create; response.should redirect_to('/')   end
            it "does not reset my session"   do controller.should_not_receive(:reset_session).and_return nil; do_create end # change if you uncomment the reset_session path
            if (has_request_token == :valid)
              it 'does not make new token'   do @site_user.should_not_receive(:remember_me);   do_create end
              it 'does refresh token'        do @site_user.should_receive(:refresh_token);     do_create end 
              it "sets an auth cookie"       do do_create;  end
            else
              if want_remember_me
                it 'makes a new token'       do @site_user.should_receive(:remember_me);       do_create end 
                it "does not refresh token"  do @site_user.should_not_receive(:refresh_token); do_create end
                it "sets an auth cookie"       do do_create;  end
              else 
                it 'does not make new token' do @site_user.should_not_receive(:remember_me);   do_create end
                it 'does not refresh token'  do @site_user.should_not_receive(:refresh_token); do_create end 
                it 'kills site_user token'        do @site_user.should_receive(:forget_me);         do_create end 
              end
            end
          end # inner describe
        end
      end
    end
  end
  
  describe "on failed login" do
    before do
      SiteUser.should_receive(:authenticate).with(anything(), anything()).and_return(nil)
      login_as :quentin
    end
    it 'logs out keeping session'   do controller.should_receive(:logout_keeping_session!); do_create end
    it 'flashes an error'           do do_create; flash[:error].should =~ /Couldn't log you in as 'quentin@example.com'/ end
    it "doesn't log me in"          do do_create; controller.should_not be_site_user_logged_in end
    it "doesn't send password back" do 
      @login_params[:password] = 'FROBNOZZ'
      do_create
      response.should_not have_text(/FROBNOZZ/i)
    end
  end

  describe "on signout" do
    def do_destroy
      get :destroy
    end
    before do 
      login_as :quentin
    end
    it 'logs me out'                   do controller.should_receive(:logout_killing_session!); do_destroy end
    it 'redirects me to the home page' do do_destroy; response.should be_redirect     end
  end
  
end

describe SiteSessionsController do
  describe "route generation" do
    it "should route the create site_sessions correctly" do
      route_for(:controller => 'site_sessions', :action => 'create').should == "/site_session"
    end
    it "should route the destroy site_sessions action correctly" do
      route_for(:controller => 'site_sessions', :action => 'destroy').should == "/logout"
    end
  end
  
  describe "route recognition" do
    xit "should generate params from POST /site_session correctly" do
      params_from(:post, '/site_session').should == {:controller => 'site_sessions', :action => 'create'}
    end
    xit "should generate params from DELETE /site_session correctly" do
      params_from(:delete, '/logout').should == {:controller => 'site_sessions', :action => 'destroy'}
    end
  end
  
end

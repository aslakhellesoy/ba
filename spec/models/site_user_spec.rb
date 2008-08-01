# -*- coding: mule-utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe SiteUser do
  fixtures :site_users

  describe 'being created' do
    before do
      @site_user = nil
      @creating_site_user = lambda do
        @site_user = create_site_user
        violated "#{@site_user.errors.full_messages.to_sentence}" if @site_user.new_record?
      end
    end
    
    it 'increments SiteUser#count' do
      @creating_site_user.should change(SiteUser, :count).by(1)
    end

    it 'initializes #activation_code' do
      @creating_site_user.call
      @site_user.reload
      @site_user.activation_code.should_not be_nil
    end

    it 'starts in pending state' do
      @creating_site_user.call
      @site_user.reload
      @site_user.should be_pending
    end
  end

  #              
  # Validations
  #
 
  it 'requires login' do
    lambda do
      u = create_site_user(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(SiteUser, :count)
  end

  it 'requires password' do
    lambda do
      u = create_site_user(:password => nil)
      u.errors.on(:password).should_not be_nil
    end.should_not change(SiteUser, :count)
  end

  it 'requires password confirmation' do
    lambda do
      u = create_site_user(:password_confirmation => nil)
      u.errors.on(:password_confirmation).should_not be_nil
    end.should_not change(SiteUser, :count)
  end

  it 'requires email' do
    lambda do
      u = create_site_user(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(SiteUser, :count)
  end

  describe 'allows legitimate emails:' do
    ['foo@bar.com', 'foo@newskool-tld.museum', 'foo@twoletter-tld.de', 'foo@nonexistant-tld.qq',
     'r@a.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail.com',
     'hello.-_there@funnychar.com', 'uucp%addr@gmail.com', 'hello+routing-str@gmail.com',
     'domain@can.haz.many.sub.doma.in', 
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_site_user(:email => email_str)
          u.errors.on(:email).should     be_nil
        end.should change(SiteUser, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate emails' do
    ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
     'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
     'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
     # these are technically allowed but not seen in practice:
     'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_site_user(:email => email_str)
          u.errors.on(:email).should_not be_nil
        end.should_not change(SiteUser, :count)
      end
    end
  end

  describe 'allows legitimate names:' do
    ['Andre The Giant (7\'4", 520 lb.) -- has a posse', 
     '', '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_site_user(:name => name_str)
          u.errors.on(:name).should     be_nil
        end.should change(SiteUser, :count).by(1)
      end
    end
  end
  describe "disallows illegitimate names" do
    ["tab\t", "newline\n",
     '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
     ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_site_user(:name => name_str)
          u.errors.on(:name).should_not be_nil
        end.should_not change(SiteUser, :count)
      end
    end
  end

  it 'resets password' do
    site_users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    SiteUser.authenticate('quentin@example.com', 'new password').should == site_users(:quentin)
  end

  it 'does not rehash password' do
    site_users(:quentin).update_attributes(:email => 'quentin2@example.com')
    SiteUser.authenticate('quentin2@example.com', 'monkey').should == site_users(:quentin)
  end

  #
  # Authentication
  #

  it 'authenticates site_user' do
    SiteUser.authenticate('quentin@example.com', 'monkey').should == site_users(:quentin)
  end

  it "doesn't authenticates site_user with bad password" do
    SiteUser.authenticate('quentin@example.com', 'monkey').should == site_users(:quentin)
  end

 if REST_AUTH_SITE_KEY.blank? 
   # old-school passwords
   it "authenticates a site_user against a hard-coded old-style password" do
     SiteUser.authenticate('old_password_holder@example.com', 'test').should == site_users(:old_password_holder)
   end
 else
   it "doesn't authenticate a site_user against a hard-coded old-style password" do
     SiteUser.authenticate('old_password_holder@example.com', 'test').should be_nil
   end

   # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
   desired_encryption_expensiveness_ms = 0.1
   it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
     test_reps = 100
     start_time = Time.now; test_reps.times{ SiteUser.authenticate('quentin@example.com', 'monkey'+rand.to_s) }; end_time   = Time.now
     auth_time_ms = 1000 * (end_time - start_time)/test_reps
     auth_time_ms.should > desired_encryption_expensiveness_ms
   end
 end

  #
  # Authentication
  #

  it 'sets remember token' do
    site_users(:quentin).remember_me
    site_users(:quentin).remember_token.should_not be_nil
    site_users(:quentin).remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    site_users(:quentin).remember_me
    site_users(:quentin).remember_token.should_not be_nil
    site_users(:quentin).forget_me
    site_users(:quentin).remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    site_users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    site_users(:quentin).remember_token.should_not be_nil
    site_users(:quentin).remember_token_expires_at.should_not be_nil
    site_users(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    site_users(:quentin).remember_me_until time
    site_users(:quentin).remember_token.should_not be_nil
    site_users(:quentin).remember_token_expires_at.should_not be_nil
    site_users(:quentin).remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    site_users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    site_users(:quentin).remember_token.should_not be_nil
    site_users(:quentin).remember_token_expires_at.should_not be_nil
    site_users(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'registers passive site_user' do
    site_user = create_site_user(:password => nil, :password_confirmation => nil)
    site_user.should be_passive
    site_user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    site_user.register!
    site_user.should be_pending
  end

  it 'suspends site_user' do
    site_users(:quentin).suspend!
    site_users(:quentin).should be_suspended
  end

  it 'does not authenticate suspended site_user' do
    site_users(:quentin).suspend!
    SiteUser.authenticate('quentin@example.com', 'monkey').should_not == site_users(:quentin)
  end

  it 'deletes site_user' do
    site_users(:quentin).deleted_at.should be_nil
    site_users(:quentin).delete!
    site_users(:quentin).deleted_at.should_not be_nil
    site_users(:quentin).should be_deleted
  end

  describe "being unsuspended" do
    fixtures :site_users

    before do
      @site_user = site_users(:quentin)
      @site_user.suspend!
    end
    
    it 'reverts to active state' do
      @site_user.unsuspend!
      @site_user.should be_active
    end
    
    it 'reverts to passive state if activation_code and activated_at are nil' do
      SiteUser.update_all :activation_code => nil, :activated_at => nil
      @site_user.reload.unsuspend!
      @site_user.should be_passive
    end
    
    it 'reverts to pending state if activation_code is set and activated_at is nil' do
      SiteUser.update_all :activation_code => 'foo-bar', :activated_at => nil
      @site_user.reload.unsuspend!
      @site_user.should be_pending
    end
  end

protected
  def create_site_user(options = {})
    record = SiteUser.new({ :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end

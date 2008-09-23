Feature: Account
  In order to have returning users
  As a community member
  I want to manage my own account

  Scenario: Successful change of personal info
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    When I view the account page
    And I fill in "newaddr@new.com" for "Email"
    And I press "Save"
    Then "Aslak"'s Email should be "newaddr@new.com"
    And I should see "Your account has been updated"

  Scenario: Failed change of personal info
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    When I view the account page
    And I fill in "gibberish" for "Email"
    And I press "Save"
    Then "Aslak"'s Email should be "aslak@test.com"
    And I should see "The Email address should look like an email address."
    
  Scenario: Receive reset password email
    Given an "active" site_user named "Aslak" exists
    When I view the forgot password page
    And I fill in "aslak@test.com" for "Email"
    And I press "Send me a reset link"
    Then "aslak@test.com" should receive an email with reset code/

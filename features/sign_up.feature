Feature: Sign up
  In order to learn more
  As a passionate individual
  I want to sign up for a conference

  Scenario: New user
    Given "Johannes" is signed up for "Beerfest"
    Then I should see "You are registered, Johannes"

  Scenario: Receive confirmation email
    Given "Johannes" is signed up for "Beerfest"
    Then "Johannes" should receive an email with "Hi, Johannes"

  Scenario: From email link, good password
    Given I am logged out
    And a "pending" site_user named "Aslak" exists
    And there is a "Beerfest" happening page with parts
    When I follow the "Beerfest" signup link for "Aslak"
    And I fill in "greatpass" for "Choose Password"
    And I fill in "greatpass" for "Confirm password"
    And I press "Sign up"
    Then I should see "You are registered, Aslak"
    And the site_user named "Aslak" should be "active"

  Scenario: From email link, no password
    Given I am logged out
    And a "pending" site_user named "Aslak" exists
    And there is a "Beerfest" happening page with parts
    When I follow the "Beerfest" signup link for "Aslak"
    And I press "Sign up"
    Then I should see "can't be blank"
    And the site_user named "Aslak" should be "pending"

  Scenario: Existing attendance, logged out, correct password
    Given "Johannes" is signed up for "Beerfest"
    And I am logged out
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    Then I should see "The Email address has already been taken"

  Scenario: Existing attendance, logged in
    Given "Aslak" is signed up for "Beerfest"
    When I view the "Beerfest" signup page
    Then I should see "You are registered, Aslak"

  # tags: barcode_reg
  Scenario: Existing attendance, logged in
    Given "Aslak" is signed up for "Beerfest"
    When I view the "Beerfest" signup page
    And I follow "Print my ticket"
    Then I should receive a application/pdf representation

  Scenario: New site user, bad password confirmation
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I fill in "otherpass" for "Confirm password"
    And I press "Sign up"
    Then I should see "doesn't match confirmation"
    And I should see "Please sign up below"

  Scenario: Not using promotion code
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "10" promotion codes "CHEAP" at "NOK" "150"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    Then I should see "You are registered, Johannes"
    And I should see "We will send you an invoice of NOK 250 later."

  Scenario: Using promotion code
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "10" promotion codes "CHEAP" at "NOK" "150"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I fill in "CHEAP" for "Price code"
    And I press "Sign up"
    Then I should see "You are registered, Johannes"
    And I should see "We will send you an invoice of NOK 150 later."

  Scenario: Adding promotion code after signup
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "10" promotion codes "CHEAP" at "NOK" "150"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    And I go to "/beerfest/attendance"
    And I fill in "CHEAP" for "Price code"
    And I press "Save"
    Then I should see "We will send you an invoice of NOK 150 later."

  Scenario: Using bad promotion code
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I fill in "BAD" for "Price code"
    And I press "Sign up"
    Then I should see "No such price code"

  Scenario: Using unavailable promotion code
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "0" promotion codes "CHEAP" at "NOK" "150"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I fill in "CHEAP" for "Price code"
    And I press "Sign up"
    Then I should see "no longer available"

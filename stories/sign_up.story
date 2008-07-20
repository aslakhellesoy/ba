Story: Sign up
  In order to learn and improve my position in the marketplace
  As a passionate individual
  I want to sign up for a conference

  Scenario: New user
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    Then I should see "You are registered, Johannes"

  Scenario: Logged in (from email link)
    Given a user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    When I view the "Beerfest" signup page
    And I press "Sign up"
    Then I should see "You are registered, Aslak"

  Scenario: Existing attendance, logged out
    Given a user named "Johannes" exists
    And I am logged out
    And there is a "Beerfest" happening page with parts
    And "Johannes" is signed up for "Beerfest"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    Then I should see "You are already registered, Johannes"

  Scenario: Existing attendance, logged in
    Given a user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I view the "Beerfest" signup page
    Then I should see "You are already registered, Aslak"

  Scenario: New user, bad password confirmation
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I fill in "otherpass" for "Confirm password"
    And I press "Sign up"
    Then I should see "Password must match confirmation"
    And I should see "Please sign up below"

  Scenario: Not using promotion code
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "10" promotion codes "CHEAP" at "NOK" "150"
    And "Beerfest" has "unlimited" promotion codes "" at "NOK" "250"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    Then I should see "You are registered, Johannes"
    And I should see "You will receive an invoice with NOK 250"

  Scenario: Using promotion code
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "10" promotion codes "CHEAP" at "NOK" "150"
    And "Beerfest" has "unlimited" promotion codes "" at "NOK" "250"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I fill in "CHEAP" for "Price code"
    And I press "Sign up"
    Then I should see "You are registered, Johannes"
    And I should see "You will receive an invoice with NOK 150"

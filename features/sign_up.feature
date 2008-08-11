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

  Scenario: Receive confirmation email
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
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
    Given an "active" site_user named "Johannes" exists
    And I am logged out
    And there is a "Beerfest" happening page with parts
    And "Johannes" is signed up for "Beerfest"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    Then I should see "The email address is already registered."

  Scenario: Existing attendance, logged in
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I view the "Beerfest" signup page
    Then I should see "You are registered, Aslak"

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
    And "Beerfest" has "unlimited" promotion codes "" at "NOK" "250"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I press "Sign up"
    Then I should see "You are registered, Johannes"
    And I should see "We will send you an invoice of NOK 250 later."

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
    And I should see "We will send you an invoice of NOK 150 later."

  Scenario: Using bad promotion code
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "10" promotion codes "CHEAP" at "NOK" "150"
    And "Beerfest" has "unlimited" promotion codes "" at "NOK" "250"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Johannes"
    And I fill in "BAD" for "Price code"
    And I press "Sign up"
    Then I should see "No such price code"

  Scenario: Submitting talk proposal
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    And "Beerfest" has "10" promotion codes "CHEAP" at "NOK" "150"
    And "Beerfest" has "unlimited" promotion codes "" at "NOK" "250"
    When I view the "Beerfest" signup page
    And I fill in personal info for "Aslak"
    And I check "Add a presentation proposal"
    And I fill in "How to make Bearnaise" for "Title"
    And I fill in "Best sauce in the world" for "Description"
    And I press "Sign up"
    Then I should see "How to make Bearnaise"

  Scenario: Viewing talk proposal
    Given I am logged out
    And there is a "Beerfest" happening page with parts
    When I view the "Beerfest" signup page
    And I fill in personal info for "Aslak"
    And I check "Add a presentation proposal"
    And I fill in "How to make beurre blanc" for "Title"
    And I fill in "Best butter in the world" for "Description"
    And I press "Sign up"
    And the presentation "How to make beurre blanc" is in the "33" slot
    And I go to "/beerfest/presentations/how-to-make-beurre-blanc"
    Then I should see "Best butter in the world"

Story: Sign up
  In order to learn and improve my position in the marketplace
  As a passionate individual
  I want to sign up for a conference

  Scenario: New user
    Given I am logged out
    And there is a "Beerfest" happening page
    And the "Beerfest" page has a <r:signup> tag
    When I view the "Beerfest" happening page
    And I fill in personal info for "Aslak"
    And I press "Sign up"
    Then I should be see "You are registered for Beerfest."

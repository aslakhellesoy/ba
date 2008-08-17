Feature: Submit proposal
  In order to position myself in the marketplace
  As an individual with expericnec
  I want to submit talk proposals for a conference

  Scenario: Successful proposal submission
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I fill in "How to make Bearnaise" for "Title"
    And I fill in "Best sauce in the world" for "Body"
    And I press "Save"
    Then I should see "How to make Bearnaise"

  Scenario: Failed proposal submission
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I fill in "How to make Bearnaise" for "Title"
    And I press "Save"
    Then I should see "Body can't be blank"

  Scenario: Viewing talk proposal
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I fill in "How to make Bearnaise" for "Title"
    And I fill in "Best sauce in the world" for "Body"
    And I press "Save"
    And the presentation "How to make Bearnaise" is in the "33" slot
    And I go to "/beerfest/presentations/how-to-make-bearnaise"
    Then I should see "Best sauce in the world"

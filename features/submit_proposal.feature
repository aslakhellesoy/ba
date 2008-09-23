Feature: Submit presentation
  In order to position myself in the marketplace
  As an individual with experience
  I want to submit presentation proposals for a conference

  Scenario: Successful presentation submission
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I follow "Register new talk"
    And I fill in "How to make Bearnaise" for "Title"
    And I fill in "Best sauce in the world" for "Body"
    And I press "Save"
    Then I should see "How to make Bearnaise"

  Scenario: Failed presentation submission
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I follow "Register new talk"
    And I fill in "How to make Bearnaise" for "Title"
    And I press "Save"
    Then I should see "Body can't be blank"

  Scenario: Change existing presentation
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I follow "Register new talk"
    And I fill in "How to make Bearnaise" for "Title"
    And I fill in "Best sauce in the world" for "Body"
    And I press "Save"
    And I follow "How to make Bearnaise"
    And I fill in "How to make Hollandaise" for "Title"
    And I press "Save"
    Then I should see "How to make Hollandaise"
    And I should not see "How to make Bearnaise"

  Scenario: Viewing published presentation
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I follow "Register new talk"
    And I fill in "How to make Bearnaise" for "Title"
    And I fill in "Best sauce in the world" for "Body"
    And I press "Save"
    And the presentation "How to make Bearnaise" is in the "33" slot
    And I go to "/beerfest/presentations/how-to-make-bearnaise"
    Then I should see "Best sauce in the world"

  Scenario: Add Web 2.0 tags to presentation
    Given an "active" site_user named "Aslak" exists
    And I am logged in as "Aslak"
    And there is a "Beerfest" happening page with parts
    And "Aslak" is signed up for "Beerfest"
    When I visit the "Beerfest" my-page
    And I follow "Register new talk"
    And I fill in "How to make Bearnaise" for "Title"
    And I fill in "Best sauce in the world" for "Body"
    And I check "Project Manager"
    And I check "Product Owner"
    And I select "Advanced" from "Level"
    And I press "Save"
    Then the tags for "How to make Bearnaise" should be "advanced productowner projectmanager"
    
  Scenario: Upload presentation materials to presentation
    GivenScenario: Successful presentation submission
    When I visit the "Beerfest" my-page
    And I follow "How to make Bearnaise"
    And I attach "vendor/extensions/ba/ba_extension.rb" for "Presentation"
    And I press "Save"
    Then Page "How to make Bearnaise" should have one attachment named "ba_extension.rb"
    
  Scenario: Re-Upload presentation materials to presentation
    GivenScenario: Upload presentation materials to presentation
    When I visit the "Beerfest" my-page
    And I follow "How to make Bearnaise"
    And I attach "vendor/extensions/ba/README.textile" for "Presentation"
    And I press "Save"
    Then Page "How to make Bearnaise" should have one attachment named "README.textile"

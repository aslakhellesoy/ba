Story: Create Program
  In order to market my conference
  As a conference organiser
  I want to publish the program

  Scenario: No presentations
    Given there is a "Beerfest" happening page with parts
    And there is a simple "Day 1" program for "Beerfest"
    When I go to "/beerfest/day-1"
    Then I should see "TBA"

  Scenario: Two presentations
    Given there is a "Beerfest" happening page with parts
    And there is a simple "Day 1" program for "Beerfest"
    And there is a "Cats" presentation in "Beerfest" slot "1"
    And there is a "Dogs" presentation in "Beerfest" slot "2"
    When I go to "/beerfest/day-1"
    Then I should see "Cats"
    Then I should see "Dogs"

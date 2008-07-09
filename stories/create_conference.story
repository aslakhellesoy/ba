Story: Create conference
  In order to market a conference
  As an organiser of a conference
  I want to create a new conference page

  Scenario: Display details with hCal tag
    Given I am logged in
    And there is a "Smidig2008" page
    And I am editing the "Smidig2008" page
    When I add a hCal tag to the body text
    And I view the "Smidig2008" page
    Then the page should display the conference details as hCal

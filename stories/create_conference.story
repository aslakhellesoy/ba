Story: Create conference
  In order to market a conference
  As an organiser of a conference
  I want to create a new conference page

  Scenario: Display details with hCal tag
    Given I am logged in
    And there is a "Smidig2008" happening page with parts
    When I view the "Smidig2008" main page
    Then the page should display the conference details as hCal

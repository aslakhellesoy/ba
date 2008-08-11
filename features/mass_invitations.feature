Feature: Mass invitation
  In order to attract as many people as possible to my happening
  I as an organizer
  Want to send out invitations to a bunch of people
  
  Scenario: Some of the users
    Given a "pending" site_user named "Trond" exists
    And a "pending" site_user named "Johannes" exists
    And a "pending" site_user named "Sarah" exists
    And a "pending" site_user named "OleMorten" exists
    And I am logged into Radiant
    And I am on the mass mailing page
    When I fill in "aslak.hellesoy@gmail.com" for "From"
    When I fill in "Invitation to Smdig 2008" for "Subject"
    And I fill in "Sign up at http://smidig.no/s2008/attendance?activation_code=<r:ba:email:site_user:activation_code />" for "Body"
    And I check "Trond"
    And I check "Sarah"
    And I press "Send"
    Then "Sarah" should receive an email with activation code
    And "Johannes" should not receive any emails
Feature: Invite
  So that more people can join the site
  Signed up users
  Can invite others by email

  Scenario: Unauthenticated Invite
    Given I am not authenticated
    When I go to /invites/new
    Then the invite request should fail

  Scenario: Successful Invite
    Given I am authenticated
    And "friend@email.com" has not been invited
    When I go to /invites/new
    And I fill in "their email" with "friend@email.com"
    And I press "Invite Them!"
    Then I should see a notice message

  Scenario: No Double Invites
    Given I am authenticated
    And "friend@email.com" has been invited
    When I go to /invites/new
    And I fill in "their email" with "friend@email.com"
    And I press "Invite Them!"
    Then I should see an error message

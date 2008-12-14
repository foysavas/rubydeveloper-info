Feature: Profile
  So that the site can be used to display personal and professional information
  Users of the site
  Are able to maintain a public profile

  Scenario: Viewing profiles
    Given there are users
    When I go to /users/1
    Then I should see user profile "1"

  Scenario: Editing you profile
    Given there are users
    And I am authenticated
    When I go to /
    And I follow "account"
    Then I should see "Edit Your Profile"

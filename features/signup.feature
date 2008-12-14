Feature: Signup
  To keep the site meaningful
  A visitor of the site
  May only signup with an invite code or when there are no other users

  Scenario: First Signup
    Given there are no users
    When I go to /users/new
    And I fill in "email" with "first@gmail.com"
    And I fill in "password" with "password"
    And I fill in "confirm password" with "password"
    And I press "sign me up"
    And I should be logged in
    And I should see a notice message

  Scenario: No Invite Signup
    Given there are users
    When I go to /users/new
    And I fill in "email" with "first@gmail.com"
    And I fill in "password" with "password"
    And I fill in "confirm password" with "password"
    And I press "sign me up"
    And I should see an error message

  Scenario: Wrong Inivite Signup
    Given there are users
    When I go to /users/new
    And I fill in "invite_code" with "XYZ01"
    And I fill in "email" with "first@gmail.com"
    And I fill in "password" with "password"
    And I fill in "confirm password" with "password"
    And I press "sign me up"
    And I should see an error message

  Scenario: Good Invite Signup
    Given there are users
    And I have been invited
    When I go to /users/new
    And I fill in my invite code
    And I fill in "email" with "first@gmail.com"
    And I fill in "password" with "password"
    And I fill in "confirm password" with "password"
    And I press "sign me up"
    And I should see an notice message
    And I should be logged in

  Scenario: Used Invite Signup
    Given there are users
    And I have a used invite code
    When I go to /users/new
    And I fill in my invite code
    And I fill in "email" with "first@gmail.com"
    And I fill in "password" with "password"
    And I fill in "confirm password" with "password"
    And I press "sign me up"
    And I should see an error message

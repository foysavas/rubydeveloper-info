Feature: Contributions
  So that visitor can confirm contributors to major projects
  The profiles of users of the site
  Should automatically display contribution to projects

  Scenario: User is a contributor
    Given a user is contributor to "Merb"
    When I look at the user's profile
    Then I should see "Contributor to Merb"

  Scenario: User is not a contributor
    Given a user is not a contributor to "Rails"
    When I look at the user's profile
    Then I should not see "Contributor to Rails" 

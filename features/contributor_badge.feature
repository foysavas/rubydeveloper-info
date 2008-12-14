Feature:
  So that visitor can confirm contributors to major projects
  The profiles of users of the site
  Should automatically display contributor badges

  Scenario: I'm a contributor
    Given I am authenticated
    And I am a contributor to "Merb"
    When I look at my profile
    Then I should be shown as a "Merb" contributor

  Scenario: I'm not a contributor
    Given I am authenticated
    And I am not a contributor to "Rails"
    When I look at my profile
    Then I should not be shown as a "Rails" contributor

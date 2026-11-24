Feature: Profile Access
    As a user
    I want to be able to open my profile easily
    So that I can keep track of my achievements and my streak

    Scenario: Accessing Profile
    Given I am a registered user
    And I have logged into the app
    When I want to view my profile
    Then I should have a menu option to access my profile

    Scenario: Profile Information
    Given I am viewing my profile
    Then I should see information about my achievements, friends list, study streak and progress

    Scenario: Viewing Achievements
    Given I am viewing my profile
    When I navigate to the achievements section
    Then I should see a list of all the achievements I have unlocked
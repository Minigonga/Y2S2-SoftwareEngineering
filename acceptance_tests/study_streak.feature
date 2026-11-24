Feature: Study Streak Tracking
    As a user
    I want to maintain a record of my consecutive days of study (study streak)
    So that I can get motivated and recognized for my effort

    Scenario: Tracking Study Streak
    Given I am a registered user
    And I have logged into the app
    When I open the app
    And I open my profile
    Then I should see my current study streak displayed

    Scenario: Continuing Study Streak
    Given I have logged into the app 
    And I have a study streak of n days
    When I study on consecutive days
    Then my study streak should increase by one day

    Scenario: Missed a Day of Study
    Given I have logged into the app
    And I have a study streak of n days
    When I miss a day of study
    And I have no streak savers
    Then my study streak should reset to zero
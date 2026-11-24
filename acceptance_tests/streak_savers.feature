Feature: Streak Savers for Study Motivation
    As a user 
    I want to be able to get streak savers when I reach some achievements
    So that I don't lose all my streak progress and therefore lose motivation if I don't study for one day

    Scenario: Earning Streak Savers
    Given I am a registered user
    And I have completed specific missions/achievements as defined by the system
    When I successfully complete these missions/achievements
    Then I should earn streak savers as rewards

    Scenario: Applying Streak Savers
    Given I am a registered user
    And I have earned streak savers through completing missions
    When I miss a day of studying
    Then I use a streak saver to maintain my study streak

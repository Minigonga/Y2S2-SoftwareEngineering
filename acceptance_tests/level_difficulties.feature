Feature: Progression Through Difficulty Levels
    As a user
    I want to unlock a new level of difficulty after I finish the previous one
    So that I keep progressing without losing interest or motivation

    Scenario: Progression through Levels
    Given I have select a certain unlocked quizz level
    When I complete the selected quizz level
    And I complete my highest quizz level
    And I score a pontuation higher than 70%
    Then I should be able to unlock the next level

    Scenario: Motivational Messages
    Given I have completed my most difficult level
    When I unlock the newly difficulty level
    Then I should receive motivational messages or encouragement to continue my progression and challenge myself further
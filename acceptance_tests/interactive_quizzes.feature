Feature: Interactive Quizzes
    As a user
    I want the quizzes to be made of multiple-choice questions or sentence completion exercises
    So that I can study in an interactive way

    Scenario: Completing Quizzes
    Given I am a registered user
    And I have selected a unlocked quizz level
    And I am completing the level
    Then I should be able to complete the level with completion sentence exercises or with multiple choice exercises

    Scenario: Completing Sentences
    Given I am a registered user
    And I have selected a unlocked quizz level
    And I am completing the level
    And I have to complete a sentence 
    Then I should be able to choose and select between some predefined answers my final answer

    Scenario: Multiple-Choices Questions
    Given I am a registered user
    And I have selected a unlocked quizz level
    And I am completing the level
    And I have to choose select a multiple choice 
    Then I should be able select and mark my final answer
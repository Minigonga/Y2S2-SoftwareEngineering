Feature: Selecting Quizz Levels
    As a user
    I want to be able to choose between the unlocked quizz levels
    So that I can recap every part of the previous study sessions

    Scenario: Accessing Quizz Levels
    Given I am a registered user
    And I have logged into the app
    When I select a subject
    And I navigate to the quizz section
    Then I should see a list of available quizz levels
    And I should be able so select only the unlocked ones

    Scenario: Selecting Quizz Level
    Given I am viewing the list of available quiz levels for a subject
    When I select a specific unlocked quizz level
    Then I should be directed to the quizz interface for that level

    Scenario: Taking Quizz at Selected Level
    Given I am in the quizz interface for a selected level
    When I start the quizz
    Then I should be presented with questions relevant to the chosen level of study

    Scenario: Reviewing Unlocked Quiz Levels
    Given I have unlocked multiple quizz levels for a subject
    When I want to review previous levels
    Then I should have the option to choose any unlocked level for recap purposes
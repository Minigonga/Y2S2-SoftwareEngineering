Feature: Quick Subject Selection
    As a user
    I want to be able to easily select and switch my desired subject in a quick move
    So that I don't lose a lot of studying time

    Scenario: Viewing Subject Options
    Given I am on the initial screen
    Then I should see all my subjects displayed in a order manner

    Scenario: Selecting a Subject
    Given I am on the initial screen
    When I choose a subject
    Then I should be directed to the flashcards or quizzes for the selected subject without any additional steps or delays

    Scenario: Quick Subject Switching
    Given I am taking a quizz for a specific subject
    When I want to switch to another subject
    Then I should be able to switch subjects by quitting the quizz and select the desired subject
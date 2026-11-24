Feature: Subject Organization
    As a user
    I want to open the app and see all my subjects
    So that I can choose them in an organized manner

    Scenario: Viewing All Subjects
    Given I am a registered user
    And I have logged into the app
    When I open the app
    Then I should see a list of all my subjects displayed

    Scenario: Subject Information
    Given I am viewing the list of all my subjects
    When I tap on a specific subject
    Then I should be able to view more information about that subject (quizz levels and flashcards)

Feature: Subject Quizzes 
    As a user
    I want to be able to study any subject using quizzes
    So that I can test myself and improve my weaknesses

    Scenario: Accessing Quizzes
    Given I am a registered user
    And I have logged into the app
    When I select any subject to study
    And I select the quizzes section
    Then I should see a list of quizz levels available

    Scenario: Selecting a Quizz
    Given I am viewing the list of available quizzes for a subject
    When I select a quizz 
    Then I should be directed to the quizz interface

    Scenario: Taking the Quizz
    Given I am in the quizz interface
    When I start the quizz
    Then I should be presented with a series of questions related to the chosen subject

    Scenario: Answering Quizz Questions
    Given I am taking a quizz
    When I am presented with a question
    Then I should select my answer from multiple choices or choose between predefined answers in case of completion exercises

    Scenario: Receiving Feedback
    Given I have completed a quizz
    When I finish answering all the questions
    Then I should receive immediate feedback on my performance, including the number of correct and incorrect answers

    Scenario: Reviewing Quiz Results
    Given I have completed a quizz
    When I review my quizz results
    Then I should see a detailed breakdown of my performance, including which questions I answered correctly and incorrectly
Feature: Flashcards for Subject Study
    As a user
    I want to be able to study all of my subjects using flashcards
    So that I can improve my theoretical knowledge

    Scenario: Accessing Flashcards
    Given I am a registered user
    And I have logged into the app
    When I select any subject to study
    And I select the flashcards section
    Then I should see a list of flashcards available

    Scenario: Selecting Flashcards
    Given I am a registered user
    And I have logged into the app
    When I select any subject to study
    And I select the flashcards section
    Then I should be able to select flashcards of every subject's topic

    Scenario: Using Flashcards
    Given I am a registered user
    And I have logged into the app
    When I select any subject to study
    And I select the flashcards section
    And I select the flashcard topic
    Then I should be able to see information about that topic 
    And I should be able to go to the next and to the previos flashcard of the subject's topic
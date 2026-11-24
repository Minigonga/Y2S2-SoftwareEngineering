Feature: Topic Selection for Study Improvement
    As a user 
    I want to be able to choose a specific topic to study within a subject 
    So that I can get better at my worst topics.

    Scenario: Choosing a Specific Topic for Study
    Given I am a registered user
    And I am on the initial screen
    When I select a subject
    And I see a list of available topics within that subject
    Then I should be able to choose a specific topic to study
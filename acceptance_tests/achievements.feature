Feature: Missions and Achievements
    As a user 
    I want the app to have achievements 
    So that I get rewarded by my work and motivated to study more.

    Scenario: Viewing Missions
    Given I am a registered user
    And I have logged into the app
    When I navigate to the achievements section
    Then I should see a list of available missions to complete

    Scenario: Completing Missions
    Given I am a registered user
    And I have logged into the app
    When I fulfill the requirements of any mission
    Then I receive a notification and/or rewards for completing the mission
    And The progress towards the mission is finished 

    Scenario: Tracking Progress
    Given I am a registered user
    And I have logged into the app
    When I'm completing a mission
    Then my progress towards completing the mission should be tracked and updated accordingly the subject
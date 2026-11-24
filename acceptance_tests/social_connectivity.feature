Feature: Social Connectivity and Achievement Sharing
    As a user 
    I want to be able to have friends and share my achievements with them 
    So that I can bring more people to study with me

    Scenario: Connecting with Friends
    Given I am a registered user
    When I navigate to my profile
    And I select the my friends list
    Then I should be able to search for and connect with other users to become friends

    Scenario: Sharing Achievements
    Given I am a registered user
    And I have achieved a milestone
    When I want to share my achievement
    Then I should have the option to share it with my friends

    Scenario: Viewing Friends' Achievements
    Given I am a registered user
    And I have friends on app
    When I navigate to the friends page 
    And I select a friend's profile
    Then I should be able to view their achievements and progress

    Scenario: Sending and Receiving Messages
    Given I am a registered user
    And I am connected with friends on the app
    When I want to communicate with a friend privately
    Then I should be able to send and receive messages within the app
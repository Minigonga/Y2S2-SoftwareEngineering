Feature: Achievement Notifications
    As a user
    I want to know everytime I reach an achievement
    So that I get motivated and recognized by my efforts

    Scenario: Reaching an Achievement
    Given I am a registered user
    And I have completed every requirements for an achievement
    When I finish the last task or requirement of the achievement
    Then I should receive a notification indicating the completion

    Scenario: Notification Content
    Given I receive a notification for completing the requirements for the achievement
    Then the notification should include details about the achievement, such as its name or description

    Scenario: Celebrating Achievement
    Given I receive a notification for a new achievement
    Then the notification should include congratulatory messages or visual elements to celebrate my accomplishment

    Scenario: Sharing Achievements
    Given I reach a new achievement
    And I want to share my achievement with others
    Then I should have the option to share the my achievement with friends within the app

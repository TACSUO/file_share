Feature: Manage file attachments

  Scenario: update file description  
    Given there is 1 existing file
    And I am on the homepage
    When I follow "update"
    And I fill in "file_attachment[description]" with "Description for somefile.txt"
    And I press "Update"
    Then I should see "Description for somefile.txt"
    And I should be on the file attachments page

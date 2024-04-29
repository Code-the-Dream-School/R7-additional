Testing validates that the application does what it is supposed to do. Also, applications change over time as new features are added. It is very easy to break an application by making changes. Automated testing can ensure that such breaks are rare.

Often, the tests are written before the application code. This is called test driven development. The code can then be tested as it is being written.

The ability to do automated testing is a valuable skill with potential employers. Sometimes you can get hired to create automated tests before moving up to development.

RSpec is the most common tool for testing Rails applications.

## Some Test Types

Model testing: Tests that models validate as they should, and that all methods work.

Request testing: Tests that the controller does what it should, either for processing HTTP requests or for API endpoints

Feature testing: Feature testing for a web application actually executes browser operations, entering data in fields, clicking on buttons, and checking the screens that come back. This is complicated to set up, so we won’t work on it in this lesson. However, feature testing is very important for the end product.

System testing: End-to-end testing of the application

## Some References on RSpec Testing: Recommended Reading

(You don't need to go through all of these now -- these are just some references you may need to complete the lesson.)

[How to Test Rails Models with RSpec – Semaphore](https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-rspec) (very basic and easy to follow)

<https://www.rubyguides.com/2018/07/rspec-tutorial/> (This one’s about testing in ruby, not so much about rails)

<https://www.sitepoint.com/learn-the-first-best-practices-for-rails-and-rspec/> (A comprehensive tutorial. There are references to FactoryGirl, which has now been replaced by FactoryBot.)
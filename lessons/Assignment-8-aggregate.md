There are **four parts** to this assignment.  **Click on each Assignment title to expand the detailed instructions for that piece.** Pace yourselves and complete all four parts this week.  You will be creating another Rails application for the next series of lessons.  Your assignments will give you practice in a number of key Rails skills.  

<details>
  <summary> 
    <h2>Assignment 8A - Debugging</h2>
    </summary>
  
The first of these is debugging.  Fork and clone [this repository.](https://github.com/Code-the-Dream-School/R7-additional)  Then create a lesson8 branch, where you will do your work.

## Getting Started with a Customer App

Do ```bin/bundle install``` to install the gems needed for the repository.  We will start the quick way. (You should have forked and cloned the repository, and run bundle install.) While in your Backend-validations directory, type:

```
bin/rails generate scaffold Customer first_name:string last_name:string phone:string email:string
bin/rails db:migrate
```

Then, edit your config/routes.rb. You are probably tired of seeing the plain Rails screen when you connect your browser to the root path of your application. Right after the Rails.application.routes.draw line of your routes.rb, put the line

```
root to: 'customers#index'
```

This will configure the server to bring up this page when you connect to the root path.

## Rails Debugging

Start the rails server. Then, in the browser, go to your / URL path and try the application out. You will see that you can create customer records, edit them, show them, and delete them. Leave a few customer records in. So far, so good. However in our, now try this URL path

```
/customers/567
```

You will see the error screen that follows:

![Not found error](https://github.com/Code-the-Dream-School/R7-additional/blob/41209f64e91198d76f82a1d79a72702acab5dba0/lessons/not-found-error.png?raw=true)

So we debug, as described below.

## Now in Ruby: A Built-in Debugger

There is now a debugger built into current versions of Ruby. There is also a gemcalled debug to enable you to use the Ruby debugger in Rails. Previously, one would use a gem called Byebug, which worked much the same way. The debug gem is automatically added to the development and test section of the Gemfile when you generate a Rails instance.

## Using the Debugger

According to the error message, the problem occurs in line 67 (your line number may be slightly different) of app/controllers/customers/controller.rb. So, with our editor, we add a line that says just:

```
debugger
```

right before the failing line in that file (right after def set\_customer). Then we re-run the server, and go to the /customers/567 url to duplicate the error. The browser will appear to hang waiting on the server.

Go to your command line session where you are running the server console. You will see something like this:

![debug console](https://github.com/Code-the-Dream-School/R7-additional/blob/41209f64e91198d76f82a1d79a72702acab5dba0/lessons/debugger.png?raw=true)

## At the Debugger Prompt

You can now type into the server console session, and you can do anything you could do from the rails console, plus debugger commands. In particular, you can look at the value of variables. Type this:

```
params
```

And it will show you the value of the parameters passed to the controller. In particular, it will show “id”=>”567”. Now type:

```
Customer.all
```

and it will show you a list of the customer records you created. None of them have id 567, so that is the reason for the error. Type c and hit enter. This will allow the server to continue.

## Comments on the Debugger

This is a very short introduction to the debugger. In practice, if you are developing a real application, you will have bugs. To fix them, you will use the debugger a lot! It’s a good idea to practice with it, by putting debugger statements at various points in the code and experimenting with what you can see. You can even put debugger statements in your erb files, by adding this line:

```
<% debugger %>
```

It would be a good idea to learn more about debugging than is described in this short lesson. The commands available at the debugger prompt are described **[here.](https://www.tutorialspoint.com/ruby/ruby%5Fdebugger.htm)** Also, a reference on using the debugger in Rails is **[here.](https://guides.rubyonrails.org/debugging%5Frails%5Fapplications.html)** Have a look at these, although you do not need to go through them in detail at this time. You should now be familiar with the following command line tools: irb, which is the ruby interactive runtime; and bin/rails console, which is the rails console. Everything you can do from the rails console is can also be done in a debugger session.

Be sure to take all debugger statements out of the code before you push it to production! If the server does hit a debugger statement it will hang at that point. So take the debugger statement out of your code now.
</details>

<details>
 <summary> 
    <h2>Assignment 8B - Exception Handling</h2>
  </summary>

Stop the server. Now we want to edit ```customers_controller.rb again```. Add this line near the top of the file, right after the “class” line, but before the “before\_action” line:

```ruby
rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
```

And, add this method to the bottom of the file, right before the end that ends the class:

```ruby
def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to customers_path
end
```

## Explaining This Code

The ```rescue_from``` statement says that if an exception of the specified type occurs, call the ```catch_not_found``` method.

The Rails.logger.debug statement writes an entry to the Rails log. You will see it in the console, and it is also written to the log/development.log file.

The flash.alert statement takes the message from the exception and stores it in the flash object so that it can be displayed to the user.

The ```redirect_to``` statement puts up the index page again, so that the user does not see that other error page.

## Trying the Code Again

Now save the controller file, restart the server, and go to the /customers/567 URL again. You will see that the index page is shown, instead of the error. You will see that the “we had a not found exception” line is in the server log when you look at the console. BUT the user does not see the error message. We need to do more to make that work.

## Modifying the Layout

Edit the app/views/layouts/application.html.erb file. Add these lines, just below the <body> tag:

```
<% if flash[:alert].present? %>
    <p class="my_alert"><%= flash[:alert] %></p>
<% end %>
```

## CSS Files for Rails are in the app/assets/stylesheets Folder

Open app/assets/stylesheets/application.css. Add this CSS style rule at the bottom:

```
.my_alert {
  color: red;
}
```

This corresponds to the ```my_alert``` class that was used in the application.html.erb file. We want alerts to show in red. (You can try adding other styling if you want this application to look cool, but let’s make this work first.)

## Now Try /customers/567 Again

You will see that you are once again directed to the index page, but at the top, in red, there will be an error message:

Couldn’t find Customer with ‘id’=567

This is a much more user friendly message than before.
  
</details>

<details>
 <summary> 
    <h2>Assignment 8C - Validation</h2>
    </summary>

So far, we have talked about byebug, exception handling, logging, layouts, flash messages, and styles. Validation is next. Try this: Create several customers with blank first names or last names or phone numbers with letters in them or with email addresses that don’t have an @ sign. You will see that it just creates these nonsense entries. We wouldn’t want this in a production application. We want the entries to be validated so that they make sense.

We will use a gem called email-validator. Add this line to your Gemfile, above the development, test group:

```
gem 'email_validator'
```

Then run bundle install so that you pick up this gem.

Next, edit app/models/customer.rb. It should be changed to look like this:

```ruby
class Customer < ApplicationRecord
 validates :first_name, presence: true, format: { with: /\A[a-z\-' ]+\z/i }
 validates :last_name, presence: true, format: { with: /\A[a-z\-' ]+\z/i }
 validates :phone, presence: true
 validates :phone, numericality: { only_integer: true }
 validates :phone, length: { is: 10 }
 validates :email, presence: true, email: true

 def full_name
   "#{first_name} #{last_name}"
 end
end

```

## Explaining the Code

We have added validators, as described here: <https://guides.rubyonrails.org/active%5Frecord%5Fvalidations.html> . The presence validator means that the entry can’t be blank. The numericality validator for the phone means that only digits are accepted. The length validator for the phone means that it must be 10 digits. (Note that this would not work for other countries, as they have numbers of different lengths.) For the email, we are using the email\_validator gem. We are also using a regular expression to validate the format of the first and last name. We won’t explain regular expressions now, but they are good to learn. In this case, the expression provides a pattern that the first and last names must match.

Note: Validators do not correct entries that are already in the database. It only prevents new ones or updated ones from being incorrect.

The full\_name method is not a validator. We’ll use that for something else.

## Trying the New Validators

Restart the server with the new code, and try to create a customer record with everything blank. You will see this message:

![customer errors](https://github.com/Code-the-Dream-School/R7-additional/blob/41209f64e91198d76f82a1d79a72702acab5dba0/lessons/customer-errors.png?raw=true)

## How These Messages Come Up

When the save is attempted for the new customer object, the validators run. If any of the validations fail, the record is not written to the database. Instead, error information, including messages, is stored in the customer object, so that they can be reported to the user. Suppose the object to be saved is @customer. Then @customer.errors.full\_messages contains an array of messages about the failures.

Now look at app/views/customers/\_form.html.erb . You will see a block at the start that starts if customer.errors.any? . This is the block that displays the error messages.

This error handling is provided because we generated the scaffold for customers. You will need to know how to code error handling within your controller, which is the subject of the next section.
  
</details>

<details>
 <summary> 
    <h2>Assignment 8D - Error Handling</h2>
    </summary>

Edit ```app/controllers/customers_controller.rb```. You will see a create and an update method. We won’t explain their current contents right now, because we are going to change them. Comment all the lines out between the def and the end for the create method. Do the same for the update method.

Now in the create method, put these lines:

```ruby
@customer = Customer.new(customer_params)
@customer.save
flash.notice = "The customer record was created successfully."
redirect_to @customer
```

In the update method, put these lines:

```ruby
@customer.update(customer_params)
flash.notice = "The customer record was updated successfully."
redirect_to @customer
```

These will make the functions work, but without error processing. Now, if you try to create a customer with blank fields, it will not give error messages. It won’t actually create the record, but it will tell you that it succeeded. (By the way, the flash.notice is displayed by the line at the top of app/views/customers/index.html.erb , where it puts out the notice.)

## Checking for Errors and Handling Them

We need to get our error messages back. Basically, if @customer.save succeeds, it will return the @customer object, updated with the newly created id. If it fails, typically because validation fails, it returns nil — and then we have to handle the error. The same is true of the update function. So change those methods as follows.

## The create Method With Error Handling

```ruby
    @customer = Customer.new(customer_params)
    if @customer.save
      flash.notice = "The customer record was created successfully."
      redirect_to @customer
    else
      render :new, status: :unprocessable_entity
    end
```

## The update Method With Error Handling

```ruby
    if @customer.update(customer_params)
      flash.notice = "The customer record was updated successfully."
      redirect_to @customer
    else
      render :edit, status: :unprocessable_entity
    end
```

If @customer.save or @customer.update return non-nil values, that means they succeeded, and we can redirect back to the show page with a success message. If they return nil, we have the else processing. In that, we render the page again (put the previous screen back up), but pass the status of unprocessable\_entry, and Rails, because that status is set, displays the error that occured.

## Additional Methods in the Customer Model Class

We added a ```full_name``` method to the Customer model class. Additional methods in model classes can be convenient. This will show how. Edit ```app/views/customers/_customer.html.erb``` . Replace this:

```
  <p>
    <strong>First name:</strong>
    <%= customer.first_name %>
  </p>

  <p>
    <strong>Last name:</strong>
    <%= customer.last_name %>
  </p>
```

with this:

```
  <p>
    <strong>Full name:</strong>
    <%= customer.full_name %>
  </p>
```

Here we add the ```full_name``` method we added to the Customer model class. Now go to the /customers url and you will see the difference.

## Submitting Your Work

As usual, you add and commit your changes, and then push the lesson8 branch to github.  Then create the pull request.  You will start a new branch for the next lesson.  By the way, it is a good practice to add, commit, and push your changes after you complete each step and made it work.  Then you can't lose your work.
  
</details>

You are going to create another Rails application for the next series of lessons.  Your assignments will give you practice in a number of key Rails skills.  The first of these is debugging.  Fork and clone [this repository.](https://github.com/Code-the-Dream-School/R7-additional)  Then create a lesson8 branch, where you will do your work.

## Getting Started with a Customer App

Do ```bin/bundle install``` to install the gems needed for the repository.  We will start the quick way. (You should have forked and cloned the repository, and run bundle install.) While in your Backend-validations directory, type:

```bash
bin/rails generate scaffold Customer first_name:string last_name:string phone:string email:string
bin/rails db:migrate
```

Then, edit your config/routes.rb. You are probably tired of seeing the plain Rails screen when you connect your browser to the root path of your application. Right after the Rails.application.routes.draw line of your routes.rb, put the line

```ruby
root to: 'customers#index'
```

This will configure the server to bring up this page when you connect to the root path.

## Rails Debugging

Start the rails server. Then, in the browser, go to your / URL path and try the application out. You will see that you can create customer records, edit them, show them, and delete them. Leave a few customer records in. So far, so good. However in our, now try this URL path

```
/customers/567
```

You will see the error screen that follows:

![Not found error](/lessons/not-found-error.png)

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

![debug console](/lessons/debugger.png)

## At the Debugger Prompt

You can now type into the server console session, and you can do anything you could do from the rails console, plus debugger commands. In particular, you can look at the value of variables. Type this:

```
params
```

And it will show you the value of the parameters passed to the controller. In particular, it will show “id”=>”567”. Now type:

```ruby
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
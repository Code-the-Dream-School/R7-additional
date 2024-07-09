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

```html
<% if flash[:alert].present? %>
    <p class="my_alert"><%= flash[:alert] %></p>
<% end %>
```

## CSS Files for Rails are in the app/assets/stylesheets Folder

Open app/assets/stylesheets/application.css. Add this CSS style rule at the bottom:

```css
.my_alert {
  color: red;
}
```

This corresponds to the ```my_alert``` class that was used in the application.html.erb file. We want alerts to show in red. (You can try adding other styling if you want this application to look cool, but let’s make this work first.)

## Now Try /customers/567 Again

You will see that you are once again directed to the index page, but at the top, in red, there will be an error message:

Couldn’t find Customer with ‘id’=567

This is a much more user friendly message than before.
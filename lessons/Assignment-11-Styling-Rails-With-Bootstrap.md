In this assignment, you will use Bootstrap classes to style the application you have created. This lesson builds on the previous ones. You will use the same github repository, R7-additional, but for this lesson, you should create a new branch called lesson11. Make sure that the lesson10 branch is active when you create the lesson11 branch, so that your work adds to what you did before.

The specifications for the assignment are below. There are instructions for each part of the specification.
## Here is the specification:

1. Install and configure Bootstrap on your Rails application. Then run the server to verify that the appearance has changed.
2. Change the background to a light color.
3. Create a banner in your layout, with a title and text.
4. Add an image to your configuration, and make it the background image for your banner.
5. Add a font to your configuration, and make it the font for your banner.
6. Add a navigation bar below the banner, with pulldowns for Customers and Orders. The Customer pulldown should have the choices Customer List and New Customer. Similarly, the Orders pulldown should have the choices Order List and New Orders.
7. Add Bootstrap classes to the links and buttons within the Customers index view, so that all appear as buttons. Optionally, change all the other links and buttons within the application to have the same style. Also, style the tables using a Bootstrap class.
8. Change the Orders index view. Each Order should appear as a card within a grid. The grid should be responsive, in that if the browser window is made too narrow, the cards should stack. Each card should have as a title the product name and content that includes the customer name, the product count, and edit and delete buttons. Each card should have a border, and there should be margins to each side and above the card, and of course the edit and delete buttons should work.
9. Add Bootstrap alert divs to the layout. If these are shown, they should appear below the banner and above the navigation bar. There should be a danger one for a flash alert (if it is present) and a success one for a flash notice (if it is present.)
10. Add one or more Font Awesome glyphs.
11. Review the instructions on how to change the “are you sure” message for delete operations into a Bootstrap modal window. Optionally, complete those instructions.
12. Optionally, make any other changes you like that might make the application attractive.

## Step 1: Install and configure Bootstrap

1. Run: `bin/bundle add bootstrap`
2. Edit the Gemfile. Uncomment the line for the sassc-rails gem, and then run bundle install to make sure you have this gem.
3. Rename `app/assets/stylesheets/application.css` to `application.scss`. Then add the line

```
@import "bootstrap";

```

1. Edit `app/javascript/application.js` and add these lines:

```
import "popper"
import "bootstrap"

```

1. Edit `config/importmap.rb` and add these lines:

```
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true

```

1. Edit `config/initializers/assets.rb` and add this line:

```
Rails.application.config.assets.precompile += %w( bootstrap.min.js popper.js)

```

Then run the server, or restart it if it is already running. Verify that the appearance of the application has changed. Note – the precompile step does cause your application to start slowly. You should see something like this:  
![Starting Bootstrap](/lessons/after-bootstrap.png)

## Step 2: Changing the Background Color

The Bootstrap document includes descriptions of variables that you can set within your CSS to affect the color. At the moment we will just use one of these. Add these lines to your `app/assets/stylesheets/application.css`:

```
:root {
   --bs-body-bg: #e7a3f0;
}

```

This value is for light purple, but you can choose any light color you like. Also, change the `app/views/layouts/application.html.erb` file to add a div with class `"container-fluid"`. The yield statement should be inside this div. This makes your application responsive to window sizes. Then refresh your browser to check that the color has changed.

## Step 3: Adding the Banner

The banner is done as is described at the W3schools Bootstrap Jumbotron link. The jumbotron is no longer a Bootstrap class, but you can do the equivalent. You can use the example from W3schools, but use your own title and text. Refresh your browser page and verify that the banner is there. At this point, you should have something like this:  
![Bootstrap Banner](/lessons/bootstrap-banner.png)

## Step 4: Adding an Image

Find an image (jpg, gif, or png), and store it in app/assets/images. Then, in your application.scss, create a class .banner-background as follows:

```
.banner-background {
  background-image: url('s-l1600.jpg');
  background-size: cover;
}

```

Then refresh the page and verify that the image shows in the banner.

## Step 5: Adding a Font

Create the directory `app/assets/fonts`. Find a font. There are free ones on the net. Store it in `app/assets/fonts`. You will typically have to unpack it from a zip file. You should delete the zip file, and you will typically be left with a ttf file or something like that. Then, edit `config/application.rb`, and within the class Application section, add the line:

```
config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

```

Then restart the server, so that the fonts directory is added to the asset pipeline. After that, you need to add the following lines to your application.scss:

```
@font-face {
  font-family: 'Canterbury';
  src: url('Canterbury.ttf');
}

```

Except, of course, that you give it a family name and file name corresponding to the font you installed. This stanza should be added above the `.banner-background` style class. Then change the `.banner-background` class to add the line:

```
font-family: 'Canterbury'; 

```

Except that you need to use the name of the font-family you used. Refresh your browser page to verify that the font shows. The screen may look something like this:  
[![Bootstrap Banner With Font](/lessons/bootstrap-font.png)

## Step 6: Add a Navigation Bar

This should be in your layout, within the main div, below the banner but above the yield statement. You can copy the one from the W3schools Bootstrap tutorial, modifying it as you like. The list entries in this bar should be dropdowns, and they should have the choices described in the spec, configured with links that work. You can copy the dropdown example from W3schools, except they make it a button element that is styled as a primary button. I think that looks ugly. A better styling is the one that Bootstrap supplies for the purpose: `class="btn dropdown-toggle"`. Eefresh the page to verify that the navigation bar shows. Verify also that each of the dropdown options works. Note: Sometimes there is a problem that the dropdowns don’t work, because the required Popper JavaScript somehow didn’t get set up right. If this is the issue, take a look at the page using your browser developer tools to see if you can tell why, and also check that you did all the parts of Step 1. Contact a mentor if it still doesn’t work.

## Step 7: Styling Links, Buttons, and Tables

Here you configure the links and buttons in the Customer index view to have the same appearance. The classes you want are `"btn btn-primary"`. You add this class to each of the link\_to and button\_to statements. Then check to see that it looks right. Optionally, you can change the other buttons and links in the application to match. You don’t want to set the style of all buttons and links in your application.scss, because then the links in the navigation bar will look ugly. Also, change the wording on the buttons as you like. Then use Bootstrap table classes to style the tables. At this point, this might be the rough appearance:  
![Bootstrap Buttons and Tables](https://learn.codethedream.org/wp-content/uploads/2023/10/bootstrap-buttons.png)

**A tip here:** We do not want a button that says Destroy. We are not trying to destroy a customer, only to delete a record. Software developers have a bad habit of using the wrong words. For example, a medical monitoring application, in the event of network problems, would put up a message that said “Client died”. Doctors found this to be alarming.

## Step 8\. Showing Orders as Cards in a Grid

You want a responsive grid of cards for your Order index view. The outer div should have the classes `"container-fluid row"`. Inside this you have a loop for each of the orders. First you set up a responsive grid column, by creating a div with class `col-sm`. This style causes the cards to stack if the screen window is too narrow. Then you create a card div for each order. You can and should play with the appearance, but an example styling for the card div might include the attributes `class="card border border-2 border-success p-1 mt-3" style="width: 18rem;"`. This creates fixed width cards with borders. The `border-success` class gives the borders a Bootstrap color, in this case the `$success` color. The `p-1` class causes the cards to be separated with gutters. The `mt-3` class puts a margin at the top of each card, which makes them look ok when they are stacked, if the window is not wide enough. Now, inside this card, you want at least three divs. The first one should have class `"card-header"`, and the second should have class `"card-body"`. You can put appropriate stuff in each as you choose, but be sure that you include the order product name, the order product count, and the customer’s full name. Then, you need a dev with class `"card-footer"`, in which you put edit and delete buttons. The edit and delete buttons should work. You can play with the various options here to get an appearance you like. Then, in your browser, select the Order List view. Check that it looks ok. Check that it is responsive: if you shrink your browser width, the cards stack. Check that the buttons work. Here is a sample appearance:  
![Bootstrap Card Grid](/lessons/bootstrap-cards.png)

## Step 9\. Styling Alerts.

In the previous lesson, you put a red alert paragraph in the layout. The alert handles, for example, the error that occurs if the user attempts to get an order or customer that doesn’t exist, for example by going to `/customers/999`. Change this so that if the `flash\[:alert\]` has a value, a Bootstrap danger alert is shown. Also, the controllers have statements like:

```
flash.notice = "The customer record was created successfully."

```

And the customer views have the line:

```
<p style="color: green"><%= notice %></p>

```

You want to change this so that if the `flash\[:notice\]` has a value, a Bootstrap success alert is shown. The alert divs should be added to the layout, above the navbar but below the banner. You should remove the green notice paragraph lines in the other views.

Then test to see that the alerts work, for example by trying /customers/999 or by creating a new order. They should look something like this:

[![Bootstrap Alert](/lessons/bootstrap-alert.png)

## Step 10: Adding Font Awesome Glyphs

Glyphs are small icons that can illustrate a web page. or example, the little magnifying glass often used for search is typically aglyph, as are emoticons. The most commonly used glyphs come from Font Awesome. To install Font Awesome, do the following:

```
bin/bundle add "font-awesome-sass"

```

Then add the following line to application.scss:

```
@import "font-awesome";

```

Now add glyphs somewhere on one of the pages. For example, you could add a leading column to the customer index view, with a glyph for a person. Just use the free glyphs, listed [here.](https://fontawesome.com/search?o=r&m=free) You use the icon helper function, like:

```
<%= icon('fa-regular', 'bell')%>

```

## Step 11: Using a Modal Window

This is the optional step to use a modal window for the “Are you sure?” message. A modal window is a pop-up. It appears, somewhat rudely, in the middle of your browser screen. You can’t do any browser operations unless you first interact with and dismiss the modal window.

You don’t have to actually implement this, because it’s a little complicated, but be sure you understand how to do modal windows. The W3Schools example is a little incomplete. You put a form inside the modal, and the form should have a submit button. If the submit button is pressed, the action specified by the form is executed: a get/post/put/patch/delete for the target URL. There are several other buttons to dismiss the modal window without actions. You can do anything you like in the form, such as possibly collecting additional information from the user. You can also make it much more descriptive than a plain “Are you sure?”. Modals can be used for all sorts of reasons, not just for simple confirmations.

We are going to use the modal to put up a more descriptive “Are you sure?” message, giving information about the order or customer to be deleted. The form we are going to use is the same form we currently have embedded in the delete button. Now, on the Customers view, there is a delete button for each customer. When the modal window causes the delete to occur, we want to know which customer record to delete. There are two ways to do this, the easy way and the hard way.

The easy way is to render a different modal window for each customer. When the delete button is clicked for a given customer, that button triggers the showing of the corresponding modal. The rendering is done on the server side, and we can use all the power of embedded Ruby to customize it.

The hard way is also shown below, because it illustrates a key idea. Sometimes you need to pass data so that the modal knows what action to take. So, you attach that data to the button that triggers the modal. As you’ve seen already, you attach data to an element by giving it a “data-\*” attribute. In this way, we can attach to each button different values: the id of the record to be deleted, and other information, maybe the product name, the product count, and other stuff. But, how do you get the data back out? That requires JavaScript. When the modal is shown, a `show.bs.modal` event is triggered for that window. The event includes a value `e.relatedTarget`, which is the button that was clicked, and from that we can get the data attributes, and then we can update the text of the modal window and direct the actions to the right URL.

**A Tip:** Render your modals outside of any other elements within the view. You don’t want to declare them as you are doing the table, for example, because of some strange behavior. For some reason, some of the time, the contents of the form within the modal may render outside of the form, so that the submit button does not work. It’s not clear why this happens, but this is the workaround.

Here are the steps (first the easy way, as implemented for the customer view):

1. Change the button for delete so that instead of triggering the “Are you sure?” prompt followed by a delete, it looks like this instead:  
```  
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#myModal-<%= customer.id%>">  
```  
Note again, we have a different modal for each customer entry, and each has a different id.
2. Create the modal form itself. This should be a partial that you use wherever you intend to do a delete. It should be an erb file. You would create `app/views/customers/\_deleteModal.html.erb`, for example, and you would render it in the Orders index and show views.
3. Add render statements for these modal windows to the index and show views for the customer. For the index view, the render statement is inside the loop that shows each customer. The customer to be rendered is passed as a parameter on the render statement.
4. We can do something additional here. Suppose the customer has orders. We can add a new route that deletes all the orders for a given customer and then deletes the customer itself. We give the user fair warning that the customer has N orders and that all those records are about to be deleted when the customer record is. We add a new route and a new method to the controller that actually does the deleting.

Here is what the code for the modal might look like:

```
<div class="modal" id="<%= "myModal-#{customer.id}" %>">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">Are you sure?</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
       <p>Are you sure you want to delete the customer and order records for <%= customer.full_name %>?
           That customer has <%= customer.orders.count.to_s %> orders.  If there are any orders for this
           customer, those orders will be deleted too! </p>
      </div>

      <!-- Modal footer -->
      <div class="modal-footer">
      <%= button_to("Delete", "/customers/customerAndOrders/#{customer.id}", method: :delete, class: "btn btn-danger", 
      data: { "bs-dismiss" => "modal" })  %>
<button type="button", class="btn btn-primary" data-bs-dismiss="modal">Cancel</button>         
      </div>

    </div>
  </div>
</div>

```

And this is the route:

```
delete "/customers/customerAndOrders/:id", to: "customers#destroy_with_orders"

```

And this is the method to add to the controller ( you must also add it to the :set\_customer list):

```
  def destroy_with_orders
    if (@customer.orders.exists?)
      @customer.orders.destroy_all
    end
    @customer.destroy
    flash.notice = "The customer record and all related order records were successfully deleted."
    redirect_to customers_url
  end

```

The modal window would look like this:  
[![Bootstrap Modal](/lessons/bootstrap-modal.png)

Now, the hard way –but really only slightly harder. This is for orders instead of customers. We’ll only have one modal rendered for the whole page, but we’ll pass data to it. This example shows how you can pass data to a modal.

1. Change the button for delete so that instead of triggering the “Are you sure?” prompt followed by a delete, it looks like this instead:

```
<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#myModal" data-id=<%= order.id.to_s %> data-customer="<%= order.customer.full_name %>" data-productname="<%= order.product_name %>" data-productcount="<%= order.product_count %>">Delete</button>

```

1. Next, create the modal form itself with the attached JavaScript. This should be a partial that you use wherever you intend to do a delete: `app/views/orders/\_deleteModal.html.erb`.
2. Also, create the JavaScript to be added to the form. This is the JavaScript that gets the data from the button to customize the form. This is the only tricky part. Of course, this is client side JavaScript. You can’t access the database from here, so you can only use the data that was attached to the button. The data is used to modify the text in the modal, as well as the action on the form.
3. Add render statements for this modal to the index and show views for orders. Note that you do not need to pass the order as a parameter on the render statement, as you only have one modal to render.

Here’s an example of such a modal, with attached JavaScript:

```
<div class\="modal" id\="myModal"\>
  <div class\="modal-dialog"\>
    <div class\="modal-content"\>
      <!-- Modal Header -->
      <div class\="modal-header"\>
        <h4 class\="modal-title"\>Are you sure?</h4\>
        <button type\="button" class\="btn-close" data-bs-dismiss\="modal"\></button\>
      </div\>
      <!-- Modal body -->
      <div class\="modal-body"\>
        <p\>Are you sure you want to delete the order from <span id\="customerName"\></span\>
            for <span id\="productCount"\></span\>
            of our <span id\="productName"\></span\> product?
        </p\>
      </div\>
      <!-- Modal footer -->
      <div class\="modal-footer"\>
        <%= button\_to("Delete", nil, method: :delete, class: "btn btn-danger",
          data: { "bs-dismiss" => "modal" }, form: {id: "doDelete"})  %>
        <button type\="button", class\="btn btn-primary" data-bs-dismiss\="modal"\>Cancel
        </button\>       
      </div\>
    </div\>
  </div\>
</div\>
<script\>
document.addEventListener("DOMContentLoaded", () \=> {
  const myModal = document.getElementById("myModal")
  myModal.addEventListener("show.bs.modal", (e) \=> {
    const triggerButton = e.relatedTarget
    const customerName = document.getElementById("customerName")
    const productName = document.getElementById("productName")
    const productCount = document.getElementById("productCount");
    const doDelete = document.getElementById("doDelete")
    customerName.textContent = triggerButton.getAttribute("data-customer")
    productName.textContent = triggerButton.getAttribute("data-productname")  
    productCount.textContent = triggerButton.getAttribute("data-productcount")
    doDelete.action = ("/orders/" + triggerButton.getAttribute("data-id"))
  })
})
</script\>

```

## Step 12: Get Creative!

You can make the application look as nice as you have time for. You’ll get another chance to do this in your final project. There are many other Bootstrap features, such as tooltips, carousels, pagination, and popovers. There are also ways to modify the appearance of images and background colors. Most of these are described in the W3Schools tutorial, but for some, such as the accordion, you will need to go directly to the Bootstrap site. (You don’t need to spend too much time on this. Just have fun.)

## Submitting Your Work

Follow the usual process, this time for the lesson11 branch.
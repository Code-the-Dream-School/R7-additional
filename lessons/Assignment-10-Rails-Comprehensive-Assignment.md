Create a new branch, lesson10.  Be sure you create it when your lesson9 branch is active.  In this lesson, you practice all of the Rails skills you have learned so far.  This lesson is challenging, in that the code you need to write is not provided -- you have to write it yourself.

## Specifications for the Assignment

1. Within the customer-order application, create a new model called Order. This will have attributes called product\_name (string), product\_count (integer), and customer\_id (integer). Each order will belong to a customer. The customer\_id field is generated with customer:references — see the generate model command in the following paragraph..
2. Create a new set of routes to manage CRUD operations for the orders resource. Do not nest these routes under customer.
3. Create an OrdersController. Add methods for index, show, new, edit, create, update, and destroy. These will be similar to the methods in other controllers you have seen.
4. Create views (html.erb files) for orders: edit, index, new, and show. These should be similar to the views for customer. edit and new should share a partial form.
5. The new/edit form for the order should have a drop down list of customers to choose from when creating or updating an order, as well as fields for product\_name and product\_count.
6. The controller should include error handling.
7. Change the show view for the customer, so that if that customer has orders, a list of them are shown in a table at the bottom, with show/update/delete links. You will need to add the appropriate has\_many line to the customer model. To create this table, you can follow an example: the index view from the rails5 directory R7-blog repository. Be sure you only show the orders associated with the customer, not all orders.
8. Add validations to the order model so that validates that a product\_name, product\_count, and customer are present.
9. Create model tests for the order model, to make sure that each of the validations works correctly.
10. Create request tests for the order controller, to make sure that each of the methods works correctly.
11. Improve the index view for customers. Once the orders are added, this page is not attractive. Display instead a table, where each row has columns for the customer full name, the number of orders the customer has (hint: that’s customer.orders.count), and buttons for show, edit, and delete.
12. Handle foreign key exceptions (see below).

Use the following commands to get started:

```bash
bin/rails generate model Order product_name:string product_count:integer customer:references
bin/rails db:migrate
bin/rails generate controller orders
```

Before you run rspec, you have to migrate the test database:

```bash
bin/rails db:migrate db:test:prepare
```

## A Few New Ideas

In your Order model, we want to be sure that the customer\_id points to a real customer record. Actually, we don’t need to be concerned. If you attempt to create an order with a customer\_id integer that is not the id of a real customer record, you get a foreign key constraint exception. And, once you have the “belongs\_to :customer” statement in the model, it does something better, by catching the problem even before the foreign key constraint exception is thrown.

To create the dropdown list for choosing the customer for the order, you can use this line:

```
<%= f.collection_select :customer_id, Customer.all, :id, :full_name, include_blank: true %>
```

This is documented [here.](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-grouped%5Fcollection%5Fselect) The Rails documentation is a little confusing in that there are two collection\_select methods. You want the one for the FormBuilder, not for the FormOptionsHelper. 

In the rspec test for the order model, you can set up the subject with this line:

```ruby
subject { Order.new( product_name: "gears", product_count: 7, customer: FactoryBot.create(:customer))}
```

In the rspec test for the order controller, you will need a factory that generates an order. But as each order belongs to a customer, the factory has to create the customer object too. To do this, FactoryBot uses the association method:

```ruby
FactoryBot.define do
  factory :order do
    product_name { Faker::Lorem.word }
    product_count { Faker::Number.number(digits: 3).to_i }
    association :customer
  end
end
```

The key point here is the use of association. Now, we can do order = FactoryBot.create(:order) and it will create an order for us and store it in the database, creating the necessary customer object as well. Unfortunately, that doesn’t quite solve all our problems. For the post method, we need to get the attributes for an order object. If we do attributes = FactoryBot.attributes\_for(:order) it will not store anything in the database. It will also not create any attributes corresponding to the customer. So we have to create the customer object explicitly, and add its id to the list of attributes, as follows:

```ruby
customer = FactoryBot.create(:customer)
order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
```

The resulting attributes could be passed in the parameters when testing the post method to create an order entry.

Good rspec testing validates that the correct page is displayed, as well as testing that the right changes have been made to the database. If a redirect is expected to occur, one should check that the redirect goes to the right page, for example:

```ruby
expect(response).to redirect_to orders_path
```

If a redirect does not occur, you should check that the right page template is displayed:

```ruby
expect(response).to render_template(:show)
```

Here are a couple example tests from the orders request test that may help to explain rspec request testing:

```ruby
  describe "put order_path with valid data" do
    it "updates an entry and redirects to the show path for the customer" do
      order = FactoryBot.create(:order)
      put "/orders/#{order.id}", params: {order: {product_count: 50}}
      order.reload
      expect(order.product_count).to eq(50)
      expect(response).to redirect_to("/orders/#{order.id}")
    end
  end
  describe "put order_path with invalid data" do
    it "does not update the customer record or redirect" do
      order = FactoryBot.create(:order)
      put "/orders/#{order.id}", params: {order: {customer_id: 5001}}
      order.reload
      expect(order.customer_id).not_to eq(5001)
      expect(response).to render_template(:edit)
    end
  end
```

## Foreign Key Exceptions

Try this: Create a customer entry, and then create several orders for that customer. Then try to delete (destroy) the customer entry. A very ugly error screen is now displayed. Why?

The database schema for the orders table has a foreign key column, called customer\_id. This, of course, is the id of the customer record for the customer who placed the order. If that record were deleted, the corresponding order records would be “orphans”, belonging to no customer. We need to fix this error.

There are several possible fixes. First, we could change the Customer model so that the order records are deleted before deleting the customer record. The change is as follows:

```ruby
has_many :orders, dependent: :destroy
```

Try this. You can now destroy the customer entry, even if the customer has orders. But, does this make sense in this application? If a customer had many orders, you probably would not want to delete all that information. So, change the line in the Customer model back, to read:

```ruby
has_many :orders
```

Another way to solve the problem is to change the schema to remove the foreign key constraint. There is a Rails migration that would do this. Then one could delete a customer record without deleting the corresponding orders. For some kinds of data, it might make sense to permit orphans in this way. But it makes no sense to have a bunch of order records with no idea of the customer.

The third way to solve the problem is to give the user a friendly error message. We do this by catching the exception, as follows:

```ruby
  def destroy
    begin
      @customer.destroy
      flash.notice = "The customer record was successfully deleted."
    rescue ActiveRecord::InvalidForeignKey
      flash.notice = "That customer record could not be deleted, because the customer has orders."
    end

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end
```

We put the code for the destroy within a begin-rescue-end block. The actual exception that is thrown in this case is ActiveRecord::InvalidForeignKey. If the destroy of the customer record succeeds, the flash.notice is set to inform the user of this. If the InvalidForeignKey exception occurs, the flash.notice explains the situation to the user. Because the rescue statement catches the exception, no ugly error message goes back to the user. Go ahead and add this code and test it out.  This is the version you should submit with your homework.

There is even a fourth way to deal with the problem. One could tell the user that they are about to delete a customer record for a customer who has orders, and let the user decide if they really want to delete both the customer record and the orders. We’ll see that in the next lesson.

## Submitting Your Work

Add, commit, and push your changes for the lesson10 branch.  Then create a pull request as usual, and include a link to the pull request with your homework submission.

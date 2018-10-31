# RNDfloAPI

//------------------------------------------------------------------------------------------------------------------------------------

## Steps

==> rails new goforfloapi --api --no-sprockets -d mysql

==> cd goforfloapi

==> rails g model property

==> bin/rails db:migrate RAILS_ENV=development

==> rails g controller v1/properties

Install Devise as outlined in 
https://github.com/plataformatec/devise
//------------------------------------------------------------------------------------------------------------------------------------
-) Add gem 'devise' to Gemfile and run ==> bundle install
//------------------------------------------------------------------------------------------------------------------------------------
-) Run ==> rails g devise: install
//------------------------------------------------------------------------------------------------------------------------------------
-) Run ==> rails g devise user
//------------------------------------------------------------------------------------------------------------------------------------
-) Run ==> rails db:migrate
//------------------------------------------------------------------------------------------------------------------------------------
-) Comment out 
  # devise_for :users
  in routes.rb
//------------------------------------------------------------------------------------------------------------------------------------
-) Create a sample user as follows :

==> rails c
/Users/das/.gem/ruby/2.5.1/gems/railties-5.1.6/lib/rails/app_loader.rb:40: warning: Insecure world writable dir /Users/das/Library in PATH, mode 040777
Running via Spring preloader in process 22966
Loading development environment (Rails 5.1.6)
irb(main):001:0> user = User.create(email: 'das@rndflo.com', password: 'apple123', password_confirmation: 'apple123')
//------------------------------------------------------------------------------------------------------------------------------------
-) Check if user is correct as follows :

irb(main):002:0> user
=> #<User id: 1, email: "das@rndflo.com", created_at: "2018-07-11 08:35:24", updated_at: "2018-07-11 08:35:24">
irb(main):003:0> user.valid_password?('apple123')
=> true
//------------------------------------------------------------------------------------------------------------------------------------
-) Add simple_token_authentication from 

https://github.com/gonzalo-bulnes/simple_token_authentication

//------------------------------------------------------------------------------------------------------------------------------------
 -) Add the following line 
 acts_as_token_authenticatable
 to model/User.rb
//------------------------------------------------------------------------------------------------------------------------------------
 -) Run the following 

==> rails g migration add_authentication_token_to_users "authentication_token:string{30}:uniq"
==> rails db:migrate
//------------------------------------------------------------------------------------------------------------------------------------
-) Check as follows
==> rails c
/Users/das/.gem/ruby/2.5.1/gems/railties-5.1.6/lib/rails/app_loader.rb:40: warning: Insecure world writable dir /Users/das/Library in PATH, mode 040777
Running via Spring preloader in process 23521
Loading development environment (Rails 5.1.6)
irb(main):001:0> user = User.first
   (0.5ms)  SET NAMES utf8,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
  User Load (0.3ms)  SELECT  `users`.* FROM `users` ORDER BY `users`.`id` ASC LIMIT 1
=> #<User id: 1, email: "das@rndflo.com", created_at: "2018-07-11 08:35:24", updated_at: "2018-07-11 08:35:24", authentication_token: nil>
irb(main):002:0> user.save
   (0.3ms)  BEGIN
   (28.8ms)  SELECT COUNT(*) FROM `users` WHERE `users`.`authentication_token` = 'q_sd_pBWFyqNFSyzLyE2'
  SQL (11.6ms)  UPDATE `users` SET `updated_at` = '2018-07-11 09:00:42', `authentication_token` = 'q_sd_pBWFyqNFSyzLyE2' WHERE `users`.`id` = 1
   (0.7ms)  COMMIT
=> true
irb(main):003:0> user.authentication_token
=> "q_sd_pBWFyqNFSyzLyE2"
//------------------------------------------------------------------------------------------------------------------------------------
-) Make controller/sessions_controller.rb as follows 

class V1::SessionsController < ApplicationController

    def create
        success, user = User.valid_password?(params[:email], params[:password])
        if success
          render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created  
        else
          head :unauthorized
        end
    end

    def destroy

    end
end

//------------------------------------------------------------------------------------------------------------------------------------

-) Paste the following line from 

https://github.com/gonzalo-bulnes/simple_token_authentication

acts_as_token_authentication_handler_for User, fallback: :none

into application_controller.rb

//------------------------------------------------------------------------------------------------------------------------------------

-) Add 
binding.pry
to index action of properties_controller.rb

//------------------------------------------------------------------------------------------------------------------------------------

-) Modify sessions_controller destroy action as follows 

    def destroy
        current_user&.authentication_token = nil
        if current_user.save
            head(:ok)
        else 
            head(:unauthorized)
        end
    end

//------------------------------------------------------------------------------------------------------------------------------------

-) Add views/v1/sessions/create_json.builder as follows 

json.data do
    json.user do
        json.call(
            @user,
            :email,
            :authentication_token
        )
    end
end

//------------------------------------------------------------------------------------------------------------------------------------

-) Change sessions_controller.rb as follows 

class V1::SessionsController < ApplicationController
    def create
        @user = User.where(email: params[:email]).first

        if @user && @user.valid_password?(params[:password])
          @current_user = @user
            render :create, status: :created
        else 
            head(:unauthorized)
        end
    end

    def destroy
        current_user&.authentication_token = nil
        if current_user.save
            head(:ok)
        else 
            head(:unauthorized)
        end
    end
end

//------------------------------------------------------------------------------------------------------------------------------------

-) Change routes.rb as follows 

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1, defaults: { format: :json } do
    resources :properties
    resource :sessions, only: [:create, :destroy]
  end
end

//------------------------------------------------------------------------------------------------------------------------------------



//------------------------------------------------------------------------------------------------------------------------------------

## Deployment Steps

rails webpacker:install

Precompile assets in production

RAILS_ENV=production bin/rails assets:precompile

## Phpmyadmin

http://apps.rndflo.com/phpmyadmin


//------------------------------------------------------------------------------------------------------------------------------------

Test as follows 

http://api.rndflo.com/v1/properties


//------------------------------------------------------------------------------------------------------------------------------------

Yarn

npm install -g yarn


//------------------------------------------------------------------------------------------------------------------------------------

==> RAILS_ENV=production rails c

irb(main):003:0> user = User.create(email: 'das@rndflo.com', password: 'adminF00b4r', password_confirmation: 'adminF00b4r')


api.rndflo.com/v1/sessions

{
    "id": 1,
    "email": "das@rndflo.com",
    "authentication_token": "hob-ozsEMt1ev5XCyAFn"
}


//------------------------------------------------------------------------------------------------------------------------------------

http://www.mccartie.com/2016/11/03/token-based-api-authentication.html

//------------------------------------------------------------------------------------------------------------------------------------

Registration

http://lucatironi.net/tutorial/2012/10/15/ruby_rails_android_app_authentication_devise_tutorial_part_one/


rails g controller v1/registraions

//------------------------------------------------------------------------------------------------------------------------------------



Add admin to users

==> rails generate migration add_admin_to_users admin:boolean

==> bundle exec rails db:migrate RAILS_ENV=production


//------------------------------------------------------------------------------------------------------------------------------------

## Devise Steps
### Rails_admin / Remotipart
==> rails g rails_admin:install


Add gem 'rails_admin', '~> 1.2' to Gemfile and run bundle install

bin/rails g rails_admin:install

Add gem 'remotipart', '~> 1.2' to Gemfile and run bundle install

Add

gem 'rails_admin_rollincode', '~> 1.0' gem 'rails_admin', git: 'https://github.com/sferik/rails_admin.git' Inside config/application.rb, just after Bundler.require

ENV['RAILS_ADMIN_THEME'] = 'rollincode' You'll have to run theses commands for changes to take effect

rails assets:clean && rails assets:precompile

or

rm -rf tmp/cache/assets/development/

Add gem 'devise' to Gemfile and run bundle install

Then, run the generator

$ bin/rails generate devise:install


Dashboard should be available at : 
http://api.rndflo.com/dashboard/property

//------------------------------------------------------------------------------------------------------------------------------------

==> rails c
/Users/das/.gem/ruby/2.5.1/gems/railties-5.1.6/lib/rails/app_loader.rb:40: warning: Insecure world writable dir /Users/das/Library in PATH, mode 040777
Running via Spring preloader in process 54973
Loading development environment (Rails 5.1.6)
irb(main):001:0> JWT
=> JWT
irb(main):002:0> data = { example: 'data' }
=> {:example=>"data"}
irb(main):003:0> secret = 'blah'
=> "blah"
irb(main):004:0> Rails.application.secrets.secret_key_base
=> "fe0a57c331ee4838b65fef6d78c2397074dd6cff436256d2f40690d3bca32113a3342ea59cec4de9fa3c67518e2fd02c057165e662a016661e38a9e588ac4f4c"
irb(main):005:0> Rails.application.secrets.secret_key_base
=> "fe0a57c331ee4838b65fef6d78c2397074dd6cff436256d2f40690d3bca32113a3342ea59cec4de9fa3c67518e2fd02c057165e662a016661e38a9e588ac4f4c"
irb(main):006:0> secret 
=> "blah"
irb(main):007:0> JWT.encode data,secret, 'HS256'
=> "eyJhbGciOiJIUzI1NiJ9.eyJleGFtcGxlIjoiZGF0YSJ9.flKbmNKu5hxSNSGzF_H08wH8fH8jPnVYvagXyCe6eto"
irb(main):008:0> 

//------------------------------------------------------------------------------------------------------------------------------------

irb(main):008:0> JWT.encode data, Rails.application.secrets.secret_key_base, 'HS256'
=> "eyJhbGciOiJIUzI1NiJ9.eyJleGFtcGxlIjoiZGF0YSJ9.OROeb8M0Bcvkd4kFGxf_3yHdnmEJC6Q_ego60IV8pAE"




//------------------------------------------------------------------------------------------------------------------------------------


### Integrate with ActiveAdmin as described here 

https://medium.com/superhighfives/a-top-shelf-web-stack-rails-5-api-activeadmin-create-react-app-de5481b7ec0b

==> rails g controller Api



//------------------------------------------------------------------------------------------------------------------------------------
### Add admin user as follows

==> rails c 

or

==> rails c production (For production)


/Users/das/.gem/ruby/2.5.1/gems/railties-5.1.6/lib/rails/app_loader.rb:40: warning: Insecure world writable dir /Users/das/Library in PATH, mode 040777
Running via Spring preloader in process 73261
Loading development environment (Rails 5.1.6)
irb(main):001:0> AdminUser.new
   (0.6ms)  SET NAMES utf8,  @@SESSION.sql_mode = CONCAT(CONCAT(@@sql_mode, ',STRICT_ALL_TABLES'), ',NO_AUTO_VALUE_ON_ZERO'),  @@SESSION.sql_auto_is_null = 0, @@SESSION.wait_timeout = 2147483
=> #<AdminUser id: nil, email: "", created_at: nil, updated_at: nil>
irb(main):002:0> user = AdminUser.new
=> #<AdminUser id: nil, email: "", created_at: nil, updated_at: nil>
irb(main):003:0> user.email = "rndfloinc@gmail.com"
=> "rndfloinc@gmail.com"
irb(main):004:0> user.password = "adminF00b4r"
=> "adminF00b4r"
irb(main):005:0> user.password_confirmation = "adminF00b4r"
=> "adminF00b4r"
irb(main):006:0> user.save!
   (0.2ms)  BEGIN
  AdminUser Exists (0.4ms)  SELECT  1 AS one FROM `admin_users` WHERE `admin_users`.`email` = BINARY 'rndfloinc@gmail.com' LIMIT 1
  SQL (18.2ms)  INSERT INTO `admin_users` (`email`, `encrypted_password`, `created_at`, `updated_at`) VALUES ('rndfloinc@gmail.com', '$2a$11$J44PEaodI5qMk.78QFkMd.zPNdEfdYE4bI9RZA0u/e/nEgV992s6q', '2018-08-23 22:14:21', '2018-08-23 22:14:21')
   (14.5ms)  COMMIT
=> true
irb(main):007:0> quit

//------------------------------------------------------------------------------------------------------------------------------------
### Add Property to active_admin as follows

==> rails g active_admin:resource propert
//------------------------------------------------------------------------------------------------------------------------------------


class AddFieldsToAddress < ActiveRecord::Migration[5.1]
  def change
      add_column :address_line_1, :string
      add_column :address_line_2, :string
      add_column :unit, :string
      add_column :postal_code, :string
      add_column :city, :string
      add_column :notes, :string
      add_column :latitude, :string
      add_column :longitude, :string
      t.timestamps
  end
end
==> rails g migration AddColumnsToAddress address_line_1:string address_line_2:string
//------------------------------------------------------------------------------------------------------------------------------------

mysql> CREATE TABLE addresses(id int NOT NULL, PRIMARY KEY (id) );

//------------------------------------------------------------------------------------------------------------------------------------

==> rails g controller v1/addresses

//------------------------------------------------------------------------------------------------------------------------------------

==> rails c

irb(main):002:0> secret = Rails.application.secrets.secret_key_base
=> "fe0a57c331ee4838b65fef6d78c2397074dd6cff436256d2f40690d3bca32113a3342ea59cec4de9fa3c67518e2fd02c057165e662a016661e38a9e588ac4f4c"

irb(main):003:0> data = { user_id: 1, exp: (Time.now + 2.weeks).to_i}
=> {:user_id=>1, :exp=>1536294505}


irb(main):004:0> data
=> {:user_id=>1, :exp=>1536294505}


irb(main):005:0> token = JWT.encode data, secret, 'HS256'
=> "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MzYyOTQ1MDV9.VCJj0NrwiTlYjtiBEDzcIQ9qsdZ8LO49ufkDAZEfL1s"


irb(main):006:0> decode = JWT.decode token, secret, true, { algorithm: 'HS256'}
=> [{"user_id"=>1, "exp"=>1536294505}, {"alg"=>"HS256"}]
irb(main):007:0> 

//------------------------------------------------------------------------------------------------------------------------------------

rails db:drop
rails db:create
rails db:migrate
rails db:seed
rails db:test:prepare

//------------------------------------------------------------------------------------------------------------------------------------

==> rails g model Country iso:string iso3:string name:string


//------------------------------------------------------------------------------------------------------------------------------------

==> rails g model StateProvince code:string name:string

rails g migration add_country_id_to_address country_id:integer

rails g migration RemoveCountryIdFromAddress country_id:integer


rake db:rollback STEP=n

==> rails db:migrate:redo STEP=2


//------------------------------------------------------------------------------------------------------------------------------------


Modelling Contacts and Groups

From:
https://stackoverflow.com/questions/10548195/how-would-you-model-contact-list-with-self-reference-and-category

Assumptions
This is a system for many users, not just one, so you need to specify the Owner on the Contact and Group records with a foreign key.
A Contact can belong to multiple Groups, and a Group has multiple contacts, so this is a has_and_belongs_to_many relationship.
Migrations
Create Users table:

class CreateUsers < ActiveRecords::Migrations
  def change
    create_table :users do |t|
      t.text :username
    end
  end
end

//------------------------------------------

Create Contacts table. Has a foreign key for the User the Contact is owned by as well as the User that the Contact refers to.


==> rails g model contact

class CreateContacts < ActiveRecord::Migrations
  def change
    create_table :contacts do |t|
      t.references :owner
      t.references :user
    end
  end
end


//------------------------------------------
Create Groups table. Also has a foreign key for the User that the group belongs to.
==> rails g model group

class CreateGroups < ActiveRecord::Migrations
  def change
    create_table :groups do |t|
      t.references :owner
      t.text :name
    end
  end
end
//------------------------------------------
Create the table for the has_and_belongs_to_many relationship between Contacts and Groups. Has two foreign keys; one for the Contact and the other for the Group.
==> rails g migration CreateContactsGroups


class CreateContactsGroups < ActiveRecord::Migrations
  def change
    create_table :contacts_groups do |t|
      t.references :contact
      t.references :group
    end
  end
end
//------------------------------------------
Models
The User model. A User has many Contacts and the foreign key on the contacts table that relates a contact to a user is the 'owner_id' column. Same thing for Groups.

class User
  has_many :contacts, :foreign_key => 'owner_id'
  has_many :groups, :foreign_key => 'owner_id'
end
The Contact model. A Contact belongs to an Owner and we are using the 'User' model for the Owner relationship. Also, a Contact refers to another User (or belongs to, Rails parlance, which is kind of confusing in this circumstance), but :user matches the name of the model, so we don't need to specify that like we do for :owner. Finally, the has and belongs to many relationship with Groups.

class Contact
  belongs_to :owner, :class_name => 'User'
  belongs_to :user
  has_and_belongs_to_many :groups
end
The Group model. A Group belongs to an Owner and has and belongs to many Contacts.

class Group
  belongs_to :owner, :class_name => 'User'
  has_and_belongs_to_many :contacts
end
//------------------------------------------
We don't need to create a Model for the contacts_groups table since we wont be accessing it directly and instead will only be accessing it through either a Contact or a Group.

Results
This would allow you to do stuff like the following:

@user.contacts # all of the user's contacts
@user.groups # all of the user's groups
@user.groups.find(id).contacts # all the contacts in a group
@user.contacts.find(id).groups # all of the groups that a contact belongs to
Adding Contacts to a Group
This is in response to @benrmatthews comment asking what the views would look to add a Contact to a Group.

There are actually a bunch of different ways to achieve this, but the general idea is that you need to pass the Contact id and Group id to a controller action that will then create an entry in the contact_groups table to indicate that the contact has been added to the group.

Your routes might look like this:

resources :contact_groups, only: [:create]
Then you will have a controller that looks something like this:

class ContactGroupsController < ApplicationController
  def create
    @contact = Contact.find(params[:contact_id])
    @group = Group.find(params[:group_id])
    @contact.groups << @group
  end
end
Now all you need are forms which pass the contact_id and group_id to the controller action. Here's what that would look like:

# This is for adding the contact to a group
form_tag contact_groups_path do
  hidden_field_tag :contact_id, @contact.id
  select_tag :group_id, options_from_collection_for_select(Group.all, :id, :name)
  submit_tag "Add to Group"
end
This creates a form with a hidden field that contains the contact_id and a select field that will display a list of group names. When this form gets submitted, it will pass the contact_id and group_id to the controller action, which then has enough information to do it's thing.

//------------------------------------------------------------------------------------------------------------------------------------
### Rollback

==> rails db:rollback STEP=1 

//------------------------------------------------------------------------------------------------------------------------------------
### Check Status of migrations
==> rails db:migrate:status RAILS_ENV=production


//------------------------------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------
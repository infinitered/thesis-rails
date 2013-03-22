# Thesis

### Thesis is a CMS that integrates as seamlessly as possible into your current website.

Most Rails content management systems make you conform to their system from the start, 
making it difficult to just "drop in" the gem and make it work with your CMS. Thesis
tries to be a drop-in CMS that doesn't hijack your development workflow.

## Installation

In your Gemfile:

    gem 'thesis'
    
Then run these from your command line:

    bundle install
    rails g thesis:install
    rake db:migrate
    
This will install thesis and add the database tables.

## Usage

Thesis's installer will create a couple of database table migrations (pages and page_contents) and
drop a `page_templates` folder into your `app/views` folder. This is where you put different
styles of pages.

Example (HAML version -- Thesis will install an ERB version if you don't have HAML)

```haml
!!!
%html
  %head
    %title= current_page.title
    %meta{ content: current_page.content("Description", :text), type: "description" }

    = stylesheet_link_tag    "application", :media => "all"
    = javascript_include_tag "application"
    = csrf_meta_tags
  %body
    %header
      %h1= current_page.title

    %nav
      %ul
        - root_pages.each do |p|
          %li = link_to p.title, p.url

    %article
      .main-image= current_page.content("Main Image", :image)
      .content= current_page.content("Main Content", :html)

    %aside
      = current_page.content("Sidebar Content", :html)
      
    %footer
      %p= current_page.content("Footer Content", :text)
```
        
Thesis will also add a route handler to your `routes.rb` file:

    thesis_routes
    
This will handle routes for pages you create with Thesis. To improve performance we recommend
putting this near the bottom of your `routes.rb` file.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Write tests for your new feature
5. Run `rake spec` to ensure that all tests pass # TODO: implement tests
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

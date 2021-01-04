# Thesis Rails

**NOTE: Thesis Rails has been deprecated. If you're interested in maintaining it, please email hello@infinite.red.**

See also [Thesis Phoenix](https://github.com/infinitered/thesis-phoenix) for an Elixir take on Thesis.

### Thesis is a Rails CMS gem that integrates as seamlessly as possible into your current Rails website.

Most Rails content management systems make you conform to their system from the start,
making it difficult to just "drop in" the gem and make it work with your CMS. Thesis
tries to be a drop-in CMS that doesn't hijack your development workflow and stays out
of the way.

Thesis is a research project of [Infinite Red](http://infinite.red), a web and mobile development company based in Portland, OR and San Francisco, CA.

### Requirements

* Rails 4.0.x (or higher)
* ActiveRecord on MySQL, PostgresQL, or SQLite3
* Ruby 2.0.0 (or higher)
* jQuery
* File hosting or Amazon S3 (for image upload)

## Getting Started

### Installation

In your Gemfile:

    gem 'thesis', '~> 0.1'

Then run these from your command line:

    bundle install
    rails g thesis:install
    rake db:migrate

This will install thesis and add the database tables.

[API Reference](#API)

## Using the CMS

### Adding a Page

TODO

### Editing a Page

TODO

### Deleting a Page

TODO

### Rearranging Pages

TODO

## API

### Authentication

**Thesis does not force you to use a particular user or authentication strategy.**

Instead, it adds a method into your application_controller.rb file that
allows you to hook up your own authentication logic.

* If you return `false` from this method, nothing will show up client-side nor will the page be editable.
* If you return `true` from this method, the Thesis editor will appear and the page will be editable.

#### Thesis authentication examples

```ruby
def page_is_editable?(page)
  logged_in? && current_user.admin? # Devise + admin boolean
end

def page_is_editable?(page)
  can? :update, page # CanCanCan
end

def page_is_editable?(page)
  true # Just let everyone edit everything
end

def page_is_editable?(page)
  if current_user.admin?
    true
  elsif page.parent == Thesis::Page.find_by(name: "Blog")
    true
  else
    false
  end
end
```

### Models

Thesis creates two straightforward ActiveRecord tables: pages and page_contents. Since they're normal ActiveRecord models, you're free to use them in your code however you want.

#### Thesis::Page

      t.integer :parent_id
      t.string  :name
      t.string  :slug
      t.string  :title
      t.string  :description
      t.integer :sort_order, default: 0, null: false
      t.string  :template, default: "default", null: false
      t.timestamps

#### Thesis::PageContent

      t.integer :page_id,           null: false
      t.string  :name,              null: false
      t.text    :content,           default: "Edit This Content Area"
      t.string  :content_type,      default: :html
      t.timestamps

### Page Templates

Thesis's installer will drop a `page_templates` folder into your `app/views` folder.
This is where you put different styles of pages for use in the CMS.
Thesis will install an ERB, [HAML](http://haml.info), or [Slim](http://slim-lang.com) version, depending on your configuration.

### Meta information

Pages come with a few built-in fields for use in SEO meta tags.

```slim
head
  title = current_page.title || "Default Title"
  meta content="#{current_page.description}" type="description"
```

### Thesis Editor

Place this right after your opening `body` tag to embed the Thesis editor. It will only show
up if your `page_is_editable?` method returns `true`.

```slim
body
  = thesis_editor
```

### Primary Navigation

Use `root_pages` to get a list of pages at the root level. You can use the
page's `name` and `path` accessors in your links.

```slim
nav
  ul
    li = link_to "Home", root_path # You can mix and match dynamic and static pages
    - root_pages.each do |p|
      li = link_to p.name, p.path
    li = link_to "Static Page", static_page_path
```

### Page content

Content areas are accessible from any page using the `content` method. This method
takes two arguments: name and type. Type defaults to `:html`. The only other type
is `:text` (for now) which is plain text, no HTML accepted. `:image` will be added soon.

Referencing a content area in a page template will create one if it doesn't exist already, using the `default:` value.

```slim
article
  = current_page.content("Main Content", :html, default: "<p>This is my default HTML content.<p>")
  = current_page.content("Splash Image", :image, default: "/assets/default-image.jpg") # coming soon
aside
  = current_page.content("Sidebar Content", :html)
footer
  p = current_page.content("Footer Content", :text, default: "Copyright Me")
```

### Routing

Thesis will automatically handle routes for pages you create with Thesis. Your
routes will take precedence over Thesis-created pages, so if you create a page
with Thesis called "About" and you already have a route for
`get "about" => "something#else"` Thesis won't show the page.

## What Thesis Isn't

You can't have it all. Thesis isn't the same as other -bloated- full-functioned
content management systems out there. This is a list of what it's not now and
not likely to be in the future.

*We reserve the right to change our mind, however, especially with well planned and written
pull requests to help prod us in the right direction. :-)*

1. A WordPress Replacement
2. A full featured CMS
3. A full featured WYSIWYG editor
4. An authentication or permission system
5. A gem that works well with Sinatra or non-ActiveRecord ORMs
6. Anything other than a basic editor for pages and page content

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Write tests for your new feature
5. Run `rake spec` in the root directory to ensure that all tests pass.
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

### Key Contributors

* Jamon Holmgren [@jamonholmgren](https://twitter.com/jamonholmgren)
* Daniel Berkompas [@dberkom](https://twitter.com/dberkom)
* The Infinite Red team

## Premium Support

[Thesis Rails](https://github.com/infinitered/thesis-rails), as an open source project, is free to use and always will be. [Infinite Red](https://infinite.red/) offers premium Thesis Rails support and general mobile app design/development services. Email us at [hello@infinite.red](mailto:hello@infinite.red) to get in touch with us for more details.

FactoryGirl.define do
  factory :page_content, class: Thesis::PageContent do
    name "Content Block"
    content "<h1>Some Header</h1><p>A little paragraph.</p>"
    content_type "html"
  end
end

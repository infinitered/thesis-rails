FactoryGirl.define do
  factory :page, class: Thesis::Page do
    name "Some Page"
    slug "/some-page"
    title "An Awesome Page"
    description "A description goes here"
    template "default"
  end
end

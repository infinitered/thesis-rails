require "spec_helper"

describe Thesis::Page do
  subject(:page) { build(:page) }

  describe "#update_slug" do
    let(:page) { build(:page, slug: "original-slug") }
    it "updates the page's slug attribute, based on the page name" do
      page.name = "New Name"
      page.update_slug
      page.slug.should == "/new-name"
    end
  end
end

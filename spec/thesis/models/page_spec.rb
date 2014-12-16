require "spec_helper"

describe Thesis::Page do
  subject(:page) { create(:page) }

  describe "#update_slug" do
    let(:page) { build(:page, slug: "/original-slug") }

    it "updates the page's slug attribute, based on the page name" do
      page.name = "New Name"
      page.update_slug
      expect(page.slug).to eq "/new-name"
    end
  end

  describe "#update_subpage_slugs" do
    let!(:parent)  { create(:page, name: "Parent") }
    let!(:subpage) { create(:page, name: "Subpage", parent_id: parent.id) }
    
    before { parent.reload }

    it "fixes the subpage's slug attributes when the parent's name is updated" do
      parent.name = "New Parent Name"
      parent.save

      expect(subpage.reload.slug).to eq "/new-parent-name/subpage"
    end
  end

  describe "#content" do
    it "creates a Thesis::PageContent record if one does not exist" do
      page.content("nonexistent-content-block")
      content = Thesis::PageContent.first
      expect(content.name).to eq "nonexistent-content-block"
      expect(content.content_type).to eq "html"
    end
    
    it "returns a string of content" do
      result = page.content("nonexistent-content-block")
      expect(result).to be_a String
    end
  end

  describe "#path" do
    it "is an alias for #slug" do
      expect(page.path).to eq page.slug
    end
  end
end

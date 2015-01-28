require "spec_helper"

describe Thesis::PageContent do
  let(:page)         { create(:page) }
  let(:page_content) { create(:page_content, attributes.merge(page: page)) }

  describe "#render" do
    subject { page_content.render(editable: true) }

    context "when the content type is 'html'" do
      let(:attributes) {{ content_type: 'html' }}

      it { should match /thesis-content-html/ }
      it { should match page_content.content }
    end

    context "when the content type is 'text'" do
      let(:attributes) {{ content_type: "text" }}

      it { should match /thesis-content-text/ }
      it { should match page_content.content }
    end

    context "when the content type is 'image'" do
      let(:attributes) {{ content_type: "image" }}

      it { should match /thesis-content-image/ }
      it { should match /img/ }
      it { should match page_content.content }
    end
  end
end

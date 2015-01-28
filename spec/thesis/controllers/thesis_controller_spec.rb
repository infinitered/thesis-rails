require "spec_helper"

describe Thesis::ThesisController, type: :controller do
  let(:page) { create :page, template: "default" }
  let(:page_content) { create :page_content, name: "Main", page: page }

  before do
    described_class.any_instance.stub(:render).and_return(page.title)
    described_class.any_instance.stub(:template_exists?).and_return(true)
    described_class.any_instance.stub(:page_is_editable?).and_return(true)
  end

  describe "#show" do
    it "displays a page when it can be found" do
      make_request :show, path: page.slug
      expect(response).to_not be_nil
    end

    it "raises PageRequiresTemplate when template can't be found" do
      described_class.any_instance.stub(:template_exists?).and_return(false)
      expect { make_request :show, path: page.slug }.to raise_error Thesis::PageRequiresTemplate
    end
  end

  describe "#create_page" do
    context "when the page can be edited" do
      it "creates a page" do
        make_request :create_page, name: "New Page"
        page = Thesis::Page.last
        expect(page.name).to eq "New Page"
      end
    end

    context "when the page can't be edited" do
      before { described_class.any_instance.stub(:page_is_editable?).and_return(false) }

      it "returns a status of 403 'Forbidden'" do
        make_request :create_page, name: "New Page"
        expect(@response.status).to eq 403
      end
    end
  end

  describe "#update_page" do
    context "when the page can be edited" do
      it "updates the attributes of the page" do
        make_request :update_page, path: page.slug, name: "New Name"
        expect(response.status).to eq 200
        page.reload
        expect(page.name).to eq "New Name"
        expect(page.slug).to eq "/new-name"
      end
    end
  end

  describe "#update_page_content" do
    context "when the page can be edited" do
      it "updates the content on the page" do
        page_content.content = "I'm the content"
        page_content.save

        make_request :update_page_content, { method: :put, page_content.id => "New content" }

        expect(page_content.reload.content).to eq "New content"
      end
    end

    context "when the page can't be edited" do
      before { described_class.any_instance.stub(:page_is_editable?).and_return(false) }

      it "doesn't update the page_content" do
        page_content.content = "I'm the content"
        page_content.save

        make_request :update_page_content, { method: :post, page_content.id => "New content" }

        expect(page_content.reload.content).to eq "I'm the content"
      end
    end
  end
end

# Mock a request to the controller without
# Using Rails routing. Makes the response available
# in the @response instance variable.
def make_request(action, params = {})
  path = params[:path] || "/"
  method = params[:method] || "post"
  env = Rack::MockRequest.env_for(path, params: params.except(:path).except(:method), method: method)
  status, headers, body = described_class.action(action).call(env)
  @response = ActionDispatch::TestResponse.new(status, headers, body)
  @controller = body.instance_variable_get(:@response).request.env['action_controller.instance']
end

def response
  @response
end


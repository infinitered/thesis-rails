require "spec_helper"

describe Thesis::ThesisController do
	let(:page) { create :page, template: "default" }
	
	before do
		described_class.any_instance.stub(:render).and_return(page.title)
		described_class.any_instance.stub(:template_exists?).and_return(true)
		described_class.any_instance.stub(:page_is_editable?).and_return(true)
	end

	describe "#show" do
		it "displays a page when it can be found" do
			make_request :show, path: page.slug
			@response.should_not be_nil
		end

		it "raises RoutingError when the page slug can't be found" do
			expect { make_request :show, path: "/nonexistent" }.to raise_error ActionController::RoutingError
		end

		it "raises PageRequiresTemplate when template can't be found" do
			described_class.any_instance.stub(:template_exists?).and_return(false)
			expect { make_request :show, path: page.slug }.to raise_error Thesis::PageRequiresTemplate
		end
	end

	describe "#new_page" do
		context "when the page can be edited" do
			it "creates a page" do
				make_request :new_page, name: "New Page"
				page = Thesis::Page.last
				expect(page.name).to eq "New Page"
			end
		end

		context "when the page can't be edited" do
			before { described_class.any_instance.stub(:page_is_editable?).and_return(false) }

			it "returns a status of 403 'Forbidden'" do
				make_request :new_page, name: "New Page"
				expect(@response.status).to eq 403	
			end
		end
	end

	describe "#update_page" do
		context "when the page can be edited" do
			it "updates the attributes of the page" do
				make_request :update_page, path: page.slug, name: "New Name"
				page.reload
				expect(page.name).to eq "New Name"
				expect(page.slug).to eq "/new-name"
			end
		end
	end
end

# Mock a request to the controller without
# Using Rails routing. Makes the response available
# in the @response instance variable.
def make_request(action, params = {})
	path = params[:path] || "/"
	env = Rack::MockRequest.env_for(path, :params => params.except(:path), method: :post)
	status, headers, body = described_class.action(action).call(env)
	@response = ActionDispatch::TestResponse.new(status, headers, body)
	@controller = body.request.env['action_controller.instance']
end

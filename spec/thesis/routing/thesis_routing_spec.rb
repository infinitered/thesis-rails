require 'spec_helper'

RSpec.describe Thesis::RouteConstraint do
  subject { Thesis::RouteConstraint.new }
  let(:page) { create :page, template: "default" }

  describe ".matches?" do
    context "proper route" do
      it "returns true" do
        req = Struct.new(:path).new(page.slug)
        expect(subject.matches?(req)).to be_true
      end
    end

    context "invalid route" do
      it "returns false" do
        req = Struct.new(:path).new("invalid")
        expect(subject.matches?(req)).to be_false
      end
    end
  end
end


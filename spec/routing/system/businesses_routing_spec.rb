require "rails_helper"

RSpec.describe System::BusinessesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/system/businesses").to route_to("system/businesses#index")
    end

    it "routes to #new" do
      expect(get: "/system/businesses/new").to route_to("system/businesses#new")
    end

    it "routes to #show" do
      expect(get: "/system/businesses/1").to route_to("system/businesses#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/system/businesses/1/edit").to route_to("system/businesses#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/system/businesses").to route_to("system/businesses#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/system/businesses/1").to route_to("system/businesses#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/system/businesses/1").to route_to("system/businesses#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/system/businesses/1").to route_to("system/businesses#destroy", id: "1")
    end
  end
end

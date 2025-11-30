require "rails_helper"

RSpec.describe Settings::BranchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/system/branches").to route_to("system/branches#index")
    end

    it "routes to #new" do
      expect(get: "/system/branches/new").to route_to("system/branches#new")
    end

    it "routes to #show" do
      expect(get: "/system/branches/1").to route_to("system/branches#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/system/branches/1/edit").to route_to("system/branches#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/system/branches").to route_to("system/branches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/system/branches/1").to route_to("system/branches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/system/branches/1").to route_to("system/branches#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/system/branches/1").to route_to("system/branches#destroy", id: "1")
    end
  end
end

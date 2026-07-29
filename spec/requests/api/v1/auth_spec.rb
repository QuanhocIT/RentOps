require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "POST /api/v1/auth/login" do
    it "logs in successfully with valid credentials and returns real JWT" do
      post "/api/v1/auth/login", params: { email: "admin@rentops.vn", password: "Password123!" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["success"]).to be true
      expect(json["data"]["token"]).to be_present
    end
  end
end

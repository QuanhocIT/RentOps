require 'rails_helper'

RSpec.describe "Api::V1::Automations", type: :request do
  describe "POST /api/v1/automations/trigger_jobs" do
    it "queues all background automation jobs when authenticated" do
      post "/api/v1/auth/login", params: { email: "admin@rentops.vn", password: "Password123!" }
      token = JSON.parse(response.body).dig("data", "token")

      post "/api/v1/automations/trigger_jobs", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["success"]).to be true
      expect(json["message"]).to include("công việc tự động")
    end
  end
end

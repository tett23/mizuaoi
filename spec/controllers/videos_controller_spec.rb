require 'spec_helper'

describe VideosController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'play'" do
    it "returns http success" do
      get 'play'
      response.should be_success
    end
  end

end

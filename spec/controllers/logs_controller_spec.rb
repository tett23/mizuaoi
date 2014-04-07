require 'spec_helper'

describe LogsController do

  describe "GET 'job'" do
    it "returns http success" do
      get 'job'
      response.should be_success
    end
  end

  describe "GET 'encode'" do
    it "returns http success" do
      get 'encode'
      response.should be_success
    end
  end

  describe "GET 'disporsable'" do
    it "returns http success" do
      get 'disporsable'
      response.should be_success
    end
  end

end

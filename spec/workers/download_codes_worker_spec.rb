require "rails_helper"

RSpec.describe DownloadCodesWorker, :type => :job do
  describe "#perform" do
    it "creates a csv" do
      expect(DownloadCodesWorker.generate_csv(attributes: ["A", "B"], codes: [["1", "2"], ["3","4"]])).to eq("A,B\n1,2\n3,4\n")
    end
  end
end
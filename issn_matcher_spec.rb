require_relative 'issn_matcher'

describe ISSNMatcher do

  before do
    @issn_matcher = ISSNMatcher.new({sfx_file: "sfx_test_data.xml", catkey_file: "ckeys022.txt"})
  end

  describe "read SFX data file" do
    context "given an SFX data file" do
      it "should populate a hash of issn->object ID" do
        expect(@issn_matcher.sfx_data).to include("0168-0072" => "954921332001")
      end
    end
  end

  describe "read CATKEY file" do
    context "given a file of catkeys" do
      it "should populate a hash of catkey->issn" do
        expect(@issn_matcher.catkeys).to include("493306" => "0168-0072")
      end

      it "should handle cases with a dash instead of an issn" do
        expect(@issn_matcher.catkeys["483883"]).to eq "NO ISSN"
      end

      it "should handle cases with no issn" do
        expect(@issn_matcher.catkeys["728521"]).to eq "NO ISSN"
      end

      it "should handle issns that end in X" do
        expect(@issn_matcher.catkeys["398511"]).to eq "0006-341X"
      end
    end
  end

  describe "output a merged list" do
    it "should print out a merged line" do
      expect(@issn_matcher.merged("493306")).to eq "493306,0168-0072,954921332001"
      expect(@issn_matcher.merged("728521")).to eq "728521,NO ISSN,"
      expect(@issn_matcher.merged("483883")).to eq "483883,NO ISSN,"
    end
  end
end

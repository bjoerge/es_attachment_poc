require 'spec_helper'

describe Article do

  describe "elasticsearch" do
    before :each do

      Tire.configure do
        #logger STDERR
      end

      Article.index.create :mappings => {
          :article => {
            :properties => {
              :id => {:type => 'string', :index => 'not_analyzed', :include_in_all => false},
              :title => {:type => 'string', :boost => 2.0, :analyzer => 'snowball'},
              :attachment_base64 => {
                :type => 'attachment',
                :fields => {
                  :title => {:store => "yes"},
                  :file => {
                    :term_vector => "with_positions_offsets",
                    :store => "yes"
                  }
                }
              }
            }
          }
        }
    end

    after :each do
      Article.index.delete
    end

    it "indexes an article with a word document as attachment" do
      dirname = File.dirname(__FILE__)

      article = Article.new(:id=>123, :title=>"MS Word document", :attachment_path=>"#{dirname}/example.doc")

      Article.index.import [article]
      Article.index.refresh

      result = Article.search("LQG controllers")
      result.should_not be_empty
    end

    it "indexes an article with a pdf file as attachment" do
      dirname = File.dirname(__FILE__)

      article = Article.new(:id=>123, :title=>"PDF Document", :attachment_path=>"#{dirname}/example.pdf")

      Article.index.import [article]
      Article.index.refresh

      result = Article.search("Elsevier")
      result.should_not be_empty
    end
  end
end

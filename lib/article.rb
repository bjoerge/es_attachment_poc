require 'base64'

class Article < ActiveRecord::Base

  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_reader :id, :title, :attachment_path

  def initialize(attributes={})
    @attributes =  attributes
    @attributes.each_pair { |name,value| instance_variable_set :"@#{name}", value }
  end

  def type
    'article'
  end

  def to_indexed_json
    json = as_json
    json['article']['attachment_base64'] = attachment_base64
    json.to_json
  end

  def attachment_base64
    Base64.encode64(File.read(@attachment_path)) unless @attachment_path.nil?
  end
end
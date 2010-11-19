class Language
  include Mongoid::Document
  field :name, :type => String
  field :code, :type => String
  references_many :conversations
  
  validates_presence_of :name, :code
end

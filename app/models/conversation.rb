class Conversation
  
  require 'google_translate'
  
  include Mongoid::Document
  field :message, :type => String
  field :from_user, :type => Boolean
  field :published_on, :type => DateTime
  referenced_in :language
  
  validates_presence_of :message
  
  after_save :create_translations
  
  private
  def create_translations
    if self.from_user
      Language.all.select{|l| l.id != self.language.id}.each do |lang|
        Conversation.create(
          :message => translate_message(self.language.code, lang.code, self.message), 
          :language_id => lang.id, 
          :from_user => false,
          :published_on => DateTime.now)
      end
    end
  end
  
  def translate_message(from, to, message)
    @api ||= Google::Translator.new
    @api.translate(from, to, message)
  end
end

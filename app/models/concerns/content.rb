module Content
  extend ActiveSupport::Concern

  included do
    include Elastics::ActiveModel
    # uses 'reeis' for ReeisContent etc.
    elastics.index = name.underscore.gsub(/_content$/, '')

    # contains the original url of the crawled document
    attribute :url, :default => '', :analyzed => false
    attribute_created_at
    # leave it as the latest attribute, predefined for the attachment_scope scope
    attribute_attachment

    scope :searchable do |q|
      s =  attachment_scope
          .highlight(:fields => { :attachment          => {},
                                  :'attachment.title'  => {},
                                  :'attachment.author' => {} })
      q.blank? ? s : s.query(q)
    end
  end

  # overrides documents with the same url
  def elastics_id
    Digest::MD5.hexdigest url
  end

  # returns the original title of the document or missing_title
  def attachment_title
    orig_title = super
    orig_title.blank? ? missing_title : orig_title
  rescue NoMethodError
    missing_title
  end

  def missing_title
    'untitled'
  end

end

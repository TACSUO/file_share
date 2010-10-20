module FileContainer
  @@types ||= []

  def self.included(base)
    @@types << base
  
    base.instance_eval do
      include Associations
    end
  end
  def self.types
    @@types.sort
  end

  module Associations
    def self.included(base)
      base.instance_eval do
        has_many :file_attachments, {
          :as => :attachable,
          :dependent => :destroy
        }
      end
    end
  end
end
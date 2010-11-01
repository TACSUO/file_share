module FileContainer
  mattr_reader :types
  
  @@types ||= []

  def self.included(base)
    @@types << base
  
    base.instance_eval do
      include Associations
    end
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
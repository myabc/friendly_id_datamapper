require 'dm-core'
require 'friendly_id/datamapper_adapter/slug'
require 'friendly_id/datamapper_adapter/simple_model'
require 'friendly_id/datamapper_adapter/slugged_model'
require 'forwardable'

module FriendlyId
  module DataMapperAdapter

    include FriendlyId::Base

    def has_friendly_id(method, options = {})
      extend FriendlyId::DataMapperAdapter::ClassMethods
      @friendly_id_config = ::FriendlyId::Configuration.new(self, method, options)

      if friendly_id_config.use_slug?
        include ::FriendlyId::DataMapperAdapter::SluggedModel
      else
        include ::FriendlyId::DataMapperAdapter::SimpleModel
      end
    end

    module ClassMethods
      attr_accessor :friendly_id_config
    end

  end
end

DataMapper::Model.append_extensions FriendlyId::DataMapperAdapter

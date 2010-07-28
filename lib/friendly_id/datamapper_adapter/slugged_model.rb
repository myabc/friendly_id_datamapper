require 'friendly_id/slugged'
require 'friendly_id/status'

module FriendlyId
  module DataMapperAdapter

    module SluggedModel

      class SingleFinder

        include FriendlyId::Finders::Base
        include FriendlyId::Finders::Single

        def find
          result = model_class.first({
            model_class.slugs.name => name,
            # model_class.slugs.sluggable_type => model_class.to_s
            model_class.slugs.sequence => sequence
          })
          # result.friendly_id_status.name = id if result
          result
        end

      end

      include FriendlyId::Slugged::Model

      def self.included(base)
        base.class_eval do
          has 1, :slug,
            :model      => ::FriendlyId::DataMapperAdapter::Slug,
            :child_key  => [:sluggable_id],
            :conditions => {:sluggable_type => "#{base.to_s}"},
            :order      => [:id.desc]
          has n, :slugs,
            :model      => ::FriendlyId::DataMapperAdapter::Slug,
            :child_key  => [:sluggable_id],
            :conditions => {:sluggable_type => "#{base.to_s}"},
            :order      => [:id.desc]

          before :save do
            begin
              build_slug if new_slug_needed?
              method = friendly_id_config.method
            rescue FriendlyId::BlankError
              @errors ||= ValidationErrors.new
              @errors[method] = "can't be blank"
              throw :halt, false
            rescue FriendlyId::ReservedError
              @errors ||= ValidationErrors.new
              @errors[method] = "is reserved"
              throw :halt, false
            end
          end

          after(:save) do
            throw :halt, false if friendly_id_config.allow_nil? && !slug
            slug.sluggable_id = id
            slug.save
          end
        end

        def base.get(*key)
          if key.size == 1
            repository = self.repository
            key        = self.key(repository.name).typecast(key)
            SingleFinder.new(key, self).find or super
          else
            super
          end
        end
      end

      def find_slug(name, sequence)
        slugs.first(:name => name, :sequence => sequence)
      end

      def self.slug_class
        FriendlyId::DataMapperAdapter::Slug
      end

      private

      def build_slug
        self.slug = SluggedModel.slug_class.new(:name => slug_text,
          :sluggable_type => self.class.to_s, :sluggable_id => self.id)
      end

      def skip_friendly_id_validations
        friendly_id.nil? && friendly_id_config.allow_nil?
      end

    end
  end
end

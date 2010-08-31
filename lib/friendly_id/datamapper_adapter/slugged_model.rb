require 'friendly_id/slugged'
require 'friendly_id/status'

module FriendlyId
  module DataMapperAdapter

    module SluggedModel

      include FriendlyId::Slugged::Model

      def self.included(base)
        base.class_eval do
          has n, :slugs,
            :model      => ::FriendlyId::DataMapperAdapter::Slug,
            :child_key  => [:sluggable_id],
            :conditions => { :sluggable_type => base },
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
            return super if key.first.unfriendly_id?
            name, sequence = key.first.to_s.parse_friendly_id
            repository = self.repository
            result     = self.first({
              slugs.name     => name,
              slugs.sequence => sequence
            })
            return super unless result
            result.friendly_id_status.name = name
            result.friendly_id_status.sequence = sequence
            result
          else
            super
          end
        end
      end

      def slug
        @slug ||= slugs.first
      end

      def find_slug(name, sequence)
        @slug = slugs.first(:name => name, :sequence => sequence)
        #s = FriendlyId::DataMapperAdapter::Slug.first(:name => name, :sequence => sequence,
        #  :sluggable_type => self.class)
        @slug
      end

      def self.slug_class
        FriendlyId::DataMapperAdapter::Slug
      end

      private

      def build_slug
        @slug = slugs.new(:name => slug_text)
        raise FriendlyId::BlankError unless @slug.valid?
        @slug
      end

      def skip_friendly_id_validations
        friendly_id.nil? && friendly_id_config.allow_nil?
      end

    end
  end
end

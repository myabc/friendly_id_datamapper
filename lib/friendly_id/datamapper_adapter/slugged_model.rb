require 'friendly_id/slugged'
require 'friendly_id/status'

module FriendlyId
  module DataMapperAdapter

    module SluggedModel

      include FriendlyId::Slugged::Model

      def self.included(base)
        base.class_eval do
          has n, :slugs,
            :model      => ::Slug,
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
            set_slug_cache
          end

        end

        def base.get(*key)
          if key.size == 1
            return super if key.first.unfriendly_id?
            name, sequence = key.first.to_s.parse_friendly_id

            if friendly_id_config.cache_column?
              result = self.first(friendly_id_config.cache_column => key.first)
            end

            result ||= self.first({
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
      end

      # Returns the friendly id, or if none is available, the numeric id. Note that this
      # method will use the cached_slug value if present, unlike {#friendly_id}.
      def to_param
        friendly_id_config.cache_column ? to_param_from_cache : to_param_from_slug
      end

      private

      # Respond with the cached value if available.
      def to_param_from_cache
        attribute_get(friendly_id_config.cache_column) || id.to_s
      end

      # Respond with the slugged value if available.
      def to_param_from_slug
        slug? ? slug.to_friendly_id : id.to_s
      end

      # Build the new slug using the generated friendly id.
      def build_slug
        return unless new_slug_needed?
        @slug = slugs.new(:name => slug_text)
        raise FriendlyId::BlankError unless @slug.valid?
        @new_friendly_id = @slug.to_friendly_id
        @slug
      end

      # Reset the cached friendly_id?
      def new_cache_needed?
        uses_slug_cache? && slug? && send(friendly_id_config.cache_column) != slug.to_friendly_id
      end

      # Reset the cached friendly_id.
      def set_slug_cache
        if new_cache_needed?
          self.attribute_set(friendly_id_config.cache_column, slug.to_friendly_id)
          self.save_self(false) # save!
        end
      end

      def skip_friendly_id_validations
        friendly_id.nil? && friendly_id_config.allow_nil?
      end

      # Does the model use slug caching?
      def uses_slug_cache?
        friendly_id_config.cache_column?
      end

    end
  end
end

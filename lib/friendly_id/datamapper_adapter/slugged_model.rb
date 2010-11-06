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

          after :update, :update_scope
          after :update, :update_dependent_scopes

          before(:destroy) do
            slugs.destroy!
          end
        end

        def base.extract_options!(args)
          options = args.last
          if options.respond_to?(:to_hash)
            args.pop
            options.to_hash.dup
          else
            {}
          end
        end

        base.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.get(*key)
            options = extract_options!(key)

            if key.size == 1
              return super if key.first.unfriendly_id?
              name, sequence = key.first.to_s.parse_friendly_id

              if !friendly_id_config.scope? && friendly_id_config.cache_column?
                result = self.first(friendly_id_config.cache_column => key.first)
              end

              conditions = {
                slugs.name     => name,
                slugs.sequence => sequence
              }
              conditions.merge!({
                slugs.scope    => (options[:scope].to_param if options[:scope] && options[:scope].respond_to?(:to_param))
              }) if friendly_id_config.scope?

              result ||= self.first(conditions)
              return super unless result
              result.friendly_id_status.name = name
              result.friendly_id_status.sequence = sequence
              result
            else
              super
            end
          end

          def self.get!(*key)
            return super unless friendly_id_config.scope?

            result = get(*key)
            if result
              result
            else
              options = extract_options!(key)
              scope   = options[:scope]
              message = "Could not find \#{self.name} with key \#{key.inspect}"
              message << " and scope \#{scope.inspect}" if scope
              message << ". Scope expected but none given." unless scope
              raise(::DataMapper::ObjectNotFoundError, message)
            end
          end
        RUBY
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

      def scope_changed?
        friendly_id_config.scope? && send(friendly_id_config.scope).to_param != slug.scope
      end

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
        @slug = slugs.new(:name => slug_text, :scope => friendly_id_config.scope_for(self))
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

      def update_scope
        return unless slug && scope_changed?
        transaction do
          slug.scope = send(friendly_id_config.scope).to_param
          similar = Slug.similar_to(slug)
          if !similar.empty?
            slug.sequence = similar.first.sequence.succ
          end
          slug.save
        end
      end

      # Update the slugs for any model that is using this model as its
      # FriendlyId scope.
      def update_dependent_scopes
        return unless friendly_id_config.class.scopes_used?
        # slugs.reload.size == 1, slugs.dirty? == true
        if slugs.size > 1 && @new_friendly_id
          friendly_id_config.child_scopes.each do |klass|
            # slugs.first -- ordering not respected when dirty
            Slug.all(:sluggable_type => klass, :scope => slugs.first.to_friendly_id).update(:scope => @new_friendly_id)
          end
        end
      end

      # Does the model use slug caching?
      def uses_slug_cache?
        friendly_id_config.cache_column?
      end

    end
  end
end

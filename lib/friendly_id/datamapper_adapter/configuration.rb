module FriendlyId
  module DataMapperAdapter
    # Extends FriendlyId::Configuration with some implementation details and
    # features specific to DataMapper.
    class Configuration < FriendlyId::Configuration

=begin
      # The column used to cache the friendly_id string. If no column is specified,
      # FriendlyId will look for a column named +cached_slug+ and use it automatically
      # if it exists. If for some reason you have a column named +cached_slug+
      # but don't want FriendlyId to modify it, pass the option
      # +:cache_column => false+ to {FriendlyId::DataMapperAdapter#has_friendly_id has_friendly_id}.
      attr_accessor :cache_column

      def cache_column
        return @cache_column if defined?(@cache_column)
        @cache_column = autodiscover_cache_column
      end

      def cache_column?
        !! cache_column
      end

      def autodiscover_cache_column
        :cached_slug if configured_class.properties.any? { |p| p.name == 'cached_slug' }
      end
=end

    end
  end
end

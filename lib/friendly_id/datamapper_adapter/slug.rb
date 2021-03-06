# A Slug is a unique, human-friendly identifier for a DataMapper model
class Slug
  include ::DataMapper::Resource

  property :id,             Serial
  property :name,           String,   :index => :index_slugs_on_n_s_s_and_s, :required => true, :length => 1..255
  property :sluggable_id,   Integer,  :index => :sluggable_id
  property :sequence,       Integer,  :index => :index_slugs_on_n_s_s_and_s, :required => true, :default => 1
  property :sluggable_type, Class,    :index => :index_slugs_on_n_s_s_and_s
  property :scope,          String,   :index => :index_slugs_on_n_s_s_and_s
  property :created_at,     DateTime

  before :save do
    self.sequence   = next_sequence
    self.created_at = DateTime.now
  end

  def self.similar_to(slug)
    all({
      :name           => slug.name,
      :scope          => slug.scope,
      :sluggable_type => slug.sluggable_type,
      :order          => [:sequence.asc]
    })
  end

  # Whether this slug is the most recent of its owner's slugs.
  def current?
    sluggable.slug == self
  end

  def outdated?
    !current?
  end

  def to_friendly_id
    sequence > 1 ? friendly_id_with_sequence : name
  end

  def sluggable
    sluggable_type.get(sluggable_id)
  end

  def sluggable=(instance)
    attribute_set(:sluggable_type, instance.class)
    attribute_set(:sluggable_id,   instance.id)
  end

  private

  def enable_name_reversion
    conditions = { :sluggable_id => sluggable_id, :sluggable_type => sluggable_type,
        :name => name, :scope => scope }
    self.class.all(conditions).destroy
  end

  def friendly_id_with_sequence
    "#{name}#{separator}#{sequence}"
  end

  def next_sequence
    enable_name_reversion
    conditions =  { :name => name, :scope => scope, :sluggable_type => sluggable_type }
    prev = self.class.first(conditions.update(:order => :sequence.desc))
    prev ? prev.sequence.succ : 1
  end

  def separator
    sluggable_type.friendly_id_config.sequence_separator
  end

end

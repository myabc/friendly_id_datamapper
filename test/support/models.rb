# A model that uses the automagically configured "cached_slug" column
class District
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String
  property :note,         String
  property :cached_slug,  String, :index => :unique
  has_friendly_id :name, :use_slug => true
end

# A model with optimistic locking enabled
class Region
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String
  property :cached_slug,  String, :index => :unique
  property :note,         String
  property :lock_version, Integer, :required => true, :default => 0

  has_friendly_id :name, :use_slug => true

  after :create do
    other_instance = Region.get(self.id)
    other_instance.update_attributes(:note => name + "!")
  end
end

# A model that specifies a custom cached slug column
class City
  include DataMapper::Resource
  property :id,         Serial
  property :name,       String
  property :my_slug,    String, :index => :unique
  property :population, Integer
  has_friendly_id :name, :use_slug => true, :cache_column => 'my_slug'
end

# A model with a custom slug text normalizer
class Person
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  property :note, String
  belongs_to :country, :required => false # Prevent DataMapper from creating
                                          # an implicit required association
  has_friendly_id :name, :use_slug => true

  def normalize_friendly_id(string)
    string.upcase
  end

end

# A model that doesn't use FriendlyId
class Unfriendly
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
end

# A slugged model that uses a scope
class Resident
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  belongs_to :country
  has_friendly_id :name, :use_slug => true, :scope => :country
end

# A slugged model used as a scope
class Country
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  has n, :people
  has n, :residents
  has_friendly_id :name, :use_slug => true
end

# A model that doesn't use slugs
class User
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  has_friendly_id :name
  has n, :houses
end

# Another model that doesn"t use slugs
class Author
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  has_friendly_id :name
end


# A model that uses a non-slugged model for its scope
class House
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  belongs_to :user
  has_friendly_id :name, :use_slug => true, :scope => :user
end

# A model that uses default slug settings and has a named scope
class Post
  include DataMapper::Resource
  property :id,         Serial
  property :name,       String
  property :published,  Boolean
  property :note,       String
  has_friendly_id :name, :use_slug => true

  def self.published
    all(:published => true)
  end
end

# Model that uses a custom table name
class Place
  include DataMapper::Resource
  storage_names[:default] = 'legacy_table'
  property :id,   Serial
  property :name, String
  property :note, String
  has_friendly_id :name, :use_slug => true
end

# A model that uses a datetime field for its friendly_id
class Event
  include DataMapper::Resource
  property :id,         Serial
  property :name,       String
  property :event_date, DateTime
  has_friendly_id :event_date, :use_slug => true
end

# A base model for single table inheritence
class Book
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
  property :type, String
  property :note, String
end

# A model that uses STI
class Novel < ::Book
  has_friendly_id :name, :use_slug => true
end

=begin
# A model with no table
class Question
  include DataMapper::Resource
  has_friendly_id :name, :use_slug => true
end

# A model to test polymorphic associations
class Site
  include DataMapper::Resource
  property :name
  belongs_to :owner, :polymorphic => true
  has_friendly_id :name, :use_slug => true
end

# A model used as a polymorphic owner
class Company
  include DataMapper::Resource
  property :name, String
  has n, :sites, :as => :owner
end
=end

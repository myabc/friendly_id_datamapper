This is an in-development experimental adapter for
[FriendlyId](http://norman.github.com/friendly_id) using DataMapper.

It currently supports all of FriendlyId's features except:

* Rails Generator
* Support for multiple finders

Currently, only finds using `get` is supported.

    @post = Post.get("this-is-a-title")
    @post.friendly_id # this-is-a-title

## Usage

    gem install friendly_id friendly_id_datamapper

    require "friendly_id"
    require "friendly_id/datamapper"

    class Post
      include DataMapper::Resource

      property :id,    Serial
      property :title, String

      has_friendly_id :title, :use_slug => true
    end


For more information on the available features, please see the
[FriendlyId Guide](http://norman.github.com/friendly_id/file.Guide.html).

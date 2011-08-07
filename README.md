# FriendlyId DataMapper Adapter

This is an pre-release (beta) adapter for
[FriendlyId](http://norman.github.com/friendly_id) using DataMapper.

## FriendlyId Features

It currently supports all of FriendlyId's features except:

* Rails Generator
* Support for multiple finders

Currently, only finds using `get` is supported.

    @post = Post.get("this-is-a-title")
    @post.friendly_id # this-is-a-title

## Compatibility

The FriendlyId DataMapper Adapter keeps in lock-step with major and
minor versions of the FriendlyId gem, i.e.
`friendly_id_datamapper 3.1.x` is compatible with `friendly_id 3.1.x series`.
Patch and build versions are not kept in lock-step.

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

## Bugs

Please report them on the [Github issue tracker](http://github.com/myabc/friendly_id_datamapper/issues)
for this project.

If you have a bug to report, please include the following information:

* **Version information for FriendlyId, friendly_id_datamapper, Rails and Ruby.**
* Stack trace and error message.
* Any snippets of relevant model, view or controller code that shows how your
  are using FriendlyId.

If you are able to, it helps even more if you can fork FriendlyId on Github,
and add a test that reproduces the error you are experiencing.

## Credits

Copyright (c) 2010, 2011, released under the MIT license.

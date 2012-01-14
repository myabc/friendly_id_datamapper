# FriendlyId DataMapper Adapter

[![Build Status](https://travis-ci.org/myabc/friendly_id_datamapper.png)](http://travis-ci.org/myabc/friendly_id_datamapper)

An adapter for [FriendlyId](https://github.com/norman/friendly_id/tree/3.x) 3.x
using DataMapper. _N.B. This adapter does not support FriendlyId 4.x._

## FriendlyId Features

It currently supports all of FriendlyId's features except:

* Rails Generator

Currently, only finds using `get` are supported.

    @post = Post.get("this-is-a-title")
    @post.friendly_id # this-is-a-title

## Compatibility

The FriendlyId DataMapper Adapter keeps in lock-step with major and minor
versions of the FriendlyId gem, i.e. `friendly_id_datamapper 3.2.x` is
compatible with `friendly_id 3.2.x series`. Patch and build versions are not
kept in lock-step.

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
[FriendlyId 3.x Guide](https://github.com/norman/friendly_id/blob/3.x/Guide.md).

Documentation for FriendlyId 3.x may also be found on [rubydoc.info](http://rubydoc.info/gems/friendly_id/3.3.1).

## Known Issues

FriendlyId DataMapper Adapter is not yet compatible with Ruby 1.9.3, because of
an issue with a dependency `dm-do-adapter` and changes with the DateTime class,
after its reimplementation in C (namely, `DateTime#new!` no longer exists).

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

Copyright (c) 2010, 2011, 2012 released under the MIT license.

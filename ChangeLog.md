# FriendlyId DataMapper Adapter Changelog

* Table of Contents
{:toc}

## 3.2.0 (2011-08-08)

* Release offering compatibility with FriendlyId 3.2.x series.
* Release provides support for both DataMapper 1.0.x and 1.1.x series:
  * Silence noisy deprecation warnings on DataMapper 1.1 (11a6dd5).
* Gemspec compatibility with RubyGems 1.7+:
  * Fix Rake and RubyGems deprecation warnings (030df1f, 132e4ba).
* Optimize to use Rails extract_options method. Ignore Array keys when doing
  lookup ([Josh Huckabee](http://github.com/jhuckabee), f11f206).
* Fix for orphaned slugs on deletion of a FriendlyId model instance, without
  using dm-constraints (54d3a9c).
* Workaround an issue overriding DataMapper::Model#get on 1.9.2 that results in
  "NotImplementedError - super from singleton method that is defined to multiple
  classes is not supported" (0cd55ab).

Additionally this release establishes Continuous Integration, using the
excellent [Travis CI](http://travis-ci.org/) hosted CI service. This should lead
to more reliable future releases!

## 3.1.0 (not released)

## 3.1.0.beta1 (2010-09-13)

* Initial beta release.

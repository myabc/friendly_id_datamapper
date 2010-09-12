# encoding: utf-8
require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test

    class SlugTest < ::Test::Unit::TestCase

      def teardown
        Slug.all.destroy!
        Post.all.destroy!
      end

      test "should indicate if it is the most recent slug" do
        post = Post.create(:name => "test title")
        post.name = "a new title"
        post.save
        post.slugs.reload # DM issue: collection must be reloaded for correct ordering by id desc (for #first/#last)
        assert post.slugs.first.current?
        assert !post.slugs.last.current?
      end

      test "should include the sequence if the sequence is greater than 1" do
        slug = Slug.new(:name => "test", :sluggable => Post.new, :sequence => 2)
        assert_equal "test--2", slug.to_friendly_id
      end

      test "should not include the sequence if the sequence is 1" do
        slug = Slug.new(:name => "test",  :sluggable => Post.new, :sequence => 1)
        assert_equal "test", slug.to_friendly_id
      end

    end
  end
end

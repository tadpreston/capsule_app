module CapsuleCachedAssociations
  extend ActiveSupport::Concern

  included do

    def cached_user
      Rails.cache.fetch(["capsule/author", self]) { user }
    end

    def cached_recipients
      Rails.cache.fetch(["capsule/recipients", self]) { recipients.to_a }
    end

    def cached_assets
      Rails.cache.fetch(["capsule/assets", self]) { assets.to_a }
    end

    def cached_comments
      Rails.cache.fetch(["capsule/comments", self]) { comments.to_a }
    end

    def cached_read_by
      Rails.cache.fetch(["capsule/read_by", self]) { read_by.to_a }
    end

    def cached_watchers
      Rails.cache.fetch(["capsule/watchers", self]) { watchers.to_a }
    end
  end
end

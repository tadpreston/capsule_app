module IsLikeable
  extend ActiveSupport::Concern

  included do
    attr_accessor :likes
    mattr_accessor :likes_accessor do
      []
    end
    self.after_initialize :likes_initializer
  end

  module ClassMethods
    def is_likeable(store)
      likes_accessor << store
    end
  end

  class LikeAccessor
    def initialize(object, store)
      @object = object
      @likes_store = store

      initialize_store
    end

    def << (id)
      ids_array = get_array
      unless ids_array.include? id
        ids_array << id
        @object[@likes_store] = { "ids" => ids_array }
      end
    end

    def delete(id)
      ids_array = get_array
      if ids_array.include? id
        ids_array.delete id
        @object[@likes_store] = { "ids" => ids_array }
      end
    end

    def to_s
      get_array.join(',')
    end

    def inspect
      get_array
    end

    def include?(id)
      ids_array = get_array
      ids_array.include? id
    end

    def size
      get_array.size
    end

    private

      def initialize_store
        @object[@likes_store] = { "ids" => [] } if @object[@likes_store].nil?
      end

      def get_array
        eval(@object[@likes_store]["ids"])
      end
  end

  private

    def likes_initializer
      begin
        @likes = LikeAccessor.new(self, likes_accessor[0])
      rescue ActiveModel::MissingAttributeError
      end
    end

end

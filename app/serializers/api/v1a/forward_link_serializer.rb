module API
  module V1a
    class ForwardLinkSerializer < ActiveModel::Serializer
      attributes *(Feed::ATTRIBUTES)
    end
  end
end

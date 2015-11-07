module API
  module V1a
    class ForwardLinkSerializer < ActiveModel::Serializer
      attributes *(ForwardLink::ATTRIBUTES)
    end
  end
end

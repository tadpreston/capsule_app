class RegisteredUserSerializer < ActiveModel::Serializer
  attributes *RegisteredUser::ATTRIBUTES
end

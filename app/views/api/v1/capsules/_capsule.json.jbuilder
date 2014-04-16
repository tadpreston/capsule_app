json.capsule do
  json.id capsule.id
  json.partial! 'api/v1/users/user', user: capsule.user
  json.title capsule.title
  json.set! :hash_tags, capsule.hash_tags.split(' ')
  json.purged_title capsule.purged_title
  json.location capsule.location
  json.payload_type capsule.payload_type
  json.status capsule.status
  json.promotional_state capsule.promotional_state
  json.lock_question capsule.lock_question
  json.lock_answer capsule.lock_answer
  json.visibility capsule.visibility
end

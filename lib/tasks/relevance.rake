namespace :db do
  namespace :relevance do
    task :initialize => :environment do
      Capsule.all.each do |capsule|
        capsule.relevances.create user_id: capsule.user_id, relevant_date: capsule.updated_at
        capsule.recipients.each do |recipient|
          capsule.relevances.create user_id: recipient.id, relevant_date: capsule.updated_at
        end
      end
    end
  end
end

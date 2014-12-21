module Users
  class Search
    def self.find_or_create_by_oauth(oauth)
      User.find_or_create_by(provider: oauth[:provider], uid: oauth[:uid].to_s) do |user|
        user.oauth = oauth
      end
    end

    def self.find_or_create_by_phone_number(phone_number, user_attributes = {})
      User.find_or_create_by(phone_number: phone_number) do |user|
        user.email = user_attributes[:email]
        user.full_name = user_attributes[:full_name]
        user.provider = user_attributes[:provider] || 'capsule'
        tmp_pwd = SecureRandom.hex
        user.password = tmp_pwd
        user.password_confirmation = tmp_pwd
      end
    end

    def self.find_or_create_recipient(attributes)
      args = attributes[:email] ? { email: attributes[:email] } : { phone_number: attributes[:phone_number] }

      User.find_or_create_by(args) do |user|
        user.instance_eval('generate_token(:recipient_token)')
        tmp_pwd = SecureRandom.hex
        user.password = tmp_pwd
        user.password_confirmation = tmp_pwd
        user.provider = 'recipient'
        attributes.each do |key, val|
          user[key] = val
        end
      end
    end

    def self.by_identity(query)
      user_query = query.split(' ').select { |s| s.include? '@' }.join
      if user_query[0] == '@'
        User.where(username: user_query[/(?<=@).*/])
      else
        User.where(email: user_query)
      end
    end

    def self.by_name(query)
      user_query = query.split
      where_clause = []
      user_query.each do |q|
        where_clause << '(' + %w[full_name].map { |column| "#{column} ilike '%#{q}%'" }.join(' OR ') + ')'
      end
      User.where(where_clause.join(' AND '))
    end
  end
end

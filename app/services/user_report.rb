class UserReport
  attr_reader :report_params, :users

  def self.registrations start_date=Date.today
    user_report = new start_date: start_date
    user_report.registrations
  end

  def initialize params
    @report_params = params
  end

  def registrations
    start_date = DateTime.parse report_params.fetch(:start_date, DateTime.now)
    @users = User.where('created_at >= ? AND provider = ?', start_date, 'capsule')
    self
  end

  def to_csv
    CSV.generate do |csv|
      csv << ['Full Name', 'Email', 'Registration Date']
      users.each { |user| csv << [user.full_name, user.email, user.created_at] }
    end
  end
end

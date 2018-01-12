class HomeController < ActionController::Base
  layout "application"
  def index
    Time.zone = "Central Time (US & Canada)"
    @users = User.all

    @weight_data = {}

    @users.order(:id).each do |user|
      user_data = @weight_data[user.id] = {}

      user.weight_data.group_by{|d| (d.created_at.in_time_zone).all_week}.each do |date, weights|
        user_data[date.first.strftime("%b %d, %Y")] = weights.max_by(&:created_at).weight
      end

      @this_week = {}
      @users.order(:id).each do |user|
        data = @this_week[user.id] = {}
        prev_weight = ""
        Date.today().all_week.each do |date|
          if date <= Date.today()
            weight = user.weight_data.select{|d| (d.created_at.in_time_zone).to_date == date}.first
            if weight.nil?
              data[date] = prev_weight
            else
              data[date] = weight.weight
              prev_weight = weight.weight
            end
          end
        end
      end
    end
  end

  def paid
    user = User.find(params[:id])
    user.update_attribute('paid', true)
    render :nothing => true
  end

end

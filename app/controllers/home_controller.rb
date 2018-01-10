class HomeController < ActionController::Base
  layout "application"
  def index
    @users = User.all

    @weight_data = {}

    @users.order(:id).each do |user|
      user_data = @weight_data[user.id] = {}

      user.weight_data.group_by{|d| (d.created_at-6.hours).all_week}.each do |date, weights|
        user_data[date.first.strftime("%b %d, %Y")] = weights.max_by(&:created_at).weight
      end

      @this_week = {}
      @users.order(:id).each do |user|
        data = @this_week[user.id] = {}
        prev_weight = ""
        Date.today().all_week.each do |date|
          if date <= Date.today()
            weight = user.weight_data.select{|d| (d.created_at-6.hours).to_date == date}.first
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

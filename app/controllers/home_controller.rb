class HomeController < ActionController::Base
  layout "application"
  def index
    @users = User.all

    @weight_data = {}

    @users.order(:id).each do |user|
      user_data = @weight_data[user.id] = {}

      user.weight_data.group_by{|d| d.created_at.all_week}.each do |date, weights|
        user_data[date.first.strftime("%b %d, %Y")] = weights.max_by(&:created_at).weight
      end

      @this_week = {}
      @users.order(:id).each do |user|
        data = @this_week[user.id] = {}
        Date.today().all_week.each do |date|
          weight = user.weight_data.select{|d| d.created_at.to_date == date}.first
          data[date] = weight.weight unless weight.nil?
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

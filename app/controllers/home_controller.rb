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
    end
  end

  def paid
    user = User.find(params[:id])
    user.update_attribute('paid', true)
    render :nothing => true
  end

end

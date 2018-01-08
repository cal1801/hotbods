class HomeController < ActionController::Base
  layout "application"
  def index
    @users = User.all

    @weight_data = {}
    @users.each do |user|
      user_data = @weight_data[user.id] = {}
      user.weight_data.each do |weight|
        user_data[weight.created_at] = weight.weight
      end
    end
  end

end

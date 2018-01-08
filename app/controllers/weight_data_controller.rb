class WeightDataController < ActionController::Base
  layout "application"
  def new
    @weight = WeightDatum.new
  end

  def create
    WeightDatum.create(weight_datum_params)

    redirect_to "/"
  end

  private

  def weight_datum_params
    params.require(:weight_datum).permit(:weight, :user_id)
  end
end

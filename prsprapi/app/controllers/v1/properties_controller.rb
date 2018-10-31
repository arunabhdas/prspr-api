class V1::PropertiesController < ApiController
    # skip_before_action :require_login!

    def index
        @properties = Property.all

        render json: @properties, status: :ok
    end


    def create
        @property = Property.new(property_params)
        # byebug
        @property.save
        render :create, status: :created
        # render json: @property, status: :created
    end

    def destroy
        @property = Property.where(id: params[:id]).first
        if @property.destroy
            head(:ok)
        else
            head(:unprocessable_entity)
        end
    end


    def property_params
        params.permit(:title, :desc, :address_id, :avatar_url)
    end

end

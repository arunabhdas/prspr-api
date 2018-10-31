class V1::AddressesController < ApiController
    # skip_before_action :require_login!

    def index
        @addresses = Address.all

        render json: @addresses, status: :ok
    end
end

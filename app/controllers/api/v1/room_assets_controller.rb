module Api
  module V1
    class RoomAssetsController < BaseController
      def index
        assets = RoomAsset.all
        assets = assets.where(property_id: params[:property_id]) if params[:property_id].present?
        assets = assets.where(room_id: params[:room_id]) if params[:room_id].present?
        
        render json: assets
      end

      def create
        asset = RoomAsset.new(asset_params)
        if asset.save
          render json: asset, status: :created
        else
          render json: { errors: asset.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        asset = RoomAsset.find(params[:id])
        if asset.update(asset_params)
          render json: asset
        else
          render json: { errors: asset.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        asset = RoomAsset.find(params[:id])
        asset.destroy
        head :no_content
      end

      private

      def asset_params
        params.require(:room_asset).permit(:room_id, :property_id, :name, :asset_code, :category, :condition, :quantity, :purchase_price, :installed_at, :notes)
      end
    end
  end
end

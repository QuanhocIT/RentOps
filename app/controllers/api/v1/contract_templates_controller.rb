module Api
  module V1
    class ContractTemplatesController < BaseController
      def index
        templates = ContractTemplate.all
        if templates.empty?
          templates = [
            ContractTemplate.create!(
              name: "Hợp đồng Thuê nhà Trọ / Căn hộ Chuẩn",
              content: "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc\n\nHỢP ĐỒNG CHO THUÊ PHÒNG TRO\n\nBên A (Bên cho thuê): {{landlord_name}} - SĐT: {{landlord_phone}}\nBên B (Bên thuê): {{tenant_name}} - CCCD: {{tenant_id_card}}\n\nHai bên thỏa thuận thuê phòng số {{room_number}} tại địa chỉ {{property_address}} với giá {{monthly_rent}} VNĐ/tháng. Đặt cọc {{deposit_amount}} VNĐ. Hợp đồng có hiệu lực từ {{start_date}} đến {{end_date}}.",
              is_default: true,
              description: "Mẫu hợp đồng pháp lý đầy đủ quy định về cọc, điều khoản sử dụng điện nước và hủy hợp đồng."
            )
          ]
        end
        render json: templates
      end

      def create
        tpl = ContractTemplate.new(template_params)
        if tpl.save
          render json: tpl, status: :created
        else
          render json: { errors: tpl.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        tpl = ContractTemplate.find(params[:id])
        if tpl.update(template_params)
          render json: tpl
        else
          render json: { errors: tpl.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def template_params
        params.require(:contract_template).permit(:name, :content, :is_default, :description)
      end
    end
  end
end

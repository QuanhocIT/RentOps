# Tài liệu mô tả thiết kế hệ thống SaaS quản lý phòng trọ RentOps

**Phiên bản:** 1.0  
**Phạm vi:** Kiến trúc hệ thống, hiệu năng, bảo mật, API, UI/UX, cơ sở dữ liệu, lộ trình triển khai  
**Mục tiêu:** Mô tả đầy đủ một nền tảng SaaS multi-tenant cho chủ trọ, nhân viên vận hành và khách thuê

## 1. Tổng quan hệ thống

RentOps là nền tảng phần mềm dịch vụ (SaaS) multi-tenant dành cho quản lý phòng trọ, căn hộ dịch vụ và chuỗi cho thuê quy mô nhỏ đến lớn. Hệ thống cho phép nhiều chủ trọ sử dụng chung một hạ tầng nhưng dữ liệu được cô lập theo tenant, bảo đảm an toàn, tối ưu chi phí và dễ mở rộng.

### 1.1. Bài toán đặt ra

Các đơn vị quản lý nhà trọ thường gặp những vấn đề sau:

- Quản lý phòng, hợp đồng, hóa đơn và công nợ bằng Excel hoặc sổ tay nên dễ sai sót.
- Khối lượng dữ liệu tăng nhanh nhưng hệ thống chậm dần theo thời gian.
- Rủi ro mất dữ liệu khi nhân viên thao tác nhầm hoặc xóa nhầm.
- Thanh toán thủ công, đối soát chậm, khó theo dõi trạng thái thu tiền.
- Cần phân quyền rõ ràng cho chủ trọ, kế toán, lễ tân và nhân viên vận hành.

### 1.2. Mục tiêu thiết kế

Hệ thống được thiết kế để đạt 4 mục tiêu chính:

- Tốc độ xử lý nhanh, phản hồi tốt ngay cả khi dữ liệu tăng lớn.
- Dữ liệu tài chính và định danh được bảo vệ chặt chẽ.
- Có khả năng vận hành liên tục, chống gián đoạn dịch vụ.
- Trải nghiệm người dùng thân thiện, thao tác nhanh trên web và mobile.

---

## 2. Kiến trúc tổng thể

### 2.1. Mô hình kiến trúc

Hệ thống được triển khai theo mô hình:

- **Frontend SPA:** Vue 3 + Vite + Pinia
- **Backend API:** Ruby on Rails API mode
- **Database:** MySQL 8.0 InnoDB
- **Cache / Queue:** Redis + Sidekiq
- **Auth:** JWT Bearer Token
- **Security Edge:** Cloudflare WAF + Nginx + Fail2ban

### 2.2. Luồng hoạt động tổng quát

1. Người dùng truy cập ứng dụng qua domain hoặc subdomain của tenant.
2. Cloudflare chặn bot, DDoS và lưu lượng bất thường ở lớp biên.
3. Nginx tiếp nhận request hợp lệ, áp rate limit theo endpoint.
4. Rails xác thực JWT, xác định tenant hiện tại và kiểm tra quyền truy cập.
5. API truy vấn MySQL với index phù hợp và chỉ lấy các cột cần thiết.
6. Tác vụ nặng được đẩy sang Sidekiq để xử lý nền.
7. Các số liệu dashboard được đọc từ cache hoặc bảng tổng hợp thay vì tính trực tiếp.

---

## 3. Tổng quan nghiệp vụ

### 3.1. Vai trò người dùng

- **Super Admin:** quản trị toàn hệ thống, xem danh sách tenant, cấu hình gói cước, xử lý sự cố.
- **Tenant Owner:** chủ trọ/chủ doanh nghiệp, quản lý toàn bộ dữ liệu trong tenant của mình.
- **Staff:** nhân viên vận hành, nhập chỉ số điện, cập nhật phòng, hỗ trợ tạo hóa đơn.
- **Renter:** khách thuê, xem hóa đơn, thanh toán, tra cứu thông tin hợp đồng.

### 3.2. Chức năng cốt lõi

- Quản lý tòa nhà, dãy trọ và phòng.
- Quản lý khách thuê và hợp đồng thuê.
- Ghi nhận chỉ số điện, nước và phụ phí.
- Tạo hóa đơn định kỳ và theo dõi công nợ.
- Sinh mã thanh toán VietQR cho từng hóa đơn.
- Đồng bộ trạng thái thanh toán qua webhook.
- Báo cáo doanh thu, công nợ, tỷ lệ lấp đầy và lợi nhuận ròng.
- Quản lý phân quyền và lịch sử thay đổi.

---

## 4. Lý do lựa chọn công nghệ

### 4.1. Backend: Ruby 3.2+ và Ruby on Rails 7.1+

Rails phù hợp với sản phẩm SaaS có vòng đời phát triển nhanh nhờ:

- Convention over Configuration giúp giảm thời gian dựng hệ thống.
- Active Record hỗ trợ làm việc với dữ liệu nghiệp vụ nhanh và rõ ràng.
- Hệ sinh thái gem phong phú cho multi-tenancy, soft delete, auth và background job.
- API mode của Rails rất phù hợp cho SPA hiện đại.

**Ưu tiên kỹ thuật:**

- Dùng `acts_as_tenant` để cô lập dữ liệu theo tenant.
- Dùng `discard` để xử lý xóa mềm an toàn.
- Dùng `devise-jwt` hoặc cơ chế JWT tương đương để xác thực API.
- Dùng `sidekiq` cho các tác vụ nền.

### 4.2. Frontend: Vue 3 + Pinia + Vite

Vue 3 phù hợp với giao diện quản trị giàu tương tác:

- Composition API dễ tái sử dụng logic.
- Pinia quản lý state gọn, rõ và dễ bảo trì.
- Vite giúp build nhanh, HMR tốt, trải nghiệm phát triển mượt.
- Dễ xây dashboard dạng grid, bảng, drawer và modal.

### 4.3. Database: MySQL 8.0 InnoDB

MySQL được chọn vì:

- Bảo đảm ACID cho dữ liệu tài chính.
- InnoDB hỗ trợ transaction và index tốt.
- Phù hợp với mô hình triển khai chi phí hợp lý.
- Dễ vận hành, backup và scale theo chiều dọc trong giai đoạn đầu.

### 4.4. Redis và Sidekiq

Redis được dùng cho:

- Cache cấu hình tenant.
- Cache dashboard summary.
- Rate limiting.
- Hàng đợi Sidekiq.

Sidekiq được dùng cho:

- Tạo hóa đơn hàng loạt.
- Gửi OTP, SMS, ZNS, email.
- Tạo PDF hợp đồng và hóa đơn.
- Đồng bộ thanh toán và reconcile dữ liệu.

---

## 5. Chiến lược hiệu năng

### 5.1. Quy tắc truy vấn

- Không dùng `SELECT *`.
- Chỉ select các cột thực sự cần hiển thị.
- Dùng eager loading khi cần tránh N+1.
- Tách tác vụ đọc nặng sang read-only service hoặc cache.

**Ví dụ Rails:**

```ruby
@rooms = Room
  .select(:id, :tenant_id, :property_id, :room_number, :price, :status)
  .where(property_id: property_id)

@contracts = Contract
  .select(:id, :tenant_id, :room_id, :renter_user_id, :contract_code, :status)
  .includes(:room, :renter_user)
```

### 5.2. Composite index theo tenant

Trong mô hình multi-tenant, gần như mọi truy vấn đều đi kèm `tenant_id`. Vì vậy, index phải được thiết kế theo nguyên tắc:

- Cột đầu tiên thường là `tenant_id`.
- Sau đó là cột lọc chính như `property_id`, `status`, `billing_month`, `room_id`.
- Tối ưu theo pattern truy vấn thực tế, không tạo index trùng lặp.

**Ví dụ đề xuất:**

- `rooms(tenant_id, property_id, status)`
- `monthly_bills(tenant_id, billing_month, status)`
- `utility_readings(tenant_id, room_id, billing_month)`

### 5.3. Phân vùng dữ liệu

Với bảng tăng nhanh như hóa đơn và chỉ số điện nước, có thể cân nhắc partitioning theo năm hoặc theo kỳ thanh toán.

Lợi ích:

- Giảm phạm vi quét dữ liệu.
- Tăng tốc truy vấn theo thời gian.
- Dễ lưu trữ và tối ưu dữ liệu cũ.

### 5.4. Tổng hợp báo cáo

Dashboard tài chính không nên tính trực tiếp trên bảng giao dịch lớn mỗi lần mở trang. Thay vào đó:

- Tạo bảng tổng hợp theo ngày/tháng.
- Hoặc cache kết quả báo cáo trong Redis.
- Chạy job định kỳ để refresh số liệu.

---

## 6. Chiến lược an toàn dữ liệu

### 6.1. Soft delete bắt buộc

Không cho phép xóa vật lý trực tiếp với dữ liệu nghiệp vụ quan trọng.

Quy ước:

- Mọi bảng chính có cột `discarded_at`.
- Thao tác xóa chỉ là cập nhật timestamp.
- Dữ liệu có thể khôi phục khi cần.

**Ví dụ model:**

```ruby
class Contract < ApplicationRecord
  include Discard::Model

  acts_as_tenant(:tenant)

  has_encrypted :id_card_number
end
```

### 6.2. Mã hóa dữ liệu nhạy cảm

Các trường cần mã hóa:

- Số CCCD/CMND.
- Số tài khoản ngân hàng.
- Một số thông tin định danh khách thuê.

Nguyên tắc:

- Mã hóa ở tầng ứng dụng trước khi lưu DB.
- Chỉ giải mã ở nơi có quyền truy cập phù hợp.
- Không log dữ liệu nhạy cảm ra console hoặc file log.

### 6.3. Kiểm soát thao tác nguy hiểm

- Phân quyền rõ ràng cho thao tác hoàn tiền, xóa, khôi phục.
- Ghi audit log cho thay đổi quan trọng.
- Chặn xóa hàng loạt nếu chưa có xác nhận đặc biệt.

---

## 7. Bảo mật nhiều lớp

### 7.1. Lớp biên

Cloudflare đảm nhiệm:

- Ẩn IP gốc của máy chủ.
- Chặn DDoS.
- WAF cho SQL injection, XSS, LFI/RFI.
- Challenge với lưu lượng bất thường.

### 7.2. Lớp web server

Nginx và Fail2ban đảm nhiệm:

- Chỉ cho phép traffic từ Cloudflare.
- Rate limit theo IP và theo endpoint.
- Tự động chặn IP có hành vi bất thường.

### 7.3. Lớp ứng dụng

Rails đảm nhiệm:

- JWT authentication.
- Phân quyền theo role.
- Kiểm tra chữ ký webhook.
- Rate limiting ở tầng ứng dụng nếu cần.

### 7.4. Lớp dữ liệu

- Mã hóa dữ liệu nhạy cảm.
- Ràng buộc foreign key.
- Index đúng chiến lược.
- Backup định kỳ và kiểm tra khôi phục.

---

## 8. Thiết kế multi-tenancy

### 8.1. Mô hình được chọn

Hệ thống dùng mô hình:

- **Single database**
- **Shared schema**
- **tenant_id trên các bảng nghiệp vụ**

Lý do:

- Dễ triển khai và vận hành.
- Chi phí thấp hơn nhiều so với mỗi tenant một database.
- Phù hợp giai đoạn đầu và vẫn có thể mở rộng tốt.

### 8.2. Cách hoạt động

- Mỗi request sau khi xác thực sẽ xác định tenant hiện tại.
- Rails gắn scope theo tenant tự động.
- Mọi query nghiệp vụ đều phải lọc theo `tenant_id`.

**Ví dụ:**

```ruby
class Api::V1::BaseController < ActionController::API
  set_current_tenant_through_filter
  before_action :set_tenant

  private

  def set_tenant
    set_current_tenant(current_user.tenant)
  end
end
```

---

## 9. Thiết kế API

### 9.1. Chuẩn response

API sử dụng JSON thống nhất:

```json
{
  "success": true,
  "message": "Lấy danh sách phòng trọ thành công",
  "data": [],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_items": 48
  }
}
```

### 9.2. HTTP status code

- `200 OK`: thành công.
- `201 Created`: tạo mới thành công.
- `400 Bad Request`: yêu cầu không hợp lệ.
- `401 Unauthorized`: chưa xác thực hoặc token hết hạn.
- `403 Forbidden`: không đủ quyền.
- `404 Not Found`: không tìm thấy tài nguyên.
- `422 Unprocessable Entity`: lỗi validate.
- `429 Too Many Requests`: vượt rate limit.
- `500 Internal Server Error`: lỗi hệ thống.

### 9.3. Nhóm endpoint cốt lõi

#### Authentication

- `POST /api/v1/auth/login`
- `POST /api/v1/auth/logout`
- `POST /api/v1/auth/send-otp`
- `GET /api/v1/auth/me`

#### Properties and Rooms

- `GET /api/v1/properties`
- `POST /api/v1/properties`
- `GET /api/v1/rooms/grid`
- `POST /api/v1/rooms`
- `PUT /api/v1/rooms/:id`
- `PATCH /api/v1/rooms/:id/status`

#### Contracts and Billing

- `POST /api/v1/contracts`
- `POST /api/v1/contracts/:id/checkout`
- `POST /api/v1/utility-readings`
- `POST /api/v1/bills/generate`
- `GET /api/v1/bills/:id/vietqr`
- `POST /api/v1/webhooks/vietqr`

---

## 10. Thiết kế UI/UX

### 10.1. Nguyên tắc giao diện

- Mobile-first.
- Thao tác nhanh, số bước ít.
- Tối ưu cho người vận hành tại hiện trường.
- Trạng thái phòng phải nhìn thấy ngay bằng màu sắc.

### 10.2. Design system

- **Màu chính:** Deep Blue cho sidebar/topbar.
- **Màu phụ:** Ocean Blue cho button, tab, action chính.
- **Trạng thái phòng:**
  - Xanh lá: trống
  - Đỏ: đang ở
  - Vàng: đã đặt cọc
  - Xám: bảo trì

### 10.3. Màn hình cốt lõi

#### 1. Sơ đồ phòng tương tác

- Hiển thị dạng grid theo tòa nhà/tầng.
- Mỗi phòng là một card theo màu trạng thái.
- Click vào phòng để mở drawer thao tác nhanh.

#### 2. Nhập chỉ số điện nước

- Form nhập nhanh theo phòng và theo tháng.
- Cảnh báo nếu chỉ số không hợp lệ.
- Cho phép đính kèm ảnh chụp công tơ.

#### 3. Cổng khách thuê

- Hiển thị hóa đơn, công nợ và mã VietQR.
- Tối ưu cho mobile.
- Có nút tải QR hoặc mở app ngân hàng.

---

## 11. Thiết kế cơ sở dữ liệu

### 11.1. Nguyên tắc chung

- Thiết kế theo 3NF ở mức hợp lý.
- Tất cả bảng nghiệp vụ chính có `discarded_at`.
- Tạo foreign key cho quan hệ quan trọng.
- Thiết kế composite index theo truy vấn.

### 11.2. Danh sách bảng chính

Hệ thống cốt lõi gồm các bảng:

- `plans`
- `tenants`
- `users`
- `properties`
- `rooms`
- `services`
- `contracts`
- `utility_readings`
- `monthly_bills`
- `operating_expenses`

### 11.3. Mô tả chi tiết các bảng

#### Bảng `plans`

- Lưu các gói SaaS.
- Có giới hạn số phòng, giá tháng và tính năng đi kèm.

#### Bảng `tenants`

- Lưu thông tin chủ trọ hoặc doanh nghiệp thuê hệ thống.
- Có `subdomain`, `phone`, `status`, `plan_id`.

#### Bảng `users`

- Lưu tài khoản đăng nhập.
- Có thể thuộc tenant hoặc là super admin.
- Trường nhạy cảm được mã hóa.

#### Bảng `properties`

- Lưu tòa nhà, dãy trọ hoặc cụm phòng.

#### Bảng `rooms`

- Lưu thông tin phòng và trạng thái.
- Có composite index theo tenant, property và status.

#### Bảng `services`

- Danh mục dịch vụ như điện, nước, wifi, rác.

#### Bảng `contracts`

- Lưu hợp đồng thuê, mã hợp đồng, giá chốt và trạng thái.

#### Bảng `utility_readings`

- Lưu chỉ số điện nước theo phòng và theo tháng.
- Có thể partition nếu dữ liệu tăng lớn.

#### Bảng `monthly_bills`

- Lưu hóa đơn theo tháng.
- Phục vụ tạo QR thanh toán và đối soát.

#### Bảng `operating_expenses`

- Lưu chi phí vận hành để tính lợi nhuận ròng.

### 11.4. Một số cột và index quan trọng

- `tenant_id`: gần như có trên mọi bảng nghiệp vụ.
- `discarded_at`: soft delete.
- `contract_code`, `bill_code`: unique để truy xuất nhanh.
- `billing_month`, `due_date`, `status`: phục vụ lọc và báo cáo.

---

## 12. Chiến lược báo cáo và đồng bộ thanh toán

### 12.1. VietQR

Mỗi hóa đơn có thể sinh một mã VietQR riêng để:

- Khách thuê thanh toán nhanh.
- Ngân hàng hoặc webhook trả về thông tin đối soát.
- Hệ thống tự động cập nhật trạng thái đã trả.

### 12.2. Webhook

Webhook thanh toán phải:

- Có chữ ký HMAC.
- Xác thực secret key.
- Kiểm tra idempotency để tránh ghi đè trùng lặp.
- Ghi log đầy đủ cho từng lần nhận.

### 12.3. Đồng bộ trạng thái

- Khi nhận thanh toán hợp lệ, hệ thống cập nhật hóa đơn.
- Nếu thanh toán một phần, trạng thái chuyển sang `partially_paid`.
- Nếu thanh toán đủ, trạng thái chuyển sang `paid`.

---

## 13. Lộ trình triển khai

### Phase 1: Nền tảng lõi và bảo mật

- Khởi tạo Rails API.
- Thiết lập JWT authentication.
- Tạo migration cho các bảng chính.
- Áp dụng multi-tenancy và soft delete.
- Cấu hình Cloudflare, Nginx, rate limit.

### Phase 2: Nghiệp vụ cốt lõi

- Quản lý tòa nhà, phòng, hợp đồng.
- Nhập chỉ số điện nước.
- Sinh hóa đơn và mã VietQR.
- Giao diện dashboard cho chủ trọ.

### Phase 3: Tự động hóa

- Sidekiq jobs cho tạo hóa đơn hàng loạt.
- Webhook đối soát thanh toán.
- Nhắc nợ tự động qua SMS/ZNS/email.
- Báo cáo tài chính và vận hành.

### Phase 4: Mở rộng

- Mobile app.
- OCR CCCD.
- Tích hợp IoT công tơ điện.
- Phân tích nâng cao và dự báo công nợ.

---

## 14. Việc nên làm ngay

1. Chốt lại mô hình nghiệp vụ và danh sách bảng.
2. Tạo skeleton backend Rails API.
3. Cài các gem lõi: `acts_as_tenant`, `discard`, `devise-jwt`, `sidekiq`, `rack-attack`.
4. Dựng bộ migration cho toàn bộ bảng chính.
5. Thiết kế trước các endpoint auth, rooms, contracts, bills.
6. Dựng UI dashboard grid cho phòng trọ và luồng nhập chỉ số.
7. Bổ sung logging, audit trail và bộ kiểm thử.

---

## 15. Kết luận

RentOps được thiết kế như một nền tảng SaaS quản lý phòng trọ có khả năng mở rộng, bảo mật cao và tối ưu cho vận hành thực tế. Trọng tâm của hệ thống là:

- Multi-tenant rõ ràng.
- Hiệu năng truy vấn tốt.
- Bảo vệ dữ liệu tài chính và dữ liệu cá nhân.
- Tự động hóa các nghiệp vụ thu tiền, đối soát và báo cáo.

Nếu triển khai đúng hướng, hệ thống có thể đáp ứng cả nhu cầu của một chủ trọ nhỏ lẫn một chuỗi quản lý nhiều tòa nhà.

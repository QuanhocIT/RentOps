# Tài Liệu Đề Xuất Nâng Cấp, Tự Động Hóa & Tối Ưu Hiệu Năng Hệ Thống RentOps

> **Ngày cập nhật:** 31/07/2026  
> **Dự án:** RentOps - Nền tảng SaaS Quản lý Bất động sản & Phòng trọ Multi-tenant  
> **Mục tiêu:** Liệt kê chi tiết các vị trí logic có thể nâng cấp, giải pháp tự động hóa vận hành, phương án giải quyết điểm tắc nghẽn dữ liệu (bottlenecks) và tối ưu hiệu năng tổng thể.

---

## 🛠️ 1. Nâng Cấp Logic & Tính Năng Theo Màn Hình / Tệp Nguồn

### 1.1. Quản Lý Hóa Đơn & Thanh Toán (`src/views/BillsView.vue`, `src/stores/data.js`)
- **Điểm nâng cấp logic:**
  - **Tự động tính phạt chậm nộp (Late Payment Fee):** Bổ sung logic tự động cộng % phạt hoặc số tiền cố định (ví dụ: 50.000đ/ngày) cho các hóa đơn chuyển trạng thái sang `overdue` (Quá hạn) sau ngày `dueDate`.
  - **Khấu trừ tiền cọc trực tiếp:** Khi thanh lý hợp đồng hoặc tạo hóa đơn cuối kỳ, cho phép tích chọn "Trừ vào tiền cọc" thay vì bắt buộc thu tiền mặt/chuyển khoản.
  - **Hỗ trợ thanh toán từng phần (Partial Payment):** Cập nhật thuộc tính `paidAmount`, tính số tiền còn nợ (`remainingAmount = totalAmount - paidAmount`) và tự động cập nhật trạng thái `partially_paid`.

### 1.2. Chốt Chỉ Số Điện Nước (`src/views/UtilityReadingsView.vue`)
- **Điểm nâng cấp logic:**
  - **Phát hiện chỉ số quay đầu (Meter Reset / Rollover):** Xử lý trường hợp công tơ điện/nước hết số (ví dụ: từ 9999 quay về 0001) để không tính số dư bị âm hoặc tiêu thụ tăng đột biến sai thực tế.
  - **Tính điện bậc thang (Progressive Tariff Rate):** Cho phép cấu hình giá điện theo lũy tiến (Bậc 1, Bậc 2, Bậc 3...) đối với các khu chung cư/căn hộ dịch vụ mua điện theo giá nhà nước.

### 1.3. Hợp Đồng & Cư Dân (`src/views/ContractsView.vue`, `src/views/RentersView.vue`)
- **Điểm nâng cấp logic:**
  - **Định danh eKYC CCCD Chip / OCR:** Thêm tính năng tải ảnh CCCD 2 mặt, tự động bóc tách số CCCD, họ tên, ngày sinh, quê quán điền tự động vào hồ sơ cư dân.
  - **Tự động thay đổi trạng thái phòng:** Khi tạo hợp đồng mới (`status = 'active'`), tự động chuyển trạng thái phòng trong `RoomsView` từ `vacant` sang `occupied`. Ngược lại, khi thanh lý hợp đồng (`CheckoutContractModal`), chuyển trạng thái phòng về `vacant`.

### 1.4. Trợ Lý AI Advisor (`src/views/AiAdvisorView.vue`)
- **Điểm nâng cấp logic:**
  - **Gợi ý tối ưu giá phòng (Smart Pricing Engine):** Sử dụng AI phân tích tỷ lệ lấp đầy khu vực và mùa cao điểm (ví dụ: đợt nhập học tháng 8-9) để gợi ý tăng/giảm giá niêm yết phòng trống thêm 5 - 10%.
  - **Dự báo dòng tiền (Cashflow Forecasting):** Sử dụng thuật toán hồi quy thời gian (Time-series Forecasting) dự đoán doanh thu thực thu trong 3 tháng tới dựa trên hợp đồng đang chạy và tỷ lệ hủy phòng lịch sử.

---

## ⚡ 2. Kịch Bản Tự Động Hóa Hệ Thống (Automation Modules)

### 2.1. Đẩy Tự Động Webhook Đối Soát Thanh Toán VietQR (Auto-Reconcile)
- **Cơ chế:**
  - Ngân hàng gửi Webhook khi nhận chuyển khoản -> Backend Rails tiếp nhận -> Kiểm tra mã hóa đơn trong nội dung chuyển khoản (`INV-202607-101`).
  - Nguồn xử lý: Khai báo background job `ReconcilePaymentJob` trong Sidekiq.
  - **Hành động tự động:**
    1. Gạch nợ hóa đơn (`status = 'paid'`, `paidDate = Time.current`).
    2. Gửi tin nhắn Zalo/SMS cảm ơn cho khách thuê: *"RentOps đã nhận 6.174.000đ cho hóa đơn P101. Cảm ơn bạn!"*
    3. Ghi Audit Log tự động.

### 2.2. Nhắc Nợ & Nhắc Hạn Hợp Đồng Tự Động (Cron & Background Queue)
- **Tự động gửi Zalo ZNS / SMS Brandname:**
  - **Ngày 01 hàng tháng:** Tự động quét các phòng có hợp đồng -> Sinh hóa đơn tháng -> Gửi thông báo kèm mã VietQR qua Zalo.
  - **Ngày 03 hàng tháng:** Gửi tin nhắn nhắc nợ nhẹ nhàng trước 2 ngày hạn nộp.
  - **Ngày 06 hàng tháng:** Gửi tin nhắn thông báo quá hạn đối với các hóa đơn chưa trả.
  - **Trước 30 ngày hết hợp đồng:** Gửi cảnh báo cho Chủ trọ & thông báo gợi ý gia hạn cho Khách thuê.

### 2.3. AI OCR Nhập Chỉ Số Điện Nước Qua Ảnh Chụp
- **Cơ chế:**
  - Nhân viên vận hành chỉ cần dùng điện thoại chụp ảnh mặt đồng hồ điện/nước -> Tải lên ứng dụng.
  - Ứng dụng dùng Gemini Vision / OCR API nhận diện con số hiển thị trên mặt số -> Tự động điền vào ô `currElectric` và `currWater`.
  - Cảnh báo ngay nếu số mới nhỏ hơn số cũ hoặc tiêu thụ cao bất thường (> 50% so với tháng trước).

---

## 🚀 3. Tối Ưu Hiệu Năng & Điểm Tắc Nghẽn Dữ Liệu (Bottlenecks & Performance)

### 3.1. Điểm Tắc Nghẽn Dữ Liệu Báo Cáo Tài Chính (Financial Reporting Bottleneck)
- **Vấn đề:** Khi số lượng hóa đơn (`monthly_bills`) lên tới hàng trăm nghìn bản ghi, việc tính toán tổng doanh thu, công nợ, chi phí trên giao diện Dashboard bằng cách quét trực tiếp toàn bộ mảng sẽ gây treo/lag UI.
- **Giải pháp tối ưu:**
  - **Bảng tổng hợp theo kỳ (`daily_tenant_summaries` / `monthly_tenant_summaries`):** Đã đề xuất trong thiết kế SaaS. Lưu sẵn tổng tiền `total_revenue`, `total_unpaid`, `occupancy_rate` của từng tháng.
  - **Redis Caching:** Cache kết quả dashboard summary theo `tenant_id` với thời gian `TTL = 15 phút`. Chỉ invalidate cache khi có giao dịch thanh toán hoặc sinh hóa đơn mới.

### 3.2. Điểm Tắc Nghẽn Truy Vấn Database Multi-tenant (Single DB Multi-tenant Indexing)
- **Vấn đề:** Do mọi bảng đều chung 1 Database và có cột `tenant_id`, nếu thiếu Composite Index sẽ gây Full Table Scan giữa dữ liệu các chủ trọ khác nhau.
- **Giải pháp tối ưu index (MySQL 8.0):**
  ```sql
  -- Tối ưu truy vấn danh sách phòng theo tòa nhà và trạng thái
  CREATE INDEX idx_rooms_tenant_prop_status ON rooms(tenant_id, property_id, status);

  -- Tối ưu truy vấn hóa đơn theo kỳ tháng và trạng thái nợ
  CREATE INDEX idx_bills_tenant_month_status ON monthly_bills(tenant_id, billing_month, status);

  -- Tối ưu truy vấn chốt chỉ số điện nước
  CREATE INDEX idx_utility_tenant_room_month ON utility_readings(tenant_id, room_id, billing_month);
  ```

### 3.3. Tối Ưu Tầng Frontend Vue 3 / Pinia
- **Pinia State Normalization:**
  - Tránh lưu trữ mảng lồng nhau quá sâu trong `dataStore`. Chuyển sang dạng normalized map (Entities by ID) để thao tác update/delete đạt độ phức tạp `O(1)` thay vì `O(n)`.
- **Code-Splitting & Lazy Loading Routes:**
  - Sử dụng Dynamic Import `() => import('../views/SuperAdminView.vue')` trong `router/index.js` giúp giảm kích thước bundle ban đầu từ **614 kB** xuống dưới **200 kB**, tăng tốc độ tải trang lần đầu (FCP/LCP).

---

## 📋 4. Lộ Trình Triển Khai Nâng Cấp Đề Xuất (Implementation Roadmap)

| Giai đoạn | Hạng mục công việc | Mức độ ưu tiên | Thời gian dự kiến |
| :--- | :--- | :--- | :--- |
| **Giai đoạn 1** | Phạt chậm nộp, trừ cọc hợp đồng, tự động đổi trạng thái phòng | 🔴 Cao | 2 ngày |
| **Giai đoạn 2** | Triển khai Webhook VietQR Auto-Reconcile & Nhắc nợ Zalo ZNS | 🔴 Cao | 3 ngày |
| **Giai đoạn 3** | Tối ưu DB Composite Indexes & Redis Cache cho Dashboard Summary | 🟡 Trung bình | 2 ngày |
| **Giai đoạn 4** | Tích hợp AI OCR đọc đồng hồ điện nước & Dự báo dòng tiền AI | 🟢 Mở rộng | 4 ngày |

---

> [!TIP]
> *Tài liệu này được lưu trữ trực tiếp tại file [`DeXuatNangCapVaToiUuHeThong.md`](file:///c:/laragon/www/RentOps/DeXuatNangCapVaToiUuHeThong.md) thuộc thư mục gốc dự án RentOps để các developer và đội ngũ vận hành dễ dàng theo dõi và triển khai.*

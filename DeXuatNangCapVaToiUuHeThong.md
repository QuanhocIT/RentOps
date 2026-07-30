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

## 🗂️ 4. Nâng Cấp Các Màn Hình Còn Lại (Remaining Views)

### 4.1. Màn Hình Bảo Trì Sự Cố (`src/views/MaintenanceView.vue`)
- **Thiếu sót hiện tại:**
  - Không có cơ chế theo dõi SLA (Service Level Agreement) – thời gian xử lý tối đa theo mức ưu tiên (Khẩn: 4h, Cao: 24h, Thường: 72h).
  - Không có chức năng phân công (Assign) công việc cho từng kỹ thuật viên cụ thể.
- **Đề xuất nâng cấp:**
  - **SLA Countdown Timer:** Hiển thị đồng hồ đếm ngược thời gian xử lý còn lại, đổi màu vàng khi còn 2h, đỏ khi đã quá hạn.
  - **Kanban Board View:** Cho phép chuyển chế độ xem từ danh sách sang Kanban 4 cột (Chờ → Đã nhận → Đang sửa → Hoàn thành), kéo thả thẻ để cập nhật trạng thái.
  - **Upload ảnh trước/sau sửa chữa:** Cho phép kỹ thuật viên tải ảnh hiện trạng lúc nhận việc và ảnh kết quả sau khi hoàn thành – tự động lưu vào `Audit Log`.
  - **Tổng hợp chi phí bảo trì theo phòng/tòa nhà:** So sánh với chi phí bảo trì trung bình của cùng loại hạng mục (điện, nước, điều hòa...) để phát hiện phòng "ngốn chi phí" bất thường.

### 4.2. Màn Hình Tài Sản (`src/views/AssetsView.vue`)
- **Thiếu sót hiện tại:**
  - Không có cảnh báo khi tài sản gần hết hạn bảo hành (`warrantyUntil`).
  - Không có lịch sử sửa chữa/bảo dưỡng theo từng tài sản.
- **Đề xuất nâng cấp:**
  - **Cảnh báo hết hạn bảo hành:** Tự động hiển thị badge cảnh báo 🔴 khi `warrantyUntil` còn dưới 30 ngày, gửi thông báo vào `NotificationsView`.
  - **Lịch bảo dưỡng định kỳ (Preventive Maintenance Schedule):** Thêm trường `nextMaintenanceDate` và tích hợp với `MaintenanceView` để tự động tạo phiếu bảo dưỡng định kỳ.
  - **QR Code tài sản:** Mỗi tài sản có mã QR in ra dán vào thiết bị, nhân viên quét QR sẽ xem ngay được thông tin thiết bị và lịch sử bảo trì.

### 4.3. Màn Hình Báo Cáo (`src/views/ReportsView.vue`)
- **Thiếu sót hiện tại:**
  - Dữ liệu báo cáo hiện tại chủ yếu là dữ liệu tĩnh/giả lập, chưa kết nối thực với các bảng `bills`, `expenses`, `contracts`.
  - Không có chức năng xuất báo cáo PDF/Excel.
- **Đề xuất nâng cấp:**
  - **Biểu đồ Doanh thu - Chi phí - Lợi nhuận ròng:** Tính `netProfit = totalRevenue - totalExpenses - totalMaintenanceCost` theo từng tháng, hiển thị dạng stacked bar chart.
  - **Báo cáo Tỷ lệ lấp đầy theo tòa nhà:** Cho phép lọc theo từng `property`, hiển thị xu hướng lấp đầy 12 tháng gần nhất.
  - **Xuất Excel / PDF:** Dùng thư viện `SheetJS` (XLSX) cho Excel và `jsPDF` cho PDF trực tiếp trên frontend không cần backend.
  - **Biểu đồ công nợ tích lũy (Aging Report):** Phân loại khách thuê nợ theo mức: <7 ngày, 7-30 ngày, 30-60 ngày, >60 ngày – hỗ trợ quyết định xử lý pháp lý.

### 4.4. Màn Hình Chi Phí (`src/views/ExpensesView.vue`)
- **Thiếu sót hiện tại:**
  - Không có phân loại chi phí theo nhóm vận hành: Chi phí cố định (Fixed Cost) vs Chi phí biến đổi (Variable Cost).
  - Không có hạn mức ngân sách (Budget Limit) theo từng danh mục chi phí.
- **Đề xuất nâng cấp:**
  - **Budget vs Actual Tracking:** Thiết lập ngân sách chi phí hàng tháng theo từng danh mục (Điện nước, Sửa chữa, Vệ sinh...). Hiển thị thanh progress bar và cảnh báo khi vượt 80% hạn mức.
  - **Upload hóa đơn chứng từ:** Cho phép tải ảnh hóa đơn/biên lai thanh toán, lưu vào cloud storage (Cloudflare R2 / AWS S3) và liên kết với mỗi bản ghi chi phí.

### 4.5. Cổng Cư Dân (`src/views/TenantPortalView.vue`)
- **Thiếu sót hiện tại:**
  - Tất cả dữ liệu đang dùng hardcode static, chưa kết nối với `dataStore` (bills của chính người dùng đang đăng nhập).
  - Chức năng nhắn tin (Chat) với quản lý mới là UI demo, chưa có backend xử lý.
- **Đề xuất nâng cấp:**
  - **Kết nối dữ liệu thực theo `renterId`:** Lọc hóa đơn, hợp đồng, bảo trì theo đúng `renterId` của user đang đăng nhập từ `authStore.currentUser.id`.
  - **Real-time Chat:** Tích hợp ActionCable (Rails WebSocket) hoặc Pusher để hỗ trợ nhắn tin thời gian thực giữa cư dân và ban quản lý.
  - **Gửi yêu cầu bảo trì ngay từ Cổng Cư Dân:** Form gửi yêu cầu trực tiếp tạo bản ghi trong `MaintenanceView`, cư dân nhận được thông báo real-time khi có cập nhật trạng thái xử lý.

### 4.6. Màn Hình Audit Logs (`src/views/AuditLogsView.vue`)
- **Thiếu sót hiện tại:**
  - Không có chức năng lọc theo `user_name` hoặc `action` cụ thể.
  - Không có khả năng xuất log ra file để giao nộp cơ quan kiểm toán.
- **Đề xuất nâng cấp:**
  - **Bộ lọc đa chiều:** Lọc theo khoảng ngày, người thực hiện, loại hành động (CRUD), loại đối tượng (Bill, Contract, Room...).
  - **Phát hiện hành vi bất thường (Anomaly Detection):** Cảnh báo khi một user thực hiện >50 thao tác xóa trong 1 giờ hoặc đăng nhập từ IP nước ngoài.
  - **Xuất Audit Log ra PDF/CSV:** Phục vụ báo cáo kiểm toán nội bộ hoặc giao nộp cơ quan chức năng.

---

## 🔐 5. Nâng Cấp Bảo Mật & Phân Quyền (Security & Authorization)

### 5.1. Bảo Mật Frontend
- **Vấn đề hiện tại:**
  - Tệp `src/stores/auth.js` khi API login lỗi, **vẫn tự động đăng nhập thành công** với dữ liệu mặc định `defaultUser` — đây là lỗ hổng bảo mật nghiêm trọng trong môi trường Production.
  - Token JWT lưu trong `localStorage` có thể bị tấn công XSS đánh cắp.
- **Đề xuất vá lỗi:**
  - **Tắt fallback login giả (`catch` block trong `auth.js`):** Chỉ cho phép đăng nhập thành công khi API trả về `200 OK` với token hợp lệ. Môi trường demo cần flag riêng `VITE_DEMO_MODE=true`.
  - **Chuyển JWT Token sang `HttpOnly Cookie`:** Token không còn accessible qua JavaScript, miễn nhiễm với tấn công XSS.
  - **Thêm CSRF Token protection:** Khi dùng Cookie-based auth, thêm header `X-CSRF-Token` trong mọi request thay đổi dữ liệu.

### 5.2. Phân Quyền Tầng Frontend (Route & Component Guards)
- **Vấn đề hiện tại:**
  - Router guard hiện tại chỉ kiểm tra `isAuthenticated` và `role`, chưa kiểm tra quyền truy cập theo từng tính năng cụ thể (Feature-level RBAC).
  - Nhân viên (role `staff`) có thể truy cập màn hình `/settings`, `/audit-logs`, `/super-admin` nếu biết URL.
- **Đề xuất nâng cấp:**
  - **Permission Matrix:** Định nghĩa rõ từng quyền theo role trong một file `permissions.js`:

  ```js
  // src/config/permissions.js
  export const PERMISSIONS = {
    owner:  ['dashboard', 'rooms', 'bills', 'contracts', 'renters', 'reports', 'settings', 'audit-logs'],
    staff:  ['dashboard', 'rooms', 'utility-readings', 'maintenance', 'notifications'],
    renter: ['tenant-portal'],
    super_admin: ['super-admin', 'audit-logs']
  }
  ```

  - **Component-level guard:** Dùng `v-if="hasPermission('delete_bill')"` để ẩn nút nguy hiểm theo quyền thay vì chỉ theo `role`.

### 5.3. Bảo Mật Dữ Liệu Cư Dân (GDPR-alike Compliance)
- **Đề xuất:**
  - **Che giấu thông tin nhạy cảm theo mặc định:** Số CCCD hiển thị dạng `079****1234`, chỉ cho phép xem đầy đủ khi người dùng có quyền `view_sensitive_data` và xác nhận 2FA.
  - **Audit trail khi xem CCCD:** Mỗi lần ai đó xem số CCCD đầy đủ của cư dân đều tạo một bản ghi trong `AuditLog`.

---

## 📱 6. Tối Ưu Mobile & Progressive Web App (PWA)

### 6.1. Responsive Layout Còn Thiếu
- **Các màn hình chưa responsive tốt trên mobile (<768px):**
  - `BillsView.vue`: Bảng hóa đơn có quá nhiều cột, bị tràn ngang trên điện thoại.
  - `UtilityReadingsView.vue` (batch mode): Ma trận nhập chỉ số điện nước khó sử dụng trên màn hình nhỏ.
  - `RoomsView.vue` (table mode): Bảng phòng cần thêm chế độ Card-only trên mobile.
- **Giải pháp:**
  - Thêm breakpoint `sm:hidden` để ẩn cột phụ trên mobile, ưu tiên hiển thị: Mã phòng, Giá thuê, Trạng thái, Thao tác.
  - Batch utility readings nên có layout 2 cột (Điện / Nước) thay vì 8 cột trên mobile.

### 6.2. Chuyển Đổi Sang PWA (Progressive Web App)
- **Lợi ích:** Nhân viên vận hành có thể cài ứng dụng lên màn hình điện thoại, hoạt động offline cơ bản và nhận Push Notification.
- **Cần bổ sung:**
  - **`vite-plugin-pwa`:** Tích hợp vào `vite.config.js`, cấu hình Service Worker để cache assets và API responses.
  - **Web Push Notification:** Thay thế một phần thông báo ZNS bằng Web Push cho cư dân đang dùng trình duyệt — miễn phí và không cần số điện thoại.
  - **Offline mode cho chốt chỉ số điện nước:** Nhân viên đi thực địa có thể nhập chỉ số offline, dữ liệu sync lại khi có mạng.

---

## 🧩 7. Tái Cấu Trúc & Cải Thiện Kiến Trúc Code (Refactoring)

### 7.1. Tách Logic Sang Composables (Vue 3 Best Practices)
- **Vấn đề hiện tại:** Nhiều tệp View có script section dài hơn 200 dòng, chứa cả logic nghiệp vụ lẫn UI state.
- **Đề xuất refactor:**

  ```
  src/
  ├── composables/
  │   ├── useBills.js          ← logic sinh hóa đơn, thanh toán, tính phạt
  │   ├── useContracts.js      ← logic tạo/gia hạn/thanh lý hợp đồng
  │   ├── useUtilityCalc.js    ← tính điện nước bậc thang, phát hiện quay đầu
  │   ├── useFormatCurrency.js ← formatter dùng chung cho tất cả views
  │   └── usePermissions.js    ← kiểm tra quyền theo role
  ```

### 7.2. Thống Nhất Chuẩn Tên Trường Dữ Liệu (Field Naming Convention)
- **Vấn đề hiện tại:** Dữ liệu trong `dataStore` dùng `camelCase` (`roomNumber`, `renterId`) nhưng nhiều View ánh xạ lại sang `snake_case` (`room_number`, `renter_id`) trong `computed` — dẫn đến code dư thừa, dễ nhầm lẫn.
- **Giải pháp:** Thống nhất toàn bộ dùng `camelCase` trong Pinia store, chỉ convert sang `snake_case` tại tầng API adapter khi gọi backend.

### 7.3. Lazy Loading Routes (Code-Splitting)
- **Vị trí thực hiện:** `src/router/index.js`
- **Cách thực hiện:**

  ```js
  // Trước: Static import — tải tất cả ngay lúc app load
  import SuperAdminView from '../views/SuperAdminView.vue'

  // Sau: Lazy import — chỉ tải khi user điều hướng đến
  const SuperAdminView = () => import('../views/SuperAdminView.vue')
  const TenantPortalView = () => import('../views/TenantPortalView.vue')
  const AiAdvisorView = () => import('../views/AiAdvisorView.vue')
  ```

  - Kết quả dự kiến: Giảm initial bundle từ **614 kB → ~180 kB** (−70%), tăng tốc độ tải trang đầu tiên đáng kể.

---

## 🐛 8. Tổng Hợp Pattern Lỗi Tiềm Ẩn Cần Lưu Ý

| # | File / Vị trí | Loại lỗi | Mô tả & Cách sửa |
| :- | :--- | :--- | :--- |
| 1 | `src/stores/auth.js` dòng 59-62 | **Bảo mật nghiêm trọng** | `catch` block tự động đăng nhập thành công dù API lỗi → Xóa fallback login trong Production |
| 2 | `src/views/BillsView.vue` hàm `generateBill()` | **Logic sai** | Điện/nước luôn hardcode `electricCost = 380000`, `waterCost = 144000` thay vì tính từ chỉ số thực tế → Kết nối với `utilityReadings` để tính đúng |
| 3 | `src/views/BillsView.vue` hàm `runBatchGenerate()` | **Logic sai** | `dueDate` hardcode `'2026-08-05'` thay vì tính động theo `billing_month + 5 ngày` |
| 4 | `src/views/ContractsView.vue` hàm `createContract()` | **Logic sai** | `renterId` fallback về `dataStore.renters[0]?.id` nếu không chọn → Có thể gán nhầm cư dân vào hợp đồng |
| 5 | `src/components/PaymentQrModal.vue` | **Runtime Error** | `simulateWebhook` gọi `fetch('/api/v1/...')` nhưng backend Rails chưa chạy → Lỗi Network, không fallback gracefully |
| 6 | `src/views/LandingView.vue` dòng 7 | **Branding sai** | Header hiển thị **"Rentalio"** thay vì **"RentOps"** — không đồng bộ thương hiệu |
| 7 | `src/stores/data.js` hàm `saveToStorage()` | **Performance** | Ghi toàn bộ state (40KB+) vào `localStorage` sau mỗi thao tác — nên debounce 500ms hoặc chỉ ghi delta thay đổi |
| 8 | `src/views/RoomsView.vue` | **UX không nhất quán** | Trạng thái phòng `'rented'` trong `dataStore` nhưng filter dropdown dùng `'occupied'` → phòng đang thuê không hiện khi lọc |

---

## 📋 9. Lộ Trình Triển Khai Đề Xuất (Updated Roadmap)

| Giai đoạn | Hạng mục công việc | Mức độ ưu tiên | Thời gian |
| :--- | :--- | :--- | :--- |
| **Sprint 1** | Vá lỗi bảo mật auth fallback, fix trạng thái phòng `rented/occupied`, sửa hardcode dueDate & chi phí điện nước | 🔴 Cao | 1-2 ngày |
| **Sprint 2** | Phạt chậm nộp, thanh toán từng phần, trừ tiền cọc trực tiếp khi thanh lý | 🔴 Cao | 2 ngày |
| **Sprint 3** | Tự động đổi trạng thái phòng khi tạo/thanh lý hợp đồng, Webhook VietQR Auto-Reconcile | 🔴 Cao | 2-3 ngày |
| **Sprint 4** | Lazy loading routes (code-split), Pinia state normalization, debounce saveToStorage | 🟡 Trung bình | 1 ngày |
| **Sprint 5** | Responsive cải thiện mobile (Bills, Utility, Rooms), SLA Kanban bảo trì | 🟡 Trung bình | 2 ngày |
| **Sprint 6** | Kết nối TenantPortal với dữ liệu thực, gửi yêu cầu bảo trì từ Cổng Cư Dân | 🟡 Trung bình | 2 ngày |
| **Sprint 7** | Báo cáo Lợi nhuận ròng, Aging Report công nợ, Xuất Excel/PDF | 🟡 Trung bình | 2-3 ngày |
| **Sprint 8** | Cảnh báo hết hạn bảo hành tài sản, QR Code tài sản, lịch bảo dưỡng định kỳ | 🟢 Mở rộng | 2 ngày |
| **Sprint 9** | PWA, Web Push Notification, Offline mode nhập chỉ số điện nước | 🟢 Mở rộng | 3-4 ngày |
| **Sprint 10** | AI OCR đọc đồng hồ điện nước, Smart Pricing Engine, Cashflow Forecasting | 🟢 Mở rộng | 5-7 ngày |

---

> [!IMPORTANT]
> **Ưu tiên hàng đầu là Sprint 1** — vá lỗi bảo mật `auth.js` fallback login và đồng bộ trạng thái phòng `rented/occupied` trước khi triển khai Production.

> [!TIP]
> Tài liệu này được lưu tại [`DeXuatNangCapVaToiUuHeThong.md`](file:///c:/laragon/www/RentOps/DeXuatNangCapVaToiUuHeThong.md) trong thư mục gốc dự án. Cập nhật liên tục khi phát hiện thêm điểm cần cải tiến.

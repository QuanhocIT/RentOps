# 🔍 Phân Tích Vấn Đề Hệ Thống RentOps — Ba Góc Nhìn

> **Ngày viết:** 31/07/2026  
> **Phương pháp:** Đặt mình vào vai 3 nhóm người dùng thực tế để phát hiện vấn đề mà tài liệu kỹ thuật thuần túy thường bỏ sót.  
> **Mục tiêu:** Cung cấp bức tranh toàn diện về trải nghiệm, kỳ vọng và rủi ro kỹ thuật của hệ thống.

---

## 👤 PHẦN 1 — GÓC NHÌN NGƯỜI DÙNG CUỐI (Nhân viên vận hành / Khách thuê)

*"Tôi là nhân viên quản lý khu trọ, hàng ngày tôi dùng RentOps để nhập chỉ số điện nước, đôn đốc thu tiền và trả lời thắc mắc của khách thuê."*

---

### ❌ 1.1. Vấn đề Luồng Thao Tác Hàng Ngày

**Vấn đề #1 — Nhập chỉ số điện nước hàng tháng rất mất thời gian**

Màn hình `UtilityReadingsView` yêu cầu nhập từng phòng một. Với khu trọ 20-30 phòng, mỗi tháng tôi phải click ít nhất **60-90 lần** để hoàn thành việc chốt chỉ số. Không có chức năng "Tab để chuyển ô tiếp theo" — tôi cứ phải dùng chuột, rất chậm.

> **Kỳ vọng:** Dùng bàn phím `Tab/Enter` để di chuyển giữa các ô nhập. Hỗ trợ nhập hàng loạt theo cột dọc (tất cả ô "Chỉ số điện mới" trước, rồi mới sang "Chỉ số nước mới").

---

**Vấn đề #2 — Không biết hóa đơn đã gửi cho khách chưa**

Sau khi tôi nhấn "Sinh hàng loạt hóa đơn", hệ thống chỉ hiện thông báo nhỏ "Thành công" trong 3 giây rồi biến mất. Không có danh sách xác nhận "Đã sinh được X hóa đơn, phòng nào thành công, phòng nào bị lỗi". Tôi không dám chắc là hệ thống đã xử lý đúng hay chưa.

> **Kỳ vọng:** Sau khi sinh hàng loạt, hiện bảng tóm tắt kết quả: ✅ 18 phòng thành công / ⚠️ 2 phòng bị lỗi (lý do: chưa có chỉ số điện nước tháng này).

---

**Vấn đề #3 — Không có nút "Gọi điện ngay" hoặc "Nhắn tin Zalo" khi xem hồ sơ khách nợ**

Khi tôi thấy khách P205 nợ 2 tháng, tôi muốn liên hệ ngay. Nhưng phải thoát ra, mở Zalo, copy số điện thoại từ màn hình `RentersView`, rồi mới nhắn được. Mất ít nhất 5 bước thừa.

> **Kỳ vọng:** Ngay trong popup chi tiết hóa đơn hoặc hồ sơ khách, có nút `📞 Gọi ngay` và `💬 Nhắn Zalo` — dùng deep link `tel:` và `https://zalo.me/số_điện_thoại`.

---

### ❌ 1.2. Vấn Đề Từ Góc Nhìn Khách Thuê

**Vấn đề #4 — Cổng Cư Dân (TenantPortal) hiện thị sai dữ liệu**

Khi tôi đăng nhập vào **Cổng Cư Dân** (`TenantPortalView`), tôi thấy hóa đơn và thông tin của người khác hoàn toàn — vì dữ liệu đang hardcode tĩnh, không lọc theo `renterId` của người đang đăng nhập. Đây không phải lỗi nhỏ — đây là **lỗi lộ dữ liệu nghiêm trọng** nếu deploy ra production.

> **Kỳ vọng:** Cổng cư dân chỉ hiển thị đúng dữ liệu của chính mình: hóa đơn tháng này, hợp đồng đang ký, yêu cầu bảo trì đã gửi.

---

**Vấn đề #5 — Không có lịch sử thanh toán rõ ràng**

Tôi đã chuyển tiền qua VietQR 3 tháng liên tiếp nhưng ứng dụng vẫn hiện "Chưa thanh toán" vì không có webhook đối soát. Tôi phải chụp màn hình ngân hàng gửi cho chủ trọ để chứng minh. Điều này làm mất niềm tin vào hệ thống.

> **Kỳ vọng:** Lịch sử giao dịch hiển thị đầy đủ ngay cả khi chưa đối soát — ít nhất cho phép tôi upload ảnh biên lai thanh toán tạm thời.

---

**Vấn đề #6 — Không nhận được thông báo khi hóa đơn mới được tạo**

Tôi chỉ biết có hóa đơn mới khi chủ trọ nhắn Zalo thủ công. Ứng dụng không gửi bất kỳ notification nào — email, SMS hay push notification đều không có.

> **Kỳ vọng:** Khi hóa đơn mới được tạo → tự động gửi Zalo ZNS hoặc Email tóm tắt số tiền + mã QR thanh toán.

---

## 🏠 PHẦN 2 — GÓC NHÌN CHỦ NHÀ (Tenant Owner)

*"Tôi sở hữu 3 dãy trọ, tổng 37 phòng. Tôi cần biết mỗi tháng thu được bao nhiêu, còn nợ bao nhiêu, và ai đang ở phòng nào."*

---

### ❌ 2.1. Vấn Đề Tài Chính & Kiểm Soát Dòng Tiền

**Vấn đề #7 — Dashboard không phản ánh dữ liệu thực**

Màn hình Dashboard (`DashboardGrid.vue`) hiện biểu đồ doanh thu với đường line chart đẹp mắt, nhưng **dữ liệu là hardcode tĩnh** (đường cong SVG cố định, tooltip "16/07/2026: 68.500.000đ" không thay đổi dù tôi thêm hay xóa hóa đơn). Tôi ra quyết định kinh doanh dựa trên con số **giả mạo** mà không biết.

> **Kỳ vọng:** Biểu đồ phải tính toán từ dữ liệu bills thực — doanh thu theo tháng, công nợ tích lũy, số phòng trống theo thời gian.

---

**Vấn đề #8 — Không phân biệt được "Thu về" và "Ghi nợ"**

Tổng doanh thu trên Dashboard đang cộng cả hóa đơn `unpaid` vào "Doanh thu tháng". Nhưng thực tế tôi chưa nhận được tiền đó. **Đây là lỗi kế toán nghiêm trọng** — tôi có thể nhầm tưởng mình có nhiều tiền hơn thực tế và đưa ra quyết định đầu tư sai.

> **Kỳ vọng:** Phân biệt rõ 3 chỉ số: `Doanh thu ghi nhận (Accrual)` / `Thực thu (Cash Collected)` / `Công nợ còn lại (Outstanding)`.

---

**Vấn đề #9 — Không có báo cáo lợi nhuận ròng (P&L)**

Tôi biết doanh thu phòng, nhưng không thấy chi phí điện nước mua vào, chi phí bảo trì, chi phí dịch vụ... để tính lợi nhuận thực sự. `ReportsView` chỉ có biểu đồ hóa đơn, hoàn toàn thiếu **Profit & Loss Statement**.

> **Kỳ vọng:** Báo cáo P&L hàng tháng: Doanh thu thuê phòng − Chi phí vận hành − Chi phí bảo trì = **Lợi nhuận ròng**. In được ra PDF.

---

**Vấn đề #10 — Tiền cọc bị "mất tích" khi thanh lý hợp đồng**

Khi tôi dùng `ContractsView` để thanh lý hợp đồng, hệ thống chỉ đổi trạng thái sang `terminated` nhưng **không hỏi tôi muốn làm gì với tiền cọc**: hoàn trả toàn bộ? Khấu trừ nợ tháng cuối? Khấu trừ thiệt hại? Tôi phải ghi chép tay ra ngoài — hoàn toàn thất bại mục đích của phần mềm.

> **Kỳ vọng:** Modal thanh lý phải có bước "Xử lý tiền cọc": điền số tiền trả lại, lý do khấu trừ, tự động tạo bút toán ghi sổ.

---

**Vấn đề #11 — Không thể theo dõi phòng nào "ngốn tiền" bảo trì nhất**

Tôi có phòng P301 tháng nào cũng sự cố — khi thì điều hòa, khi thì ống nước. Nhưng hệ thống không tổng hợp chi phí bảo trì **theo từng phòng** để tôi quyết định có nên nâng cấp thiết bị hay tăng giá thuê hay không.

> **Kỳ vọng:** Trong màn hình Chi tiết Phòng (`RoomDetailView`), có mục "Lịch sử bảo trì & tổng chi phí" và so sánh với mức trung bình khu.

---

### ❌ 2.2. Vấn Đề Vận Hành & Nhân Sự

**Vấn đề #12 — Tôi không thể giới hạn nhân viên chỉ được sửa phòng của họ**

Hệ thống có role `staff` nhưng nhân viên A (quản lý tòa A) có thể vào sửa dữ liệu phòng của tòa B. Nếu có 2 khu trọ với 2 nhân viên riêng, tôi không thể phân chia phạm vi quyền theo `property`.

> **Kỳ vọng:** Phân quyền cấp `property` — mỗi nhân viên chỉ được truy cập dữ liệu của tòa nhà được giao.

---

**Vấn đề #13 — Không có cảnh báo khi hợp đồng sắp hết hạn**

Hệ thống có ô "Sắp Hết Hạn (<30 Ngày)" trên Dashboard nhưng **không gửi bất kỳ thông báo nào**. Tôi phát hiện ra chỉ khi vào kiểm tra thủ công. Khách thuê đã dọn đồ đi mà tôi không biết vì không có cảnh báo sớm.

> **Kỳ vọng:** Tự động gửi thông báo cho cả chủ nhà lẫn khách thuê khi hợp đồng còn 30 ngày, 15 ngày và 7 ngày nữa là hết hạn.

---

**Vấn đề #14 — Giá điện nước không đồng nhất giữa các tòa nhà**

Khu trọ Lê Văn Sỹ tôi mua điện kinh doanh giá 3.500đ/kWh, còn RentOps Tower tôi đàm phán riêng được 3.200đ/kWh. Nhưng `SettingsView` chỉ có **1 bộ giá điện nước duy nhất** cho toàn bộ hệ thống — dẫn đến tính sai chi phí cho các tòa khác nhau.

> **Kỳ vọng:** Cấu hình giá điện nước **riêng theo từng `property`**, không phải cấu hình chung toàn tenant.

---

## 💻 PHẦN 3 — GÓC NHÌN LẬP TRÌNH VIÊN (Senior Developer — 7+ năm kinh nghiệm)

*"Tôi đọc toàn bộ source code Vue 3 + Pinia. Đây là danh sách vấn đề kỹ thuật theo mức độ nghiêm trọng."*

---

### 🔴 CRITICAL — Phải sửa trước khi Production

**[CRIT-01] `src/stores/auth.js` — Lỗ hổng bảo mật Bypass Authentication**

```js
// auth.js ~line 59
} catch (error) {
  // API lỗi → vẫn đăng nhập thành công với dữ liệu giả!
  this.user = defaultUser
  this.token = 'demo-token-fallback'
  this.isAuthenticated = true
}
```

**Vấn đề:** Bất kỳ ai gõ sai mật khẩu, hoặc API backend down, đều được đăng nhập vào hệ thống với quyền `owner`. Đây là **critical security vulnerability** — toàn bộ dữ liệu khách hàng có thể bị truy cập trái phép.  
**Sửa:** Xóa `catch` block fallback. Chỉ set `isAuthenticated = true` khi API trả về `200 OK` với JWT hợp lệ. Demo mode phải dùng env flag `VITE_DEMO_MODE=true` được kiểm soát riêng.

---

**[CRIT-02] `src/views/TenantPortalView.vue` — Rò rỉ dữ liệu Cross-Tenant**

Toàn bộ dữ liệu trong `TenantPortalView` là hardcode tĩnh — không lọc theo `renterId` của người đăng nhập. Nếu deploy production, **mọi khách thuê đều thấy dữ liệu của nhau**: họ tên, số CCCD, số dư nợ, thông tin hợp đồng.  
**Sửa:** Lọc `bills`, `contracts`, `maintenance` từ `dataStore` theo `authStore.currentUser.renterId` ngay sau `onMounted`.

---

**[CRIT-03] `src/views/BillsView.vue` — Chi phí điện nước hardcode gây sai số tài chính**

```js
// BillsView.vue line 574-575
const electricCost = 380000  // LUÔN luôn 380.000đ, bất kể phòng nào dùng bao nhiêu kWh
const waterCost = 144000     // LUÔN luôn 144.000đ
```

**Vấn đề:** Mọi hóa đơn được sinh ra đều có điện 380.000đ và nước 144.000đ, hoàn toàn bỏ qua chỉ số thực tế từ `UtilityReadings`. Chủ nhà đang thu tiền sai — có phòng bị thiệt, có phòng được lợi.  
**Sửa:**  
```js
const reading = dataStore.utilityReadings.find(r => r.roomId === room.id && r.month === form.value.billing_month)
const electricUsage = reading ? (reading.currElectric - reading.prevElectric) : 0
const electricCost = electricUsage * (dataStore.settings.electricRate || 3500)
const waterUsage = reading ? (reading.currWater - reading.prevWater) : 0
const waterCost = waterUsage * (dataStore.settings.waterRate || 18000)
```

---

**[CRIT-04] `src/views/BillsView.vue` — `dueDate` hardcode cứng ngày 05/08/2026**

```js
// form.value.due_date được khởi tạo với giá trị cứng '2026-08-05'
// và batchForm không có dueDate → hóa đơn hàng loạt không có hạn nộp đúng
```

**Vấn đề:** Hóa đơn sinh ra trong tháng 9, 10, 11... vẫn có `dueDate = '2026-08-05'` (ngày trong quá khứ) → tất cả hóa đơn mới đều ngay lập tức ở trạng thái "Quá Hạn".  
**Sửa:** Tính động: `dueDate = new Date(billingMonth + '/05').toISOString().split('T')[0]`

---

### 🟠 HIGH — Ảnh hưởng nghiêm trọng đến nghiệp vụ

**[HIGH-01] `src/stores/data.js` — `saveToStorage()` ghi 40KB+ vào localStorage sau MỌI thao tác**

```js
// data.js — gọi sau addBill(), updateBill(), deleteBill(), addRoom()...
saveToStorage() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(this.$state))
}
```

**Vấn đề:** `this.$state` chứa toàn bộ data: properties, rooms, bills, contracts, renters, settings... (~40KB). Mỗi lần nhấn nút bất kỳ → serialize + write 40KB vào localStorage → block main thread trong 15-30ms → UI giật lag có thể cảm nhận được, đặc biệt trên máy yếu.  
**Sửa:** Debounce 500ms, hoặc chỉ serialize `$patch` thay đổi nhỏ. Về dài hạn: dùng IndexedDB thay localStorage.

---

**[HIGH-02] `src/views/RoomsView.vue` — Inconsistent Status Values**

```js
// dataStore: rooms có status = 'rented'
// RoomsView filter dropdown: option value = 'occupied'
// Kết quả: Filter "Đang thuê" → 0 kết quả, dù có 8 phòng đang thuê
```

**Vấn đề:** Giá trị enum `status` không nhất quán giữa data model và UI component. Người dùng click filter "Đang thuê" và thấy danh sách rỗng — mất niềm tin vào hệ thống.  
**Sửa:** Định nghĩa enum chuẩn một lần trong `src/config/constants.js`:  
```js
export const ROOM_STATUS = { RENTED: 'rented', VACANT: 'vacant', MAINTENANCE: 'maintenance' }
```
Sử dụng thống nhất trong cả store lẫn template.

---

**[HIGH-03] `src/views/ContractsView.vue` — Silent Fallback gán sai khách thuê**

```js
// ContractsView.vue createContract()
const renterId = form.value.renter_id || dataStore.renters[0]?.id  // ← nguy hiểm
```

**Vấn đề:** Nếu user tạo hợp đồng mà không chọn khách thuê (trường `required` bị bỏ qua), hợp đồng sẽ được gán cho **người đầu tiên trong danh sách** một cách âm thầm. Không có cảnh báo, không có validation, không có audit log.  
**Sửa:** Validate bắt buộc `renter_id`, throw toast error nếu rỗng. Không dùng fallback ngầm.

---

**[HIGH-04] `src/views/DashboardGrid.vue` — Toàn bộ KPI và biểu đồ là dữ liệu tĩnh**

```html
<!-- DashboardGrid.vue line 12 — hardcode ngày tháng -->
<span>01/07/2026 - 31/07/2026</span>

<!-- Biểu đồ SVG hardcode, không liên quan gì đến bills trong dataStore -->
<path d="M0 201 C25 200 30 196 50 202 S75 194 92 198..."/>

<!-- Tooltip hardcode -->
<div class="chart-tooltip"><strong>16/07/2026</strong><span>Doanh thu: 68.500.000 đ</span></div>
```

**Vấn đề:** Dashboard — trung tâm ra quyết định của chủ nhà — hiển thị **dữ liệu giả hoàn toàn**. Mọi con số KPI, mọi điểm trên biểu đồ, mọi tooltip đều là hardcode.  
**Sửa:** Tính `revenueByMonth` từ `dataStore.bills`, vẽ SVG path động, cập nhật KPI cards từ computed properties.

---

**[HIGH-05] `src/views/LandingView.vue` — Branding không nhất quán**

Trang Landing Page hiển thị tên sản phẩm là **"Rentalio"** thay vì **"RentOps"**. Đây là tên thương hiệu cũ chưa được thay. Ảnh hưởng đến SEO, niềm tin người dùng và thương hiệu sản phẩm.

---

### 🟡 MEDIUM — Nợ kỹ thuật ảnh hưởng dài hạn

**[MED-01] Không có Error Boundary — Lỗi 1 component làm trắng toàn bộ trang**

Hiện tại không có `errorCaptured` lifecycle hook hay `<Suspense>` wrapper. Khi 1 computed property ném ra exception (chia cho 0, null reference...) → toàn bộ màn hình bị trắng, console đầy lỗi.  
**Sửa:** Thêm global error handler trong `main.js`, bọc các view chính bằng `<ErrorBoundary>` component.

---

**[MED-02] Không có Loading State khi fetch API — UX bị gián đoạn**

Các hàm `fetchData()` và `loadData()` được thêm vào các view nhưng không có skeleton loading placeholder. Khi API chậm, người dùng thấy màn hình trắng rồi đột ngột hiện data — trải nghiệm tệ.  
**Sửa:** Thêm `<SkeletonCard>` component cho mỗi view, hiển thị khi `loading = true`.

---

**[MED-03] `v-for` không có `:key` đủ unique ở một số chỗ**

Một số danh sách dùng `v-for="(item, index) in list" :key="index"` — anti-pattern trong Vue 3. Khi list reorder hoặc splice phần tử giữa, DOM không được cập nhật đúng cách → bug UI khó tái hiện.  
**Sửa:** Luôn dùng `:key="item.id"` thay vì `:key="index"`.

---

**[MED-04] `src/router/index.js` — Tất cả routes dùng Static Import, không có Code Splitting**

```js
import SuperAdminView from '../views/SuperAdminView.vue'    // 66KB
import TenantPortalView from '../views/TenantPortalView.vue' // 76KB
import AiAdvisorView from '../views/AiAdvisorView.vue'       // 20KB
```

Initial bundle hiện tại ~614KB — toàn bộ 23 views được load ngay lúc app khởi động, dù người dùng chỉ cần vào Dashboard. Đây là nguyên nhân chính khiến app load chậm.  
**Sửa:** Chuyển sang dynamic import `() => import(...)` cho tất cả views trừ `DashboardGrid` và `LoginView`.

---

**[MED-05] Không có Optimistic Update — UX chậm chạp**

Khi nhấn "Xác nhận thanh toán", hệ thống: (1) gọi API → đợi response → (2) mới cập nhật UI. Trong thực tế latency 200-500ms, người dùng thấy nút bị disable và không có gì xảy ra, dễ nhấn nhiều lần.  
**Sửa:** Dùng **Optimistic Update pattern**: cập nhật UI ngay lập tức (giả sử thành công), rollback nếu API trả về lỗi.

---

**[MED-06] Không có Rate Limiting / Debounce cho Search Input**

Ô tìm kiếm trong `BillsView`, `RoomsView`, `RentersView` bind trực tiếp `v-model` vào computed filter. Mỗi keystroke kích hoạt `filteredBills.value` re-compute — với 10.000+ bản ghi sẽ gây lag đáng kể.  
**Sửa:** Dùng `debounce(300ms)` cho search input, hoặc chuyển filter logic sang Web Worker.

---

**[MED-07] Cấu trúc dự án thiếu tầng Abstraction rõ ràng**

```
src/
├── views/       ← 23 files, mỗi file 300-700 dòng, trộn lẫn business logic + UI
├── stores/      ← data.js 1108 dòng, làm đủ mọi việc: state + actions + computed
├── components/  ← các component UI thuần
└── (thiếu)      ← composables/, services/, utils/, config/
```

Không có tầng `composables` để tái sử dụng logic, không có tầng `services` để gọi API, không có `config/constants.js` để chuẩn hóa enum. Kết quả: logic nghiệp vụ lặp lại ở nhiều chỗ, khó test, khó maintain.

---

### 🟢 LOW — Cải tiến chất lượng code

**[LOW-01] Magic Numbers và Magic Strings rải rác trong toàn bộ codebase**

```js
// BillsView.vue
const serviceFee = 150000    // Con số 150.000 có ý nghĩa gì? Tại sao 150k?
const dueDate = '2026-08-05' // Hardcode ngày cụ thể

// ContractsView.vue
if (daysLeft < 30) { ... }   // 30 ngày từ đâu ra?
```

**Sửa:** Tập trung vào `src/config/constants.js`:
```js
export const DEFAULT_SERVICE_FEE = 150_000
export const CONTRACT_EXPIRY_WARNING_DAYS = 30
export const LATE_PAYMENT_PENALTY_RATE = 0.02  // 2%/tháng
```

---

**[LOW-02] Không có TypeScript / JSDoc — Code không tự tài liệu hóa**

Các hàm như `generateBill()`, `createContract()`, `runBatchGenerate()` không có type annotation hay JSDoc comment. Developer mới vào team không biết tham số truyền vào có định dạng gì, function trả về gì.

---

**[LOW-03] Không có Unit Test cho logic nghiệp vụ quan trọng**

Không có 1 file `.spec.js` hay `.test.js` nào trong dự án. Logic tính toán hóa đơn, kiểm tra hợp đồng hết hạn, tính tiền phạt... hoàn toàn không được kiểm thử tự động. Mọi thay đổi đều có nguy cơ gây regression không phát hiện được.

---

**[LOW-04] `console.log()` debug còn sót lại trong production code**

Rải rác nhiều `console.log('DEBUG:', ...)` trong store và views — khi build production, những log này vẫn chạy và có thể in ra thông tin nhạy cảm (token, user data) trong DevTools.

---

## 📊 TỔNG KẾT — Ma Trận Ưu Tiên

| ID | Vấn đề | Vai trò phát hiện | Mức độ | Thời gian sửa |
| :--- | :--- | :--- | :---: | :--- |
| CRIT-01 | Auth bypass — fallback login | Dev | 🔴 Critical | 30 phút |
| CRIT-02 | TenantPortal lộ dữ liệu chéo | Người dùng + Dev | 🔴 Critical | 2 giờ |
| CRIT-03 | Điện nước hardcode sai số thực tế | Chủ nhà + Dev | 🔴 Critical | 3 giờ |
| CRIT-04 | dueDate hardcode gây quá hạn ngay | Chủ nhà + Dev | 🔴 Critical | 1 giờ |
| HIGH-01 | localStorage write 40KB mỗi thao tác | Dev | 🟠 High | 4 giờ |
| HIGH-02 | Status `rented` vs `occupied` mismatch | Người dùng + Dev | 🟠 High | 2 giờ |
| HIGH-03 | createContract gán nhầm renterId | Chủ nhà + Dev | 🟠 High | 1 giờ |
| HIGH-04 | Dashboard toàn dữ liệu tĩnh | Chủ nhà + Dev | 🟠 High | 2 ngày |
| HIGH-05 | Landing Page tên "Rentalio" sai brand | Chủ nhà | 🟠 High | 15 phút |
| MED-01 | Không có Error Boundary | Dev | 🟡 Medium | 4 giờ |
| MED-04 | Không có code splitting routes | Dev | 🟡 Medium | 2 giờ |
| VĐ-07 | Dashboard không phản ánh thực | Chủ nhà | 🟠 High | 2 ngày |
| VĐ-10 | Tiền cọc không được xử lý khi thanh lý | Chủ nhà | 🟠 High | 1 ngày |
| VĐ-14 | Giá điện không cấu hình theo tòa nhà | Chủ nhà | 🟡 Medium | 1 ngày |
| VĐ-03 | Không có nút gọi/nhắn tin nhanh | Người dùng | 🟡 Medium | 4 giờ |

---

> [!CAUTION]
> **4 vấn đề CRITICAL (CRIT-01 đến CRIT-04) phải được sửa trước khi đưa hệ thống lên production.** Đặc biệt CRIT-01 (auth bypass) và CRIT-02 (rò rỉ dữ liệu) có thể gây hậu quả pháp lý và mất niềm tin người dùng không thể phục hồi.

> [!TIP]
> Bắt đầu ngay với **CRIT-04** (sửa hardcode dueDate — 1 giờ) và **HIGH-05** (đổi "Rentalio" → "RentOps" — 15 phút) để có "quick wins" rõ ràng trước khi sang các vấn đề phức tạp hơn.

---

*Tài liệu này được tạo bằng phương pháp Role-play Analysis — đặt mình vào từng vai người dùng thực tế để phát hiện vấn đề mà code review thuần kỹ thuật thường bỏ sót.*  
*Lưu tại: [`PhanTichVanDe_3GocNhin.md`](file:///c:/laragon/www/RentOps/PhanTichVanDe_3GocNhin.md)*

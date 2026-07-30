<template>
  <div class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4 animate-fade-in">
    <div class="bg-white rounded-2xl max-w-xl w-full p-6 shadow-2xl space-y-5">
      <div class="flex items-center justify-between border-b border-slate-100 pb-3">
        <div>
          <h3 class="text-lg font-bold text-slate-900 flex items-center gap-2">
            <span>👥 Thành Viên Ở Cùng & Tạm Trú</span>
          </h3>
          <p class="text-xs text-slate-500 mt-0.5">
            Hợp đồng: <strong class="text-indigo-600 font-mono">{{ contract.contract_code }}</strong> (Phòng {{ contract.room_number || contract.room_id }})
          </p>
        </div>
        <button @click="$emit('close')" class="text-slate-400 hover:text-slate-600 font-bold text-lg">✕</button>
      </div>

      <!-- Add New Co-Tenant Form -->
      <form @submit.prevent="addCoTenant" class="bg-slate-50 p-4 rounded-xl border border-slate-200 space-y-3">
        <div class="text-xs font-bold uppercase text-slate-700">Thêm người ở ghép / khai báo tạm trú mới</div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label class="block text-[11px] font-semibold text-slate-600 uppercase mb-1">Họ & Tên *</label>
            <input
              v-model="form.full_name"
              required
              type="text"
              placeholder="Nguyễn Văn A"
              class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-xs focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label class="block text-[11px] font-semibold text-slate-600 uppercase mb-1">Số Điện Thoại</label>
            <input
              v-model="form.phone"
              type="tel"
              placeholder="0912345678"
              class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-xs focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label class="block text-[11px] font-semibold text-slate-600 uppercase mb-1">Số CCCD/CMND</label>
            <input
              v-model="form.id_card_number"
              type="text"
              placeholder="001200123456"
              class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-xs focus:ring-2 focus:ring-indigo-500 font-mono"
            />
          </div>

          <div>
            <label class="block text-[11px] font-semibold text-slate-600 uppercase mb-1">Biển Số Xe</label>
            <input
              v-model="form.vehicle_plate"
              type="text"
              placeholder="29B1-99888"
              class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-xs font-mono uppercase focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label class="block text-[11px] font-semibold text-slate-600 uppercase mb-1">Liên Hệ Khẩn Cấp</label>
            <input
              v-model="form.emergency_contact"
              type="text"
              placeholder="0909999888 (Mẹ)"
              class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-xs focus:ring-2 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label class="block text-[11px] font-semibold text-slate-600 uppercase mb-1">Đăng ký tạm trú</label>
            <select
              v-model="form.temporary_residence_status"
              class="w-full px-3 py-2 bg-white border border-slate-300 rounded-lg text-xs focus:ring-2 focus:ring-indigo-500"
            >
              <option value="pending">⏳ Đang chờ đăng ký</option>
              <option value="registered">✅ Đã khai báo Công an</option>
              <option value="not_registered">❌ Chưa đăng ký</option>
            </select>
          </div>
        </div>

        <div class="flex justify-end pt-1">
          <button
            type="submit"
            :disabled="submitting"
            class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-lg shadow transition"
          >
            {{ submitting ? 'Đang thêm...' : '➕ Thêm vào hợp đồng' }}
          </button>
        </div>
      </form>

      <!-- Existing Co-Tenants List -->
      <div class="space-y-2">
        <div class="text-xs font-bold uppercase text-slate-700 flex items-center justify-between">
          <span>Danh sách thành viên ở ghép ({{ coTenants.length }})</span>
          <button @click="loadCoTenants" class="text-slate-500 hover:text-slate-700 text-[11px]">🔄 Làm mới</button>
        </div>

        <div v-if="loading" class="text-center py-6 text-slate-400 text-xs">
          Đang tải danh sách thành viên...
        </div>

        <div v-else-if="coTenants.length === 0" class="text-center py-6 bg-slate-50 rounded-xl text-slate-400 text-xs border border-dashed border-slate-200">
          Chưa có người ở ghép nào trong hợp đồng này.
        </div>

        <div v-else class="max-h-56 overflow-y-auto space-y-2 pr-1">
          <div
            v-for="ct in coTenants"
            :key="ct.id"
            class="p-3 bg-white border border-slate-200 rounded-xl flex items-center justify-between hover:border-slate-300 transition"
          >
            <div class="space-y-0.5">
              <div class="flex items-center gap-2">
                <span class="font-bold text-slate-900 text-sm">{{ ct.full_name }}</span>
                <span :class="['px-2 py-0.5 rounded text-[10px] font-bold uppercase', getResBadge(ct.temporary_residence_status)]">
                  {{ getResLabel(ct.temporary_residence_status) }}
                </span>
              </div>
              <div class="text-xs text-slate-500 flex flex-wrap items-center gap-3">
                <span>📞 {{ ct.phone || 'Không có SĐT' }}</span>
                <span>🪪 CCCD: <strong class="font-mono text-slate-700">{{ ct.id_card_number || 'Chưa cập nhật' }}</strong></span>
                <span v-if="ct.vehicle_plate">🛵 Xe: <strong class="font-mono text-indigo-700">{{ ct.vehicle_plate }}</strong></span>
              </div>
            </div>

            <button
              @click="removeCoTenant(ct.id)"
              class="px-2.5 py-1 text-xs text-rose-600 bg-rose-50 hover:bg-rose-100 rounded-lg transition font-medium"
            >
              Xóa
            </button>
          </div>
        </div>
      </div>

      <div class="flex justify-end border-t border-slate-100 pt-3">
        <button
          @click="$emit('close')"
          class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl"
        >
          Đóng
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../services/api'

const props = defineProps({
  contract: { type: Object, required: true }
})

const emit = defineEmits(['close', 'updated'])

const coTenants = ref([])
const loading = ref(false)
const submitting = ref(false)

const form = ref({
  full_name: '',
  phone: '',
  id_card_number: '',
  vehicle_plate: '',
  emergency_contact: '',
  temporary_residence_status: 'pending'
})

const getResBadge = (st) => {
  if (st === 'registered') return 'bg-emerald-100 text-emerald-800'
  if (st === 'not_registered') return 'bg-rose-100 text-rose-800'
  return 'bg-amber-100 text-amber-800'
}

const getResLabel = (st) => {
  if (st === 'registered') return 'Đã Khai Báo'
  if (st === 'not_registered') return 'Chưa Đăng Ký'
  return 'Chờ Tạm Trú'
}

const loadCoTenants = async () => {
  loading.value = true
  try {
    const res = await api.get(`/contracts/${props.contract.id}/co_tenants`)
    coTenants.value = res?.data || []
  } catch (err) {
    console.warn('Error fetching co-tenants:', err)
  } finally {
    loading.value = false
  }
}

onMounted(loadCoTenants)

const addCoTenant = async () => {
  submitting.value = true
  try {
    await api.post(`/contracts/${props.contract.id}/co_tenants`, { co_tenant: form.value })
    form.value = { full_name: '', phone: '', id_card_number: '', vehicle_plate: '', emergency_contact: '', temporary_residence_status: 'pending' }
    loadCoTenants()
    emit('updated')
  } catch (err) {
    alert(err?.message || 'Không thể thêm thành viên')
  } finally {
    submitting.value = false
  }
}

const removeCoTenant = async (id) => {
  if (!confirm('Bạn có chắc muốn xóa thành viên ở cùng này khỏi hợp đồng?')) return
  try {
    await api.delete(`/contracts/${props.contract.id}/co_tenants?co_tenant_id=${id}`)
    loadCoTenants()
    emit('updated')
  } catch (err) {
    alert(err?.message || 'Không thể xóa thành viên')
  }
}
</script>

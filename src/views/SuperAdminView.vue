<template>
  <AppLayout>
    <div class="space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-2xl font-bold text-slate-900">Super Admin SaaS Console</h1>
          <p class="text-slate-500 text-sm mt-0.5">Quản lý các chủ trọ (Tenants), gói cước (Plans) và theo dõi doanh thu SaaS (MRR)</p>
        </div>

        <div class="bg-indigo-50 border border-indigo-200 px-4 py-2 rounded-xl text-right">
          <p class="text-xs text-indigo-700 font-bold uppercase">Doanh thu MRR Ước Tính</p>
          <p class="text-xl font-mono font-black text-indigo-900 mt-0.5">{{ formatCurrency(data.mrr_estimate) }}</p>
        </div>
      </div>

      <!-- Summary Metrics -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
          <p class="text-xs font-bold uppercase text-slate-400">Tổng Số Chủ Trọ (Tenants)</p>
          <p class="text-2xl font-black text-slate-900 mt-1">{{ data.total_tenants || 0 }}</p>
        </div>
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
          <p class="text-xs font-bold uppercase text-emerald-600">Tenant Đang Hoạt Động</p>
          <p class="text-2xl font-black text-emerald-700 mt-1">{{ data.active_tenants || 0 }}</p>
        </div>
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
          <p class="text-xs font-bold uppercase text-amber-600">Số Gói Cước SaaS</p>
          <p class="text-2xl font-black text-amber-700 mt-1">{{ (data.plans || []).length }}</p>
        </div>
      </div>

      <!-- Tenants Management Table -->
      <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-6 space-y-4">
        <div class="flex justify-between items-center">
          <h3 class="font-bold text-slate-900 text-base">🏢 Danh Sách Chủ Trọ / Tenants</h3>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full text-left text-sm text-slate-700">
            <thead class="bg-slate-50 text-xs uppercase text-slate-500 font-bold border-b border-slate-200">
              <tr>
                <th class="px-6 py-3.5">Tên Chủ trọ / Tòa nhà</th>
                <th class="px-6 py-3.5">Subdomain</th>
                <th class="px-6 py-3.5">Số điện thoại</th>
                <th class="px-6 py-3.5">Gói cước hiện tại</th>
                <th class="px-6 py-3.5">Trạng thái</th>
                <th class="px-6 py-3.5 text-right">Đổi gói cước</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              <tr v-for="tenant in data.tenants" :key="tenant.id" class="hover:bg-slate-50/80 transition">
                <td class="px-6 py-4 font-bold text-slate-900">{{ tenant.name }}</td>
                <td class="px-6 py-4 font-mono text-xs text-indigo-600 font-semibold">{{ tenant.subdomain }}.rentops.vn</td>
                <td class="px-6 py-4 font-mono text-slate-600">{{ tenant.phone || '0901234567' }}</td>
                <td class="px-6 py-4 font-semibold text-amber-700">
                  {{ tenant.plan?.name || 'Gói Dùng Thử / Cơ bản' }}
                </td>
                <td class="px-6 py-4">
                  <span class="px-2.5 py-1 bg-emerald-50 text-emerald-700 border border-emerald-200 text-xs font-semibold rounded-full uppercase">
                    {{ tenant.status || 'Active' }}
                  </span>
                </td>
                <td class="px-6 py-4 text-right">
                  <select
                    @change="changePlan(tenant.id, $event.target.value)"
                    class="bg-slate-50 border border-slate-300 text-xs text-slate-800 rounded-xl px-2.5 py-1.5 font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  >
                    <option value="" disabled selected>-- Nâng cấp gói --</option>
                    <option v-for="p in data.plans" :key="p.id" :value="p.id">
                      {{ p.name }} ({{ formatCurrency(p.monthly_price) }}/tháng)
                    </option>
                  </select>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import AppLayout from '../components/AppLayout.vue'

const data = ref({
  tenants: [],
  plans: [],
  total_tenants: 0,
  active_tenants: 0,
  mrr_estimate: 0
})

const formatCurrency = (val) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0)

const fetchOverview = async () => {
  try {
    const res = await fetch('/api/v1/super_admin/overview')
    if (res.ok) {
      const json = await res.json()
      data.value = json.data || {}
    }
  } catch (err) {
    console.error(err)
  }
}

const changePlan = async (tenantId, planId) => {
  try {
    const res = await fetch('/api/v1/super_admin/update_plan', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ tenant_id: tenantId, plan_id: planId })
    })
    if (res.ok) {
      alert('Đã cập nhật gói cước thành công!')
      fetchOverview()
    }
  } catch (err) {
    alert('Lỗi cập nhật gói cước')
  }
}

onMounted(fetchOverview)
</script>

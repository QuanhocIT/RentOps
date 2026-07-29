<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex justify-between items-center bg-slate-900 p-6 rounded-2xl border border-indigo-500/40 shadow-2xl text-white">
      <div>
        <span class="px-3 py-1 bg-indigo-500/20 text-indigo-300 font-bold text-xs rounded-full border border-indigo-500/30 uppercase tracking-widest">
          SaaS Super Admin Console
        </span>
        <h1 class="text-3xl font-black mt-2 bg-gradient-to-r from-indigo-400 to-blue-200 bg-clip-text text-transparent">
          ⚙️ Quản Trị Hệ Thống SaaS RentOps
        </h1>
        <p class="text-xs text-slate-400 mt-1">Quản lý các chủ trọ (Tenants), gói cước (Plans) và theo dõi doanh thu SaaS (MRR)</p>
      </div>

      <div class="text-right">
        <p class="text-xs text-slate-400">Doanh thu MRR Ước Tính</p>
        <p class="text-3xl font-mono font-black text-emerald-400 mt-1">{{ formatCurrency(data.mrr_estimate) }}</p>
      </div>
    </div>

    <!-- Summary Metrics -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700/60 shadow-lg text-white">
        <p class="text-xs text-slate-400">Tổng số Chủ Trọ (Tenants)</p>
        <p class="text-3xl font-bold text-indigo-400 mt-1">{{ data.total_tenants || 0 }}</p>
      </div>
      <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700/60 shadow-lg text-white">
        <p class="text-xs text-slate-400">Tenant Đang Hoạt Động</p>
        <p class="text-3xl font-bold text-emerald-400 mt-1">{{ data.active_tenants || 0 }}</p>
      </div>
      <div class="bg-slate-800/80 p-5 rounded-2xl border border-slate-700/60 shadow-lg text-white">
        <p class="text-xs text-slate-400">Số Gói Cước SaaS</p>
        <p class="text-3xl font-bold text-amber-400 mt-1">{{ (data.plans || []).length }}</p>
      </div>
    </div>

    <!-- Tenants Management Table -->
    <div class="bg-slate-800/80 rounded-2xl border border-slate-700/60 overflow-hidden shadow-xl text-white">
      <div class="p-4 border-b border-slate-700/60 flex justify-between items-center">
        <h3 class="font-bold text-white text-base">🏢 Danh Sách Chủ Trọ / Tenants</h3>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-left text-sm text-slate-300">
          <thead class="bg-slate-900/60 text-xs uppercase text-slate-400 border-b border-slate-700/60">
            <tr>
              <th class="px-6 py-4">Tên Chủ trọ / Tòa nhà</th>
              <th class="px-6 py-4">Subdomain</th>
              <th class="px-6 py-4">Số điện thoại</th>
              <th class="px-6 py-4">Gói cước hiện tại</th>
              <th class="px-6 py-4">Trạng thái</th>
              <th class="px-6 py-4 text-right">Đổi gói cước</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-700/40">
            <tr v-for="tenant in data.tenants" :key="tenant.id" class="hover:bg-slate-700/30 transition">
              <td class="px-6 py-4 font-bold text-white">{{ tenant.name }}</td>
              <td class="px-6 py-4 font-mono text-xs text-indigo-300">{{ tenant.subdomain }}.rentops.vn</td>
              <td class="px-6 py-4 font-mono">{{ tenant.phone || '0901234567' }}</td>
              <td class="px-6 py-4 font-semibold text-amber-400">
                {{ tenant.plan?.name || 'Gói Dùng Thử / Cơ bản' }}
              </td>
              <td class="px-6 py-4">
                <span class="px-2.5 py-1 bg-emerald-500/20 text-emerald-400 text-xs font-bold rounded-lg uppercase">
                  {{ tenant.status || 'Active' }}
                </span>
              </td>
              <td class="px-6 py-4 text-right">
                <select
                  @change="changePlan(tenant.id, $event.target.value)"
                  class="bg-slate-900 border border-slate-700 text-xs text-slate-200 rounded-lg px-2 py-1 font-semibold"
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
</template>

<script setup>
import { ref, onMounted } from 'vue'

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

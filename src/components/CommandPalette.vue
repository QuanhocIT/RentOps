<template>
  <div
    v-if="isOpen"
    class="fixed inset-0 z-[9990] bg-slate-900/60 backdrop-blur-sm flex items-start justify-center pt-20 px-4 animate-fade-in"
    @click.self="close"
  >
    <div class="bg-white dark:bg-slate-900 rounded-2xl max-w-2xl w-full shadow-2xl border border-slate-200 dark:border-slate-800 overflow-hidden flex flex-col max-h-[80vh]">
      <!-- Search Input -->
      <div class="p-4 border-b border-slate-100 dark:border-slate-800 flex items-center gap-3 bg-slate-50/50 dark:bg-slate-900/50">
        <span class="text-slate-400 text-lg">🔍</span>
        <input
          ref="searchInput"
          v-model="query"
          type="text"
          placeholder="Tìm phòng, khách thuê, hóa đơn hoặc phím tắt trang... (Esc để đóng)"
          class="w-full bg-transparent text-slate-900 dark:text-white font-medium text-sm focus:outline-none placeholder-slate-400"
          @keydown.down.prevent="navigateDown"
          @keydown.up.prevent="navigateUp"
          @keydown.enter.prevent="selectCurrent"
        />
        <kbd class="px-2 py-1 bg-slate-200 dark:bg-slate-800 text-slate-500 dark:text-slate-400 rounded text-[10px] font-mono font-bold">ESC</kbd>
      </div>

      <!-- Results List -->
      <div class="overflow-y-auto p-2 space-y-1 flex-1">
        <!-- Quick Nav Actions -->
        <div v-if="filteredPages.length > 0" class="mb-2">
          <div class="px-3 py-1 text-[10px] font-bold uppercase tracking-wider text-slate-400">Trang Chức Năng</div>
          <div
            v-for="(page, idx) in filteredPages"
            :key="page.path"
            :class="[
              'px-3.5 py-2.5 rounded-xl flex items-center justify-between text-xs font-semibold cursor-pointer transition',
              selectedIndex === idx ? 'bg-indigo-600 text-white shadow-md' : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800'
            ]"
            @click="goToPage(page.path)"
            @mouseenter="selectedIndex = idx"
          >
            <div class="flex items-center gap-2.5">
              <span>{{ page.icon }}</span>
              <span>{{ page.title }}</span>
            </div>
            <span :class="['text-[11px] font-mono', selectedIndex === idx ? 'text-indigo-200' : 'text-slate-400']">{{ page.path }}</span>
          </div>
        </div>

        <div v-if="filteredPages.length === 0" class="p-8 text-center text-slate-400 text-xs">
          Không tìm thấy trang hoặc dữ liệu phù hợp.
        </div>
      </div>

      <!-- Footer Info -->
      <div class="p-3 bg-slate-50 dark:bg-slate-950 border-t border-slate-100 dark:border-slate-800 text-[11px] text-slate-400 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <span>⬆️⬇️ Di chuyển</span>
          <span>↵ Chọn</span>
          <span>Esc Đóng</span>
        </div>
        <span class="font-mono text-indigo-500 font-bold">RentOps Command Palette</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, nextTick, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({
  isOpen: { type: Boolean, default: false }
})

const emit = defineEmits(['close'])

const router = useRouter()
const query = ref('')
const searchInput = ref(null)
const selectedIndex = ref(0)

const pages = [
  { title: 'Dashboard - Tổng Quan', path: '/dashboard', icon: '📊' },
  { title: 'Quản Lý Tòa Nhà & Bất Động Sản', path: '/properties', icon: '🏢' },
  { title: 'Quản Lý Danh Sách Phòng Trọ', path: '/rooms', icon: '🚪' },
  { title: 'Quản Lý Khách Thuê', path: '/renters', icon: '👥' },
  { title: 'Ghi Chỉ Số Điện Nước', path: '/utility-readings', icon: '⚡' },
  { title: 'Quản Lý Hợp Đồng Thuê', path: '/contracts', icon: '📄' },
  { title: 'Hóa Đơn & Mã VietQR', path: '/bills', icon: '💰' },
  { title: 'Dịch Vụ & Phụ Phí', path: '/services', icon: '⚙️' },
  { title: 'Tài Sản & Tiện Nghi Phòng', path: '/assets', icon: '🛋️' },
  { title: 'Yêu Cầu Bảo Trì & Sửa Chữa', path: '/maintenance', icon: '🔧' },
  { title: 'Chi Phí Vận Hành', path: '/expenses', icon: '💸' },
  { title: 'Báo Cáo Phân Tích Tài Chính', path: '/reports', icon: '📈' },
  { title: 'Cấu Hình & Cài Đặt Hệ Thống', path: '/settings', icon: '⚙️' },
  { title: 'Thùng Rác & Khôi Phục Dữ Liệu', path: '/trash', icon: '🗑️' }
]

const filteredPages = computed(() => {
  if (!query.value.trim()) return pages
  const q = query.value.toLowerCase()
  return pages.filter((p) => p.title.toLowerCase().includes(q) || p.path.toLowerCase().includes(q))
})

watch(() => props.isOpen, (newVal) => {
  if (newVal) {
    query.value = ''
    selectedIndex.value = 0
    nextTick(() => searchInput.value?.focus())
  }
})

const close = () => {
  emit('close')
}

const goToPage = (path) => {
  router.push(path)
  close()
}

const navigateDown = () => {
  if (selectedIndex.value < filteredPages.value.length - 1) {
    selectedIndex.value++
  }
}

const navigateUp = () => {
  if (selectedIndex.value > 0) {
    selectedIndex.value--
  }
}

const selectCurrent = () => {
  if (filteredPages.value[selectedIndex.value]) {
    goToPage(filteredPages.value[selectedIndex.value].path)
  }
}

const handleKeyDown = (e) => {
  if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
    e.preventDefault()
    if (props.isOpen) {
      close()
    } else {
      emit('open')
    }
  } else if (e.key === 'Escape' && props.isOpen) {
    close()
  }
}

onMounted(() => window.addEventListener('keydown', handleKeyDown))
onUnmounted(() => window.removeEventListener('keydown', handleKeyDown))
</script>

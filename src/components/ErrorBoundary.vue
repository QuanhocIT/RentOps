<template>
  <div v-if="error" class="p-6 m-4 bg-rose-50 border border-rose-200 rounded-2xl text-rose-900 space-y-3">
    <div class="flex items-center gap-2 text-rose-700 font-bold">
      <span class="text-xl">⚠️</span>
      <h3 class="text-base font-black">Đã xảy ra lỗi giao diện trong phần này</h3>
    </div>
    <p class="text-xs text-rose-800 font-mono bg-rose-100/70 p-3 rounded-xl overflow-x-auto">
      {{ error.message || error }}
    </p>
    <button
      @click="resetError"
      class="px-4 py-2 bg-rose-600 hover:bg-rose-700 text-white font-bold text-xs rounded-xl shadow-md transition"
    >
      🔄 Tải lại thành phần
    </button>
  </div>
  <slot v-else />
</template>

<script setup>
import { ref, onErrorCaptured } from 'vue'

const error = ref(null)

onErrorCaptured((err) => {
  console.error('[ErrorBoundary] Caught component error:', err)
  error.value = err
  return false
})

const resetError = () => {
  error.value = null
}
</script>

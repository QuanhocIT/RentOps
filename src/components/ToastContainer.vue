<template>
  <div class="fixed top-5 right-5 z-[9999] space-y-3 pointer-events-none max-w-sm w-full px-4">
    <transition-group
      enter-active-class="transform ease-out duration-300 transition"
      enter-from-class="translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-4"
      enter-to-class="translate-y-0 opacity-100 sm:translate-x-0"
      leave-active-class="transition ease-in duration-200"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0 translate-x-4"
    >
      <div
        v-for="t in toastStore.toasts"
        :key="t.id"
        :class="[
          'pointer-events-auto flex items-start gap-3 p-4 rounded-2xl shadow-xl border backdrop-blur-md transition-all text-xs font-semibold',
          getToastStyle(t.type)
        ]"
      >
        <span class="text-base select-none">{{ getToastIcon(t.type) }}</span>
        <div class="flex-1 pt-0.5 leading-snug">
          {{ t.message }}
        </div>
        <button
          @click="toastStore.removeToast(t.id)"
          class="text-slate-400 hover:text-slate-600 font-bold ml-1 text-sm focus:outline-none"
        >
          ✕
        </button>
      </div>
    </transition-group>
  </div>
</template>

<script setup>
import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()

const getToastIcon = (type) => {
  switch (type) {
    case 'success': return '✅'
    case 'error': return '❌'
    case 'warning': return '⚠️'
    default: return 'ℹ️'
  }
}

const getToastStyle = (type) => {
  switch (type) {
    case 'success':
      return 'bg-emerald-50/95 border-emerald-200 text-emerald-900 shadow-emerald-500/10'
    case 'error':
      return 'bg-rose-50/95 border-rose-200 text-rose-900 shadow-rose-500/10'
    case 'warning':
      return 'bg-amber-50/95 border-amber-200 text-amber-900 shadow-amber-500/10'
    default:
      return 'bg-indigo-50/95 border-indigo-200 text-indigo-900 shadow-indigo-500/10'
  }
}
</script>

<template>
  <div class="animate-pulse space-y-4">
    <div v-if="type === 'card'" class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div v-for="i in count" :key="i" class="h-32 bg-slate-200/80 rounded-2xl"></div>
    </div>
    <div v-else-if="type === 'table'" class="space-y-3">
      <div class="h-10 bg-slate-200/90 rounded-xl"></div>
      <div v-for="i in count" :key="i" class="h-12 bg-slate-100 rounded-xl"></div>
    </div>
    <div v-else class="space-y-3">
      <div v-for="i in count" :key="i" class="h-20 bg-slate-200/70 rounded-2xl"></div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  type: {
    type: String,
    default: 'list' // 'card' | 'table' | 'list'
  },
  count: {
    type: Number,
    default: 4
  }
})
</script>

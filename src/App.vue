<template>
  <div id="app" class="min-h-screen bg-slate-100 text-slate-800 selection:bg-indigo-500 selection:text-white font-sans antialiased overflow-x-hidden">
    <router-view v-slot="{ Component, route }">
      <component :is="Component" :key="route.path" />
    </router-view>
  </div>
</template>

<script setup>
</script>




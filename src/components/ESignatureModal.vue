<template>
  <div v-if="show" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in">
    <div class="bg-slate-900 border border-slate-700/60 rounded-2xl max-w-lg w-full p-6 text-white shadow-2xl relative animate-scale-in">
      <button @click="$emit('close')" class="absolute top-4 right-4 text-slate-400 hover:text-white text-xl">✕</button>

      <h3 class="text-lg font-bold text-amber-400 mb-2">✍️ Ký Tên Điện Tử Hợp Đồng</h3>
      <p class="text-xs text-slate-400 mb-4">Vui lòng vẽ chữ ký của bạn vào ô bên dưới bằng chuột hoặc cảm ứng tay.</p>

      <div class="bg-slate-800 rounded-xl p-2 border border-slate-700">
        <canvas
          ref="canvasRef"
          @mousedown="startDrawing"
          @mousemove="draw"
          @mouseup="stopDrawing"
          @mouseleave="stopDrawing"
          @touchstart.prevent="startDrawingTouch"
          @touchmove.prevent="drawTouch"
          @touchend.prevent="stopDrawing"
          class="w-full h-48 bg-white rounded-lg cursor-crosshair border border-slate-300"
        ></canvas>
      </div>

      <div class="flex justify-between items-center mt-4">
        <button @click="clearCanvas" class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs rounded-xl transition">
          🧹 Xóa vẽ lại
        </button>

        <div class="space-x-2">
          <button @click="$emit('close')" class="px-4 py-2 bg-slate-800 text-slate-400 hover:text-white text-xs rounded-xl">Hủy</button>
          <button @click="saveSignature" class="px-5 py-2 bg-emerald-500 hover:bg-emerald-600 font-bold text-white text-xs rounded-xl shadow-lg transition">
            ✓ Xác nhận Chữ ký
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'

const props = defineProps({
  show: Boolean
})

const emit = defineEmits(['close', 'save'])
const canvasRef = ref(null)
const isDrawing = ref(false)

const clearCanvas = () => {
  if (!canvasRef.value) return
  const ctx = canvasRef.value.getContext('2d')
  ctx.clearRect(0, 0, canvasRef.value.width, canvasRef.value.height)
}

const setupCanvas = () => {
  if (!canvasRef.value) return
  const canvas = canvasRef.value
  canvas.width = canvas.offsetWidth
  canvas.height = canvas.offsetHeight
  const ctx = canvas.getContext('2d')
  ctx.strokeStyle = '#0f172a'
  ctx.lineWidth = 3
  ctx.lineCap = 'round'
}

watch(() => props.show, (newVal) => {
  if (newVal) {
    setTimeout(setupCanvas, 100)
  }
})

const startDrawing = (e) => {
  isDrawing.value = true
  const ctx = canvasRef.value.getContext('2d')
  const rect = canvasRef.value.getBoundingClientRect()
  ctx.beginPath()
  ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top)
}

const draw = (e) => {
  if (!isDrawing.value) return
  const ctx = canvasRef.value.getContext('2d')
  const rect = canvasRef.value.getBoundingClientRect()
  ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top)
  ctx.stroke()
}

const startDrawingTouch = (e) => {
  isDrawing.value = true
  const touch = e.touches[0]
  const ctx = canvasRef.value.getContext('2d')
  const rect = canvasRef.value.getBoundingClientRect()
  ctx.beginPath()
  ctx.moveTo(touch.clientX - rect.left, touch.clientY - rect.top)
}

const drawTouch = (e) => {
  if (!isDrawing.value) return
  const touch = e.touches[0]
  const ctx = canvasRef.value.getContext('2d')
  const rect = canvasRef.value.getBoundingClientRect()
  ctx.lineTo(touch.clientX - rect.left, touch.clientY - rect.top)
  ctx.stroke()
}

const stopDrawing = () => {
  isDrawing.value = false
}

const saveSignature = () => {
  if (!canvasRef.value) return
  const dataUrl = canvasRef.value.toDataURL('image/png')
  emit('save', dataUrl)
  emit('close')
}
</script>

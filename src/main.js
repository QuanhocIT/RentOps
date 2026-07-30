import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'
import './style.css'

const app = createApp(App)
const pinia = createPinia()

app.config.errorHandler = (err, instance, info) => {
  console.error('[RentOps Global ErrorHandler]:', err, info)
}

app.use(pinia)
app.use(router)
app.mount('#app')

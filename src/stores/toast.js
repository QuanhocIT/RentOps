import { defineStore } from 'pinia'

export const useToastStore = defineStore('toast', {
  state: () => ({
    toasts: []
  }),

  actions: {
    addToast({ message, type = 'info', timeout = 3500 }) {
      const id = Date.now() + Math.random().toString(36).substring(2, 5)
      const toast = { id, message, type }
      this.toasts.push(toast)

      if (timeout > 0) {
        setTimeout(() => {
          this.removeToast(id)
        }, timeout)
      }
    },

    success(message, timeout = 3500) {
      this.addToast({ message, type: 'success', timeout })
    },

    error(message, timeout = 4500) {
      this.addToast({ message, type: 'error', timeout })
    },

    warning(message, timeout = 4000) {
      this.addToast({ message, type: 'warning', timeout })
    },

    info(message, timeout = 3500) {
      this.addToast({ message, type: 'info', timeout })
    },

    removeToast(id) {
      this.toasts = this.toasts.filter((t) => t.id !== id)
    }
  }
})

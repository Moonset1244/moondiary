import { createStore } from 'zustand/vanilla'

export const modeStore = createStore(() => ({ editable: true, panelMode: false }))

// 编辑偏好（从 Flutter boot payload 下发）
export const editPrefsStore = createStore<{
  enterBreaks: boolean
  autoTitleMode: number
  autoFormat: boolean
}>(() => ({
  enterBreaks: false,
  autoTitleMode: 0,
  autoFormat: false,
}))

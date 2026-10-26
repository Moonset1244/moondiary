import { createStore } from 'zustand/vanilla'

// 源码模式：隐藏 TipTap 视图，直接编辑当前文档的 Markdown 文本。
// 进入时把文档序列化进 sourceText；退出时把文本解析回文档并触发 change 流水线。
export const sourceStore = createStore(() => ({
  sourceMode: false,
  sourceText: '',
}))

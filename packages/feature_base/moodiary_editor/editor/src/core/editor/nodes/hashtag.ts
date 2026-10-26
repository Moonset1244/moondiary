import { Extension } from '@tiptap/core'
import { Plugin, PluginKey } from '@tiptap/pm/state'
import { Decoration, DecorationSet, type EditorView } from '@tiptap/pm/view'
import type { Node as PMNode } from '@tiptap/pm/model'

// 标签：# 后跟字母/数字/下划线/中文；# 前不能是同类字符或 #（避免误匹配 ##标题 / abc#tag）
const HASHTAG_REGEX = /(?<![\p{L}\p{N}_#])#[\p{L}\p{N}_\u4e00-\u9fa5]+/gu

function collectDecorations(doc: PMNode): Decoration[] {
  const decorations: Decoration[] = []
  doc.descendants((node, pos) => {
    if (!node.isText || !node.text) return
    HASHTAG_REGEX.lastIndex = 0
    let match: RegExpExecArray | null
    while ((match = HASHTAG_REGEX.exec(node.text))) {
      decorations.push(
        Decoration.inline(pos + match.index, pos + match.index + match[0].length, {
          class: 'md-hashtag',
        }),
      )
    }
  })
  return decorations
}

const hashtagPluginKey = new PluginKey<DecorationSet>('hashtag')

export const Hashtag = Extension.create({
  name: 'hashtag',

  addProseMirrorPlugins() {
    return [
      new Plugin({
        key: hashtagPluginKey,
        state: {
          init: (_, { doc }) => DecorationSet.create(doc, collectDecorations(doc)),
          apply: (tr, old) =>
            tr.docChanged
              ? DecorationSet.create(tr.doc, collectDecorations(tr.doc))
              : old,
        },
        props: {
          decorations: (state) => hashtagPluginKey.getState(state) ?? DecorationSet.empty,
        },
      }),
    ]
  },
})

import { useEffect, useRef } from 'react'
import type { Editor } from '@tiptap/core'
import { EditorContent, useEditorState } from '@tiptap/react'
import { useStore } from 'zustand'
import { post } from '@/core/bridge/post'
import { bindScrollViewport } from '@/core/bridge/scroll'
import { countCharacters, plainTextOf } from '@/core/editor/plain-text'
import { modeStore, editPrefsStore } from '@/core/state/editable'
import { metaStore } from '@/core/state/meta'
import { sourceStore } from '@/core/state/source'
import { titleStore } from '@/core/state/title'
import EditorLinksPanel from './EditorLinksPanel'
import { useScrollSpy } from './hooks/use-scroll-spy'
import EditorMetaHeader from './meta/EditorMetaHeader'
import TitleField from './TitleField'

export default function EditorViewport({ editor }: { editor: Editor }) {
  const editable = useStore(modeStore, (s) => s.editable)
  const meta = useStore(metaStore, (s) => s.meta)
  const links = useStore(metaStore, (s) => s.links)
  const sourceMode = useStore(sourceStore, (s) => s.sourceMode)
  const sourceText = useStore(sourceStore, (s) => s.sourceText)
  const viewport = useRef<HTMLDivElement>(null)
  const sourceRef = useRef<HTMLTextAreaElement>(null)
  const onScroll = useScrollSpy(editor, viewport)

  const wordCount = useEditorState({
    editor,
    selector: ({ editor: ed }) => (editable ? 0 : countCharacters(plainTextOf(ed.state.doc))),
  })

  const autoTitleMode = useStore(editPrefsStore, (s) => s.autoTitleMode)
  const title = useStore(titleStore, (s) => s.title)
  const doc = useEditorState({ editor, selector: ({ editor: ed }) => ed.state.doc })

  // 自动标题实时预览：标题为空时作为 placeholder 显示
  const autoTitlePreview = (() => {
    if (autoTitleMode === 0 || title.trim().length > 0) return null
    if (autoTitleMode === 1) {
      const text = plainTextOf(doc).trim()
      if (!text) return null
      const first = text.split(/[。！？!?.\n]/)[0].trim()
      return first ? (first.length > 40 ? `${first.slice(0, 40)}…` : first) : null
    }
    if (autoTitleMode === 2) return meta?.subText ?? null
    return null
  })()

  useEffect(() => {
    bindScrollViewport(viewport.current)
    return () => bindScrollViewport(null)
  }, [])

  // 源码模式切换后自动聚焦 textarea，并把焦点上报为编辑器焦点（否则底部工具栏消失、无法切回）
  useEffect(() => {
    if (sourceMode && editable) {
      sourceRef.current?.focus()
    }
  }, [sourceMode, editable])

  return (
    <div ref={viewport} className="md-viewport" onScroll={onScroll}>
      <div className="md-page">
        {meta && <EditorMetaHeader meta={meta} editable={editable} wordCount={wordCount} />}
        <TitleField editor={editor} editable={editable} autoTitlePreview={autoTitlePreview} />
        {sourceMode ? (
          <textarea
            ref={sourceRef}
            className="md-source"
            value={sourceText}
            readOnly={!editable}
            spellCheck={false}
            autoCapitalize="off"
            autoCorrect="off"
            onChange={(e) => sourceStore.setState({ sourceText: e.target.value })}
            onFocus={() => post('focusChange', 'editor')}
            onBlur={() => post('focusChange', '')}
          />
        ) : (
          <EditorContent editor={editor} className="md-editor" />
        )}
        {!editable && links && links.outgoing.length + links.incoming.length > 0 && <EditorLinksPanel links={links} />}
      </div>
    </div>
  )
}

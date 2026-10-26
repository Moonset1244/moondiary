import { useEffect, useRef } from 'react'
import type { Editor } from '@tiptap/core'
import { EditorContent, useEditorState } from '@tiptap/react'
import { useStore } from 'zustand'
import { bindScrollViewport } from '@/core/bridge/scroll'
import { countCharacters, plainTextOf } from '@/core/editor/plain-text'
import { modeStore } from '@/core/state/editable'
import { metaStore } from '@/core/state/meta'
import { sourceStore } from '@/core/state/source'
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
  const onScroll = useScrollSpy(editor, viewport)

  const wordCount = useEditorState({
    editor,
    selector: ({ editor: ed }) => (editable ? 0 : countCharacters(plainTextOf(ed.state.doc))),
  })

  useEffect(() => {
    bindScrollViewport(viewport.current)
    return () => bindScrollViewport(null)
  }, [])

  return (
    <div ref={viewport} className="md-viewport" onScroll={onScroll}>
      <div className="md-page">
        {meta && <EditorMetaHeader meta={meta} editable={editable} wordCount={wordCount} />}
        <TitleField editor={editor} editable={editable} />
        {sourceMode ? (
          <textarea
            className="md-source"
            value={sourceText}
            readOnly={!editable}
            spellCheck={false}
            autoCapitalize="off"
            autoCorrect="off"
            onChange={(e) => sourceStore.setState({ sourceText: e.target.value })}
          />
        ) : (
          <EditorContent editor={editor} className="md-editor" />
        )}
        {!editable && links && links.outgoing.length + links.incoming.length > 0 && <EditorLinksPanel links={links} />}
      </div>
    </div>
  )
}

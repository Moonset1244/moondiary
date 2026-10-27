import { setLocale } from '@/core/i18n'
import { editPrefsStore, modeStore } from '@/core/state/editable'
import { applyTheme, type EditorTheme } from './theme'

export interface EditorBoot {
  editable: boolean
  locale: string
  theme: EditorTheme
  enterBreaks?: boolean
  autoTitleMode?: number
  autoFormat?: boolean
}

export function bootstrap(boot: EditorBoot): void {
  setLocale(boot.locale)
  modeStore.setState({ editable: boot.editable })
  editPrefsStore.setState({
    enterBreaks: boot.enterBreaks === true,
    autoTitleMode: boot.autoTitleMode ?? 0,
    autoFormat: boot.autoFormat === true,
  })
  applyTheme(boot.theme)
}

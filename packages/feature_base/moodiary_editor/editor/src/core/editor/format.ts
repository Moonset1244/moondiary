// 日记自动格式化（参考 Obsidian Linter）：中文与英文/数字之间加空格、段落间空行、清理尾随空格。

const CJK = '[\u4e00-\u9fff\u3400-\u4dbf\u3000-\u303f]'

export interface FormatRules {
  cjkSpace: boolean
  blankLines: boolean
  trailingSpaces: boolean
}

export const DEFAULT_FORMAT_RULES: FormatRules = {
  cjkSpace: true,
  blankLines: true,
  trailingSpaces: true,
}

// 中文与英文/数字之间加空格（pangu 式）
export function spaceCjkLatin(text: string): string {
  return text
    .replace(new RegExp(`(${CJK})([A-Za-z0-9])`, 'g'), '$1 $2')
    .replace(new RegExp(`([A-Za-z0-9])(${CJK})`, 'g'), '$1 $2')
}

// 段落间空行：3 个及以上换行合并为 2 个（一个空行）
export function normalizeBlankLines(text: string): string {
  return text.replace(/\n{3,}/g, '\n\n')
}

// 清理行尾空格与制表符
export function trimTrailingSpaces(text: string): string {
  return text.replace(/[ \t]+$/gm, '')
}

export function formatMarkdown(
  text: string,
  rules: FormatRules = DEFAULT_FORMAT_RULES,
): string {
  let out = text
  if (rules.blankLines) out = normalizeBlankLines(out)
  if (rules.cjkSpace) out = spaceCjkLatin(out)
  if (rules.trailingSpaces) out = trimTrailingSpaces(out)
  return out
}

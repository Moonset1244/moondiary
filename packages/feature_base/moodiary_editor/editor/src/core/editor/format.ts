// 日记自动格式化（参考 Obsidian Linter 插件规则）。
// 全部在 markdown 文本层做正则处理；编辑器 formatDocument 用 getMarkdown→format→parse 往返。

const CJK = '[\u4e00-\u9fff\u3400-\u4dbf\u3000-\u303f]'

export interface FormatRules {
  headingSpace: boolean // 标题 # 后空格
  listSpace: boolean // 列表标记后空格
  trailingSpaces: boolean // 行尾空格
  collapseBlankLines: boolean // 折叠多余空行
  cjkSpace: boolean // 中英文空格
}

export const DEFAULT_FORMAT_RULES: FormatRules = {
  headingSpace: true,
  listSpace: true,
  trailingSpaces: true,
  collapseBlankLines: true,
  cjkSpace: true,
}

// 中文与英文/数字之间加空格（pangu 式）
export function spaceCjkLatin(text: string): string {
  return text
    .replace(new RegExp(`(${CJK})([A-Za-z0-9])`, 'g'), '$1 $2')
    .replace(new RegExp(`([A-Za-z0-9])(${CJK})`, 'g'), '$1 $2')
}

// 标题 # 后加空格：#标题 → # 标题（保留缩进；排除已带空格的）
export function headingSpace(text: string): string {
  return text.replace(/^(\s{0,3}#{1,6})(?=\S)/gm, '$1 ')
}

// 列表标记后加空格：-项目 → - 项目；1.项目 → 1. 项目
export function listSpace(text: string): string {
  return text.replace(/^(\s*)([-*+]|\d+[.)])(?=\S)/gm, '$1$2 ')
}

// 清理行尾空格与制表符
export function trimTrailingSpaces(text: string): string {
  return text.replace(/[ \t]+$/gm, '')
}

// 折叠 3 个及以上连续空行为 2 个（一个空行）
export function collapseBlankLines(text: string): string {
  return text.replace(/\n{3,}/g, '\n\n')
}

export function formatMarkdown(
  text: string,
  rules: FormatRules = DEFAULT_FORMAT_RULES,
): string {
  let out = text.replace(/\r\n?/g, '\n')
  if (rules.trailingSpaces) out = trimTrailingSpaces(out)
  if (rules.headingSpace) out = headingSpace(out)
  if (rules.listSpace) out = listSpace(out)
  if (rules.collapseBlankLines) out = collapseBlankLines(out)
  if (rules.cjkSpace) out = spaceCjkLatin(out)
  return out
}

# macOS 26 (Tahoe) 隐藏 Apps / Launchpad 图标方案

## 背景

在 macOS 26 (Tahoe) 中：

- Launchpad 已被新的 **Apps / Spotlight UI** 替代  
- 不再使用旧的：
  ~/Library/Application Support/Dock/*.db
- Apps 列表来源：
  LaunchServices + Spotlight 索引

## 核心思路

使用 LaunchServices 注销应用：

lsregister -u <app_path>

## 单个 App 隐藏

/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "/Applications/Utilities/LogiPluginService.app"

## Bundle 内嵌 App

lsregister -u "/Applications/Utilities/XXX.bundle/YYY.app"

## 恢复

lsregister -f "<app_path>"

## 批量隐藏脚本

路径：
~/.local/bin/hide-hidden-apps.sh

内容：

#!/bin/zsh
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
LIST="$HOME/Library/Application Support/HiddenAppsManager/hidden_apps.txt"

[ -f "$LIST" ] || exit 0

while IFS= read -r app; do
  [ -z "$app" ] && continue
  [ -d "$app" ] && "$LSREGISTER" -u "$app" 2>/dev/null
done < "$LIST"

权限：
chmod +x ~/.local/bin/hide-hidden-apps.sh

## 列表文件

~/Library/Application Support/HiddenAppsManager/hidden_apps.txt

## Karabiner 自动触发

Option + Space：
隐藏 → 打开 Apps → 清空搜索

## 总结

macOS 26 无法直接隐藏单个 App  
唯一方法：lsregister -u + 自动触发

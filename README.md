# macOS 26 (Tahoe) 隐藏 Apps / Launchpad 图标方案

适配 macOS 26.4.1，对于其他系统没有测试过，不定期更新

不用安装额外软件，更新于04/29/2026

可以正常使用，但是在安装/删除软件后会掉（应该是因为App.app重新加载索引了）

#
[Version1](./Version1/README.md): 手动添加app，然后手动隐藏

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
```
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u /Applications/Utilities/LogiPluginService.app
```
## Bundle 内嵌 App
```
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u /Applications/Utilities/Logi Options+ Driver Installer.bundle/Logi Options+ Driver Installer.app
```
## 恢复
```
lsregister -f <app_path>
```
## 效果
<img src="imgs/img.png">
可以看到，logi Option+后续2个软件已经被隐藏了，但是搜索依然有用

## 总结

macOS 26.4.1 无法直接隐藏单个 App  
唯一方法：lsregister -u

## 后续
后续可以考虑 使用 自动触发或是一些更加快捷、自动的方式实现这个功能

## License
MIT
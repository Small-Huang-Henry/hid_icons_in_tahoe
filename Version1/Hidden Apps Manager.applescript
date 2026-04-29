property configFile : ((path to home folder as text) & "Library:Application Support:HiddenAppsManager:hidden_apps.txt")

on run
	do shell script "mkdir -p ~/Library/Application\\ Support/HiddenAppsManager && touch ~/Library/Application\\ Support/HiddenAppsManager/hidden_apps.txt"
	
	set actionList to {"添加要隐藏的 App", "隐藏列表里的所有 App", "恢复列表里的所有 App", "查看隐藏列表"}
	set chosenAction to choose from list actionList with title "Hidden Apps Manager" with prompt "选择操作：" default items {"添加要隐藏的 App"}
	
	if chosenAction is false then return
	
	set actionName to item 1 of chosenAction
	
	if actionName is "添加要隐藏的 App" then
		set chosenApp to POSIX path of (choose file with prompt "选择要隐藏的 .app" of type {"app"} default location (path to applications folder))
		do shell script "mkdir -p ~/Library/Application\\ Support/HiddenAppsManager"
		do shell script "grep -qxF " & quoted form of appPath & " ~/Library/Application\\ Support/HiddenAppsManager/hidden_apps.txt || echo " & quoted form of appPath & " >> ~/Library/Application\\ Support/HiddenAppsManager/hidden_apps.txt"
		display dialog "已加入隐藏列表：" & return & appPath buttons {"OK"} default button "OK"
		
	else if actionName is "隐藏列表里的所有 App" then
		do shell script "
LSREGISTER='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
while IFS= read -r app; do
  [ -d \"$app\" ] && \"$LSREGISTER\" -u \"$app\" 2>/dev/null
done < ~/Library/Application\\ Support/HiddenAppsManager/hidden_apps.txt
"
		display dialog "已执行隐藏。必要时重启 Apps 页面查看效果。" buttons {"OK"} default button "OK"
		
	else if actionName is "恢复列表里的所有 App" then
		do shell script "
LSREGISTER='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
while IFS= read -r app; do
  [ -d \"$app\" ] && \"$LSREGISTER\" -f \"$app\" 2>/dev/null
done < ~/Library/Application\\ Support/HiddenAppsManager/hidden_apps.txt
"
		display dialog "已恢复列表里的 App 注册。" buttons {"OK"} default button "OK"
		
	else if actionName is "查看隐藏列表" then
		set appList to do shell script "cat ~/Library/Application\\ Support/HiddenAppsManager/hidden_apps.txt"
		if appList is "" then set appList to "当前列表为空。"
		display dialog appList buttons {"OK"} default button "OK"
	end if
end run
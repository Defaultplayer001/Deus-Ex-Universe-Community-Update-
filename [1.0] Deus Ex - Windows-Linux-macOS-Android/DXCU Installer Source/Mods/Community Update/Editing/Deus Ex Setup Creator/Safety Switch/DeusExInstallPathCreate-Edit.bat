set InstallPath=C:\Program Files (x86)\Steam\steamapps\common\Deus Ex

reg add "HKLM\SOFTWARE\WOW6432Node\Unreal Technology\Installed Apps\Deus Ex" /v Folder /d "%InstallPath%"

reg add "HKLM\SOFTWARE\Unreal Technology\Installed Apps\Deus Ex" /v Folder /d "%InstallPath%"

reg add "HKLM\SOFTWARE\WOW6432Node\Unreal Technology\Installed Apps\Deus Ex" /v Version /d 1112fm

reg add "HKLM\SOFTWARE\Unreal Technology\Installed Apps\Deus Ex" /v Version /d 1112fm

pause
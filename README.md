# Rime XKJD

My user configs backup for [Rime XKJD](https://xkinput.gitee.io/)

## Install

- Download the latest [Rime for Windows](https://github.com/rime/weasel/releases/latest)

- Install Rime in the default directory

- Download the latest Rime XKJD ([GitHub](https://github.com/xkinput/Rime_JD) | [Gitee](https://gitee.com/xkinput/Rime_JD))

- Install Rime XKJD in the default directory (the same directory as Rime), but unzip the installation tools in `D:\Rime XKJD`

- Right-click the input method icon at the bottom-right of the screen and hit `Exit Rime`

- Replace all default configs in `C:\Users\%USERNAME%\AppData\Roaming\Rime` with the user configs in this repo (including the hidden git folder, so all future modifications can be managed by git)

- Copy the theme preview file (`color_scheme_sphs.png`) from `C:\Users\%USERNAME%\AppData\Roaming\Rime\preview` to `C:\Program Files (x86)\Rime\weasel-<latest version>\data\preview`

- After an OS restart, activate the input method (add Rime in `Start -> Settings -> Time & Language -> Language (Chinese)` if it's not added automatically during the installation)

- Right-click the input method icon at the bottom-right of the screen and hit `Redeploy`

## Update

- To update Rime: right-click the input method icon at the bottom-right of the screen and hit `Check for updates`

- To update Rime XKJD dictionaries: go to the installation tools folder and run the update script (`D:\Rime XKJD\Rime_JD\Tools\SystemTools\WindowsTools\update.bat`)

- If user configs are lost after the update, just restore them by replacing all default configs in `C:\Users\%USERNAME%\AppData\Roaming\Rime` with the user configs in this repo again (including the hidden git folder, so all future modifications can be managed by git)

- Right-click the input method icon at the bottom-right of the screen and hit `Redeploy`

- Right-click the input method icon at the bottom-right of the screen and hit `Sync user data`

## Uninstall

- Uninstall Rime using the Windows `Programs and Features`, followed by an OS restart

- Delete the folder in `C:\Program Files (x86)\Rime`

- Delete the installation tools in `D:\Rime XKJD`

- Delete the user configs in `C:\Users\%USERNAME%\AppData\Roaming\Rime`

- Clean the registry and any residue if needed

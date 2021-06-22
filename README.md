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

- Update Rime: right-click the input method icon at the bottom-right of the screen and hit `Check for updates`

- [All your user configs will be lost after the Rime XKJD update] Backup your git configs in the hidden folder (`C:\Users\%USERNAME%\AppData\Roaming\Rime\.git`)

- Update Rime XKJD: go to the installation tools folder and run the update script (`D:\Rime XKJD\Rime_JD\Tools\SystemTools\WindowsTools\update.bat`), or just re-intialise everything using the start script (`D:\Rime XKJD\start.bat`)

- Right-click the input method icon at the bottom-right of the screen and hit `Quit`, so the Rime service is shut down before restoring your customisation

- Revert git configs in the hidden folder to the ones pointing to this repo (so you can see what's been changed after the update)

- Review all changes carefully to ensure your customisaion is restored while updates on Rime XKJD (input methods and dictionaries) remain effective

- Restart your OS to bring back the Rime service

- Right-click the input method icon at the bottom-right of the screen and hit `Redeploy`

- Right-click the input method icon at the bottom-right of the screen and hit `Sync user data`

## Uninstall

- Uninstall Rime using the Windows `Programs and Features`, followed by an OS restart

- Delete the folder in `C:\Program Files (x86)\Rime`

- Delete the installation tools in `D:\Rime XKJD`

- Delete the user configs in `C:\Users\%USERNAME%\AppData\Roaming\Rime`

- Clean the registry and any residue if needed

#************************************ Definitions *********************************************************#
!define PRODUCT_NAME "Code Orchestra 2.0 Beta"
!define PRODUCT_VERSION "$build$"
!define PRODUCT_MAJOR_VERSION "$version$"
!define PRODUCT_PUBLISHER "Code Orchestra"
!define PRODUCT_WEB_SITE "http://www.codeorchestra.com/"
!define APP_NAME "Code Orchestra $version$"

#************************************ Registry ************************************************************#
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

#************************************ Shortcuts ***********************************************************#
!define MAIN_MENU_FOLDER "$SMPROGRAMS\${PRODUCT_PUBLISHER}"
!define PROGRAM_LINK "${MAIN_MENU_FOLDER}\${APP_NAME}.lnk"
!define WEB_SITE_LINK "${MAIN_MENU_FOLDER}\${PRODUCT_NAME} Home Page.lnk"
!define UNINSTALL_LINK "${MAIN_MENU_FOLDER}\Uninstall ${APP_NAME}.lnk"
!define DESKTOP_LINK "$DESKTOP\${APP_NAME}.lnk"
!define QL_LINK "$QUICKLAUNCH\${APP_NAME}.lnk"
!define LAUNCHER_BAT "codeorchestra.bat"

#************************************ Include Headers *****************************************************#
!include MUI.nsh

#************************************ Installation Properties *********************************************#
Name "${APP_NAME}"
OutFile "${PRODUCT_NAME}-win.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
ShowInstDetails show
ShowUnInstDetails show
!define MUI_WELCOMEPAGE_TITLE "Welcome to the ${PRODUCT_NAME} setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of ${APP_NAME}.\n\nClick Next to continue."
!define MUI_ICON "installer.ico"
!define MUI_UNICON "uninstaller.ico"
!define MUI_COMPONENTSPAGE_NODESC

#************************************ Install *************************************************************#
; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "license.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Components Page
!insertmacro MUI_PAGE_COMPONENTS
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH
; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES
; Language files
!insertmacro MUI_LANGUAGE "English"

Section "Main Application" secMain
    SectionIn RO
    SetOutPath '$INSTDIR'
    !include install.nsh
    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Start Menu Folder" setStartMenuFolder
    SetOutPath $INSTDIR
    CreateDirectory "${MAIN_MENU_FOLDER}"
    CreateShortCut "${PROGRAM_LINK}" "$INSTDIR\${LAUNCHER_BAT}" "" "$INSTDIR\application.ico" "" SW_SHOWMINIMIZED
    WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
    CreateShortCut "${WEB_SITE_LINK}" "$INSTDIR\${PRODUCT_NAME}.url" "" "$INSTDIR\homepage.ico"
    CreateShortCut "${UNINSTALL_LINK}" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Desktop Shortcut" secDesktop
    CreateShortCut "${DESKTOP_LINK}" "$INSTDIR\${LAUNCHER_BAT}" "" "$INSTDIR\application.ico" "" SW_SHOWMINIMIZED
SectionEnd

Section "Quick Launch Shortcut" secQuickLaunch
    CreateShortCut "${QL_LINK}" "$INSTDIR\${LAUNCHER_BAT}" "" "$INSTDIR\application.ico" "" SW_SHOWMINIMIZED
SectionEnd

Section -Post
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${APP_NAME}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function .onInit
  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
  "UninstallString"
  StrCmp $R0 "" done
 
  MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
  "${PRODUCT_NAME} is already installed. $\n$\nClick `OK` to remove the \
  previous version or `Cancel` to cancel this upgrade." \
  IDOK uninst
  Abort
 
;Run the uninstaller
uninst:
  ClearErrors
  ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
 
  IfErrors no_remove_uninstaller done
    ;You can either use Delete /REBOOTOK in the uninstaller or add some code
    ;here to remove the uninstaller. Use a registry key to check
    ;whether the user has chosen to uninstall. If you are using an uninstaller
    ;components page, make sure all sections are uninstalled.
  no_remove_uninstaller:
 
done:
FunctionEnd

Function .onInstSuccess
FunctionEnd

#************************************ Uninstall ***********************************************************#
Function UN.onUninstSuccess
    HideWindow
    MessageBox MB_ICONINFORMATION|MB_OK "${APP_NAME} was successfully uninstalled."
FunctionEnd

Section -UN.Install
    SectionIn RO
    Delete "$INSTDIR\${PRODUCT_NAME}.url"
    Delete "${PROGRAM_LINK}"
    Delete "${WEB_SITE_LINK}"
    Delete "${UNINSTALL_LINK}"
    RmDir  "${MAIN_MENU_FOLDER}"
    Delete "${QL_LINK}"
    Delete "${DESKTOP_LINK}"
    ; delete Uninstaller
    Delete "$INSTDIR\Uninstall.exe"
    !include uninstall.nsh
    RmDir "$INSTDIR"
    DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
SectionEnd

Function UN.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to uninstall ${APP_NAME}?" IDYES +2
    Abort
FunctionEnd
    
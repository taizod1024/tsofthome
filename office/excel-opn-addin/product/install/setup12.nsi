;--------------------------------
; Modern UI�̃C���N���[�h

  !include "MUI2.nsh"

;--------------------------------
; ��ʓI�Ȑݒ�

  ; �萔
  !define PRODUCT_GROUP "tsoft"
  !define PRODUCT_AUTHOR "YAMAMOTO TAIZO"

  !define MUI_PRODUCT "${PRODUCT_NAME} ${PRODUCT_VERSION}"

  !define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP_NOSTRETCH

  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\win-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\win-uninstall.ico"

  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE

  !define MUI_ABORTWARNING

  !define ERROR_MESSAGE0 "�Z�b�g�A�b�v�𒆒f���܂����B"
  !define ERROR_MESSAGE1 "�Z�b�g�A�b�v�𒆒f���܂����B�t�@�C���̃R�s�[�Ɏ��s���܂����B�C���X�g�[���̏I����A�蓮�ŃG���[���������Ă��������B"
  !define ERROR_MESSAGE2 "�Z�b�g�A�b�v�𒆒f���܂����B�C���X�g�[���͐������܂������A�A�h�C���̗L�����Ɏ��s���܂����B�C���X�g�[���̏I����A�蓮�ŃA�h�C����L���ɂ��Ă��������B"
  !define ERROR_MESSAGE3 "�A�h�C���̖������Ɏ��s���܂������A�A���C���X�g�[���͌p�����܂��B�A���C���X�g�[���̏I����A�蓮�ŃA�h�C���𖳌��ɂ��Ă��������B"

  ; �A�v���P�[�V������
  Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"

  ; �C���X�g�[���t�@�C����
  OutFile "${PRODUCT}"

  ; �C���X�g�[���f�B���N�g��
  InstallDir "$LOCALAPPDATA\${PRODUCT_GROUP}\${PRODUCT_NAME}"

  ; �v�����s���x��
  RequestExecutionLevel user

  ; �u�����h
  BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION}"

  ; �X�^�[�g���j���[�p�̐ݒ�
  !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${PRODUCT_GROUP}"

;--------------------------------
; �y�[�W

  !define MUI_WELCOMEPAGE_TEXT "$_CLICK"
  !define MUI_FINISHPAGE_TEXT "�E�B�U�[�h�����ɂ�[����]�������Ă��������B"
  !define MUI_FINISHPAGE_NOAUTOCLOSE

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !define MUI_WELCOMEPAGE_TEXT "$_CLICK"
  !define MUI_FINISHPAGE_TEXT "�E�B�U�[�h�����ɂ�[����]�������Ă��������B"
  !define MUI_UNFINISHPAGE_NOAUTOCLOSE

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; ���{��

  !insertmacro MUI_LANGUAGE "Japanese"

  VIAddVersionKey /LANG=${LANG_JAPANESE} "ProductName" "${PRODUCT_GROUP} ${PRODUCT_NAME}"
  VIAddVersionKey /LANG=${LANG_JAPANESE} "Comments" ""
  VIAddVersionKey /LANG=${LANG_JAPANESE} "CompanyName" ""
  VIAddVersionKey /LANG=${LANG_JAPANESE} "LegalTrademarks" ""
  VIAddVersionKey /LANG=${LANG_JAPANESE} "LegalCopyright" "${PRODUCT_AUTHOR}"
  VIAddVersionKey /LANG=${LANG_JAPANESE} "FileDescription" "${PRODUCT_GROUP} ${PRODUCT_NAME}"
  VIAddVersionKey /LANG=${LANG_JAPANESE} "FileVersion" "${PRODUCT_VERSION}"
  VIProductVersion "${PRODUCT_VERSION}"

;--------------------------------
; �ϐ�

  Var ReturnCode
  Var AppName

;--------------------------------
; �C���X�g�[���Z�N�V����

Section "Install"

  ; �A�v���P�[�V�����̊m�F
  DetailPrint "### �A�v���P�[�V�����̊m�F"
  SetOutPath "$TEMP"
  File "..\src\check_object12.vbs"
  StrCpy $AppName "Excel.Application"
  ExecWait 'wscript.exe "$TEMP\check_object12.vbs" $AppName' $ReturnCode
  StrCmp $ReturnCode "0" CHKAPP_OK CHKAPP_NG
  CHKAPP_NG:
    DetailPrint "����: �A�v���P�[�V�����̊m�F�Ɏ��s���܂����B"
    MessageBox MB_ICONSTOP "�Z�b�g�A�b�v�𒆒f���܂����B$\r$\n�A�v���P�[�V�����̊m�F�Ɏ��s���܂����B$\r$\n�ȉ��̃A�v���P�[�V�������C���X�g�[������Ă��邱�Ƃ��m�F���Ă��������B$\r$\n$\r$\n�A�v���P�[�V����: $AppName"
    Abort ${ERROR_MESSAGE0}
  CHKAPP_OK:
  DetailPrint "����: �A�v���P�[�V�����̊m�F�ɐ������܂����B"

  ; �t�@�C���̓W�J
  DetailPrint "### �t�@�C���̓W�J"
  SetOutPath "$INSTDIR"
  File /r /x .svn "..\src\*.*"
  IfErrors FILECOPY1_NG FILECOPY1_OK
  FILECOPY1_NG:
    MessageBox MB_ICONSTOP ${ERROR_MESSAGE1}
    Abort ${ERROR_MESSAGE0}
  FILECOPY1_OK:

  ; �A�h�C���t�@�C���̃R�s�[
  DetailPrint "### �A�h�C���t�@�C���̃R�s�["
  CopyFiles "$INSTDIR\${PRODUCT_SYMBOL}.xlam" "$APPDATA\Microsoft\AddIns\"
  IfErrors FILECOPY2_NG FILECOPY2_OK
  FILECOPY2_NG:
    MessageBox MB_ICONSTOP ${ERROR_MESSAGE1}
    Abort ${ERROR_MESSAGE0}
  FILECOPY2_OK:

  ; �A���C���X�g�[���̓o�^
  DetailPrint "### �A���C���X�g�[���̓o�^"
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_GROUP} ${PRODUCT_NAME} ${PRODUCT_VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Helplink" "$INSTDIR\readme.txt"
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoModify" 1
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoRepair" 1
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "${PRODUCT_GROUP}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"

  ; �X�^�[�g���j���[�ւ̓o�^
  DetailPrint "### �X�^�[�g���j���[�ւ̓o�^"
  CreateDirectory	"$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}"
  CreateShortCut	"$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�A���C���X�g�[��.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut	"$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�͂��߂ɂ��ǂ݂�������.lnk" "$INSTDIR\readme.txt" "" "$SYSDIR\shell32.dll" 70

  ; �A�h�C���̗L����
  DetailPrint "### �A�h�C���̗L����"
  ExecWait 'wscript.exe "$INSTDIR\addin_enable12.vbs" ${PRODUCT_SYMBOL} /i' $ReturnCode
  strcmp $ReturnCode "0" ADDINENABLE_OK ADDINENABLE_NG
  ADDINENABLE_OK:
    DetailPrint "����: �A�h�C����L�������܂����B"
    goto ADDINENABLE
  ADDINENABLE_NG:
    DetailPrint "����: �A�h�C���̗L�����Ɏ��s���܂����B"
    MessageBox MB_ICONINFORMATION ${ERROR_MESSAGE2}
  ADDINENABLE:

SectionEnd

;--------------------------------
; �A���C���X�g�[���Z�N�V����
; �E�A���C���X�g�[���Z�N�V�����ł�$INSTDIR�́A"WriteUninstaller"�����f�B���N�g���ɂȂ邱�Ƃɒ��ӁB

Section "Uninstall"

  ; �A�h�C���̖�����
  DetailPrint "### �A�h�C���̖�����"
  ExecWait 'wscript.exe "$INSTDIR\addin_disable.vbs" ${PRODUCT_SYMBOL} /i' $ReturnCode
  strcmp $ReturnCode "0" ADDINDISABLE_OK ADDINDISABLE_NG
  ADDINDISABLE_OK:
    DetailPrint "����: �A�h�C���𖳌������܂����B"
    goto ADDINDISABLE
  ADDINDISABLE_NG:
    DetailPrint "����: �A�h�C���̖������Ɏ��s���܂����B"
    MessageBox MB_ICONINFORMATION ${ERROR_MESSAGE3}
    DetailPrint "����: �A���C���X�g�[�����p�����܂��B"
    goto ADDINDISABLE
  ADDINDISABLE:

  ; �t�@�C���̍폜
  DetailPrint "### �t�@�C���̍폜"
  Delete /REBOOTOK "$INSTDIR\readme.txt"
  Delete /REBOOTOK "$INSTDIR\addin_disable.vbs"
  Delete /REBOOTOK "$INSTDIR\addin_enable12.vbs"
  Delete /REBOOTOK "$INSTDIR\${PRODUCT_SYMBOL}.xlam"

  ; �A�h�C���t�@�C���̍폜
  DetailPrint "### �A�h�C���t�@�C���̍폜"
  Delete /REBOOTOK "$APPDATA\Microsoft\AddIns\${PRODUCT_SYMBOL}.xlam"
  
  ; �A���C���X�g�[���̍폜
  DetailPrint "### �A���C���X�g�[���̍폜"
  Delete /REBOOTOK "$INSTDIR\uninstall.exe"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

  ; �X�^�[�g���j���[�̍폜
  DetailPrint "### �X�^�[�g���j���[�̍폜"
  RMDir /r "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}"
  RMDir "$SMPROGRAMS\${PRODUCT_GROUP}"

  ; �C���X�g�[���t�H���_�̍폜
  DetailPrint "### �C���X�g�[���t�H���_�̍폜"
  RMDir /r /REBOOTOK "$INSTDIR"
  
SectionEnd

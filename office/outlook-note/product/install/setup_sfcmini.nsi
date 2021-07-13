;--------------------------------
; Modern UI�̃C���N���[�h

  !include "MUI2.nsh"
  !include "Library.nsh"

;--------------------------------
; ��ʓI�Ȑݒ�

  ; �萔
  !define PRODUCT_GROUP "tsoft"

  !define MUI_PRODUCT "${PRODUCT_NAME} ${PRODUCT_VERSION}"
  
  !define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP_NOSTRETCH

  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\win-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\win-uninstall.ico"

  !define MUI_ABORTWARNING

  ; �A�v���P�[�V������
  Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"

  ; �C���X�g�[���t�@�C����
  OutFile "${PRODUCT}"

  ; �C���X�g�[���f�B���N�g��
  InstallDir "$COMMONFILES\${PRODUCT_GROUP}\${PRODUCT_NAME}"

  ; �v�����s���x��
  RequestExecutionLevel admin

  ; �u�����h
  BrandingText "${PRODUCT_NAME}"

  ; �e��萔
  !define SUB_KEY "SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls"
  !define DLL_PATH "$COMMONFILES\${PRODUCT_GROUP}\${PRODUCT_NAME}\${PRODUCT_NAME}.dll"
  
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

;--------------------------------
; �ϐ�

  Var RegCnt0
  Var RegCnt1
  
;--------------------------------
; �C���X�g�[���Z�N�V����

Section "Install"

  SetOutPath "$INSTDIR"
  File "${PRODUCT_NAME}.dll"
  WriteUninstaller "uninstall.exe"

  ReadRegStr $RegCnt0 HKLM "${SUB_KEY}" "${DLL_PATH}"
  !insertmacro InstallLib REGDLL "" REBOOT_NOTPROTECTED "${PRODUCT_NAME}.dll" "${DLL_PATH}" $TEMP
  ReadRegStr $RegCnt1 HKLM "${SUB_KEY}" "${DLL_PATH}"
  
  DetailPrint "�Q�ƃJ�E���g: '$RegCnt0' -> '$RegCnt1'"
  
SectionEnd

;--------------------------------
; �A���C���X�g�[���Z�N�V����

Section "Uninstall"

  ReadRegStr $RegCnt0 HKLM "${SUB_KEY}" "${DLL_PATH}"
  !insertmacro UninstallLib REGDLL SHARED REBOOT_NOTPROTECTED "${DLL_PATH}"
  ReadRegStr $RegCnt1 HKLM "${SUB_KEY}" "${DLL_PATH}"

  DetailPrint "�Q�ƃJ�E���g: '$RegCnt0' -> '$RegCnt1'"

  StrCmp "$RegCnt1" "" DLL_NONE DLL_EXISTS
  DLL_NONE:
    RMDir /r /REBOOTOK "$INSTDIR"
	RmDir "$COMMONFILES\${PRODUCT_GROUP}"
  DLL_EXISTS:

SectionEnd

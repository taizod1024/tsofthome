;--------------------------------
; Modern UI�̃C���N���[�h

  !include "MUI2.nsh"

;--------------------------------
; ��ʓI�Ȑݒ�

  ; �萔
  ; - �S�p�́u�`�v��make�ŃG���[�ɂȂ邽�߃V���{�����Ē�`���Ă���B
  !undef PRODUCT_NAME
  !define PRODUCT_NAME "Ngen���[�e�B���e�B"

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

  ; �A�v���P�[�V������
  Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"

  ; �C���X�g�[���t�@�C����
  OutFile "${PRODUCT}"

  ; �C���X�g�[���f�B���N�g��
  InstallDir "$LOCALAPPDATA\${PRODUCT_GROUP}\${PRODUCT_NAME}"

  ; �v�����s���x��
  RequestExecutionLevel admin

  ; �u�����h
  BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION}"

  ; �X�^�[�g���j���[�p�̐ݒ�
  !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${PRODUCT_GROUP}"

  ; �X�^�[�g���j���[�p�̐ݒ�
  SetFont "MS UI Gothic" 9

;--------------------------------
; �y�[�W

  !define MUI_WELCOMEPAGE_TEXT "$_CLICK"
  !define MUI_FINISHPAGE_TEXT "�E�B�U�[�h�����ɂ�[����]�������Ă��������B"

  !define MUI_FINISHPAGE_NOAUTOCLOSE
  !define MUI_FINISHPAGE_RUN "$INSTDIR\ngenutil.exe"
  !define MUI_FINISHPAGE_RUN_PARAMETERS "$\"$INSTDIR\ngenutil.exe$\""
  !define MUI_FINISHPAGE_RUN_TEXT "Ngen���[�e�B���e�B�̃l�C�e�B�u�C���[�W�𐶐�����B"

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

  ;;; Var ReturnCode

;--------------------------------
; �C���X�g�[���Z�N�V����

Section "Install"

  ; �t�@�C���̓W�J
  DetailPrint "### �t�@�C���̓W�J"
  SetOutPath "$INSTDIR"
  File /r /x .svn "..\src\readme.txt"
  File /r /x .svn "..\src\ngenutil\ngenutil\bin\Release\ngenutil.exe"
  IfErrors FILECOPY1_NG FILECOPY1_OK
  FILECOPY1_NG:
    MessageBox MB_ICONSTOP ${ERROR_MESSAGE1}
    Abort ${ERROR_MESSAGE0}
  FILECOPY1_OK:

  ; �G�N�X�v���[���̓���̓o�^
  WriteRegStr HKCU "Software\Classes\Directory\shell\${PRODUCT_NAME}" "" "${PRODUCT_NAME}(&G) ..."
  WriteRegStr HKCU "Software\Classes\Directory\shell\${PRODUCT_NAME}\command" "" "$INSTDIR\ngenutil.exe %1"
  WriteRegStr HKCU "Software\Classes\Directory\Background\shell\${PRODUCT_NAME}" "" "${PRODUCT_NAME}(&G) ..."
  WriteRegStr HKCU "Software\Classes\Directory\Background\shell\${PRODUCT_NAME}\command" "" "$INSTDIR\ngenutil.exe %V"

  ; �G�N�X�v���[����[����]�̓o�^
  CreateShortCut "$SENDTO\${PRODUCT_NAME}.lnk" "$INSTDIR\ngenutil.exe"
 
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
  CreateDirectory "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�A���C���X�g�[��.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�͂��߂ɂ��ǂ݂�������.lnk" "$INSTDIR\readme.txt" "" "$SYSDIR\shell32.dll" 70

SectionEnd

;--------------------------------
; �A���C���X�g�[���Z�N�V����
; �E�A���C���X�g�[���Z�N�V�����ł�$INSTDIR�́A"WriteUninstaller"�����f�B���N�g���ɂȂ邱�Ƃɒ��ӁB

Section "Uninstall"

  ; �t�@�C���̍폜
  DetailPrint "### �t�@�C���̍폜"
  Delete /REBOOTOK "$INSTDIR\readme.txt"
  Delete /REBOOTOK "$INSTDIR\ngenutil.exe"

  ; �G�N�X�v���[���̓���̍폜
  DeleteRegKey HKCU "Software\Classes\Directory\shell\${PRODUCT_NAME}"
  DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\${PRODUCT_NAME}"

  ; �G�N�X�v���[����[����]�̍폜
  Delete /REBOOTOK "$SENDTO\${PRODUCT_NAME}.lnk"
 
  ; �A���C���X�g�[���̍폜
  DetailPrint "### �A���C���X�g�[���̍폜"
  Delete /REBOOTOK "$INSTDIR\uninstall.exe"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

  ; �X�^�[�g���j���[����̍폜
  DetailPrint "### �X�^�[�g���j���[����̍폜"
  RMDir /r "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}"
  RMDir "$SMPROGRAMS\${PRODUCT_GROUP}"

  ; �f�X�N�g�b�v����̍폜
  DetailPrint "### �f�X�N�g�b�v����̍폜"
  Delete /REBOOTOK "$DESKTOP\${PRODUCT_NAME}.lnk"

  ; �C���X�g�[���t�H���_�̍폜
  DetailPrint "### �C���X�g�[���t�H���_�̍폜"
  RMDir /r /REBOOTOK "$INSTDIR"
  
SectionEnd

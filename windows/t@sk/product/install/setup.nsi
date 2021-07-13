;--------------------------------
; Modern UI�̃C���N���[�h

  !include "MUI2.nsh"
  !include "EnvVarUpdate.nsh"

;--------------------------------
; ��ʓI�Ȑݒ�

  ; �萔
  ; - �S�p�́u�`�v��make�ŃG���[�ɂȂ邽�߃V���{�����Ē�`���Ă���B
  !undef PRODUCT_NAME
  !define PRODUCT_NAME "�o�b�`�t�@�C�����[�e�B���e�B"

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

  ; �X�^�[�g���j���[�p�̐ݒ�
  SetFont "MS UI Gothic" 9

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

;--------------------------------
; �C���X�g�[���Z�N�V����

Section "Install"

  ; �t�@�C���̓W�J
  DetailPrint "### �t�@�C���̓W�J"
  SetOutPath "$INSTDIR"
  File /r /x .svn "..\doc\readme.txt"

  SetOutPath "$INSTDIR\sh"
  File /r /x .svn "..\src\t@sk.cmd"

  ; �C���X�g�[���f�B���N�g���̒Z�����O���擾
  GetFullPathName /SHORT $0 $INSTDIR\sh

  ; �G�N�X�v���[���̓���̓o�^
  DetailPrint "### �G�N�X�v���[���̓���̓o�^"
  WriteRegStr HKCU "Software\Classes\.t@sk\shell\${PRODUCT_NAME}" "" "�^�X�N�����s����(&T)"
  WriteRegStr HKCU "Software\Classes\.t@sk\shell\${PRODUCT_NAME}\command" "" 'cmd.exe /C $0\t@sk.cmd /p /f "%1" %*'

  ; ���ϐ�PATH�ւ̓o�^
  DetailPrint "### ���ϐ�PATH�ւ̒ǉ�"
  ${EnvVarUpdate} $1 "PATH" "A" "HKCU" $0

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
  CreateShortCut "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�C���X�g�[���t�H���_.lnk" "$INSTDIR"
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
  Delete /REBOOTOK "$INSTDIR\sh\t@sk.cmd"

  ; �G�N�X�v���[���̓���̍폜
  DetailPrint "### �G�N�X�v���[���̓���̍폜"
  DeleteRegKey HKCU "Software\Classes\.t@sk\shell\${PRODUCT_NAME}"

  ; �C���X�g�[���f�B���N�g���̒Z�����O���擾
  GetFullPathName /SHORT $0 $INSTDIR\sh

  ; ���ϐ�PATH����̍폜
  DetailPrint "### ���ϐ�PATH����̍폜"
  ${un.EnvVarUpdate} $1 "PATH" "R" "HKCU" $0

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

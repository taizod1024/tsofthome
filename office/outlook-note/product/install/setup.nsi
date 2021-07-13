;--------------------------------
; Modern UI�̃C���N���[�h

  !include "MUI2.nsh"
  !include "Library.nsh"

;--------------------------------
; ��ʓI�Ȑݒ�

  ; �萔
  !define PRODUCT_GROUP "tsoft"
  !define PRODUCT_AUTHOR "YAMAMOTO TAIZO"

  !define PRODUCT_BASE_FILE "tsoft-sfcmini-${PRODUCT_VERSION}.exe"

  !define MUI_PRODUCT "${PRODUCT_NAME} ${PRODUCT_VERSION}"

  !define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP_NOSTRETCH

  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\win-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\win-uninstall.ico"

  !define MUI_ABORTWARNING

  !define ERROR_MESSAGE0 "�Z�b�g�A�b�v�𒆒f���܂����B"
  !define ERROR_MESSAGE1 "�Z�b�g�A�b�v�𒆒f���܂����B�t�@�C���̃R�s�[�Ɏ��s���܂����B�C���X�g�[���̏I����A�蓮�ŃG���[���������Ă��������B"

  !define DLL_UNINSTALLER "$COMMONFILES\${PRODUCT_GROUP}\sfcmini\uninstall.exe"
  
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
  Var AlreadyInstalled

;--------------------------------
; �C���X�g�[���Z�N�V����

Section "Install"

  ; �A�v���P�[�V�����̊m�F
  DetailPrint "### �A�v���P�[�V�����̊m�F"
  SetOutPath "$TEMP"
  File "..\src\check_object.vbs"
  StrCpy $AppName "Outlook.Application"
  ExecWait 'wscript.exe "$TEMP\check_object.vbs" $AppName' $ReturnCode
  StrCmp $ReturnCode "0" CHKAPP_OK CHKAPP_NG
  CHKAPP_NG:
    DetailPrint "����: �A�v���P�[�V�����̊m�F�Ɏ��s���܂����B"
    MessageBox MB_ICONSTOP "�Z�b�g�A�b�v�𒆒f���܂����B$\r$\n�A�v���P�[�V�����̊m�F�Ɏ��s���܂����B$\r$\n�ȉ��̃A�v���P�[�V�������C���X�g�[������Ă��邱�Ƃ��m�F���Ă��������B$\r$\n$\r$\n�A�v���P�[�V����: $AppName"
    Abort ${ERROR_MESSAGE0}
  CHKAPP_OK:
  DetailPrint "����: �A�v���P�[�V�����̊m�F�ɐ������܂����B"

  ; �t�@�C���̓W�J
  ; �E��ɋ��L���C�u�����̓o�^�����Ă��܂���File�ŃG���[������
  DetailPrint "### �t�@�C���̓W�J"
  SetOutPath "$INSTDIR"
  File /r /x .svn "..\src\*.*"
  IfErrors FILECOPY1_NG FILECOPY1_OK
  FILECOPY1_NG:
    MessageBox MB_ICONSTOP ${ERROR_MESSAGE1}
    Abort ${ERROR_MESSAGE0}
  FILECOPY1_OK:

  ; ���L���C�u�����̓o�^
  DetailPrint "### sfcmini.dll�̓o�^"
  ReadRegStr $AlreadyInstalled HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon"
  StrCmp "$AlreadyInstalled" "" REGDLL_BGN0 REGDLL_BGN1
  REGDLL_BGN0:
    SetOutPath "$TEMP"
    File "${PRODUCT_BASE_FILE}"
    ExecWait 'cmd /c "$TEMP\${PRODUCT_BASE_FILE}" /S' $ReturnCode
    DetailPrint "�߂�l: '$ReturnCode'"
    StrCmp $ReturnCode "0" REGDLL_OK REGDLL_NG
    REGDLL_NG:
      DetailPrint "����: ���L���C�u�����̓o�^�Ɏ��s���܂����B"
      MessageBox MB_ICONSTOP "�Z�b�g�A�b�v�𒆒f���܂����B$\r$\n���L���C�u�����̓o�^�Ɏ��s���܂����B"
      Abort ${ERROR_MESSAGE0}
    REGDLL_OK:
    DetailPrint "����: ���L���C�u������o�^���܂����B"
	GoTo REGDLL_END
  REGDLL_BGN1:
    DetailPrint "����: ���L���C�u�����̓o�^���X�L�b�v���܂��B"
	GoTo REGDLL_END
  REGDLL_END:
 
  ; �A���C���X�g�[���̓o�^
  DetailPrint "### �A���C���X�g�[���̓o�^"
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon"	"$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName"	"${PRODUCT_GROUP} ${PRODUCT_NAME} ${PRODUCT_VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayVersion"	"${PRODUCT_VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Helplink" "$INSTDIR\readme.txt"
  WriteRegDWORD	HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoModify"		1
  WriteRegDWORD	HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoRepair"		1
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher"		"${PRODUCT_GROUP}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString"	"$INSTDIR\uninstall.exe"

  ; �X�^�[�g���j���[�ւ̓o�^
  DetailPrint "### �X�^�[�g���j���[�ւ̓o�^"
  CreateDirectory       "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}"
  CreateShortCut        "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�A���C���X�g�[��.lnk"			"$INSTDIR\uninstall.exe"
  CreateShortCut        "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�V�����tⳎ�.lnk"				"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/new" "$INSTDIR\image\note-ajouter-icone-6022.ico" 0
  CreateShortCut        "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�N���b�v�{�[�h����tⳎ�.lnk"	"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/new /clipboard" "$INSTDIR\image\note-ajouter-icone-6022.ico" 0
  CreateShortCut        "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�tⳎ��̕\��.lnk"				"$INSTDIR\${PRODUCT_SYMBOL}.vbs" ""     "$INSTDIR\image\note-icone-7296.ico" 0
  CreateShortCut        "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\Outlook�����̊Ǘ�.lnk"		"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/outlook" "$SYSDIR\shell32.dll" 127
  CreateShortCut	    "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}\�͂��߂ɂ��ǂ݂�������.lnk"	"$INSTDIR\readme.txt" "" "$SYSDIR\shell32.dll" 70

  ; �X�^�[�g�A�b�v�ւ̓o�^
  DetailPrint "### �X�^�[�g�A�b�v�ւ̓o�^"
  CreateShortCut        "$SMSTARTUP\${PRODUCT_NAME}.lnk"	"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/display"	"$INSTDIR\image\note-icone-7296.ico" 0

  ; �f�X�N�g�b�v�ւ̓o�^
  DetailPrint "### �f�X�N�g�b�v�ւ̓o�^"
  CreateShortCut        "$DESKTOP\�V�����tⳎ�.lnk"				"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/new"				"$INSTDIR\image\note-ajouter-icone-6022.ico" 0
  CreateShortCut        "$DESKTOP\�N���b�v�{�[�h����tⳎ�.lnk"	"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/new /clipboard"	"$INSTDIR\image\note-ajouter-icone-6022.ico" 0
  CreateShortCut        "$DESKTOP\�tⳎ��̕\��.lnk"				"$INSTDIR\${PRODUCT_SYMBOL}.vbs" ""					"$INSTDIR\image\note-icone-7296.ico" 0

  ; �N�C�b�N�N���ւ̓o�^
  DetailPrint "### �N�C�b�N�N���ւ̓o�^"
  CreateShortCut        "$QUICKLAUNCH\�V�����tⳎ�.lnk"				"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/new"				"$INSTDIR\image\note-ajouter-icone-6022.ico" 0
  CreateShortCut        "$QUICKLAUNCH\�N���b�v�{�[�h����tⳎ�.lnk"	"$INSTDIR\${PRODUCT_SYMBOL}.vbs" "/new /clipboard"	"$INSTDIR\image\note-ajouter-icone-6022.ico" 0
  CreateShortCut        "$QUICKLAUNCH\�tⳎ��̕\��.lnk"				"$INSTDIR\${PRODUCT_SYMBOL}.vbs" ""					"$INSTDIR\image\note-icone-7296.ico" 0

SectionEnd

;--------------------------------
; �A���C���X�g�[���Z�N�V����
; �E�A���C���X�g�[���Z�N�V�����ł�$INSTDIR�́A"WriteUninstaller"�����f�B���N�g���ɂȂ邱�Ƃɒ��ӁB

Section "Uninstall"

  ; �A���C���X�g�[���̍폜
  DetailPrint "### �A���C���X�g�[���̍폜"
  Delete /REBOOTOK "$INSTDIR\uninstall.exe"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

  ; �X�^�[�g���j���[����̍폜
  DetailPrint "### �X�^�[�g���j���[����̍폜"
  RMDir /r "$SMPROGRAMS\${PRODUCT_GROUP}\${PRODUCT_NAME}"
  RMDir "$SMPROGRAMS\${PRODUCT_GROUP}"

  ; �X�^�[�g�A�b�v����̍폜
  DetailPrint "### �X�^�[�g�A�b�v����̍폜"
  Delete /REBOOTOK "$SMSTARTUP\${PRODUCT_NAME}.lnk"

  ; �f�X�N�g�b�v����̍폜
  DetailPrint "### �f�X�N�g�b�v����̍폜"
  Delete /REBOOTOK "$DESKTOP\�V�����tⳎ�.lnk"
  Delete /REBOOTOK "$DESKTOP\�N���b�v�{�[�h����tⳎ�.lnk"
  Delete /REBOOTOK "$DESKTOP\�tⳎ��̕\��.lnk"

  ; �N�C�b�N�N������̍폜
  DetailPrint "### �f�X�N�g�b�v����̍폜"
  Delete /REBOOTOK "$QUICKLAUNCH\�V�����tⳎ�.lnk"
  Delete /REBOOTOK "$QUICKLAUNCH\�N���b�v�{�[�h����tⳎ�.lnk"
  Delete /REBOOTOK "$QUICKLAUNCH\�tⳎ��̕\��.lnk"

  ; �C���X�g�[���t�H���_�̍폜
  DetailPrint "### �C���X�g�[���t�H���_�̍폜"
  RMDir /r /REBOOTOK "$INSTDIR"

  ; ���L���C�u�����̓o�^����
  DetailPrint "### sfcmini.dll�̓o�^����"
  ExecWait 'cmd /c "${DLL_UNINSTALLER}" /S' $ReturnCode
  DetailPrint "�߂�l: '$ReturnCode'"
  StrCmp $ReturnCode "0" UNREG_OK UNREG_NG
  UNREG_NG:
    DetailPrint "����: ���L���C�u�����̓o�^�����Ɏ��s���܂����B"
	GoTo UNREG_END
  UNREG_OK:
    DetailPrint "����: ���L���C�u������o�^�������܂����B"
	GoTo UNREG_END
  UNREG_END:

SectionEnd

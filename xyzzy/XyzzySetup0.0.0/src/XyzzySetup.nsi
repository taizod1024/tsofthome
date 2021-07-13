;;; -*- Mode: nsi; Package: editor -*-
;;;
;;; XyzzySetup.nsi --- xyzzy �z�z�p�b�P�[�W�����x��

;;; �w�b�_�Ǎ���
!include "MUI.nsh"
!include "XyzzySetup.nsh"
!include "XyzzyCustomA.nsh"

; �o�̓t�@�C��
OutFile "XyzzySetup.exe"

; �f�t�H���g�̃C���X�g�[���f�B���N�g��
InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"

; �C���X�g�[���f�B���N�g���̊i�[�惌�W�X�g��
InstallDirRegKey HKLM "Software\${MUI_SETUP}" ""

; �ڍו\��
ShowInstDetails show			; �ڍׂ�\������
ShowUninstDetails show			; �ڍׂ�\������

; STARTMENU�p���W�X�g���ݒ�
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${MUI_SETUP}" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

; �g�p����y�[�W��錾����
!define MUI_CUSTOMPAGECOMMANDS		; CUSTOM�y�[�W���g�p����
!define MUI_WELCOMEPAGE			; WELCOME�y�[�W���g�p����
!define MUI_DIRECTORYPAGE		; DIRECOTRY�y�[�W���g�p����
!define MUI_STARTMENUPAGE		; STARTMENU�y�[�W���g�p����
!define MUI_FINISHPAGE			; FINISH�y�[�W���g�p����

; MUI_CUSTOMPAGECOMMANDS��ݒ肵���̂ňȉ��̏��ԂŃy�[�W����ׂ�
!insertmacro MUI_PAGECOMMAND_WELCOME	; WELCOME�y�[�W
!insertmacro MUI_PAGECOMMAND_DIRECTORY	; DIRECOTRY�y�[�W
!insertmacro MUI_PAGECOMMAND_STARTMENU	; STARTMENU�y�[�W
Page custom SetCustomA			; CUSTOM�y�[�W
!insertmacro MUI_PAGECOMMAND_INSTFILES	; INSTFILES�y�[�W
!insertmacro MUI_PAGECOMMAND_FINISH	; FINISH�y�[�W

; �ȉ��̃I�v�V�����ō��
!define MUI_UNINSTALLER			; �A���C���X�g�[�������
!define MUI_UNCONFIRMPAGE		; �A���C���X�g�[���ł͊m�F����
!define MUI_STARTMENUPAGE_NODISABLE	; �V���[�g�J�b�g�̍쐬�͗}�~�ł��Ȃ�
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\html\00README.html"
!define MUI_FINISHPAGE_NOAUTOCLOSE	; FINISH�y�[�W�ɏ���ɑJ�ڂ��Ȃ�
!define MUI_FINISHPAGE_RUN "$INSTDIR\XyzzySetup\XyzzyHome.exe"

; �ȉ��̃��b�Z�[�W�ō��
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_WELCOME_INFO_TEXT "���̃E�B�U�[�h�́A${MUI_PRODUCT} �̃C���X�g�[�����K�C�h���Ă����܂��B\r\n\r\n!!! ����1 !!!\r\n${MUI_PRODUCT} �� ${MUI_PRODUCT_AUTHOR} �ɂ���č쐬���ꂽ�e�L�X�g�G�f�B�^�ł��B\r\n${MUI_SETUP} �� ${MUI_PRODUCT} �̓����̊ȈՉ���ڎw���āA${MUI_SETUP_AUTHOR} ���쐬�������̂ł��B�]���� ${MUI_SETUP} �Ɋւ��鎿��y�їv�]�́A���L���[���A�h���X���� ${MUI_SETUP_AUTHOR} �܂ŘA�����Ă��������B������ ${MUI_PRODUCT_AUTHOR} �ɘA�����Ă͂����܂���B\r\n\r\n�@�@cbf95600@pop02.odn.ne.jp\r\n\r\n!!! ����2 !!!\r\n${MUI_PRODUCT} �z�z�p�b�P�[�W�̓W�J�̂��߂�UNLHA32.DLL���g�p���Ă��܂��BUNLHA32.DLL���C���X�g�[�����Ă��������B\r\n\r\n"
!insertmacro MUI_LANGUAGEFILE_STRING MUI_INNERTEXT_DIRECTORY_TOP "${MUI_PRODUCT} ���ȉ��̃t�H���_�ɃC���X�g�[�����܂��B${MUI_SETUP} �̓T�u�t�H���_�ɃC���X�g�[������܂��B$\r$\n$\r$\n�قȂ����t�H���_�ɃC���X�g�[������ɂ́A[�Q��]�������āA�ʂ̃t�H���_��I�����Ă��������B"
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_FINISH_RUN "���[�U���ϐ� XYZZYHOME ��ݒ肷��"
!insertmacro MUI_LANGUAGE "Japanese"	; ���{��ō��

; Reserve����
ReserveFile "XyzzyCustomA.ini"
!insertmacro MUI_RESERVEFILE_WELCOMEFINISHPAGE
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

;;; ------------------------------------------------
;;; �C���X�g�[��
;;; ------------------------------------------------

;;; �N��������
Function .onInit
  ReadRegStr $R0 HKLM "Software\${MUI_SETUP}" ""
  StrCmp $R0 "" +4
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "${MUI_PRODUCT} �̃C���X�g�[����񂪑��݂��܂��B$\r$\n${MUI_PRODUCT} �z�z�p�b�P�[�W�̍X�V�̏ꍇ�ɂ́AXyzzyUpdate �ōs���Ă��������B$\r$\n����ł����s���܂����H" IDOK +3
      MessageBox MB_OK|MB_ICONSTOP "�C���X�g�[���𒆎~���܂����B"
      Quit
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "XyzzyCustomA.ini"
FunctionEnd

;;; �C���X�g�[��
Section "XyzzySetup.exe"

  ; ���̃Z�N�V�����̃T�C�Y
  AddSize 8000

  ; �z�z�p�b�P�[�W�̃C���X�g�[��
  Call InstallPackage

  ; XyzzyUpdate�̒ǉ�
  SetOutPath "$INSTDIR\XyzzySetup"
  File "XyzzyHome.exe"
  File "XyzzyUpdate.exe"

  ; ��芸�������W���[���𗎂Ƃ����̂ŏ�������
  WriteRegStr HKLM "Software\${MUI_SETUP}" "" $INSTDIR

  ; �X�^�[�g���j���[�ǉ�
  SetOutPath "$INSTDIR"
  !insertmacro MUI_STARTMENU_WRITE_BEGIN
    CreateDirectory	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}"
    CreateShortCut	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\README.lnk" "$INSTDIR\html\00README.html"
    CreateShortCut	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\xyzzy.lnk" "$INSTDIR\xyzzy.exe"
    CreateShortCut	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\xyzzycli.lnk" "$INSTDIR\xyzzycli.exe"
    CreateDirectory	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\XyzzySetup"
    CreateShortCut	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\xyzzySetup\xyzzy -q.lnk" "$INSTDIR\xyzzy.exe" "-q"
    CreateShortCut	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\XyzzySetup\XyzzyHome.lnk" "$INSTDIR\XyzzySetup\XyzzyHome.exe"
    CreateShortCut	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\XyzzySetup\XyzzyUpdate.lnk" "$INSTDIR\XyzzySetup\XyzzyUpdate.exe"
    CreateShortCut	"$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\XyzzySetup\XyzzyUninstall.lnk" "$INSTDIR\XyzzySetup\XyzzyUninstall.exe"
  !insertmacro MUI_STARTMENU_WRITE_END

  ; �A���C���X�g�[���ǉ�
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_SETUP}" "DisplayName" "${MUI_SETUP}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_SETUP}" "UninstallString" '"$INSTDIR\XyzzySetup\XyzzyUninstall.exe"'
  CreateDirectory "$INSTDIR\XyzzySetup"
  WriteUninstaller "$INSTDIR\XyzzySetup\XyzzyUninstall.exe"

SectionEnd

;;; ------------------------------------------------
;;; �A���C���X�g�[��
;;; ------------------------------------------------

;;; �N��������
Function un.onInit
  ReadRegStr $INSTDIR HKLM "Software\${MUI_SETUP}" ""
  StrCmp $INSTDIR "" 0 +3
    MessageBox MB_OK|MB_ICONSTOP "${MUI_PRODUCT} �̃C���X�g�[����񂪌�����܂���B$\r$\n${MUI_PRODUCT} �̃A���C���X�g�[���𒆎~���܂��B"
    Quit
FunctionEnd

;;; �A���C���X�g�[��
Section "Uninstall"

  ; .xyzzy �� siteinit.l �̑��݃`�F�b�N
  IfFileExists "$INSTDIR\.xyzzy" confirm
  IfFileExists "$INSTDIR\site-lisp\siteinit.l" confirm
  Goto fileok
  confirm:
  MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION ".xyzzy �܂��� siteinit.l �����݂��܂��B�폜���Ă���낵���ł����H" IDOK fileok
    MessageBox MB_OK|MB_ICONSTOP "�A���C���X�g�[���𒆎~���܂����B"
    Quit
  fileok:

  ; �A���C���X�g�[���폜
  Delete "$INSTDIR\XyzzySetup\XyzzyUninstall.exe"
  Delete "$INSTDIR\XyzzySetup\XyzzyUpdate.exe"
  Delete "$INSTDIR\XyzzySetup\XyzzyHome.exe"

  ; �X�^�[�g���j���[�폜
  ReadRegStr $R0 "${MUI_STARTMENUPAGE_REGISTRY_ROOT}" "${MUI_STARTMENUPAGE_REGISTRY_KEY}" "${MUI_STARTMENUPAGE_REGISTRY_VALUENAME}"
  StrCmp $R0 "" noshortcuts
    Delete "$SMPROGRAMS\$R0\XyzzySetup\XyzzyUninstall.lnk"
    Delete "$SMPROGRAMS\$R0\XyzzySetup\XyzzyUpdate.lnk"
    Delete "$SMPROGRAMS\$R0\XyzzySetup\XyzzyHome.lnk"
    Delete "$SMPROGRAMS\$R0\xyzzySetup\xyzzy -q.lnk"
    Delete "$SMPROGRAMS\$R0\XyzzySetup"
    RMDir "$SMPROGRAMS\$R0\XyzzySetup"
    Delete "$SMPROGRAMS\$R0\xyzzycli.lnk"
    Delete "$SMPROGRAMS\$R0\xyzzy.lnk"
    Delete "$SMPROGRAMS\$R0\README.lnk"
    RMDir "$SMPROGRAMS\$R0"
  noshortcuts:

  ; �C���X�g�[���f�B���N�g���폜
  RMDir /r $INSTDIR

  ; ���W�X�g���폜
  DeleteRegKey /ifempty HKLM "Software\${MUI_SETUP}"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_SETUP}"

  !insertmacro MUI_UNFINISHHEADER

SectionEnd


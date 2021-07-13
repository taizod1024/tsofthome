;;; -*- Mode: nsi; Package: editor -*-
;;;
;;; XyzzyUpdate.nsi --- xyzzy �z�z�p�b�P�[�W�X�V�x��

;;; �w�b�_�Ǎ���
!include "MUI.nsh"
!include "XyzzySetup.nsh"
!include "XyzzyCustomA.nsh"

; �o�̓t�@�C��
OutFile "XyzzyUpdate.exe"

; �ڍו\��
ShowInstDetails show			; �ڍׂ�\������

; �g�p����y�[�W��錾����
!define MUI_CUSTOMPAGECOMMANDS		; CUSTOM�y�[�W���g�p����
!define MUI_FINISHPAGE			; FINISH�y�[�W���g�p����

; MUI_CUSTOMPAGECOMMANDS��ݒ肵���̂ňȉ��̏��ԂŃy�[�W����ׂ�
Page custom SetCustomA			; CUSTOM�y�[�W
!insertmacro MUI_PAGECOMMAND_INSTFILES	; INSTFILES�y�[�W
!insertmacro MUI_PAGECOMMAND_FINISH	; FINISH�y�[�W

; �ȉ��̃I�v�V�����ō��
!define MUI_FINISHPAGE_NOAUTOCLOSE	; FINISH�y�[�W�ɏ���ɑJ�ڂ��Ȃ�

; �ȉ��̃��b�Z�[�W�ō��
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_INSTALLING_TITLE "�X�V"
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_INSTALLING_SUBTITLE "${MUI_PRODUCT} ���X�V���Ă��܂��B���΂炭���҂����������B"
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_ABORTWARNING "${MUI_PRODUCT} �̍X�V�𒆎~���܂����H"  
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_FINISH_INFO_TEXT "${MUI_PRODUCT} �́A�X�V����܂����B\r\n\r\n�E�B�U�[�h�����ɂ�[����]�������Ă��������B"
!insertmacro MUI_LANGUAGE "Japanese"	; ���{��ō��

; ����̏���Reserve����
ReserveFile "XyzzyCustomA.ini"
!insertmacro MUI_RESERVEFILE_WELCOMEFINISHPAGE
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

;;; �N��������
Function .onInit
  ReadRegStr $INSTDIR HKLM "Software\${MUI_SETUP}" ""
  StrCmp $INSTDIR "" 0 +3
    MessageBox MB_OK|MB_ICONSTOP "${MUI_PRODUCT} �̃C���X�g�[����񂪌�����܂���B$\r$\n${MUI_PRODUCT} �̍X�V�𒆎~���܂��B"
    Quit
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "XyzzyCustomA.ini"
FunctionEnd

;;; �C���X�g�[��
Section "XyzzyUpdate.exe"

  Call InstallPackage

SectionEnd


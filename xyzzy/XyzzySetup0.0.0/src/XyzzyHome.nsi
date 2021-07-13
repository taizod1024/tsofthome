;;; -*- Mode: nsi; Package: editor -*-
;;;
;;; XyzzyHome.nsi --- ���[�U���ϐ� XYZZYHOME �ݒ�

;;; �w�b�_�Ǎ���
!include "MUI.nsh"
!include "XyzzySetup.nsh"
!include "XyzzyCustomB.nsh"

; �o�̓t�@�C��
OutFile "XyzzyHome.exe"

; �ڍו\��
ShowInstDetails show			; �ڍׂ�\������

; �g�p����y�[�W��錾����
!define MUI_CUSTOMPAGECOMMANDS		; CUSTOM�y�[�W���g�p����
!define MUI_FINISHPAGE			; FINISH�y�[�W���g�p����

; MUI_CUSTOMPAGECOMMANDS��ݒ肵���̂ňȉ��̏��ԂŃy�[�W����ׂ�
Page custom SetCustomB			; CUSTOM�y�[�W
!insertmacro MUI_PAGECOMMAND_INSTFILES	; INSTFILES�y�[�W
!insertmacro MUI_PAGECOMMAND_FINISH	; FINISH�y�[�W
!define MUI_FINISHPAGE_NOAUTOCLOSE	; FINISH�y�[�W�ɏ���ɑJ�ڂ��Ȃ�

; �ȉ��̃��b�Z�[�W�ō��
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_INSTALLING_TITLE "�ݒ�"
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_INSTALLING_SUBTITLE "���[�U���ϐ� XYZZYHOME ��ݒ肵�Ă��܂��B���΂炭���҂����������B"
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_ABORTWARNING "���[�U���ϐ� XYZZYHOME �̐ݒ�𒆎~���܂����H"  
!insertmacro MUI_LANGUAGEFILE_STRING MUI_TEXT_FINISH_INFO_TEXT "���[�U���ϐ� XYZZYHOME ��ݒ肵�܂����B\r\n\r\n�E�B�U�[�h�����ɂ�[����]�������Ă��������B"
!insertmacro MUI_LANGUAGE "Japanese"	; ���{��ō��

; ����̏���Reserve����
ReserveFile "XyzzyCustomB.ini"
!insertmacro MUI_RESERVEFILE_WELCOMEFINISHPAGE
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

;;; �N��������
Function .onInit
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "XyzzyCustomB.ini"
FunctionEnd

;;; �C���X�g�[��
Section "XyzzyHome.exe"

  Call SetEnvironment

SectionEnd


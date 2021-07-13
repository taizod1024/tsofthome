;;; -*- Mode: nsi; Package: editor -*-
;;;
;;; XyzzyCustomB.nsh --- CustomB�p�w�b�_

;;; CUSTOMB�y�[�W�p����
!insertmacro MUI_LANGUAGEFILE_STRING TEXT_CUSTOMB_TITLE "XYZZYHOME ���w�肵�Ă��������B"
!insertmacro MUI_LANGUAGEFILE_STRING TEXT_CUSTOMB_SUBTITLE "���[�U���ϐ� XYZZYHOME ���A���݂���f�B���N�g������I�����܂��B"

Function SetCustomB
  ReadRegStr $R0 HKCU "Environment" "XYZZYHOME"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "XyzzyCustomB.ini" "Field 3" "State" $R0
  !insertmacro MUI_HEADER_TEXT "${TEXT_CUSTOMB_TITLE}" "${TEXT_CUSTOMB_SUBTITLE}"
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "XyzzyCustomB.ini"
FunctionEnd

Function SetEnvironment
  !insertmacro MUI_INSTALLOPTIONS_READ $R0 "XyzzyCustomB.ini" "Field 3" "State"
  StrCmp $R0 "" +4
    WriteRegStr HKCU "Environment" "XYZZYHOME" $R0
    DetailPrint "���[�U���ϐ��ݒ�FXYZZYHOME"
    Goto +3
    DeleteRegValue HKCU "Environment" "XYZZYHOME"
    DetailPrint "���[�U���ϐ��폜�FXYZZYHOME"
FunctionEnd


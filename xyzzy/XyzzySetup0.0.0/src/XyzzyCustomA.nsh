;;; -*- Mode: nsi; Package: editor -*-
;;;
;;; XyzzyCustomA.nsh --- CustomA�p�w�b�_

; CUSTOMA�y�[�W�p�e�L�X�g
!insertmacro MUI_LANGUAGEFILE_STRING TEXT_CUSTOMA_TITLE "�z�z�p�b�P�[�W�̎擾���@���w�肵�Ă��������B"
!insertmacro MUI_LANGUAGEFILE_STRING TEXT_CUSTOMA_SUBTITLE "${MUI_PRODUCT} �z�z�p�b�P�[�W���ǂ̂悤�Ɏ擾���邩��ݒ肵�܂��B"

;;; CUSTOM�y�[�W�p����
Function SetCustomA
  ReadRegStr $R1 HKLM "Software\${MUI_SETUP}" "urlflag"
  ReadRegStr $R2 HKLM "Software\${MUI_SETUP}" "url"
  ReadRegStr $R3 HKLM "Software\${MUI_SETUP}" "localfileflag"
  ReadRegStr $R4 HKLM "Software\${MUI_SETUP}" "localfile"
  StrCmp $R2 "" 0 +2
    StrCpy $R2 "http://www.jsdlab.co.jp/~kamei/cgi-bin/download.cgi"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "XyzzyCustomA.ini" "Field 3" "State" $R1
  !insertmacro MUI_INSTALLOPTIONS_WRITE "XyzzyCustomA.ini" "Field 4" "State" $R2
  !insertmacro MUI_INSTALLOPTIONS_WRITE "XyzzyCustomA.ini" "Field 5" "State" $R3
  !insertmacro MUI_INSTALLOPTIONS_WRITE "XyzzyCustomA.ini" "Field 6" "State" $R4
  !insertmacro MUI_HEADER_TEXT "${TEXT_CUSTOMA_TITLE}" "${TEXT_CUSTOMA_SUBTITLE}"
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "XyzzyCustomA.ini"
FunctionEnd

;;; �z�z�p�b�P�[�W���C���X�g�[��
Function InstallPackage

  ; �z�z�p�b�P�[�W���擾
  !insertmacro MUI_INSTALLOPTIONS_READ $R1 "XyzzyCustomA.ini" "Field 3" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ $R2 "XyzzyCustomA.ini" "Field 4" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ $R3 "XyzzyCustomA.ini" "Field 5" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ $R4 "XyzzyCustomA.ini" "Field 6" "State"
  WriteRegStr HKLM "Software\${MUI_SETUP}" "urlflag" $R1
  WriteRegStr HKLM "Software\${MUI_SETUP}" "url" $R2
  WriteRegStr HKLM "Software\${MUI_SETUP}" "localfileflag" $R3
  WriteRegStr HKLM "Software\${MUI_SETUP}" "localfile" $R4

  DetailPrint "�_�E�����[�h�y�ѓW�J�p�ꎞ�t�@�C���y�уt�H���_�쐬�J�n"
  GetTempFileName $R5
  GetTempFileName $R6
  Delete $R6
  CreateDirectory $R6
  DetailPrint "�_�E�����[�h�y�ѓW�J�p�ꎞ�t�@�C���y�уt�H���_�쐬����"
  StrCmp $R1 1 download
  StrCmp $R3 1 localfile

  download:
  DetailPrint "�_�E�����[�h�J�n�F$R2"
  NSISdl::download /TIMEOUT=30000 $R2 $R5
  Pop $R0
  StrCmp $R0 "success" +6
    StrCmp $R0 "cancel" +3
      MessageBox MB_OK|MB_ICONSTOP "�_�E�����[�h�Ɏ��s���܂����B$\r$\n�G���[���e�F$R0"
      Quit
      MessageBox MB_OK|MB_ICONSTOP "�_�E�����[�h���L�����Z�����܂����B"
      Quit
  DetailPrint "�_�E�����[�h�����F$R2"
  Goto fileready

  localfile:
  IfFileExists $R4 +3
    MessageBox MB_OK|MB_ICONSTOP "���[�J���t�@�C����������܂���B"
    Quit
  CopyFiles $R4 $R5
  Goto fileready

  fileready:

  ; �z�z�p�b�P�[�W��W�J
  ; unlha��$INSTDIR�ɒ��ړW�J������@��������Ȃ������̂ŁA
  ; ��U�W�J���Ă���K�v�Ȃ��̂����R�s�[���Ă���c
  DetailPrint "�W�J�J�n�F$R5"
  System::Call 'unlha32::Unlha(i, t, t, i) i (0, "x $R5 $R6\ ", "", 0) .r0'
  StrCmp $0 0 +3
    MessageBox MB_OK|MB_ICONSTOP "�W�J�Ɏ��s���܂����B$\r$\n���[�U�ɂ�蒆�f�AUNLHA32.DLL���g�ݍ��܂�Ă��Ȃ��A$\r$\n�t�@�C���`�����Ԉ���Ă��铙�̉\��������܂��B"
    Quit
  DetailPrint "�W�J�����F$R5"
  SetOutPath $INSTDIR  
  CopyFiles "$R6\xyzzy\*.*" $INSTDIR

  ; �z�z�p�b�P�[�W�폜
  DetailPrint "�_�E�����[�h�y�ѓW�J�p�ꎞ�t�@�C���y�уt�H���_�폜�J�n"
  Delete $R5
  Delete "$R6\*.*"
  RMDir /r $R6
  DetailPrint "�_�E�����[�h�y�ѓW�J�p�ꎞ�t�@�C���y�уt�H���_�폜����"

FunctionEnd

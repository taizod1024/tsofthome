;--------------------------------
; Modern UI�̃C���N���[�h

    !include "MUI2.nsh"
    !include "FileFunc.nsh"
    !include "InstallOptions.nsh"
    !include "WinMessages.nsh"

    ;;; MoveFileFolder.nsh
    !insertmacro Locate
    Var /GLOBAL switch_overwrite
    !include "MoveFileFolder.nsh"

;--------------------------------
; ��ʓI�Ȑݒ�

    ;;; �萔
    !undef PRODUCT_NAME
    !define PRODUCT_NAME "Dropbox�����N���[�e�B���e�B"

    !define PRODUCT_GROUP "tsoft"
    !define PRODUCT_AUTHOR "YAMAMOTO TAIZO"

    !define MUI_PRODUCT "${PRODUCT_NAME} ${PRODUCT_VERSION}"
    !define MUI_ABORTWARNING

    !define MESSAGE_ABORT                 "�����𒆒f���܂����B"
    !define ERROR_MESSAGE_NODROPBOXDB     "�����𒆒f���܂����B$\r$\n$\r$\nDropbox�f�[�^�x�[�X��������܂���B$\r$\nDropbox���C���X�g�[������Ă��邱�Ƃ��m�F���Ă��������B$\r$\nDropbox�C���X�g�[����ɐݒ肪�s���Ă��邱�Ƃ��m�F���Ă��������B"
    !define ERROR_MESSAGE_NODROPBOXPATH   "�����𒆒f���܂����B$\r$\n$\r$\nDropbox�t�H���_�����݂��܂���B$\r$\n�����m�F���Ă��������B"
    !define ERROR_MESSAGE_EXECJUNC        "�����𒆒f���܂����B$\r$\n$\r$\njunction.exe�̎��s�Ɏ��s���܂����B$\r$\n�����m�F���Ă�������"
    !define ERROR_MESSAGE_NOLINKPATH      "�����𒆒f���܂����B$\r$\n$\r$\nDropbox�t�H���_�̃����N�悪���݂��܂���B$\r$\n�����N��t�H���_���폜���ꂽ�\��������܂��B$\r$\n�����m�F���Ă��������B"
    !define ERROR_MESSAGE_DROPBOXKILL     "�����𒆒f���܂����B$\r$\n$\r$\nDropbox���~�ł��܂���B$\r$\nDropbox�̎��s��Ԃ��m�F���Ă��������B"
    !define ERROR_MESSAGE_BACKUPFAILED    "�����𒆒f���܂����B$\r$\n$\r$\n�o�b�N�A�b�v���쐬�ł��܂���B$\r$\n�o�b�N�A�b�v�t�H���_���m�F���Ă��������B"
    !define ERROR_MESSAGE_MOVEFAILED      "�����𒆒f���܂����B$\r$\n$\r$\n�t�H���_���ړ��ł��܂���B$\r$\n�o�b�N�A�b�v�t�H���_�����ɖ߂��Ă��������B"
    !define ERROR_MESSAGE_LINKFAILED      "�����𒆒f���܂����B$\r$\n$\r$\n�����N��ݒ�ł��܂���B$\r$\n�o�b�N�A�b�v�t�H���_�����ɖ߂��Ă��������B"
    !define ERROR_MESSAGE_UNLINKFAILED    "�����𒆒f���܂����B$\r$\n$\r$\n�����N�������ł��܂���B$\r$\n�����N��t�H���_���m�F���Ă��������B"
    !define ERROR_MESSAGE_ATTRFAILED      "�����𒆒f���܂����B$\r$\n$\r$\n�V�X�e��������ύX�ł��܂���B$\r$\n�����N��t�H���_���m�F���Ă��������B"
	
    ;;; �A�C�R��
    !define MUI_ICON "dropbox.ico"

    ;;; �A�v���P�[�V������
    Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"

    ;;; �C���X�g�[���t�@�C����
    OutFile "${PRODUCT}"

    ;;; �v�����s���x��
    RequestExecutionLevel user

    ;;; �u�����h
    BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION}"

;--------------------------------
; �y�[�W

    !define MUI_WELCOMEFINISHPAGE_BITMAP "finish.bmp"
    !define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH

    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_TITLE "${PRODUCT_NAME}���������܂����B"
    !define MUI_FINISHPAGE_TEXT "Dropbox�t�H���_����у����N��t�H���_���m�F���āA$\r$\n����������ɍs���Ă��邱�Ƃ��m�F���Ă��������B$\r$\n�m�F���Ă���[�o�b�N�A�b�v���폜����]���`�F�b�N�����Ă��������B"
    !define MUI_FINISHPAGE_RUN
    !define MUI_FINISHPAGE_RUN_TEXT "�o�b�N�A�b�v���폜���� ..."
    !define MUI_FINISHPAGE_RUN_FUNCTION FinishPageOut

    Page custom CustomPageIn1 CustomPageOut1
    Page custom CustomPageIn2 CustomPageOut2
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH

    ReserveFile "dropboxlink_register1.ini"
    ReserveFile "dropboxlink_register2.ini"
    ReserveFile "dropboxlink_unregister1.ini"
    ReserveFile "dropboxlink_unregister2.ini"

;--------------------------------
; ���{��

    !insertmacro MUI_LANGUAGE "Japanese_dropboxlink"

    VIAddVersionKey /LANG=${LANG_JAPANESE_DROPBOXLINK} "ProductName" "${PRODUCT_GROUP} ${PRODUCT_NAME}"
    VIAddVersionKey /LANG=${LANG_JAPANESE_DROPBOXLINK} "Comments" ""
    VIAddVersionKey /LANG=${LANG_JAPANESE_DROPBOXLINK} "CompanyName" ""
    VIAddVersionKey /LANG=${LANG_JAPANESE_DROPBOXLINK} "LegalTrademarks" ""
    VIAddVersionKey /LANG=${LANG_JAPANESE_DROPBOXLINK} "LegalCopyright" "${PRODUCT_AUTHOR}"
    VIAddVersionKey /LANG=${LANG_JAPANESE_DROPBOXLINK} "FileDescription" "${PRODUCT_GROUP} ${PRODUCT_NAME}"
    VIAddVersionKey /LANG=${LANG_JAPANESE_DROPBOXLINK} "FileVersion" "${PRODUCT_VERSION}"
    VIProductVersion "${PRODUCT_VERSION}"

;--------------------------------
; �ϐ�

    !define BAK_SUFFIX ".bak"

    Var DropboxDBPath
    Var DropboxPath
    Var LinkPath
    Var BackupPath
    Var ModeAction

;--------------------------------
; �y�[�W�Z�N�V����

Function .onInit

    ;;; MoveFileFolder.nsh
    StrCpy $switch_overwrite 0

    ;;; �J�X�^���y�[�W�̓W�J
    InitPluginsDir
    File /oname=$PLUGINSDIR\dropboxlink_register1.ini "dropboxlink_register1.ini"
    File /oname=$PLUGINSDIR\dropboxlink_register2.ini "dropboxlink_register2.ini"
    File /oname=$PLUGINSDIR\dropboxlink_unregister1.ini "dropboxlink_unregister1.ini"
    File /oname=$PLUGINSDIR\dropboxlink_unregister2.ini "dropboxlink_unregister2.ini"

    ;;; Dropbox�f�[�^�x�[�X�̓ǂݍ���
    StrCpy $DropboxDBPath "$APPDATA\Dropbox\host.db"
    IfFileExists "$DropboxDBPath" DROPBOXDB_OK DROPBOXDB_NG
      DROPBOXDB_NG:
        MessageBox MB_ICONEXCLAMATION "${ERROR_MESSAGE_NODROPBOXDB}$\r$\nDropbox�f�[�^�x�[�X�F $DropboxDBPath"
        Abort "${MESSAGE_ABORT}"
      DROPBOXDB_OK:

    FileOpen $0 "$DropboxDBPath" r
    FileRead $0 $1
    FileRead $0 $1
    FileClose $0

    ;;; Dropbox�t�H���_�̃f�R�[�h
    FileOpen $0 "$TEMP\dropboxlink.decb64.txt" w
    FileWrite $0 $1
    FileClose $0
    nsExec::Exec 'decb64.exe $TEMP\dropboxlink.decb64.txt'
    pop $R0
    FileOpen $0 "$TEMP\dropboxlink.decb64.txt.out" r
    FileRead $0 $2
    FileClose $0

    ; RELEASE StrCpy $DropboxPath "$2"
    ; DEBUG StrCpy $DropboxPath "$Documents\dropboxz"
    StrCpy $DropboxPath "$2"

    ;;; Dropbox�t�H���_�̑��݃`�F�b�N
    IfFileExists "$DropboxPath\*.*" DROPBOXPATH_OK DROPBOXPATH_NG
      DROPBOXPATH_NG:
        MessageBox MB_ICONSTOP "${ERROR_MESSAGE_NODROPBOXPATH}$\r$\nDropbox�t�H���_�F $DropboxPath"
        Abort "${MESSAGE_ABORT}"
      DROPBOXPATH_OK:

    ;;; Dropbox�t�H���_�̃����N�̗L���`�F�b�N
    nsExec::Exec 'cmd.exe /c if 1==1 junction\junction.exe "$DropboxPath" > $TEMP\dropboxlink.junction.txt'
    Pop $R0
    StrCmp $R0 "0" EXECJUNC_OK EXECJUNC_NG
      EXECJUNC_NG:
        MessageBox MB_ICONSTOP "${ERROR_MESSAGE_EXECJUNC}$\r$\n�߂�l=$R0"
        Abort "${MESSAGE_ABORT}"
      EXECJUNC_OK:

    ;;; NOTE ���̂��Afindstr�͏o���Ă���̂Ƀ��_�C���N�g����ɂȂ�!!!
    ;;;      ���߂Ď����őS���ǂ�Ŕ��f����B
    ;;; NOTE findstr�̓R�}���h�Ȃ̂�cmd.exe���g�킸�ɒ��ڋN������B

    StrCpy $LinkPath ""
    FileOpen $0 "$TEMP\dropboxlink.junction.txt" r

      FINDLINK_LOOP:
        FileRead $0 $1
        IfErrors FINDLINK_DONE

        StrCpy $2 $1 20
        StrCmp $2 "   Substitute Name: " FINDLINK_MATCH FINDLINK_NEXT

      FINDLINK_MATCH:
        StrCpy $2 $1 "" 20 
        StrCpy $LinkPath $2 -2

      FINDLINK_NEXT:
        Goto FINDLINK_LOOP

      FINDLINK_DONE:

    ;;; Dropbox�t�H���_�̃����N�̑��݃`�F�b�N
    IfFileExists "$LinkPath\*.*" LINKPATH_OK LINKPATH_NG
      LINKPATH_NG:
        MessageBox MB_ICONSTOP "${ERROR_MESSAGE_NOLINKPATH}$\r$\n�����N��t�H���_�F $LinkPath"
        Abort "${MESSAGE_ABORT}"
      LINKPATH_OK:

    ;;; �����N�̑��݂ɉ����ă��[�h��ύX
    StrCmp $LinkPath "" LINKPATH_NOTEXIST LINKPATH_EXIST

      LINKPATH_NOTEXIST:
        StrCpy $ModeAction "�����N�̐ݒ�"
        StrCpy $LinkPath "$DropboxPath"
        Goto LINKPATH_DONE

      LINKPATH_EXIST:
        StrCpy $ModeAction "�����N�̉���"
        Goto LINKPATH_DONE

      LINKPATH_DONE:

FunctionEnd

Function CustomPageIn1

    ;;; ���[�h�ɂ���ēǂݍ��ރy�[�W��ύX
    StrCmp $ModeAction "�����N�̐ݒ�" PAGE_REG PAGE_UNREG

      PAGE_REG:
        !insertmacro MUI_HEADER_TEXT "�����N�̐ݒ�" "�����N��t�H���_�̃p�X���w�肵�܂��B"
        !insertmacro INSTALLOPTIONS_WRITE "dropboxlink_register1.ini" "Field 3" "State" $LinkPath
        InstallOptions::initDialog /NOUNLOAD "$PLUGINSDIR\dropboxlink_register1.ini"
        Goto PAGE_DONE

      PAGE_UNREG:
        !insertmacro MUI_HEADER_TEXT "�����N�̉���" "Dropbox�t�H���_�ƃ����N��t�H���_�̃p�X���m�F���܂��B"
        !insertmacro INSTALLOPTIONS_WRITE "dropboxlink_unregister1.ini" "Field 2" "Text" "Dropbox�t�H���_�F $DropboxPath\n�����N��t�H���_�F $LinkPath"
        InstallOptions::initDialog /NOUNLOAD "$PLUGINSDIR\dropboxlink_unregister1.ini"
        Goto PAGE_DONE

      PAGE_DONE:

    ;;; �J�X�^���y�[�W�̕\��
    InstallOptions::show

FunctionEnd

Function CustomPageOut1

    ;;; ���[�h�ɂ���ď�����ύX
    StrCmp $ModeAction "�����N�̐ݒ�" PAGE_REG PAGE_UNREG

      PAGE_REG:
        !insertmacro INSTALLOPTIONS_READ $0 "dropboxlink_register1.ini" "Field 3" "State"
  
        ;;; �����N��t�H���_�̋�`�F�b�N
        StrCmp "$0" "" 0 +3
            MessageBox MB_ICONEXCLAMATION "�����N��t�H���_����͂��Ă��������B"
            Abort

        ;;; �����N��t�H���_�̓��̓`�F�b�N
        StrCmp "$0" "$DropboxPath" 0 +3
            MessageBox MB_ICONEXCLAMATION "�����N��t�H���_�ɂ�Dropbox�t�H���_�Ƃ͕ʂ̃t�H���_����͂��Ă��������B"
            Abort

        ;;; �����N��t�H���_��DropboxPath�̎q�t�H���_�łȂ����Ƃ̃`�F�b�N
        StrLen $1 "$DropboxPath\"
        StrCpy $2 "$0\" $1
        StrCmp "$2" "$DropboxPath\" 0 +3
            MessageBox MB_ICONEXCLAMATION "�����N��t�H���_�ɂ�Dropbox�t�H���_�̎q�t�H���_�ȊO����͂��Ă��������B"
            Abort

        ;;; �����N��t�H���_��DropboxPath�̐e�t�H���_�łȂ����Ƃ̃`�F�b�N
        StrLen $1 "$0\"
        StrCpy $2 "$DropboxPath\" $1
        StrCmp "$2" "$0\" 0 +3
            MessageBox MB_ICONEXCLAMATION "�����N��t�H���_�ɂ�Dropbox�t�H���_�̐e�t�H���_�ȊO����͂��Ă��������B"
            Abort

        ;;; �����N��t�H���_�̑��݃`�F�b�N
        ${DirState} $0 $1
        StrCmp "$1" "-1" LINK_NG LINK_OK
          LINK_NG:
            MessageBox MB_ICONQUESTION|MB_OKCANCEL "���͂��ꂽ�����N��t�H���_�����݂��܂���B$\r$\n�����N��t�H���_���쐬���܂����H" IDOK LINK_IDOK IDCANCEL LINK_IDCANCEL
              LINK_IDOK:
                CreateDirectory $0
                IfErrors LINK_CREATE_NG LINK_CREATE_OK
                  LINK_CREATE_NG:
                    MessageBox MB_ICONEXCLAMATION "�����N��t�H���_�̍쐬�Ɏ��s���܂����B$\r$\n�����N��t�H���_�F $0"
                    Abort
                  LINK_CREATE_OK:
                Goto LINK_OK
              LINK_IDCANCEL:
                Abort
          LINK_OK:
  
        ;;; �����N��t�H���_�̋�`�F�b�N
        StrCmp "$1" "1" 0 +3
            MessageBox MB_ICONEXCLAMATION "�����N��t�H���_����ł͂���܂���B$\r$\n�����N��t�H���_�F $0"
            Abort

        ;;; �����N��t�H���_�m��
        StrCpy $LinkPath $0  

        Goto PAGE_DONE

      PAGE_UNREG:

        Goto PAGE_DONE

      PAGE_DONE:

        ;;; Dropbox�t�H���_�̃o�b�N�A�b�v�̑��݃`�F�b�N
        StrCpy $BackupPath $DropboxPath${BAK_SUFFIX}
        IfFileExists "$BackupPath\*.*" DROPBOX_BACKUP_EXIST DROPBOX_BACKUP_DONE
          DROPBOX_BACKUP_EXIST:
            MessageBox MB_ICONQUESTION|MB_OKCANCEL "Dropbox�t�H���_�̃o�b�N�A�b�v�����݂��܂��B$\r$\n�o�b�N�A�b�v���폜���܂����H$\r$\n�o�b�N�A�b�v�t�H���_�F $BackupPath" IDOK DROPBOX_BACKUP_IDOK IDCANCEL DROPBOX_BACKUP_IDCANCEL
              DROPBOX_BACKUP_IDOK:
                nsExec::Exec 'cmd.exe /c if 1==1 rmdir /s /q "$BackupPath"'
                Pop $R0
                Goto LINK_OK
              DROPBOX_BACKUP_IDCANCEL:
                Abort
          DROPBOX_BACKUP_DONE:
    
        ;;; �����N��t�H���_�̃o�b�N�A�b�v�̑��݃`�F�b�N
        StrCpy $BackupPath $LinkPath${BAK_SUFFIX}
        IfFileExists "$BackupPath\*.*" LINK_BACKUP_EXIST LINK_BACKUP_DONE
          LINK_BACKUP_EXIST:
            MessageBox MB_ICONQUESTION|MB_OKCANCEL "�����N��t�H���_�̃o�b�N�A�b�v�����݂��܂��B$\r$\n�o�b�N�A�b�v���폜���܂����H$\r$\n�o�b�N�A�b�v�t�H���_�F $BackupPath" IDOK LINK_BACKUP_IDOK IDCANCEL LINK_BACKUP_IDCANCEL
              LINK_BACKUP_IDOK:
                nsExec::Exec 'cmd.exe /c if 1==1 rmdir /s /q "$BackupPath"'
                Pop $R0
                Goto LINK_OK
              LINK_BACKUP_IDCANCEL:
                Abort
          LINK_BACKUP_DONE:

        ;;; Dropbox�t�H���_�̃��b�N�`�F�b�N
        StrCpy $BackupPath $DropboxPath${BAK_SUFFIX}
        Rename $DropboxPath $BackupPath
        IfErrors DROPBOX_LOCK_NG DROPBOX_LOCK_OK
          DROPBOX_LOCK_NG:
            MessageBox MB_ICONEXCLAMATION "Dropbox�t�H���_�����b�N����Ă���\��������܂��B$\r$\nDropbox���܂ގ��s���̑��̃v���Z�X���I�������Ă��������B"
            Rename $BackupPath $DropboxPath
            Abort
          DROPBOX_LOCK_OK:
            Rename $BackupPath $DropboxPath
    
        ;;; �����N��t�H���_�̃��b�N�`�F�b�N
        StrCpy $BackupPath $LinkPath${BAK_SUFFIX}
        Rename $LinkPath $BackupPath
        IfErrors LINK_LOCK_NG LINK_LOCK_OK
          LINK_LOCK_NG:
            MessageBox MB_ICONEXCLAMATION "�����N��t�H���_�����b�N����Ă���\��������܂��B$\r$\nDropbox���܂ގ��s���̑��̃v���Z�X���I�������Ă��������B"
            Rename $BackupPath $LinkPath
            Abort
          LINK_LOCK_OK:
            Rename $BackupPath $LinkPath

FunctionEnd

Function CustomPageIn2

    ;;; ���[�h�ɂ���ēǂݍ��ރy�[�W��ύX
    StrCmp $ModeAction "�����N�̐ݒ�" PAGE_REG PAGE_UNREG

      PAGE_REG:
        !insertmacro MUI_HEADER_TEXT "�����N�̐ݒ�" "Dropbox�t�H���_�̎��̂��ړ����܂��B"
        InstallOptions::initDialog /NOUNLOAD "$PLUGINSDIR\dropboxlink_register2.ini"
        Goto PAGE_DONE

      PAGE_UNREG:
        !insertmacro MUI_HEADER_TEXT "�����N�̉���" "Dropbox�t�H���_�̎��̂����ɖ߂��܂��B"
        InstallOptions::initDialog /NOUNLOAD "$PLUGINSDIR\dropboxlink_unregister2.ini"
        Goto PAGE_DONE

      PAGE_DONE:

    ;;; �J�X�^���y�[�W�̕\��    
    InstallOptions::show

FunctionEnd

Function CustomPageOut2
FunctionEnd

Section

    ;;; ���\��
    DetailPrint "### ���\��"
    DetailPrint "���[�h�F $ModeAction"
    DetailPrint "Dropbox�t�H���_�F $DropboxPath"
    DetailPrint "�����N��t�H���_�F $LinkPath"

    ;;; ���[�h�ɂ���ď�����ύX
    StrCmp $ModeAction "�����N�̐ݒ�" PAGE_REG PAGE_UNREG

      PAGE_REG:

        StrCpy $BackupPath $DropboxPath${BAK_SUFFIX}

        DetailPrint "### �o�b�N�A�b�v�̍쐬"
        DetailPrint "�o�b�N�A�b�v�t�H���_�F $BackupPath"
        CopyFiles $DropboxPath $BackupPath
        IfErrors PAGE_REG_BACKUP_NG PAGE_REG_BACKUP_OK
          PAGE_REG_BACKUP_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_BACKUPFAILED}$\n�o�b�N�A�b�v�t�H���_�F $BackupPath"
            Abort "${MESSAGE_ABORT}"
          PAGE_REG_BACKUP_OK:

        DetailPrint "### �V�X�e�������̕ύX"
        StrCpy $0 'attrib +r "$BackupPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0

        DetailPrint "### �t�H���_�̈ړ�"
        !insertmacro MoveFolder $DropboxPath $LinkPath "*.*"
        IfErrors PAGE_REG_MOVE_NG PAGE_REG_MOVE_OK
          PAGE_REG_MOVE_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_MOVEFAILED}$\n�o�b�N�A�b�v�t�H���_�F $BackupPath"
            Abort "${MESSAGE_ABORT}"
          PAGE_REG_MOVE_OK:
    
        DetailPrint "### �V�X�e�������̕ύX"
        StrCpy $0 'attrib +r "$LinkPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0

        DetailPrint "### �����N�̐ݒ�"
        StrCpy $0 'junction\junction.exe "$DropboxPath" "$LinkPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec 'cmd.exe /c if 1==1 $0 > $TEMP\dropboxlink.junction.register.txt'
        Pop $R0
        StrCmp $R0 "0" PAGE_REG_JUNC_OK PAGE_REG_JUNC_NG
          PAGE_REG_JUNC_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_LINKFAILED}$\r$\n�߂�l=$R0"
            Abort "${MESSAGE_ABORT}"
          PAGE_REG_JUNC_OK:
    
        DetailPrint "### �����N�ݒ�̌��ʔ���"
        StrCpy $0 'findstr /B Created $TEMP\dropboxlink.junction.register.txt'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0
        StrCmp $R0 "0" PAGE_REG_JUNC_CREATE_OK PAGE_REG_JUNC_CREATE_NG
          PAGE_REG_JUNC_CREATE_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_LINKFAILED}$\r$\n�߂�l=$R0"
            Abort "${MESSAGE_ABORT}"
          PAGE_REG_JUNC_CREATE_OK:

        DetailPrint "### �V�X�e�������̕ύX"
        StrCpy $0 'attrib +r "$DropboxPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0

        DetailPrint "### desktop.ini�̍X�V"
        IfFileExists "$DropboxPath\desktop.ini" PAGE_REG_DESKTOPINI_EXIST PAGE_REG_DESKTOPINI_DONE
          PAGE_REG_DESKTOPINI_EXIST:
            ReadINIStr $0 "$DropboxPath\desktop.ini" ".ShellClassInfo" "InfoTip"
            WriteINIStr "$DropboxPath\desktop.ini" ".ShellClassInfo" "InfoTip0" "$0"
            WriteINIStr "$DropboxPath\desktop.ini" ".ShellClassInfo" "InfoTip"  "$0Dropbox�t�H���_�̎��̂�$LinkPath�ɂ���܂��B"
            DetailPrint "desktop.ini�F [.ShellClassInfo] InfoTip = $0 $LinkPath"
          PAGE_REG_DESKTOPINI_DONE:

        Goto PAGE_DONE

      PAGE_UNREG:

        DetailPrint "### �V�X�e�������̕ύX"
        StrCpy $0 'attrib -r +s "$DropboxPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0

        DetailPrint "### �����N�̉���"
        StrCpy $0 'junction\junction.exe -d "$DropboxPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec 'cmd.exe /c if 1==1 $0 > $TEMP\dropboxlink.junction.unregister.txt'
        Pop $R0
        StrCmp $R0 "0" PAGE_UNREG_JUNC_OK PAGE_UNREG_JUNC_NG
          PAGE_UNREG_JUNC_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_UNLINKFAILED}$\r$\n�߂�l=$R0"
            Abort "${MESSAGE_ABORT}"
          PAGE_UNREG_JUNC_OK:

        DetailPrint "### �����N�����̌��ʔ���"
        StrCpy $0 'findstr Deleted /B $TEMP\dropboxlink.junction.unregister.txt'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0
        StrCmp $R0 "0" PAGE_UNREG_JUNC_DELETE_OK PAGE_UNREG_JUNC_DELETE_NG
          PAGE_UNREG_JUNC_DELETE_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_UNLINKFAILED}$\r$\n�߂�l=$R0"
            Abort "${MESSAGE_ABORT}"
          PAGE_UNREG_JUNC_DELETE_OK:

        StrCpy $BackupPath $LinkPath${BAK_SUFFIX}

        DetailPrint "### �o�b�N�A�b�v�̍쐬"
        DetailPrint "�o�b�N�A�b�v�t�H���_�F $BackupPath"
        CopyFiles $LinkPath $BackupPath
        IfErrors PAGE_UNREG_BACKUP_NG PAGE_UNREG_BACKUP_OK
          PAGE_UNREG_BACKUP_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_BACKUPFAILED}$\n�o�b�N�A�b�v�t�H���_�F $BackupPath"
            Abort "${MESSAGE_ABORT}"
          PAGE_UNREG_BACKUP_OK:

        DetailPrint "### �V�X�e�������̕ύX"
        StrCpy $0 'attrib +r "$BackupPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0

        DetailPrint "### �t�H���_�̈ړ�"
        !insertmacro MoveFolder $LinkPath $DropboxPath "*.*"
        IfErrors PAGE_UNREG_MOVE_NG PAGE_UNREG_MOVE_OK
          PAGE_UNREG_MOVE_NG:
            MessageBox MB_ICONSTOP "${ERROR_MESSAGE_MOVEFAILED}$\n�o�b�N�A�b�v�t�H���_�F $BackupPath"
            Abort "${MESSAGE_ABORT}"
          PAGE_UNREG_MOVE_OK:
    
        DetailPrint "### �V�X�e�������̕ύX"
        StrCpy $0 'attrib +r "$DropboxPath"'
        DetailPrint "�R�}���h�F $0"
        nsExec::Exec '$0'
        Pop $R0

        DetailPrint "### desktop.ini�̍X�V"
        IfFileExists "$DropboxPath\desktop.ini" PAGE_UNREG_DESKTOPINI_EXIST PAGE_UNREG_DESKTOPINI_DONE
          PAGE_UNREG_DESKTOPINI_EXIST:
            ReadINIStr $0 "$DropboxPath\desktop.ini" ".ShellClassInfo" "InfoTip0"
            StrCmp "$0" "" PAGE_UNREG_DESKTOPINI_DONE PAGE_UNREG_DESKTOPINI_UPDATE
              PAGE_UNREG_DESKTOPINI_UPDATE:
                WriteINIStr "$DropboxPath\desktop.ini" ".ShellClassInfo" "InfoTip" "$0"
                DeleteINIStr "$DropboxPath\desktop.ini" ".ShellClassInfo" "InfoTip0"
                DetailPrint "desktop.ini�F [.ShellClassInfo] InfoTip = $0"
          PAGE_UNREG_DESKTOPINI_DONE:

        Goto PAGE_DONE

      PAGE_DONE:

SectionEnd

Function FinishPageOut

    MessageBox MB_ICONQUESTION|MB_OKCANCEL "�o�b�N�A�b�v�t�H���_���폜���܂����H$\r$\n�o�b�N�A�b�v�t�H���_�F $BackupPath" IDOK RMDIR_IDOK IDCANCEL RMDIR_IDCANCEL
      RMDIR_IDOK:
        nsExec::Exec 'cmd.exe /c if 1==1 rmdir /s /q "$BackupPath"'
        Pop $R0
        Goto RMDIR_DONE
      RMDIR_IDCANCEL:
        Abort
      RMDIR_DONE:

FunctionEnd


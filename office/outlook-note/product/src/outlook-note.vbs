Option Explicit

' �萔�FOS�֘A
Const olFolderNotes = 12
Const olSave = 2
Const HWND_TOPMOST = -1
Const TemporaryFolder = 2
Const SWP_NOSIZE = &H1
Const SWP_NOMOVE = &H2
Const SWP_HIDEWINDOW = &H80
Const ForWriting = 2
Const TYPE_STRING = 8

' �萔�FSFCmini
Dim FindWindowA
Dim SetWindowPos

' �萔�F�A�v���ŗL
Const cCaption = "outlook.exe"
Const cAppName = "Outlook�����ŕtⳎ�"
Const cFsnTag = "�tⳎ�"
Const cFsxTag = "�tⳎ�/�\��"
Const cNoname = "����"
Const cPrefix = " - ����"
Const cMagic = "  "

Const cArgNew = "/new"
Const cArgClip = "/clipboard"
Const cArgOutlook = "/outlook"
Const cArgDisplay = "/display"
Const cArgTag = "/tag:"

Dim cScrWidth
Dim cScrHeight

' �ϐ��F�A�v������
Dim bArgNew
Dim bArgClip
Dim bArgOutlook
Dim bArgDisplay
Dim sArgTag

' �ϐ��F�I�u�W�F�N�g
Dim oShl
Dim oFso
Dim oOlk
Dim oNsp
Dim oFld

' �ϐ��F�\�����
Dim bInit
Dim bDisplay
Dim sTagPath

' ------------------------------------------------------------------------
' �又��
ArgCheck()      ' �����̃`�F�b�N
AppInit()       ' ������
AppMain()       ' �又��

WScript.Quit 0

' ------------------------------------------------------------------------
' �又��
Sub AppMain()

  If bArgOutlook Then
	ExecOutlook()
  Else
	DisplayNote()
  End If

End Sub

' ------------------------------------------------------------------------
' �����`�F�b�N
Sub ArgCheck()

  Dim sArg

  bArgNew = False
  bArgClip = False
  bArgOutlook = False
  bArgDisplay = False
  sArgTag = ""

  For each sArg in WScript.arguments
	Select Case sArg
	Case cArgNew
	  bArgNew = True
	Case cArgClip
	  bArgClip = True
	Case cArgOutlook
	  bArgOutlook = True
	Case cArgDisplay
	  bArgDisplay = True
	Case Else
	  If Left(sArg,Len(cArgTag)) = cArgTag Then
		sArgTag = Mid(sArg,Len(cArgTag) + 1)
	  Else
		MsgBox "�s���Ȉ������w�肳��Ă��܂�" & vbcrlf & _
		  "�ڍ�: " & sArg & vbcrlf & _
		  "�g�����F�X�N���v�g�� �����Ȃ� | /new [ /clipboard ] [ /tag:�^�O ] | /display [ /tag:�^�O ] | /outlook", _
		  vbExclamation, cAppName
		WScript.Quit 1
	  End If
	End Select
  Next

End Sub

' ------------------------------------------------------------------------
' �A�v��������
Sub AppInit()

  Dim oWmi
  Dim oCols
  Dim oCol
  Dim oLct
  Dim oSvc
  Dim oSet

  ' SFCmini�̏�����
  Set FindWindowA = CreateObject("SfcMini.DynaCall")
  Set SetWindowPos = CreateObject("SfcMini.DynaCall")

  FindWindowA.Declare "user32","FindWindowA"
  SetWindowPos.Declare "user32","SetWindowPos"

  ' �X�N���[���T�C�Y
  Set oWmi = GetObject("Winmgmts:\\.\root\cimv2")
  Set oCols = oWmi.ExecQuery("Select * From Win32_DesktopMonitor where DeviceID = 'DesktopMonitor1'",,0)
  For Each oCol in oCols
	cScrWidth = oCol.ScreenWidth
	cScrHeight = oCol.ScreenHeight
  Next

  ' �t�@�C�����Ȃ���Ε\����Ԃ�
  Set oLct = WScript.CreateObject("WbemScripting.SWbemLocator")
  Set oSvc = oLct.ConnectServer
  Set oSet = oSvc.ExecQuery("select * from win32_process where caption='" & cCaption & "'")
  bInit = oSet.count = 0

  ' �I�u�W�F�N�g�ڑ�
  Set oShl = WScript.CreateObject("Wscript.Shell")
  Set oFso = WScript.CreateObject("Scripting.FileSystemObject")
  Set oOlk = CreateObject("Outlook.Application")
  Set oNsp = oOlk.GetNamespace("MAPI")
  Set oFld = oNsp.GetDefaultFolder(olFolderNotes)
  sTagPath = oFso.GetSpecialFolder(TemporaryFolder).Path & "\" & cAppName & ".dat"

End Sub

' ------------------------------------------------------------------------
' �tⳎ��̕\��
Sub DisplayNote()

  Dim oNotes
  Dim oNote
  Dim lIdx
  Dim lNote
  Dim lDelete
  Dim sTitle
  Dim hWnd

  ' --------------------------------
  ' Outlook�ێ��p�̈ꖇ��ǉ�
  ' �^�O��\�ߓo�^���Ă������߂ɁA�����\���^�O���ǉ�
  Set oNotes = oFld.Items.Restrict("[���ލ���] = '" & cFsnTag & "'")
  Set oNote = nothing
  For lIdx = 1 To oNotes.Count
	If oNotes(lIdx).subject = cAppName Then
	  Set oNote = oNotes(lIdx)
	  Exit For
	End If
  Next
  If oNote Is nothing Then
	Set oNote = oFld.Items.Add
	oNote.Categories = cFsnTag & "," & cFsxTag
	oNote.body = cAppName
	oNote.Left = cScrWidth / 2 - oNote.Width / 2
	oNote.Top = cScrHeight / 2 - oNote.Height / 2
	oNote.Close olSave
	If MsgBox("[" & cAppName & "]�̏����ݒ���s���܂����B" & vbcrlf & "�����ݒ�𔽉f������ɂ͈�xOutlook���I������K�v������܂��B" & vbcrlf & "Outlook���I�����Ă���낵���ł����H", vbQuestion + vbYesNo, cAppName) = vbYes Then
	  oOlk.Quit
	  MsgBox "[�V�����tⳎ�]���N���b�N���ĕtⳎ���ǉ����Ă��������B", vbInformation, cAppName
	Else
	  MsgBox "���Outlook���I�����Ă��������B", vbInformation, cAppName
	End If
	WScript.Quit 3
  End If

  oNote.Display
  WScript.Sleep(500)
  sTitle = NoteTitle(oNote.subject)
  hWnd = FindWindowA(0, sTitle)
  SetWindowPos hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE Or SWP_HIDEWINDOW

  ' --------------------------------
  ' �S���[�h�F��̕tⳎ������ׂč폜
  Set oNotes = oFld.Items.Restrict("[���ލ���] = '" & cFsnTag & "'")
  oNotes.Sort "�X�V����", False
  lNote = 0
  lDelete = 0
  For lIdx = oNotes.Count To 1 step -1
	Set oNote = oNotes(lIdx)
	If oNote.subject <> cAppName  Then
	  If "" = Trim(oNote.subject) Then
		oNote.Delete
		lDelete = lDelete + 1
	  Else
		lNote = lNote + 1
	  End If
	End If
  Next

  If Not bArgNew And Not bArgDisplay And lNote = 0 Then

	bDisplay = False

	' --------------------------------
	' �ǉ����[�h�F�ǉ�����̂ŃX���[
	' �\�����[�h�F�\������̂ŃX���[
	' �ʏ탂�[�h�F�tⳎ����ꖇ���Ȃ��Ȃ��Ă�����ꌏ�̓o�^���Ă��ďI��
	MsgBox "[�tⳎ��̕\��]���N���b�N����܂������tⳎ��͂���܂���B" & vbcrlf & "[�V�����tⳎ�]���N���b�N���ĕtⳎ���ǉ����Ă��������B", vbInformation, cAppName
	WScript.Quit 2

  Else

	' --------------------------------
	' �S���[�h�F���ݏ�Ԃ̎擾
	' Outlook���N����ԂȂ�\����Ԃ�
	' �V�����tⳎ��Ȃ�Ε\����Ԃ�
	' �����\���Ȃ�Ε\����Ԃ�

	bDisplay = bInit _
	  Or bArgNew _
	  Or bArgDisplay _
	  Or Not oFso.FileExists(sTagPath)

	If bDisplay Then

	  ' --------------------------------
	  ' �S���[�h�F�\������
	  For lIdx = 1 To oNotes.Count
		Set oNote = oNotes(lIdx)
		If oNote.subject <> cAppName _
			And (sArgTag = "" Or 0 < InStr(oNote.Categories, sArgTag)) Then
		  oNote.Display
		  sTitle = NoteTitle(oNote.subject)
		  oShl.AppActivate sTitle
		  hWnd = FindWindowA(0, sTitle)
		  If hWnd = 0 Then
			oNote.Close olSave
			oNote.Display
			hWnd = FindWindowA(0, sTitle)
		  End If
		  SetWindowPos hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE
		End If
	  Next

	Else

	  ' --------------------------------
	  ' �S���[�h�F�\�����Ȃ�
	  For lIdx = 1 to oNotes.Count
		Set oNote = oNotes(lIdx)
		If oNote.subject <> cAppName _
			And InStr(oNote.Categories, cFsxTag) = 0 Then
		  oNote.Close olSave
		End If
	  Next
	End If

	' --------------------------------
	' �ǉ����[�h�F�tⳎ���ǉ�
	If bArgNew Then
	  NewNote()
	End If

  End If

  ' --------------------------------
  ' �S���[�h�F���ݏ�Ԃ��X�V
  UpdateStatus()

End Sub

' ------------------------------------------------------------------------
' �V�����tⳎ�
Sub NewNote()

  Dim oNote
  Dim sFsnTag
  Dim hWnd
  Dim sBody
  Dim sTitle

  Set oNote = oFld.Items.Add
  sFsnTag = cFsnTag
  sBody = ""
  sTitle = cNoname
  If bArgClip Then
	sBody = Trim(CreateObject("htmlfile").parentwindow.clipboarddata.getdata("text"))
	If varType(sBody) <> TYPE_STRING Then
	  MsgBox "�N���b�v�{�[�h�̓��e��������ł͂���܂���B", vbExclamation, cAppName
	  WScript.Quit 4
	End If
	If 0 < InStr(sBody, vbcrlf) Then
	  sTitle = Left(sBody, InStr(sBody, vbcrlf) - 1)
	Else
	  sTitle = sBody
	End If
  End If
  If sArgTag <> "" Then
	sFsnTag = sArgTag & "," & sFsnTag
  End If
  oNote.Categories = sFsnTag
  oNote.body = sBody
  oNote.Save
  oNote.Display
  oShl.AppActivate NoteTitle(sTitle)
  hWnd = FindWindowA(0, NoteTitle(sTitle))
  SetWindowPos hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE

End Sub


' ------------------------------------------------------------------------
' �V�����tⳎ�
Sub ExecOutlook()

  oFld.Display

End Sub

' ------------------------------------------------------------------------
' �\����Ԃ̍X�V
Sub UpdateStatus()

  If bDisplay Then
	oFso.CreateTextFile(sTagPath)
  Else
	If oFso.FileExists(sTagPath) Then
	  oFso.DeleteFile(sTagPath)
	End If
  End If

End Sub

' ------------------------------------------------------------------------
' �^�C�g�����̐���
Function NoteTitle(note)
  NoteTitle = replace(note & cPrefix & cMagic, vbTab, " ")
End Function

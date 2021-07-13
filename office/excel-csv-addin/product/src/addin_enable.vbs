Option Explicit

' ------------------------------------------------------------------------
' �A�h�C���̖�����

Const MSGSUCCESS = "�A�h�C����L�������܂����B"
Const MSGFAILURE = "�A�h�C���̗L�����Ɏ��s���܂����B"

Dim oExcel
Dim oAddin
Dim oBook
Dim sArgAppName
Dim sArgMode

On Error Resume Next

sArgAppName = Wscript.Arguments.Item(0)
sArgMode = Wscript.Arguments.Item(1)

Set oExcel = nothing
Set oBook = nothing
Set oAddin = nothing

' Excel�I�u�W�F�N�g�̐���
Set oExcel = CreateObject("Excel.Application")
If Err.Number <> 0 Then ErrorHandler

' ���[�N�u�b�N�̐���
Set oBook = oExcel.Workbooks.Add
If Err.Number <> 0 Then ErrorHandler

' �A�h�C���t�@�C���̓ǂݍ���
' TODO 2002���ƁuAddIns �N���X�� Add �v���p�e�B���擾�ł��܂���B�v���o�͂����B
Set oAddin = oExcel.AddIns.Add(oExcel.Application.UserLibraryPath + sArgAppName + ".xla", True)
If Err.Number <> 0 Then ErrorHandler

' �A�h�C���̓o�^
oAddin.Installed = False
If Err.Number <> 0 Then ErrorHandler

oAddin.Installed = True
If Err.Number <> 0 Then ErrorHandler

' �I�u�W�F�N�g�̉��
oBook.Close
Set oBook = nothing

oExcel.Quit
Set oExcel = nothing

' ����I��
If sArgMode <> "/i" Then
  MsgBox MSGSUCCESS, vbInformation, sArgAppName
End If
WScript.Quit 0

' ------------------------------------------------------------------------
' �ُ�I��
Sub ErrorHandler()
  MsgBox MSGFAILURE & vbcrlf & _
	"�ڍ�: " & CStr(Err.Number) & ":" & Err.Description, _
	vbExclamation, sArgAppName
  If Not oBook Is Nothing Then oBook.Close
  Set oBook = nothing
  If Not oExcel Is Nothing Then oExcel.Quit
  Set oExcel = nothing
  WScript.Quit 1
End Sub

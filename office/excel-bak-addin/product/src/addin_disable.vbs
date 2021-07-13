Option Explicit

' ------------------------------------------------------------------------
' �A�h�C���̖�����
' ------------------------------------------------------------------------

Const MSGSUCCESS = "�A�h�C���𖳌������܂����B"
Const MSGFAILURE = "�A�h�C���̖������Ɏ��s���܂����B"

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

' �A�h�C���̑I��
Set oAddin = oExcel.AddIns(sArgAppName)
If Err.Number <> 0 Then ErrorHandler

' �A�h�C���̉���
oAddin.Installed = False
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

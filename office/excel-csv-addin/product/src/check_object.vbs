Option Explicit

' ------------------------------------------------------------------------
' �I�u�W�F�N�g�̃`�F�b�N
' ------------------------------------------------------------------------

Dim oApp

On Error Resume Next

' �����̃`�F�b�N
If 1 <> WScript.arguments.count Then
  WScript.Quit 1
End If

' �I�u�W�F�N�g�̃`�F�b�N
Set oApp = CreateObject(WScript.arguments(0))
If Err.Number <> 0 Then
  WScript.Quit 2
End If

' �I�u�W�F�N�g�̉��
oApp.Quit
Set oApp = nothing

' �`�F�b�N����
WScript.Quit 0

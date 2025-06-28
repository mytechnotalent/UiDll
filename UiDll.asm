;==============================================================================
; File:     UiDll.asm
;
; Purpose:  UiDll is a 64-bit Windows DLL exporting Windows API UI 
;           functionality in Assembler.
;
; Platform: Windows x64
; Author:   Kevin Thomas
; Date:     2025-06-28
; Updated:  2025-06-28
;==============================================================================

extrn  MessageBoxA :proc

public UIMessageBox
public DllMain

.code

;------------------------------------------------------------------------------
; UIMessageBox PROC wrapper for MessageBoxA
;
; int MessageBoxA(
;   [in, optional] HWND   hWnd,
;   [in, optional] LPCSTR lpText,
;   [in, optional] LPCSTR lpCaption,
;   [in]           UINT   uType
; );
;
; Parameters:
;   RCX = LPCSTR lpText
;   RDX = LPCSTR lpCaption
;
; Return:
;   IDOK = 1 - The OK button was selected.
;------------------------------------------------------------------------------
UIMessageBox proc lpText:QWORD, lpCaption:QWORD
  XOR    R9, R9              ; 4th param = uType
  MOV    R8, RDX             ; 3rd param = lpCaption
  MOV    RDX, RCX            ; 2nd param = lpText
  XOR    RCX, RCX            ; 1st param = hWnd
  CALL   MessageBoxA         ; call Win32 API
  RET                        ; return to caller
UIMessageBox endp

;------------------------------------------------------------------------------
; DllMain PROC
;
; BOOL WINAPI DllMain(
;   _In_ HINSTANCE hinstDLL,
;   _In_ DWORD     fdwReason,
;   _In_ LPVOID    lpvReserved
; );
;
; Parameters:
;   RCX = hinstDLL
;   RDX = fdwReason
;   R8  = lpvReserved
;
; Return:
;   TRUE = Success initialization.
;   FALSE = Failure initialization.
;------------------------------------------------------------------------------
DllMain proc hinstDLL:QWORD, fdwReason:DWORD, lpReserved:QWORD
  MOV    EAX, 1              ; TRUE
  RET                        ; return to caller
DllMain endp

end

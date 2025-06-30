<img src="https://github.com/mytechnotalent/UiDll/blob/master/UiDll.png?raw=true">

## FREE Reverse Engineering Self-Study Course [HERE](https://github.com/mytechnotalent/Reverse-Engineering-Tutorial)

<br>

# UiDll
UiDll is a 64-bit Windows DLL exporting Windows API UI functionality written in Assembler.

<br>

## Comprehensive Deep Dive Supplemental Material
### Windows Internals Crash Course by Duncan Ogilvie
#### [SLIDES](https://mrexodia.github.io/files/wicc-2023-slides.pdf)
#### [VIDEO](https://youtu.be/I_nJltUokE0?si=Q1yOfZuIF5jOa_2U)

<br>

## Reverse Engineering

### 🧠 Windows Process Loader: Beginner-Friendly Breakdown

Let’s walk through what actually happens when a Windows process is created.

#### 1. 🧱 Process Creation by the Kernel

When a new process is spun up, the kernel:

- Maps the target *executable image* into memory  
- Loads *ntdll.dll*  
- Creates a *new thread* to eventually run the main function  

> At this point, the process has no initialized PEB, TEB, or imports — it’s just a shell.

#### 2. 🚀 Starting the Thread: `ntdll!LdrInitializeThunk()`

This function is always the initial thread entrypoint. It immediately calls:

- `ntdll!LdrpInitialize()` – this handles setup.

#### 3. 🏗️ Initialization via `ntdll!LdrpInitialize()`

This routine does two things:

- Sets up the *process* if it's not already initialized  
- Sets up the *current thread*

It checks the global flag:

- `ntdll!LdrpProcessInitialized`  
  - If `FALSE`, it calls `ntdll!LdrpInitializeProcess()`

#### 4. 🔧 What `LdrpInitializeProcess()` Does

- Initializes the *PEB*  
- Resolves the process’s *import table*  
- Loads any *required DLLs*

> This is where the environment gets fully fleshed out.

#### 5. 🏁 Launching the Process: `ZwContinue()` and Beyond

When initialization is done:

1. `LdrInitializeThunk()` calls `ZwContinue()`  
2. The kernel sets the instruction pointer to `ntdll!RtlUserThreadStart()`  
3. Finally, the process’s *entrypoint function* is called

> Now the executable starts for real.

<br>

## Code
```
;==============================================================================
; File:     UiDll.asm
;
; Purpose:  UiDll is a 64-bit Windows DLL exporting Windows API UI 
;           functionality written in Assembler.
;
; Platform: Windows x64
; Author:   Kevin Thomas
; Date:     2025-06-28
; Updated:  2025-06-28
;==============================================================================

extrn  MessageBoxA :PROC

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
UIMessageBox PROC lpText:QWORD, lpCaption:QWORD
  XOR    R9, R9                   ; 4th param = uType
  MOV    R8, RDX                  ; 3rd param = lpCaption
  MOV    RDX, RCX                 ; 2nd param = lpText
  XOR    RCX, RCX                 ; 1st param = hWnd
  CALL   MessageBoxA              ; call Win32 API
  RET                             ; return to caller
UIMessageBox ENDP

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
DllMain PROC hinstDLL:QWORD, fdwReason:DWORD, lpReserved:QWORD
  MOV    EAX, 1                   ; TRUE
  RET                             ; return to caller
DllMain ENDP

END                               ; end of UiDll.asm
```

<br>

## License
[MIT](https://github.com/mytechnotalent/UiDll/blob/master/LICENSE.txt)

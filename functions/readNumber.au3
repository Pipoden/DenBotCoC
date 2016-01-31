#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <SendMessage.au3>

func readNumber($numberField)
   $handle = WinGetHandle("BlueStacks App Player","")
   $bitmap =  _CaptureWindow($handle);_WinCapture($handle,500,500)
  _ScreenCapture_SaveImage("Image.bmp", $bitmap, false)
   ;_ScreenCapture_CaptureWnd("GDIPlus_Image.jpg", $handle)
EndFunc


; from https://www.autoitscript.com/forum/topic/108822-possible-to-screen-capture-while-gui-is-hidden/
Func _CaptureWindow($hWnd)
    Local $WM_PAINT = 0x000F
    Local $WM_PRINT = 0x317
    Local $PRF_CHILDREN = 0x10; Draw all visible child windows.
    Local $PRF_CLIENT = 0x4 ; Draw the window's client area.
    Local $PRF_OWNED = 0x20 ; Draw all owned windows.
    Local $PRF_NONCLIENT = 0x2 ; Draw the window's Title area.
    Local $PRF_ERASEBKGND = 0x8 ; Erases the background before drawing the window

    Local $pos = WinGetPos($hWnd)
    Local $Width = $pos[2]
    Local $Height = $pos[3]

    Local $hDC = _WinAPI_GetDC($hWnd)
    Local $memDC = _WinAPI_CreateCompatibleDC($hDC)
    Local $memBmp = _WinAPI_CreateCompatibleBitmap($hDC, $Width, $Height)

    _WinAPI_SelectObject ($memDC, $memBmp)

    Local $Ret = _SendMessage($hWnd, $WM_PAINT, $memDC, 0)
    $Ret = _SendMessage($hWnd, $WM_PRINT, $memDC, BitOR($PRF_CHILDREN , $PRF_CLIENT, $PRF_OWNED, $PRF_NONCLIENT, $PRF_ERASEBKGND))

    Local $hBMP=_GDIPlus_BitmapCreateFromHBITMAP($memBmp)
    Local $hHBITMAP=_GDIPlus_BitmapCreateHBITMAPFromBitmap($hBMP)

    _WinAPI_DeleteObject($hDC)
    _WinAPI_ReleaseDC($hWnd, $hDC)
    _WinAPI_DeleteDC($memDC)
    _WinAPI_DeleteObject ($memBmp)
    _WinAPI_DeleteDC($hDC)

    Return $hHBITMAP
EndFunc ;==>_CaptureWindow()


Func _WinCapture($hWnd, $iWidth = -1, $iHeight = -1)
    Local $iH, $iW, $hDDC, $hCDC, $hBMP

    If $iWidth = -1 Then $iWidth = _WinAPI_GetWindowWidth($hWnd)
    If $iHeight = -1 Then $iHeight = _WinAPI_GetWindowHeight($hWnd)

    $hDDC = _WinAPI_GetDC($hWnd)
    $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
    $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)
    _WinAPI_SelectObject($hCDC, $hBMP)

    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $hWnd, "hwnd", $hCDC, "int", 0)
    _WinAPI_BitBlt($hCDC, 0, 0, $iW, $iH, $hDDC, 0, 0, 0x00330008)

    _WinAPI_ReleaseDC($hWnd, $hDDC)
    _WinAPI_DeleteDC($hCDC)

    _ScreenCapture_SaveImage("window.jpg", $hBMP, False)

    Return $hBMP
EndFunc   ;==>_WinCapture


#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Den

 Script Function: Create an overlay on bluestacks windows

#ce ----------------------------------------------------------------------------

#include <WindowsConstants.au3>
#include <WinAPI.au3>

global $bluestacksHandle = -1	; bluestacks window
global $overlayWinGraph = 0		; graphical area of win overlay
global $overlayWinHandle = 0	; win overlay

func createOverlayWindow($windowName)
   local $winW = WinGetPos($windowName)[2]
   local $winH = WinGetPos($windowName)[3]
   local $winX = WinGetPos($windowName)[0]
   local $winY = WinGetPos($windowName)[1]
   local $style = $WS_BORDER
   local $extendedStyle = BitOR($WS_EX_TOPMOST,$WS_EX_TRANSPARENT)
   $overlayWinHandle = GUICreate("Overlay",$winW,$winH,$winX, $winY,$style,$extendedStyle,$mainWinHandle)
   $bluestacksHandle = WinGetHandle($windowName,"")
   GUISetBkColor(0x00000000, $overlayWinHandle)
   WinSetTrans($overlayWinHandle, "", 200)
   $overlayWinGraph = GUICtrlCreateGraphic(0,0,$winW, $winH)
   GUICtrlSetBkColor(-1, 0x000000)
   GUICtrlSetColor(-1, 0)
   GUICtrlSetGraphic($overlayWinGraph, $GUI_GR_COLOR, 0xff0000, 0xff0000)
   GUICtrlSetGraphic($overlayWinGraph, $GUI_GR_RECT, 729 , 9, 96, 44)
   ;imageNumberSearch("", 729, 29, 96, 44)

EndFunc

func overlayDrawSpot($x, $y)

   if($bluestacksHandle == -1) Then
	  Return
   EndIf
   verbose("test")
   GUICtrlSetBkColor($overlayWinGraph, 0x000000)
   GUICtrlSetColor($overlayWinGraph, 0xff0000)
   ;GUICtrlSetGraphic(GUICtrlGetHandle ($overlayWinGraph), $GUI_GR_COLOR, 0xff0000, 0xff0000)
   ;GUICtrlSetGraphic(GUICtrlGetHandle ($overlayWinGraph), $GUI_GR_RECT, $x -5 , $y-5, 10, 10)
   GUICtrlSetGraphic($overlayWinGraph, $GUI_GR_COLOR, 0xff0000, 0xff0000)
   GUICtrlSetGraphic($overlayWinGraph, $GUI_GR_RECT, $x -5 , $y-5, 10, 10)
EndFunc


func overlayFrame()
   ; check if bluestacks window has moved
   if ( ( $bluestacksHandle == -1 ) Or ( $overlayWinHandle == 0) ) Then
	  Return
   EndIf
   local $winXBS = WinGetPos($bluestacksHandle)[0]
   local $winYBS = WinGetPos($bluestacksHandle)[1]
   local $winXOL = WinGetPos($overlayWinHandle)[0]
   local $winYOL = WinGetPos($overlayWinHandle)[1]
   if( ($winXBS<>$winXOL) Or ($winYBS<>$winYOL) ) Then
	  WinMove($overlayWinHandle,"", WinGetPos($bluestacksHandle)[0], WinGetPos($bluestacksHandle)[1])
   EndIf


EndFunc

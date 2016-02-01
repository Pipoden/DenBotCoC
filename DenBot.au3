; ********
; includes
; ********
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#Include <Timers.au3>
#include <Misc.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ListBoxConstants.au3>
#include <WindowsConstants.au3>
#Include <Color.au3>
#include "Functions.au3"

HotKeySet("{F10}","funcTest")

; *************
; --- SETUP ---
; *************
global $timeNoIdle = 60		; time between action to not be idle ( in seconds )
global $WinTitle = "DenBot Clash Of Clan V0.1"
global $bsWinName = "BlueStacks App Player"

; *********
; variables
; *********
global $timeCounter = TimerInit()
global $blueStacksIsLaunch = 0

; ****************
; windows creation
; ****************
#region
; *** ROW 1 ***
global $mainWinHandle = GUICreate($WinTitle,800,600)
global $guiVerbose = GUICtrlCreateEdit("",5,25,300,500,0x800);
global $guiAntiIdle = GUICtrlCreateCheckbox("Anti Idle", 325,25,100,20)
global $guiBlueStacksOn = GUICtrlCreateLabel("BlueStacks not detected.",450,25)
;global $guiShowClicSpot = GUICtrlCreateButton("Show Clic spots", 325,50,100,20)
global $guiTestOCR = GUICtrlCreateButton("Test OCR", 325,75,100,20)

#endregion
GUISetState(@SW_SHOW, $mainWinHandle)
;changeBSResolution(860, 720)
;createOverlayWindow("BlueStacks App Player")

GUISetState()
verbose("Welcome to " & $WinTitle)

; *********
; main loop
; *********
While 1
	$msg = GUIGetMsg(1)
	Select
	  ; fermeture de la fenetre
	  Case $msg[0] == $GUI_EVENT_CLOSE
		 if($msg[1] == $mainWinHandle) then
			ExitLoop
		 Else
			GUISetState(@SW_HIDE,$msg[1])
		 endif
	  Case $msg[0] == $guiTestOCR
		 testOCR()
	  EndSelect
	  checkwin()
	  Sleep(50)
WEnd


; *****************************************
; *********    functions        ***********
; *****************************************
func testOCR()
   ToolTip("test OCR !")
  ; loadOCRCharDef()
   imageNumberSearch("", 713, 49+51, 102, 1); +51
   ;sleep(2000)
   ;Exit



EndFunc

func funcTest()
   ;loadOCRCharDef()
   ;createOverlayWindow($bsWinName)
   ;ControlSend("BlueStacks App Player","",0,"{DOWN}",0)
   ;updateInfos()
   ;generateOCRChar()
   ;imageNumberSearch("", 700, 19, 96, 44)
  ; generateOCRChar()
  ; oolTip(Number("0xFF"))

   ;$coords = getButtonCoords("exit")
   ;overlayDrawSpot($coords[0], $coords[1])
   ;pressButton("exit")
   ;readNumber("test")
   ;getButtonCoords($buttonName)
   ;ToolTip(Hex(getScreenMode(), 6))
EndFunc

func verbose($text)
   local $oldText = GUICtrlRead($guiVerbose)
   GUICtrlSetData($guiVerbose, $oldText & @CRLF  & @hour & ":" & @min & " - " &   $text)
endfunc

func checkBlueStacks()
   Opt("WinTextMatchMode", 2)
   local $winBS = WinExists($bsWinName,"")
   if($blueStacksIsLaunch <> $winBS) then
	  $blueStacksIsLaunch = $winBS
	  if($winBS == 1) Then
		 GUICtrlSetData($guiBlueStacksOn,"BlueStacks is detected.")
	  Else
		 GUICtrlSetData($guiBlueStacksOn,"BlueStacks not detected.")
	  EndIf
   EndIf
EndFunc

func checkwin()
   checkBlueStacks()
   if($blueStacksIsLaunch == 1) then
	  ; overlayWindow
	  overlayFrame()
	  ; Check idle Time
	  if(GUICtrlRead($guiAntiIdle) == $GUI_CHECKED) Then
		 $idleTime = TimerDiff($timeCounter)
		 if($idleTime > ($timeNoIdle*1000)) Then
			$timeCounter = TimerInit()
			ControlSend($bsWinName,"",0,"{DOWN}",0)
			;verbose("Preventing idle")
		 EndIf
	  EndIf
   EndIf
endfunc


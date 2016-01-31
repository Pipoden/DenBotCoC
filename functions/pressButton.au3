; Simulate a button pression
; read from ini file
global $buttonDef[200][3]
global $buttonDefCur = 0

global $iniFile = IniReadSection("functions/buttons.ini","buttons")
For $i=1 To $iniFile[0][0] Step 1
   ; slicing
   $slice = StringSplit($iniFile[$i][1],",")
   if($slice[0] == 2) Then
	  $buttonDef[$buttonDefCur][0] = $iniFile[$i][0]	; Label
	  $buttonDef[$buttonDefCur][1] = $slice[1]			; X position
	  $buttonDef[$buttonDefCur][2] = $slice[2]			; Y position
	  $buttonDefCur += 1
   EndIf
Next

; *****************
; *** Functions ***
; *****************

func getButtonCoords($buttonName)
   local $result[2]
   for $i=0 To $buttonDefCur Step 1
	  if($buttonName == $buttonDef[$i][0]) Then
		 $result[0] = $buttonDef[$i][1]
		 $result[1] = $buttonDef[$i][2]
		 return $result
	  EndIf
   Next
   return $result
EndFunc

func pressButton($buttonName)
   for $i=0 To $buttonDefCur Step 1
	  if($buttonName == $buttonDef[$i][0]) Then
		 ControlClick ($bsWinName,"",0, "left" , 1 , $buttonDef[$i][1] , $buttonDef[$i][2] )
		 Return
	  EndIf
   Next
endfunc


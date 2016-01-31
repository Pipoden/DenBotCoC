; Window need to get active
func getScreenMode()
   AutoItSetOption ("PixelCoordMode", 0 )
   if(WinActive("BlueStacks App Player","")) Then
	  $handle = WinGetHandle("BlueStacks App Player","")
	  $pixel1 = PixelGetColor(38,590,$handle)

	  if($pixel1 == 0xBC7C19) Then	; mode village basique
		 return 1
	  EndIf
	  if($pixel1 == 0x6a614b) Then	; mode attack start screen
		 return 2
	  EndIf

	  return $pixel1
   Else
	  return 0
   EndIf
EndFunc

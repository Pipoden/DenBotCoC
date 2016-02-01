#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Den

 Script Function: recupere les infos sur l'ecran de jeu

#ce ----------------------------------------------------------------------------

#include <ScreenCapture.au3>
#include <GDIPlus.au3>

; tableau contenant les characters a reconnaitre
; les couleurs sont codés sur 8 valeurs ( valeur du pixel rouge, divisé par 8)
; de hauteur 10px, et de largeur 6px
global $OCRCharDef[200][2]
global $OCRCharDefIndex = 0

global $OCRCharWidth = 4
global $OCRCharHeight = 14


func loadOCRCharDef()
   local $readIni = IniReadSection("images\OCRDef.ini", "OCRCharMoney")
   If Not @error Then
	  For $i = 1 To $readIni[0][0]
		 if($readIni[$i][0] == "width") Then
			$OCRCharWidth = Number($readIni[$i][1])
			ContinueLoop
		 EndIf
		 if($readIni[$i][0] == "height") Then
			$OCRCharHeight = Number($readIni[$i][1])
			ContinueLoop
		 EndIf
		 $OCRCharDef[$OCRCharDefIndex][0] = $readIni[$i][0]
		 $OCRCharDef[$OCRCharDefIndex][1] = $readIni[$i][1]
		 $OCRCharDefIndex += 1
	  Next
   EndIf
   ToolTip("loaded " & $OCRCharDefIndex & " elements")
EndFunc


func updateInfos()
   ; TODO : aller vers la bonne fenetre de jeu

   ; TODO : verifier que la fenetre est active
   WinActivate($bluestacksHandle)

   ; prend un SS
   GUISetState(@SW_HIDE,$overlayWinHandle)				; on cache la fenetre d'overlay
   local $winW = WinGetPos($bluestacksHandle)[2]
   local $winH = WinGetPos($bluestacksHandle)[3]
   local $winX = WinGetPos($bluestacksHandle)[0]
   local $winY = WinGetPos($bluestacksHandle)[1]
   _GDIPlus_Startup() ;initialize GDI+
   _ScreenCapture_Capture("infoScreen.png",$winX,$winY,$winX+$winW, $winY+$winH,false)


EndFunc

func generateOCRChar()
   $text = ""
   for $i=0 to 9
	  _GDIPlus_Startup()
	  local $hBitmap = _GDIPlus_BitmapCreateFromFile("images/coc_"&$i&".png")
	  $currentChar = ""
	  for $k=0 to ($OCRCharHeight - 1)
		 for $l=0 to ($OCRCharWidth - 1)
			$color = _GDIPlus_BitmapGetPixel ($hBitmap, $l, $k)
			$colorBlue = BitAND($color,0x0000FF)
			$color8 = hex(floor($colorBlue / 16), 1)	; 16 shades color
			$currentChar &= $color8
			;ToolTip( hex($color,6) & " > " & hex($colorBlue,6) & " > " & $color8 & " > " & $currentChar)
			;sleep(500)
		 Next
	  Next
	  $text = $text & $i & " = " & $currentChar & @CRLF
	  ToolTip($currentChar)
	  _GDIPlus_Shutdown()
   Next
   ClipPut($text)
EndFunc



func imageNumberSearch($number, $x, $y, $w, $h, $errorMargin = 50)
   ; cherche l'image d'une chiffre dans le rectangle defini
   ; renvoie un tableau de coords avec tout les emplacements trouvés
   ; TODO
   $OCRCharDefIndex = 0
   loadOCRCharDef()
   _GDIPlus_Startup()
   WinActivate($bsWinName)
   sleep(1000)
   $posWin = WinGetPos ($bsWinName)
   _ScreenCapture_Capture("infoScreen.png",$posWin[0],$posWin[1],$posWin[0]+$posWin[2], $posWin[1]+$posWin[3],false)
   sleep(1000)


   $OCRResult = ""
   local $hBitmap = _GDIPlus_BitmapCreateFromFile("infoScreen.png")

   ;$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)

   if ( 1 == 1) Then
	  ; image cible
	  $hBitmap2 = _ScreenCapture_Capture("", 0, 0, $w+($OCRCharWidth - 1), $h+($OCRCharHeight - 1))
	  $hImage2 = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap2)
	  $hGraphics = _GDIPlus_ImageGetGraphicsContext($hImage2)
	  _GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 10, 0)
	  ;_GDIPlus_GraphicsDrawRect($hGraphics, 10, 10, 20, 20)
	  _GDIPlus_GraphicsDrawImageRectRect ( $hGraphics, $hBitmap, $x, $y, $w+($OCRCharWidth - 1), $h+($OCRCharHeight - 1), 0, 0, $w+($OCRCharWidth - 1), $h+($OCRCharHeight - 1) )
	  _GDIPlus_ImageSaveToFile( $hImage2, "test.png" )
	  ;_GDIPlus_Shutdown()
	  ;return
   EndIf

   for $i=0 to ($h-1)
	  for $j=0 to ($w-1)
		 $currentChar = ""
		 for $k=0 to ($OCRCharHeight - 1)
			for $l=0 to ($OCRCharWidth - 1)
			   $color = _GDIPlus_BitmapGetPixel ($hBitmap, $x+$j+$l, $y+$i+$k)
			   $colorBlue = BitAND($color,0x0000FF)
			   $color8 = hex(floor($colorBlue / 16), 1)	; 8 shades color
			   $currentChar &= $color8
			Next
		 Next
		 ; comparaison avec le tableau de char
		 for $k = 0 to ($OCRCharDefIndex - 1)
			$delta = 0
			local $ref = $OCRCharDef[$k][1]
			for $l=1 to ( $OCRCharWidth * $OCRCharHeight )
			   $char = stringmid($currentChar,$l,1)
			   $refChar = stringmid($ref,$l,1)
			   $deltaChar = abs(Number("0x"&$char) - Number("0x"&$refChar,1))
			   $delta += $deltaChar
			Next
			if($delta < $errorMargin) Then
			  ; ToolTip("delta : " & $delta & " --> " & $OCRCharDef[$k][0] & " error: " & $delta)
			   ;sleep(1000)
			   $OCRResult = $OCRResult & $OCRCharDef[$k][0]
			EndIf
		 Next
	  Next
   Next
   ToolTip("Elixir : " & $OCRResult)
   _GDIPlus_Shutdown()



EndFunc

func scanX($image,$posX, $posY, $height)

   _GDIPlus_Startup()
   Local $hGUI, $hBMP, $hBitmap, $hGraphic, $hImage, $iX, $iY, $hClone
   $hBitmap = _GDIPlus_BitmapCreateFromFile("infoScreen.png")
   $score = ""
   for $i=0 to ($height - 1) step 1
	  $color = _GDIPlus_BitmapGetPixel ( $hBitmap, $posX, $posY + $i )
	  $colorBlue = BitAND($color,0x0000FF)
	  $color8 = hex(floor($colorBlue / 8), 1)	; 8 shades color
	  $score &= $color8 &" "
   Next
   return $score
EndFunc


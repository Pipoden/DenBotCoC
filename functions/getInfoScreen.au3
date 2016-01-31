#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Den

 Script Function: recupere les infos sur l'ecran de jeu

#ce ----------------------------------------------------------------------------

#include <ScreenCapture.au3>
#include <GDIPlus.au3>

; tableau contenant les characters a reconnaitre
; les couleurs sont codés sur 8 valeurs ( valeur du pixel rouge, divisé par 8)
; de hauteur 10px, et de largeur 7px
;global OCRCharDef[200][70]
;global OCRCharDefIndex = 0

func loadOCRCharDef()
   ; TODO
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
      _GDIPlus_Startup()
   local $hBitmap = _GDIPlus_BitmapCreateFromFile("images/coc8.png")
   $currentChar = ""
   for $k=0 to 9
	  for $l=0 to 6
		 $color = _GDIPlus_BitmapGetPixel ($hBitmap, $l, $k)
		 $colorBlue = BitAND($color,0x0000FF)
		 $color8 = hex(floor($colorBlue / 8), 1)	; 8 shades color
		 $currentChar &= $color8
	  Next
   Next
   ToolTip($currentChar)
   ClipPut($currentChar)
   _GDIPlus_Shutdown()
EndFunc



func imageNumberSearch($number, $x, $y, $w, $h)
   ; cherche l'image d'une chiffre dans le rectangle defini
   ; renvoie un tableau de coords avec tout les emplacements trouvés
   ; TODO
   _GDIPlus_Startup()
    WinActivate($bluestacksHandle)

   $OCRResult = ""
   ;image source
   local $hBitmap = _GDIPlus_BitmapCreateFromFile("infoScreen.png")

   ;$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)

   if ( 0 == 1) Then
	  ; image cible
	  $hBitmap2 = _ScreenCapture_Capture("", 0, 0, $w+6, $h+9)
	  $hImage2 = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap2)
	  $hGraphics = _GDIPlus_ImageGetGraphicsContext($hImage2)
	  _GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 10, 0)
	  ;_GDIPlus_GraphicsDrawRect($hGraphics, 10, 10, 20, 20)
	  _GDIPlus_GraphicsDrawImageRectRect ( $hGraphics, $hBitmap, $x, $y, $w+6, $h+9, 0, 0, $w+6, $h+9 )
	  _GDIPlus_ImageSaveToFile( $hImage2, "test.png" )
	  _GDIPlus_Shutdown()
	  return
   EndIf

   for $i=0 to ($h-1)
	  for $j=0 to ($w-1)
		 $currentChar = ""
		 for $k=0 to 9
			for $l=0 to 6
			   $color = _GDIPlus_BitmapGetPixel ($hBitmap, $x+$j+$l, $y+$i+$k)
			   $colorBlue = BitAND($color,0x0000FF)
			   $color8 = hex(floor($colorBlue / 8), 1)	; 8 shades color
			   $currentChar &= $color8
			Next
		 Next
		 ; comparaison avec le tableau de char
		 #cs
		 local $delta = 0
		 local $ref = "1BFFFEC1DFFFFF4FFFFFFFFF8FFFFF91FFFFF91FFFFFEDFFFFFFFFFF8877FFF0001FFF"
		 for $k=1 to 70
			$char = stringmid($currentChar,$k,1)
			$refChar = stringmid($ref,$k,1)
			$deltaChar = abs(Number("0x"&$char) - Number("0x"&$refChar,1))
			;ToolTip(""&$deltaChar & " = " & Number(Dec($char,1)) & " - " & Number(Dec($refChar,1)))
			;sleep(100)
			if($deltaChar > $delta) Then
			   $delta = $deltaChar
			EndIf
		 Next

		 if($delta < 8) Then
			ToolTip("delta : " & $delta)
			sleep(100)
		 EndIf
		 #ce


		 if( $currentChar == "1BFFFEC1DFFFFF4FFFFFFFFF8FFFFF91FFFFF91FFFFFEDFFFFFFFFFF8877FFF0001FFF" ) Then
			;ToolTip("Found 4")
			$OCRResult &= "4"
			;ClipPut($currentChar)
			;sleep(1000)
		 EndIf
		 if( $currentChar == "28ACCCAFFFFFFFFFFFFFFFFBC7FFFF400EFFF230DFFF271DFFF020CFFF207EFFFFFFFF" ) Then
			;ToolTip("Found 0")
			;ClipPut($currentChar)
			$OCRResult &= "0"
			;sleep(1000)
		 EndIf
		 if( $currentChar == "AEFFFFFFFFFFFFFFF8210FFF6000FFF91B2FFFFFFF49CFFFF0005FFF15D7FFFFFFFFFF" ) Then
			$OCRResult &= "5"
		 EndIf
		 if( $currentChar == "AEFFFFFFFFFFFFFFF8210FFF6000FFF91B2FFFFFFF49CFFFF0005FFF15D7FFFFFFFFFF" ) Then
			$OCRResult &= "6"
		 EndIf
		 if( $currentChar == "DFFFFFBFFFFFFF99C8FFF0009FFF6A9EFFD64FFFFB68D1FFF2000CFF15B5FFFFFFFFFF" ) Then
			$OCRResult &= "3"
		 EndIf
		 if( $currentChar == "FFFFFFFFFFEFFFFFC1EFFFF70EFFFFFFFF6FFFFFFEFFDBEFFFF10FFFFF514FFFFFFFFF" ) Then
			$OCRResult &= "8"
		 EndIf
		 ; 6 = AEFFFFFFFFFFFFFFF8210FFF6000FFF91B2FFFFFFF49CFFFF0005FFF15D7FFFFFFFFFF
		 ; 3 = DFFFFFBFFFFFFF99C8FFF0009FFF6A9EFFD64FFFFB68D1FFF2000CFF15B5FFFFFFFFFF
		 ; 8 = FFFFFFFFFFEFFFFFC1EFFFF70EFFFFFFFF6FFFFFFEFFDBEFFFF10FFFFF514FFFFFFFFF


	  Next
   Next
   ToolTip("Found : " & $OCRResult)
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


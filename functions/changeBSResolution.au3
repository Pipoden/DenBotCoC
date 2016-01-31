#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         Den

 Script Function: Change BlueStacks Resolution

#ce ----------------------------------------------------------------------------

func changeBSResolution($width, $height)
	  ; check if resolution are already matching
	  $regWidth = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "GuestWidth")
	  $regHeight = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "GuestHeight")
	  $regWinWidth = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "WindowWidth")
	  $regWinHeight = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "WindowHeight")

	  ; change resolution in regedit
	  if ( ($regWidth <> $width) Or ($regHeight <> $height) Or ($regWinWidth <> $width) Or ($regWinHeight <> $height) ) Then
		 RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "GuestWidth", "REG_DWORD", $width )
		 RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "WindowWidth", "REG_DWORD", $width )
		 RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "GuestHeight", "REG_DWORD", $height )
		 RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0", "WindowHeight", "REG_DWORD", $height )

	  EndIf
	  ; HKEY_LOCAL_MACHINE/SOFTWARE/BlueStacks/Guests/Android/FrameBuffer/0/
	  ; HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0
	  ; Bot resolution : 860 x 720
endfunc


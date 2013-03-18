pkginstall
==========

shell script for installing packages via Mac OS X's `installer` program instead of GUI

### A note about quickly mounting DMGs

If you want to automatically mount a DMG without having to click 'yes' to an EULA (if one exists) you can use either use [FlashMount] or the `mntdmg` [shell script](mntdmg.sh) or [zsh function](mntdmg.f.zsh).

Note that under Mac OS X 10.8 you'll need to bypass GateKeeper for FlashMount by control-clicking it and choosing 'Open'. You will only need to do that once:


<img 
	width="420" height="234" border="0" 
	alt='[GateKeeper Warning for FlashMount]' 
	src="https://raw.github.com/tjluoma/pkginstall/master/FlashMountGateKeeperWarning.jpg" 
/>





[FlashMount]: http://www.tuaw.com/2011/12/30/daily-mac-app-flashmount-quickly-mounts-disk-images/

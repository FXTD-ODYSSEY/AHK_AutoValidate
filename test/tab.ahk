Gui, Add, Tab3,, General|View|Settings
Gui Add, GroupBox, x10 y6 w120 h205 HwndGrpHwnd, 效率软件
Gui Add, CheckBox, x20 y23 w100 h25 +Checked vListary, Listary
Gui Add, CheckBox, y+5 w100 h25 +Checked vQTTabBar, QTTabBar
Gui Add, CheckBox, y+5 w100 h25 +Checked vDitto, Ditto
Gui Add, CheckBox, y+5 w100 h25 vWGesture, WGesture
Gui Add, CheckBox, y+5 w100 h25 vQuicker, Quicker
Gui Add, CheckBox, y+5 w100 h25 vTencentDesktop, 腾讯桌面管理
Gui Add, GroupBox, x135 y6 w120 h49, 代码编辑器
Gui Add, CheckBox, x143 y24 w102 h23 +Checked vVScode, VScode
Gui Add, GroupBox, x135 y66 w120 h80, 截取软件
Gui Add, CheckBox, x143 y86 w107 h23 +Checked vSnipaste, Snipaste
Gui Add, CheckBox, x143 y115 w107 h23 +Checked vScreenToGif, ScreenToGif
Gui Add, GroupBox, x135 y153 w120 h58, 播放器
Gui Add, CheckBox, x143 y176 w102 h23 +Checked vPotPlayer, Pot Player

Gui, Show
return
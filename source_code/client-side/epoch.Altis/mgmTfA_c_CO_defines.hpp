// Transport for Arma Defines

// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C
#define ST_GROUP_BOX       96
#define ST_GROUP_BOX2      112
#define ST_ROUNDED_CORNER  ST_GROUP_BOX + ST_CENTER
#define ST_ROUNDED_CORNER2 ST_GROUP_BOX2 + ST_CENTER

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4

////////////////
//Base Classes//
////////////////
class RscPicture
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_PICTURE;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "PuristaMedium";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.2;
    h = 0.15;
};

class MGMTFA_FOOTEROBJECTTEMPLATE
{
	access = 0;
	idc = -1;
	type = CT_STATIC;
	style = ST_LEFT;
	linespacing = 1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {0.3,0.6,0.4,.8};
	text = "";
	shadow = 2;
	font = "PuristaMedium";
	SizeEx = 0.03500;
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0;
	w = 0;   
};

class MGMTFA_BACKGROUNDOBJECTTEMPLATE
{ 
	type = CT_STATIC;
	idc = -1;
	style = ST_CENTER;
	shadow = 2;
	colorText[] = {1,1,1,1};
	font = "PuristaMedium";
	sizeEx = 0.02;
	colorBackground[] = { 0.5,0.7,0.2, 0.9 };
	text = "";
};

class MGMTFA_PICBUTTON
{
	type = 16;
	idc = -1;
	style = 0;
	default = 0;
	x = 0.1;
	y = 0.1;
	w = 0.183825;
	h = 0.104575;
	color[] = {0.543, 0.5742, 0.4102, 1.0};
	color2[] = {0.95, 0.95, 0.95, 1};
	colorBackground[] = {1, 1, 1, 1};
	colorbackground2[] = {1, 1, 1, 1};
	colorDisabled[] = {1, 1, 1, 0.25};
	periodFocus = 1.2;
	periodOver = 0.8;

	class HitZone
	{
		left = 0.004;
		top = 0.029;
		right = 0.004;
		bottom = 0.029;
	};

	class ShortcutPos
	{
		left = 0.0145;
		top = 0.026;
		w = 0.0392157;
		h = 0.0522876;
	};

	class TextPos
	{
		left = 0.05;
		top = 0.034;
		right = 0.005;
		bottom = 0.005;
	};

	textureNoShortcut = "";
	animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
	animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
	animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";
	period = 0.4;
	font = "PuristaMedium";
	size = 0.03921;
	sizeEx = 0.03921;
	text = "custom\mgmTfA\img\9a_shared_btn_exit.paa";
	soundEnter[] = {"",0.09,1};
	soundPush[] = {"",0.0,0};
	soundClick[] = {"",0.07,1};
	soundEscape[] = {"",0.09,1};
	// default = no action && no toolTip
	action = "";
	toolTip = "";
	access = 0;
	colorText[] = {0.5,0.3,0.9,.9};
	colorBackgroundDisabled[] = {0,0.0,0};
	colorBackgroundActive[] = {0.15,0.35,0.55,0.7};
	colorFocused[] = {0.75,0.75,0.75,.5};
	colorBackgroundFocused[] = { 1, 1, 1, 0 };  
	colorShadow[] = {0.023529,0,0.0313725,1};
	colorBorder[] = {0.023529,0,0.0313725,1};
	//shadow = 2;
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;

	class Attributes
	{
		font = "PuristaMedium";
		color = "#E5E5E5";
		align = "left";
		shadow = "true";
	};

	class AttributesImage
	{
		font = "PuristaMedium";
		color = "#E5E5E5";
		align = "left";
		shadow = "true";
	};
};

// background image for the buttons
class MGMTFA_TEMPLATEBUTTONPIC
{
	// standard bit - these below should stay the same for each TfA button
	type = 0; // CT_STATIC 
	style = 48; // ST_PICTURE 
	idc = 10500; // IDC required, as image (text) will be changed
	x = 0.634062 * safezoneW + safezoneX;
	y = 0.555009 * safezoneH + safezoneY;
	w = 0.0567187 * safezoneW;
	h = 0.0770126 * safezoneH;
	colorBackground[] = {0,0,0,0};
	// white
	colorText[] = {1,1,1,1};
	font = "PuristaMedium"; 
	sizeEx = .1;
	// filename, volume, pitch
	soundEnter[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",1,1};
	soundPush[] = {"\A3\ui_f\data\sound\CfgNotifications\taskCreated",1,1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",1,1};
	soundEscape[] = {"\A3\ui_f\data\sound\ReadOut\ReadoutHideClick1",1,1};
	// dynamic bit -- these below should be customized for each individual button
	text = "custom\mgmTfA\img\mgmTfA_c_CO_img_guibtnPayNow.jpg";
};

class MGMTFA_TEMPLATEACTUALBUTTON: MGMTFA_TEMPLATEBUTTONPIC
{
	// standard bit - these below should stay the same for each TfA button
	type = 1;
	style = 0;
	idc = -1;
	colorText[] = {0,0,0,0};
	colorBackground[] = {0,0,0,0};
	colorFocused[] = {0,0,0,0};
	colorBackgroundActive[] = {0,0,0,0};
	colorDisabled[] = {0,0,0,0};
	colorBackgroundDisabled[] = {0,0,0,0};
	colorShadow[] = {0,0,0,0};
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	borderSize = 0;
	colorBorder[] = {};

	// dynamic bit -- these below should be customized for each individual button
	tooltip = "PAY NOW";
	text = "custom\mgmTfA\img\mgmTfA_c_CO_img_guibtnPayNow.jpg";
	action = "CloseDialog 0;";
	x = 0.634062 * safezoneW + safezoneX;
	y = 0.555009 * safezoneH + safezoneY;
	w = 0.0567187 * safezoneW;
	h = 0.0770126 * safezoneH;
};
// EOF
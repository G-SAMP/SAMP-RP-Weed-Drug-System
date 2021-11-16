/*
====================================
=== Created On - 2021 ==============
=== Created By - DeViL =============
=== Github - DeViL252   ============
=== Discord - DeViL#7091 ===========
=== Last Update By - DeViL =========
=== Last Updated On - 17/05/2021 ===
====================================
*/

/*
Commands :- /weed [plant/harvest/rip] , /inventory (/items,/inv), /giveitem [WeedSeed/Weed/Water]
Weed Fields :- TR-Bayside Tunnel Hills
*/


#define FILTERSCRIPT

#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <streamer>


#define COLOR_WEED_ORANGE 0xf58e20FF
#define COLOR_WEED_YELLOW 0xede02bFF
#define COLOR_WEED_GREEN 0x9ded2dFF
#define COLOR_ERROR 0xedb27eFF
#define COLOR_LIGHT_BLUE 0x6feddcFF

#define DIALOG_INVENTORY 200

#undef MAX_PLAYERS
#define MAX_PLAYERS 50 // SET TO MAX SERVER SLOT
#define SCM SendClientMessage
#define SM SendClientMessageEx
#define function:%0(%1) forward %0(%1); public %0(%1)


new PlayerItem[MAX_PLAYERS][3];
new TRWeedField;
new Text3D:WeedField3D[10000];
new WeedFieldTimer[10000];
new STREAMER_TAG_OBJECT:WeedFieldObject[10000];
new WeedFieldCount;


public OnFilterScriptInit()
{
	print("\n---------------------------------");
	print(" Weed has been loaded by DeViL.");
	print("-----------------------------------\n");

	TRWeedField = CreateDynamicRectangle(-1739.6445,2833.8943, -2166.8450,2702.3608);
	SetTimer("OnTRWeedCheckState", 5000, true);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	SetPlayerPosFindZ(playerid, fX, fY, fZ);
	SCM(playerid, COLOR_LIGHT_BLUE, "You have been teleported to marked location.");
	return 0;
}

CMD:weed(playerid, params[])
{
	new select[12];
	if(sscanf(params, "s[12]", select))
		return SendClientMessage(playerid, COLOR_ERROR, "[Usage]: /weed [plant/harvest/rip]");
	else if(!IsPlayerInDynamicArea(playerid, TRWeedField))
	{
		return SendClientMessage(playerid, COLOR_ERROR, "You are not at weed field to plant weed.");
	}
	else
	{
		if(strfind(select, "plant", true) != -1)
		{
			new Float:x, Float:y, Float:z;
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x, y, z);
			if(WeedFieldCount > 10000)
			{
				return SendClientMessage(playerid, COLOR_ERROR, "You can't plant more weed seed at this field.");
			}
			else if(PlayerItem[playerid][0] == 0)
			{
				return SCM(playerid, COLOR_ERROR, "You don't have enough weed seed to plant weed.");
			}

			for(new i=0; i < 10000; i++)
			{
				GetDynamicObjectPos(WeedFieldObject[i], x1, y1, z1);
				if(IsPlayerInRangeOfPoint(playerid, 2.0, x1, y1, z1))
				{
					return SendClientMessage(playerid, COLOR_ERROR, "You cannot plant a weed seed near a weed plant.");
				}
				else if( WeedField3D[i] == Text3D:0 && WeedFieldObject[i] == 0)
				{
					WeedFieldTimer[i] = 1;
					PlayerItem[playerid][0] -= 1;
					ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, 0, 1, 1, 0, 0, 1);
					WeedField3D[i] = CreateDynamic3DTextLabel("Seeding", COLOR_WEED_ORANGE, x, y, z, 5.0);
					WeedFieldCount += 1;
					WeedFieldObject[i] = CreateDynamicObject(2247, x, y, z-1, 0, 0, 0);
					return SendClientMessage(playerid, COLOR_LIGHT_BLUE, "You just plant a weed seed.");
				}
			}
			return SendClientMessage(playerid, COLOR_ERROR, "You cannot plant more weed seed at this weed field.");
		}
		else if(strfind(select, "water", true) != -1)
		{
			if(PlayerItem[playerid][1] == 0)
			{
				return SCM(playerid, COLOR_ERROR, "You don't have enough water.");
			}
			for(new i=0; i < 10000; i++)
			{
				new Float:x2, Float:y2, Float:z2;
				GetDynamicObjectPos(WeedFieldObject[i], x2, y2, z2);
				if(IsPlayerInRangeOfPoint(playerid, 2.0, x2, y2, z2))
				{
					if(WeedFieldTimer[i] != 21)
					{
						return SCM(playerid, COLOR_ERROR, "Plant won't need water.");
					}
					else
					{
						PlayerItem[playerid][1] -= 1;
						WeedFieldTimer[i]++;
						UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 5\%");
						return SendClientMessage(playerid, COLOR_LIGHT_BLUE, "You just give water to weed plant.");
					}
				}
			}
			return SCM(playerid, COLOR_ERROR, "You are not near at weed plant to watering.");
		}
		else if(strfind(select, "harvest", true) != -1)
		{
			for(new i=0; i < 10000; i++)
			{
				new Float:x3,Float:y3,Float:z3;
				GetDynamicObjectPos(WeedFieldObject[i], x3, y3, z3);
				if(IsPlayerInRangeOfPoint(playerid, 2.0, x3, y3, z3))
				{
					if(WeedFieldTimer[i] == 61)
					{
						ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, 0, 1, 1, 0, 0, 1);
						DestroyDynamicObject(WeedFieldObject[i]);
						DestroyDynamic3DTextLabel(WeedField3D[i]);
						PlayerItem[playerid][2] += 8;
						WeedFieldObject[i] = 0;
						WeedField3D[i] = Text3D:0;
						WeedFieldTimer[i] = 0;
						WeedFieldCount -= 1;
						return SendClientMessage(playerid, COLOR_LIGHT_BLUE, "You harvest a weed plant and got 8 gram weed.");
					}
					else
					{
						return SCM(playerid, COLOR_ERROR, "Plant has not ready yet to harvest.");
					}
				}
			}
			return SCM(playerid, COLOR_ERROR, "You are not near a weed plant to harvest.");
		}
		else if(strfind(select, "rip", true) != -1)
		{
			for(new i=0;i<10000;i++)
			{
				new Float:x4, Float:y4, Float:z4;
				GetDynamicObjectPos(WeedFieldObject[i], x4, y4, z4);
				if(IsPlayerInRangeOfPoint(playerid, 2.0, x4, y4, z4))
				{
					ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, 0, 1, 1, 0, 0, 1);
					DestroyDynamicObject(WeedFieldObject[i]);
					DestroyDynamic3DTextLabel(WeedField3D[i]);
					WeedFieldObject[i] = 0;
					WeedField3D[i] = Text3D:0;
					WeedFieldTimer[i] = 0;
					WeedFieldCount -= 1;
					return SendClientMessage(playerid, COLOR_LIGHT_BLUE, "You just ripped weed plant.");
				}
			}
			return SendClientMessage(playerid, COLOR_ERROR, "You are not near a weed plant to rip.");
		}
	}
	return 1;
}

// ---- EXTRA WORK ----

// CMD:am(playerid, params[])
// {
// 	new stringlib[32], stringam[32];
// 	if(sscanf(params, "s[32]s[32]", stringlib, stringam))
// 		return SendClientMessage(playerid, COLOR_ERROR, "[Usage]: /am [LIB] [ANIMATION]");

// 	ApplyAnimation(playerid, stringlib, stringam, 4.1, 0, 1, 1, 0, 0, 1);
// 	return 1;
// }


function:OnTRWeedCheckState()
{
	for(new i=0; i<10000; i++)
	{
		if(WeedFieldTimer[i] == 1)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 5\%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 2)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 10\%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 3)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 15\%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 4)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 20\%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 5)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 25%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 6)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 30%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 7)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 35%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 8)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 40%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 9)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 45%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 10)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 50%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 11)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 55%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 12)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 60%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 13)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 65%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 14)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 70%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 15)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 75%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 16)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 80%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 17)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 85%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 18)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 90%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 19)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 95%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 20)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_ORANGE, "Seeding\nStage: 100%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 21)
		{
			new Float:x, Float:y, Float:z;
			GetDynamicObjectPos(WeedFieldObject[i], x, y, z);
			DestroyDynamicObject(WeedFieldObject[i]);
			WeedFieldObject[i] = CreateDynamicObject(806, x, y, z, 0, 0, 0);
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Need Water");
		}
		else if(WeedFieldTimer[i] == 22)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 10%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 23)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 15%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 24)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 20%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 25)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 25%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 26)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 30%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 27)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 35%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 28)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 40%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 29)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 45%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 30)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 50%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 31)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 55%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 32)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 60%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 33)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 65%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 34)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 70%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 35)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 75%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 36)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 80%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 37)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 85%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 38)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 90%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 39)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 95%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 40)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_YELLOW, "Watering\nStage: 100%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 41)
		{
			new Float:x2, Float:y2, Float:z2;
			GetDynamicObjectPos(WeedFieldObject[i], x2, y2, z2);
			DestroyDynamicObject(WeedFieldObject[i]);
			WeedFieldObject[i] = 0;
			WeedFieldObject[i] = CreateDynamicObject(19473, x2, y2, z2, 0, 0, 0);
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 5%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 42)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 10%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 43)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 15%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 44)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 20%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 45)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 25%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 46)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 30%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 47)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 35%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 48)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 40%");
		 	WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 49)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 45%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 50)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 50%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 51)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 55%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 52)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 60%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 53)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 65%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 54)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 70%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 55)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 75%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 56)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 80%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 57)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 85%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 58)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 90%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 59)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Flowering\nStage: 95%");
			WeedFieldTimer[i]++;
		}
		else if(WeedFieldTimer[i] == 60)
		{
			UpdateDynamic3DTextLabelText(WeedField3D[i], COLOR_WEED_GREEN, "Done\nStage: Ready");
			WeedFieldTimer[i]++;
		}
	}
	return 1;
}


// ---- EXTRA WORK -----

CMD:giveitem(playerid, params[])
{
	new targetid, item[32], amount;
	if(sscanf(params, "is[32]i", targetid, item, amount))
		return SendClientMessage(playerid, COLOR_ERROR, "[Usage]: /giveitem [playerid/name] [item] [amount]");
	else if(!IsPlayerAdmin(playerid))
		return SCM(playerid, COLOR_ERROR, "You are not rcon login to use this command.");
	else if(amount <= 0)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: You entered invaild amount.");
	else if(targetid < 0 || targetid > MAX_PLAYERS)
		return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: You entered invaild targetid.");
	if(strfind(item, "WeedSeed", true) != -1)
	{
		PlayerItem[targetid][0] += amount;
		SM(targetid, COLOR_LIGHT_BLUE, "You got %i Weed Seed.", amount);
	}
	else if(strfind(item, "Water", true) != -1)
	{
		PlayerItem[targetid][1] += amount;
		SM(targetid, COLOR_LIGHT_BLUE, "You got %i Water.", amount);
	}
	else if(strfind(item, "Weed", true) != -1)
	{	
		PlayerItem[targetid][2] += amount;
		SM(targetid, COLOR_LIGHT_BLUE, "You got %i Weed.", amount);
	}
	return 1;
}

CMD:inventory(playerid, params[])
{
	new string[128];
	new empty;
	for(new i=0;i<3;i++)
	{
		if(PlayerItem[playerid][i] > 0)
		{
			new string2[32];
			format(string2, sizeof(string2), "%s\t\t%i\n", ReturnItemName(i),PlayerItem[playerid][i]);
			strcat(string, string2);
		}
		else if(PlayerItem[playerid][i] == 0)
		{
			empty++;
		}
		else if(empty == 3)
		{
			return SM(playerid, COLOR_ERROR, "You do not have any item on your inventory.");
		}
	}
	ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST, "Inventory", string, "Okay", "Close");
	return 1;
}
CMD:items(playerid, params[]) return callcmd::inventory(playerid, params);
CMD:inv(playerid, params[]) return callcmd::inventory(playerid, params);

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[156]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args
 
	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
 
	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 156
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format
 
		SendClientMessage(playerid, color, string);
 
		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}

stock ReturnName(playerid, underScore = 1)
{
	new playersName[MAX_PLAYER_NAME + 2];
	GetPlayerName(playerid, playersName, sizeof(playersName));
 
	if(!underScore)
	{
		{
			for(new i = 0, j = strlen(playersName); i < j; i ++)
			{
				if(playersName[i] == '_')
				{
					playersName[i] = ' ';
				}
			}
		}
	}
 
	return playersName;
}

stock ReturnItemName(item)
{
	new string[24];
	switch(item)
	{
		case 0: string = "Weed Seed";
		case 1: string = "Water";
		case 2: string = "Weed";
	}
	return string;
}


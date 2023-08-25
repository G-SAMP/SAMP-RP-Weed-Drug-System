#include <YSI_Coding\y_hooks>

timer OnWeedCheckState[1000](){
	new isAnyActivePlant = -1;

	foreach(new i : g_WeedPlant){
		isAnyActivePlant++;

		if(g_WeedPlantInfo[i][e_weed_plant_timer] >= 0 && g_WeedPlantInfo[i][e_weed_plant_timer] <= 19){ // Seeding
			g_WeedPlantInfo[i][e_weed_plant_timer]++;
			new weedstring[100];
			format(weedstring, sizeof(weedstring), "Weed\nState: Seeding\nProgress: %i%", g_WeedPlantInfo[i][e_weed_plant_timer]);
			UpdateDynamic3DTextLabelText(g_WeedPlantInfo[i][e_weed_plant_textlabel], COLOR_WEED_ORANGE, weedstring);
		}

		else if(g_WeedPlantInfo[i][e_weed_plant_timer] == 20){ // Needs water
			g_WeedPlantInfo[i][e_weed_plant_timer]++;
			new Float:x, Float:y, Float:z;
			GetDynamicObjectPos(g_WeedPlantInfo[i][e_weed_plant_object], x, y, z);
			DestroyDynamicObject(g_WeedPlantInfo[i][e_weed_plant_object]);
			g_WeedPlantInfo[i][e_weed_plant_object] = CreateDynamicObject(806, x, y, z, 0, 0, 0);
			new weedstring[100];
			format(weedstring, sizeof(weedstring), "Weed\nState: Needs Water\nProgress: %i%", g_WeedPlantInfo[i][e_weed_plant_timer]);
			UpdateDynamic3DTextLabelText(g_WeedPlantInfo[i][e_weed_plant_textlabel], COLOR_WEED_ORANGE, weedstring);
		}

		else if(g_WeedPlantInfo[i][e_weed_plant_timer] == 21){ // Need Water
			UpdateDynamic3DTextLabelText(Text3D:g_WeedPlantInfo[i][e_weed_plant_timer], COLOR_WEED_ORANGE, "Weed\nState: Needs Water\nProgress: 21%");
		}

		else if(g_WeedPlantInfo[i][e_weed_plant_timer] >= 22 && g_WeedPlantInfo[i][e_weed_plant_timer] <= 40){ // Watering
			g_WeedPlantInfo[i][e_weed_plant_timer]++;
			new weedstring[100];
			format(weedstring, sizeof(weedstring), "Weed\nState: Watering\nProgress: %i%", g_WeedPlantInfo[i][e_weed_plant_timer]);
			UpdateDynamic3DTextLabelText(Text3D:g_WeedPlantInfo[i][e_weed_plant_textlabel], COLOR_WEED_YELLOW, weedstring);
		}

		else if(g_WeedPlantInfo[i][e_weed_plant_timer] == 41){ // Vegetative
			new Float:x2, Float:y2, Float:z2;
			g_WeedPlantInfo[i][e_weed_plant_timer]++;
			GetDynamicObjectPos(g_WeedPlantInfo[i][e_weed_plant_object], x2, y2, z2);
			DestroyDynamicObject(g_WeedPlantInfo[i][e_weed_plant_object]);
			g_WeedPlantInfo[i][e_weed_plant_object] = CreateDynamicObject(19473, x2, y2, z2, 0, 0, 0);
			new weedstring[100];
			format(weedstring, sizeof(weedstring), "Weed\nState: Vegetative\nProgress: %i%", g_WeedPlantInfo[i][e_weed_plant_timer]);
			UpdateDynamic3DTextLabelText(g_WeedPlantInfo[i][e_weed_plant_textlabel], COLOR_WEED_YELLOW, weedstring);
		}
        
		else if(g_WeedPlantInfo[i][e_weed_plant_timer] >= 42 && g_WeedPlantInfo[i][e_weed_plant_timer] <= 80) // Vegetative
		{
			g_WeedPlantInfo[i][e_weed_plant_timer]++;
			new weedstring[100];
			format(weedstring, sizeof(weedstring), "Weed\nState: Vegetative\nProgress: %i%", g_WeedPlantInfo[i][e_weed_plant_timer]);
			UpdateDynamic3DTextLabelText(g_WeedPlantInfo[i][e_weed_plant_textlabel], COLOR_WEED_GREEN, weedstring);
		}
		else if(g_WeedPlantInfo[i][e_weed_plant_timer] >= 81 && g_WeedPlantInfo[i][e_weed_plant_timer] <= 99) // Flowering
		{
			g_WeedPlantInfo[i][e_weed_plant_timer]++;
			new weedstring[100];
			format(weedstring, sizeof(weedstring), "Weed\nState: Flowering\nProgress: %i%", g_WeedPlantInfo[i][e_weed_plant_timer]);
			UpdateDynamic3DTextLabelText(g_WeedPlantInfo[i][e_weed_plant_textlabel], COLOR_WEED_GREEN, weedstring);
		}
		else if(g_WeedPlantInfo[i][e_weed_plant_timer] >= 100) // Done
		{
			UpdateDynamic3DTextLabelText(g_WeedPlantInfo[i][e_weed_plant_textlabel], COLOR_WEED_GREEN, "Weed\nState: Flowering\nProgress: Done");
		}
    }

	if(isAnyActivePlant == -1){
		stop g_WeedFieldTimer;
		printf("No active plant weed timer closed!");
	}

    return 1;
}

hook OnGameModeInit(){
	Iter_Init(g_WeedPlant);

    g_WeedField[e_weed_field_angelpine_beach][e_weed_field_info_id] = CreateDynamicPolygon(g_AngelPine_Points);
    g_WeedField[e_weed_field_bayside_hill][e_weed_field_info_id] = CreateDynamicPolygon(g_Bayside_Hill_Points);
    g_WeedField[e_weed_field_missionary_hill][e_weed_field_info_id] = CreateDynamicPolygon(g_Missionary_Hill_Points);
    g_WeedField[e_weed_field_mount_chiliad][e_weed_field_info_id] = CreateDynamicPolygon(g_Mount_Chiliad_Points);
    g_WeedField[e_weed_field_ocean_flats][e_weed_field_info_id] = CreateDynamicPolygon(g_Ocean_Flats_Points);
    g_WeedField[e_weed_field_sherman_hill][e_weed_field_info_id] = CreateDynamicPolygon(g_Sherman_Hill_Points);
    g_WeedField[e_weed_field_thefarm][e_weed_field_info_id] = CreateDynamicPolygon(g_The_Farm_Points);
    g_WeedField[e_weed_field_tr_hill][e_weed_field_info_id] = CreateDynamicPolygon(g_TR_Hill_Points);
    g_WeedField[e_weed_field_tr_town][e_weed_field_info_id] = CreateDynamicPolygon(g_TR_Town_Points);

	g_WeedFieldTimer = repeat OnWeedCheckState();

    printf(" =================== WEED SCRIPT LOADED ================= ");
    printf(" ============== Discord & Github (galaxone) =============")
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid){
    for(new i=0; i < _:E_WEED_FIELD_INFO; i++){
		if(areaid == g_WeedField[E_WEED_FIELD_INFO:i][e_weed_field_info_id]){
			SendClientMessageEx(playerid, -1, "You have enter the %s Weed Field area.", g_WeedField[E_WEED_FIELD_INFO:i][e_weed_field_info_name]);
		}
	}
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid){
    for(new i=0; i < _:E_WEED_FIELD_INFO; i++){
		if(areaid == g_WeedField[E_WEED_FIELD_INFO:i][e_weed_field_info_id]){
			SendClientMessageEx(playerid, -1, "You have left the %s Weed Field area.", g_WeedField[E_WEED_FIELD_INFO:i][e_weed_field_info_name]);
		}
	}
    return 1;
}

@cmd() totalweedplant(playerid, params[], helpcmd){
	SendClientMessageEx(playerid, COLOR_ERROR, "Total Weed Plant: %d", g_TotalWeedPlant);
	return 1;
}


@cmd() weed(playerid, params[], helpcmd){
	new select[12];
	if(sscanf(params, "s[12]", select)) return SendClientMessage(playerid, COLOR_ERROR, "Correct usage: /weed [plant|harvest|rip]");
	else if(!IsPlayerAtWeedField(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "You are not at a Weed Field.");
	else{

		if(strfind(select, "plant", true) != -1){
            
			new Float:x, Float:y, Float:z;
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x, y, z);

			if(g_TotalWeedPlant > MAX_WEED_PLANT) return SendClientMessage(playerid, COLOR_ERROR, "The server has reached the maximum amount of plants.");
			else if(g_PlayerInventory[playerid][e_inventory_weedSeeds] <= 0) return SendClientMessage(playerid, COLOR_ERROR, "You don't have enough Weed Seeds to plant Weed.");

			new i = 0;
			foreach(new plant : g_WeedPlant){
				GetDynamicObjectPos(g_WeedPlantInfo[plant][e_weed_plant_object], x1, y1, z1);
				if(IsPlayerInRangeOfPoint(playerid, 2.0, x1, y1, z1)) return SendClientMessage(playerid, COLOR_ERROR, "You can't plant a seed near a weed plant.");
				
				if(i == plant){ // checks if already exists
					SendClientMessageEx(playerid, COLOR_ERROR, "Plant ID: %d exists..", plant);
					i++;
				}
			}
			SendClientMessageEx(playerid, COLOR_ERROR, "Plant ID: %d empty..", i);

			g_TotalWeedPlant++;
			Iter_Add(g_WeedPlant, i);

			g_WeedPlantInfo[i][e_weed_plant_timer] = 1;
			g_PlayerInventory[playerid][e_inventory_weedSeeds] -= 1;
	
			ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, 0, 1, 1, 0, 0, t_FORCE_SYNC:1);
			g_WeedPlantInfo[i][e_weed_plant_textlabel] = CreateDynamic3DTextLabel("Weed\nState: Seeding\nProgress: 0", COLOR_WEED_ORANGE, x, y, z, 8.5);
			g_WeedPlantInfo[i][e_weed_plant_object] = CreateDynamicObject(2247, x, y, z-1, 0, 0, 0);


			if(!Timer_IsRunning(g_WeedFieldTimer)){
				g_WeedFieldTimer = repeat OnWeedCheckState();
			}

			return SendClientMessage(playerid, PLAYER_LOG_COLOR, "You planted a weed seed.");
		}


		else if(strfind(select, "water", true) != -1){
			if(g_PlayerInventory[playerid][e_inventory_water] <= 0) return SendClientMessage(playerid, COLOR_ERROR, "You don't have enough water.");
			
            foreach(new plant : g_WeedPlant){
				new Float:x2, Float:y2, Float:z2;
				GetDynamicObjectPos(g_WeedPlantInfo[plant][e_weed_plant_object], x2, y2, z2);

				if(IsPlayerInRangeOfPoint(playerid, 2.0, x2, y2, z2)){
					if(g_WeedPlantInfo[plant][e_weed_plant_timer] == 21){
						g_PlayerInventory[playerid][e_inventory_water] -= 1;
						g_WeedPlantInfo[plant][e_weed_plant_timer]++;
						UpdateDynamic3DTextLabelText(Text3D:g_WeedPlantInfo[plant][e_weed_plant_timer], COLOR_WEED_YELLOW, "Weed\nState: Watering\nProgress: 22");
						return SendClientMessage(playerid, PLAYER_LOG_COLOR, "You watered a weed plant.");
					}
					else{
						return SendClientMessage(playerid, COLOR_ERROR, "This plant doesn't need watering.");
					}
				}
			}
			return SendClientMessage(playerid, COLOR_ERROR, "You are not near a weed plant.");
		}


		else if(strfind(select, "harvest", true) != -1){

			foreach(new plant : g_WeedPlant){
				new Float:x3,Float:y3,Float:z3;
				GetDynamicObjectPos(g_WeedPlantInfo[plant][e_weed_plant_object], x3, y3, z3);
				
                if(IsPlayerInRangeOfPoint(playerid, 2.0, x3, y3, z3)){
					if(g_WeedPlantInfo[plant][e_weed_plant_timer] == 100){
						ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, 0, 1, 1, 0, 0, t_FORCE_SYNC:1);
						DestroyDynamicObject(g_WeedPlantInfo[plant][e_weed_plant_object]);
						DestroyDynamic3DTextLabel(g_WeedPlantInfo[plant][e_weed_plant_textlabel]);
						g_PlayerInventory[playerid][e_inventory_weed] += 8;
						g_PlayerInventory[playerid][e_inventory_weedSeeds] += 2;
						g_WeedPlantInfo[plant][e_weed_plant_object] = 0;
						g_WeedPlantInfo[plant][e_weed_plant_textlabel] = Text3D:0;
						g_WeedPlantInfo[plant][e_weed_plant_timer] = 0;
						g_TotalWeedPlant--;
						return SendClientMessage(playerid, PLAYER_LOG_COLOR, "You harvested a weed plant for 8 grams with 2 weed seeds.");
					}
					else{
						return SendClientMessage(playerid, COLOR_ERROR, "This plant is not ready to harvest.");
					}
				}
			}
			return SendClientMessage(playerid, COLOR_ERROR, "You are not near a weed plant.");
		}


		else if(strfind(select, "rip", true) != -1){

			foreach(new plant : g_WeedPlant){
				new Float:x4, Float:y4, Float:z4;
				GetDynamicObjectPos(g_WeedPlantInfo[plant][e_weed_plant_object], x4, y4, z4);

				if(IsPlayerInRangeOfPoint(playerid, 2.0, x4, y4, z4)){
					ApplyAnimation(playerid, "BOMBER", "BOM_PLANT", 4.1, 0, 1, 1, 0, 0, t_FORCE_SYNC:1);
					DestroyDynamicObject(g_WeedPlantInfo[plant][e_weed_plant_object]);
					DestroyDynamic3DTextLabel(g_WeedPlantInfo[plant][e_weed_plant_textlabel]);
					g_WeedPlantInfo[plant][e_weed_plant_object] = 0;
					g_WeedPlantInfo[plant][e_weed_plant_textlabel] = Text3D:0;
					g_WeedPlantInfo[plant][e_weed_plant_timer] = 0;

					g_TotalWeedPlant--;

					Iter_Remove(g_WeedPlant, plant);
				}
			}
			return SendClientMessage(playerid, COLOR_ERROR, "You are not near a weed plant.");
		}
	}
	return 1;
}


// WEED FUNCTIONS
forward IsPlayerAtWeedField(playerid);
public IsPlayerAtWeedField(playerid){
    for(new i = 0; i < _:E_WEED_FIELD_INFO; i++){
        if(IsPlayerInDynamicArea(playerid, g_WeedField[E_WEED_FIELD_INFO:i][e_weed_field_info_id])){
            return 1;
        }
    }
    return 0;
}
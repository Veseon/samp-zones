// generated by "sampctl package init"
#include <a_samp>

#include <mapzones>

#if !defined FLOAT_INFINITY
	#define FLOAT_INFINITY Float:0x7F800000
#endif

#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#define TEAM_ADMIN 255

static const AdminName[] = "Veseon";

static AdminVehicle = INVALID_VEHICLE_ID;
static AdminPlayer = INVALID_PLAYER_ID;
static AdminClass = -1;

static PlayerClassRequested[MAX_PLAYERS] = {-1, ...};

static PlayerText:PlayerLocationTD[MAX_PLAYERS] = {INVALID_PLAYER_TEXT_DRAW};

main() 
{
	// write code here and run "sampctl package build" to compile
	// then run "sampctl package run" to run it
}

public OnGameModeInit()
{
	AddPlayerClass(230, 0.0, 0.0, 5.0, random(360), 0, 0, 0, 0, 0, 0);
	AdminClass = AddPlayerClassEx(TEAM_ADMIN, 101, 0.0, 0.0, 5.0, random(360), 24, cellmax, 25, cellmax, 31, cellmax);
	return 1;
}

public OnPlayerConnect(playerid)
{
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof name);
	if(strcmp(name, AdminName) == 0)
	{
		AdminPlayer = playerid;
		CreateAdminVehicle(AdminVehicle);

		new adminMessage[128];
		format(adminMessage, sizeof adminMessage, "Welcome back, {1E90FF}Administrator {FFFFFF}%s!", name);
		SendClientMessage(playerid, -1, adminMessage);
	}
	SetSpawnInfo(playerid, NO_TEAM, 101, 0.0, 0.0, 5.0, 0.0, 0, 0, 0, 0, 0, 0);

	if(CreateLocationTextDraw(playerid, PlayerLocationTD[playerid]))
	{
		PlayerTextDrawShow(playerid, PlayerLocationTD[playerid]);
	}

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(playerid == AdminPlayer)
	{
		AdminPlayer = INVALID_PLAYER_ID;
		DestroyVehicle(AdminVehicle);
		AdminVehicle = INVALID_VEHICLE_ID;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!isnull(cmdtext))
	{
		if(playerid == AdminPlayer)
		{
			if(strcmp(cmdtext, "/goadminveh") == 0)
			{
				SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(AdminVehicle));
				PutPlayerInVehicle(playerid, AdminVehicle, 0);
				return 1;
			}
			if(strcmp(cmdtext, "/getadminveh") == 0)
			{
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				SetVehiclePos(AdminVehicle, x, y, z);
				SetVehicleVirtualWorld(AdminVehicle, GetPlayerVirtualWorld(playerid));
				LinkVehicleToInterior(AdminVehicle, GetPlayerInterior(playerid));
				PutPlayerInVehicle(playerid, AdminVehicle, 0);
				return 1;
			}
		}
	}
	return 0;
}

public OnPlayerRequestClass(playerid, classid)
{
	PlayerClassRequested[playerid] = classid;
	if(classid == AdminClass && playerid != AdminPlayer)
	{
		return 0;
	}
	else if(classid != AdminClass && playerid == AdminPlayer)
	{
		return 0;
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(PlayerClassRequested[playerid] == AdminClass && playerid != AdminPlayer)
	{
		SendClientMessage(playerid, -1, "This class is reserved, only {1E90FF}Administrator {FFFFFF}may use this!");
		return 0;
	}
	else if(PlayerClassRequested[playerid] != AdminClass && playerid == AdminPlayer)
	{
		SendClientMessage(playerid, -1, "You are the {1E90FF}Administrator{FFFFFF}, please use your reserved class.");
		return 0;
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER && playerid != AdminPlayer)
	{
		RemovePlayerFromVehicle(playerid);
		SendClientMessage(playerid, -1, "This vehicle is reserved, only {1E90FF}Administrator {FFFFFF}may drive this!");
	}
}

UpdatePlayerInfinite(playerid)
{
	SetPlayerHealth(playerid, FLOAT_INFINITY);
	SetPlayerArmour(playerid, FLOAT_INFINITY);
}

public OnPlayerSpawn(playerid)
{
	if(playerid == AdminPlayer)
	{
		SetPlayerSkillLevel(playerid, 24, 999);
		SetPlayerSkillLevel(playerid, 25, 999);
		SetPlayerSkillLevel(playerid, 31, 999);
		UpdatePlayerInfinite(playerid);
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(playerid == AdminPlayer)
	{
		UpdatePlayerInfinite(playerid);
		return 1;
	}
	return 0;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(playerid == AdminPlayer)
	{
		SetPlayerAmmo(playerid, weaponid, cellmax);
	}
	else if(hittype == BULLET_HIT_TYPE_PLAYER && hitid == AdminPlayer)
	{
		return 0;
	}
	return 1;
}

CreateAdminVehicle(&vehicleid)
{
	vehicleid = CreateVehicle(522, 10.0, 10.0, 5.0, random(360), 6, 7, -1, true);
	SetVehicleHealth(vehicleid, FLOAT_INFINITY);
	SetVehicleNumberPlate(vehicleid, "{1E90FF}ADMIN");
}

UpdateVehicleInfinite(vehicleid)
{
	UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
	SetVehicleHealth(vehicleid, FLOAT_INFINITY);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if(vehicleid == AdminVehicle)
	{
		UpdateVehicleInfinite(vehicleid);
	}
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	if(vehicleid == AdminVehicle)
	{
		UpdateVehicleInfinite(vehicleid);
		return 1;
	}
	return 0;
}

// ---

CreateLocationTextDraw(playerid, &PlayerText:textdraw)
{
	if((textdraw = CreatePlayerTextDraw(playerid, 43.000000, 311.000000, "_")) != INVALID_PLAYER_TEXT_DRAW)
	{
		PlayerTextDrawFont(playerid, textdraw, 1);
		PlayerTextDrawLetterSize(playerid, textdraw, 0.275000, 1.350000);
		PlayerTextDrawTextSize(playerid, textdraw, 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, textdraw, 1);
		PlayerTextDrawSetShadow(playerid, textdraw, 0);
		PlayerTextDrawAlignment(playerid, textdraw, 1);
		PlayerTextDrawColor(playerid, textdraw, -1);
		PlayerTextDrawBackgroundColor(playerid, textdraw, 255);
		PlayerTextDrawBoxColor(playerid, textdraw, 50);
		PlayerTextDrawUseBox(playerid, textdraw, 0);
		PlayerTextDrawSetProportional(playerid, textdraw, 1);
		PlayerTextDrawSetSelectable(playerid, textdraw, 0);
		return true;
	}
	return false;
}

UpdateLocationTextDraw(playerid, Zone:zoneid)
{
	if(zoneid == INVALID_ZONE_ID)
	{
		PlayerTextDrawSetString(playerid, PlayerLocationTD[playerid], "_");
		return;
	}

	new location[MAX_ZONE_NAME + 1];
	GetZoneName(zoneid, location, sizeof location);
	PlayerTextDrawSetString(playerid, PlayerLocationTD[playerid], location);
}

public OnPlayerEnterZone(playerid, Zone:zoneid)
{
	UpdateLocationTextDraw(playerid, zoneid);
}

public OnPlayerLeaveZone(playerid, Zone:zoneid)
{
	UpdateLocationTextDraw(playerid, INVALID_ZONE_ID);
}
#include <sourcemod>
#include <colors>
#include <geoip>

public Plugin:myinfo = 
{
	name        = "ConnectMessage",
	author      = "xtc",
	description = "Prints connect message featuring name, country, and Steam ID",
	version     = "0.0.1",
	url         = "parodybit.net"
}

public OnPluginStart()
{
	HookEvent("player_connect", Event_playerConnected);
}

public Action:Event_playerConnected(Handle:event, const String:name[], bool:dontBroadcast)
{
	// name:      xtc
	// index:     0
	// userid:    2
	// networkid: STEAM_0:0:8081854
	// address:   xxx.xxx.xxx.xxx:27005
	
	decl String:s_clientName[32],
	     String:s_networkID[32],
		 String:s_address[32],
		 String:s_country[46];
		 
	GetEventString(event, "name", s_clientName, sizeof(s_clientName));
	GetEventString(event, "networkid", s_networkID, sizeof(s_networkID));
	GetEventString(event, "address", s_address, sizeof(s_address));
	
	GeoipCountry(s_address, s_country, 45);
	
	if(!strcmp(s_country, NULL_STRING))
		s_country = "localhost";
	
	CPrintToChatAll("{green}Connected {default}%s from {olive}%s{default} ({lightgreen}%s{default})", s_clientName, s_country, s_networkID);
	
	return Plugin_Handled;
}
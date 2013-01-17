#include <sourcemod>

new g_bombPlantTime;
new g_bombDelayCVAR;

public Plugin:myinfo =
{
        name        = "DefuseTalk",
        author      = "xtc",
        description = "Relays various messages at the CT defusing the bomb varying on remaining time",
        version     = "0.0.1",
        url         = "parodybit.net"
}

public OnPluginStart()
{
        HookEvent("bomb_begindefuse", Event_bombDefuseStart);
        HookEvent("bomb_planted", Event_bombPlant);
}

public Action:Event_bombDefuseStart(Handle:event, const String:name[], bool:dontBroadcast)
{
        // array of messages to send to the defusee
        new const String:message[5][200] = {
                "You have more than enough time.",
                "You are extremely lucky!",
                "You might as well kill yourself. Should have been quicker.",
                "Too bad you didn't buy a defuse kit, you would have made it.",
                "Looks like you didn't need that defuse kit after all."
        }

        new i_client = GetClientOfUserId(GetEventInt(event, "userid"));
        new i_defuseTime = 10;
        new i_currentTime = GetTime();

        // with defuser = 5 seconds
        // w/out defuser = 10 seconds
        i_defuseTime = GetEntProp(i_client, Prop_Send, "m_bHasDefuser") ?  5 : 10;

        new i_elapsedTime   = i_currentTime - g_bombPlantTime;
        new i_timeRemaining = g_bombDelayCVAR - i_elapsedTime;

        switch (i_defuseTime)
        {
                case 5:
                {
                        if (i_defuseTime < i_timeRemaining)
                        {
                                PrintCenterText(i_client, message[4]);
                        }
                        else if (i_defuseTime > i_timeRemaining)
                        {
                                PrintCenterText(i_client, message[2]);
                        }
                        else if (i_defuseTime == i_timeRemaining)
                        {
                                PrintCenterText(i_client, message[1]);
                        }
                }
                case 10:
                {
                        if ((i_timeRemaining > 5) && (i_timeRemaining < 10))
                        {
                                PrintCenterText(i_client, message[3]);
                        }
                        else if (i_defuseTime < i_timeRemaining)
                        {
                                PrintCenterText(i_client, message[0]);
                        }
                        else if (i_defuseTime > i_timeRemaining)
                        {
                                PrintCenterText(i_client, message[2]);
                        }
                        else if (i_defuseTime == i_timeRemaining)
                        {
                                PrintCenterText(i_client, message[1]);
                        }
                }
        }
}

public Action:Event_bombPlant(Handle:event, const String:name[], bool:dontBroadcast)
{
        if (event == INVALID_HANDLE) return;

        g_bombPlantTime = GetTime();
        g_bombDelayCVAR = GetConVarInt(FindConVar("mp_c4timer"));
}

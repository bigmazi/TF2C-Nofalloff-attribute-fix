#pragma semicolon 1

#include <sdkhooks>
#include <sdktools>

#define PLUGIN_VERSION "1.1"

public Plugin myinfo = {
	name = "No falloff attribute replica",
	author = "bigmazi",
	description = "Replicates no-falloff attribute for RPG and Hunting Revolver",
	version = PLUGIN_VERSION,
	url = ""
};

#define RPG_INDEX 40
#define HUNTING_REVOLVER_INDEX 41

#define BASE_DAMAGE_POINT_SQR 262144.0

public OnPluginStart()
{		
	for(int c = 1; c <= MaxClients; c++)
	if (IsClientInGame(c)) SDKHook(c, SDKHook_OnTakeDamage, Hook_TakeDamage);
}

public OnClientPutInServer(c)
{
	SDKHook(c, SDKHook_OnTakeDamage, Hook_TakeDamage);
}

public Action Hook_TakeDamage(
		victim, &attacker, &inflictor, 
		float &damage, &damagetype, &weapon, 
		float damageForce[3], float damagePosition[3], damagecustom)
{
	if (IsValidEntity(weapon))
	{
		char cls[PLATFORM_MAX_PATH];
		GetEntityClassname(weapon, cls, PLATFORM_MAX_PATH);
		
		#define NDX(%1) GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex") == %1
		
		if (StrEqual(cls, "tf_weapon_rocketlauncher") && NDX(RPG_INDEX)
		||  StrEqual(cls, "tf_weapon_hunterrifle")    && NDX(HUNTING_REVOLVER_INDEX))
		{
			if (DistBetween_Sqr(victim, attacker) > BASE_DAMAGE_POINT_SQR)
			{
				damagetype &= ~DMG_USEDISTANCEMOD;
				return Plugin_Changed;
			}
		}
	}
	
	return Plugin_Continue;
}

#define ABS_ORIGIN(%1,%2) float %2[3]; GetEntPropVector(%1, Prop_Data, "m_vecAbsOrigin", %2)

float DistBetween_Sqr(x, y)
{
	ABS_ORIGIN(x, a);
	ABS_ORIGIN(y, b);
	float v[3];
	SubtractVectors(a, b, v);
	float dist_sqr = GetVectorLength(v, true);
	return dist_sqr;
}
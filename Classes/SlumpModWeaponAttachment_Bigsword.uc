/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
*
* Original Author: Michael Bao
*
* The weapon that is replicated to all clients: Longsword
*/
class SlumpModWeaponAttachment_Bigsword extends SlumpModWeaponAttachment_Zweihander;

simulated function float GetHandleTracerPercent(int i)
{
    local vector vStart, vMid, vEnd;
    local float HandleLength, WeaponLength;

    if (Mesh.GetSocketByName('TraceMid') == None)
    {
        return 0.0f;
    }
    Mesh.GetSocketWorldLocationAndRotation('TraceStart', vStart);
    Mesh.GetSocketWorldLocationAndRotation('TraceMid', vMid);
    Mesh.GetSocketWorldLocationAndRotation('TraceEnd', vEnd);

    WeaponLength = VSize(vEnd - vStart);
    HandleLength = VSize(vMid - vStart);

    return (HandleLength / WeaponLength)*1;
}

DefaultProperties
{

KickOffset=(X=50, Y=0, Z=-65)
	KickSize=20.f

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'Exesword.WEP_Exesword'
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'Exesword.WEP_Exesword'
	End Object

	WeaponID=EWEP_Longsword
	WeaponClass=class'SlumpModWeapon_Bigsword'
	WeaponSocket=wep2hpoint

	bUseAlternativeKick=true

	AttackTypeInfo(0)=(fBaseDamage=110.0, fForce=27200, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=110.0, fForce=27200, cDamageType="AOC.AOCDmgType_SwingBlunt", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=55.0, fForce=27200, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=0.0, fForce=32500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=36400, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)

Skins(0)={(
		SkeletalMeshPath="Exesword.WEP_Exesword",
		StaticMeshPath="Exesword.Mesh_Exesword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_longsword_png"
		)};
	Skins(1)={(
		SkeletalMeshPath="Exesword.WEP_Exesword",
		StaticMeshPath="Exesword.Mesh_Exesword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_hounds_longsword_png"
		)};
	Skins(2)={(
		SkeletalMeshPath="Exesword.WEP_Exesword",
		StaticMeshPath="Exesword.Mesh_Exesword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_styrian_png"
		)};
	Skins(3)={(
		SkeletalMeshPath="Exesword.WEP_Exesword",
		StaticMeshPath="Exesword.Mesh_Exesword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_ornamental_png"
		)};
	Skins(4)={(
		SkeletalMeshPath="Exesword.WEP_Exesword",
		StaticMeshPath="Exesword.Mesh_Exesword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_ornamental_png"
		)};
	Skins(5)={(
		SkeletalMeshPath="Exesword.WEP_Exesword",
		StaticMeshPath="Exesword.Mesh_Exesword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_ornamental_png"
		)};
	Skins(6)={(
		SkeletalMeshPath="Exesword.WEP_Exesword",
		StaticMeshPath="Exesword.Mesh_Exesword",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_ornamental_png"
		)};
}

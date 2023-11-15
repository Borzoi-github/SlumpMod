/**
* Copyright 2010-2012, Torn Banner Studios, All rights reserved
* 
* Original Author: Michael Bao
* 
* The Weapon Attachment for the Hunting Knife.
*/
class SlumpModWeaponAttachment_Rapier extends AOCWeaponAttachment_HuntingKnife;

DefaultProperties
{

KickOffset=(X=50, Y=0, Z=-65)
	KickSize=20.f

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'Rapier.Rapier'
		Scale=1.4
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'Rapier.Rapier'
		Scale=1.4
	End Object

	WeaponID=EWEP_BroadDagger
	WeaponClass=class'SlumpModWeapon_Rapier'
	WeaponSocket=wep1hpoint

	AttackTypeInfo(0)=(fBaseDamage=40.0, fForce=8000, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=50.0, fForce=8000, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=50.0, fForce=8000, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=36400, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)

	Skins(0)={(
		SkeletalMeshPath="Rapier.Rapier",
		StaticMeshPath="Rapier.Rapier_m",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_bardiche_png"
		)};
	Skins(1)={(
		SkeletalMeshPath="Rapier.Rapier",
		StaticMeshPath="Rapier.Rapier_m",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="UI_CustWeaponImages_SWF.skin_bardiche_png"
		)};
}

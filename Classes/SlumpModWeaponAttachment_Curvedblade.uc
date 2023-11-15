/**
    * For the quickest release, this only fixes the Socket issue on THIS weapon.
*/
class SlumpModWeaponAttachment_Curvedblade extends AOCWeaponAttachment_Messer;

/**
    * Avian - This is the start of chaos, destruction, and hatred for Michael Bao.
*/
const HorizontalFirstActiveTraceFrame = 3; // Avian - IF THE FIRST ACTIVE TRACE FRAME IS LESS THAN 3 FOR THE SCYTHE IT CAUSES ISSUES WITH THE INITIAL TRACERS, SO THIS FIXES THAT.
const NumHorizontalTracerPoints = 6;
const NumHorizontalAttackTracerPoints = 5;
var vector HorizontalPreviousTracePoints[NumHorizontalTracerPoints];
var vector HorizontalTracePoints[NumHorizontalTracerPoints];
var ETracerType HorizontalTracePointsType[NumHorizontalTracerPoints];

/**
    * Similar to the GetTracerSocketNames function, but overriding is a pain in the ass.
    * @param - HorizontalTracer for said Socket
    * @param - Iterated Tracer for said Socket, creates HorizontalTracer$i to keep track of each Tracer.
*/
simulated function SetHorizontalTracerNames(out name horizontalTracerName, int i) {
    horizontalTracerName = 'HorizontalTracer';
    if (i > 0)
    {
        horizontalTracerName = name(horizontalTracerName$i);
    }
}

/**
    * Similar to the PerformTracers function, however this gets only the Horizontal Tracers.
    * @param - Default Constant "NumTracerPoints".
*/
simulated function PerformHorizontalTracers(int NumTracers)
{
	local int i;
	local vector TraceSegmentDir;
	local vector ParryTraceLoc;
	local vector SwingDir;

	// Perform Tracers
	for(i = 0; i < NumTracers; i++)
	{
		SwingDir = i % 2 == 0 ? HorizontalTracePoints[i + 1] - HorizontalTracePoints[i] : HorizontalTracePoints[i] - HorizontalTracePoints[i - 1];

		// First frame parry tracers
		if (TraceFrame == HorizontalFirstActiveTraceFrame)
		{
			TraceSegmentDir = HorizontalTracePoints[i] - HorizontalPreviousTracePoints[i];
			TraceSegmentDir = Normal(TraceSegmentDir);
			ParryTraceLoc = HorizontalTracePoints[i] - TraceSegmentDir * ParryTracersLength;
			TestTracerSegment(HorizontalTracePoints[i], ParryTraceLoc, SwingDir, ETracerType_CheckParryOnly, i);
		}

		if (TraceFrame >= HorizontalFirstActiveTraceFrame)
		{
			TestTracerSegment(HorizontalTracePoints[i], HorizontalPreviousTracePoints[i], SwingDir, HorizontalTracePointsType[i], i);
		}

		HorizontalPreviousTracePoints[i] = HorizontalTracePoints[i];
	}

	DrawDebugPerformTracers();

	TraceFrame++;
}


simulated state Release
{
    simulated event Tick(float DeltaTime)
    {
		super.Tick(DeltaTime);
    }

    simulated event BeginState(name PreviousStateName)
    {
		super.BeginState(PreviousStateName);
    }

    simulated event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
	}

    simulated function DetermineAlternativeTracer()
	{
		super.DetermineAlternativeTracer();
	}

    simulated function PerformKickTracers(bool bAlt)
	{
		super.PerformKickTracers(bAlt);
	}

    simulated function RegularWeaponTracers()
	{
		/** Setup Variables */
		local int i, t, TraceIdx;
		local int TracePerSection;
		local name BeginTraceName;
		local name EndTraceName;
		local vector BeginTraceLoc;
		local vector EndTraceLoc;
		local vector TraceIncDir;		
		local float HandlePercent;

        // Avian - 4th Socket Shit
		local int HorizontalTraceIdx;
		local int HorizontalTracePerSection;
        local name HorizontalTraceName;
        local vector HorizontalTraceLoc;
        local vector HorizontalTraceIncDir;

		/** Tracer Variables */
		local Actor HitActor;
		local vector HitLoc, hitNormal;
		local TraceHitInfo HitInfo;

		if (WorldInfo.NetMode == NM_DedicatedServer && !AOCOwner.bIsBot)
			return;

		TracePerSection = NumAttackTracerPoints / WeaponNumTracers;
		HorizontalTracePerSection = NumHorizontalAttackTracerPoints / WeaponNumTracers;
		// Perform tracers for each of the tracer points (as indiciated by WeaponNumTracers)
		// Work with the hard cap of 12 previous tracer points divide between points and 8 additional for parry check
		for (i = 0; i < WeaponNumTracers; i++)
		{
			// Get the tracer names and locations
			GetTracerSocketNames(BeginTraceName, EndTraceName, i);
            // Avian - Get that 4th Socket for the horizontal blade
            SetHorizontalTracerNames(horizontalTraceName, i);
			
			HandlePercent = GetHandleTracerPercent(i);

			Mesh.GetSocketWorldLocationAndRotation(BeginTraceName, BeginTraceLoc);
			Mesh.GetSocketWorldLocationAndRotation(EndTraceName, EndTraceLoc);
            // Avian - Get the Horizontal Socket POS/ROT
            Mesh.GetSocketWorldLocationAndRotation(HorizontalTraceName, HorizontalTraceLoc);

			TraceIncDir = (EndTraceLoc-BeginTraceLoc) / TracePerSection;
            // Avian - Get the Horizontal Socket TraceIncDir, Math SHOULD be correct? as seen above it's Last - First, so should apply here.
            HorizontalTraceIncDir = (HorizontalTraceLoc - EndTraceLoc) / HorizontalTracePerSection;

			// Calculate Trace Points
			for (t = 0; t < TracePerSection; t++)
			{
				TraceIdx = i * TracePerSection + t;
				AllTracePoints[TraceIdx] = BeginTraceLoc + TraceIncDir * t;

				// Check if this tracer is part of the weapon's handle (parry only)
				if (float(t) / TracePerSection < HandlePercent)
				{
					TracePointsType[TraceIdx] = ETracerType_ParryImmediately;
				}
				else
				{
					TracePointsType[TraceIdx] = ETracerType_Attack;
				}
			}

			// Calculate Trace Points for Horizontal Sockets
			for (t = 0; t < HorizontalTracePerSection; t++)
			{
				HorizontalTraceIdx = i * HorizontalTracePerSection + t;
                HorizontalTracePoints[HorizontalTraceIdx] = EndTraceLoc + HorizontalTraceIncDir * t;

				// Check if this tracer is part of the weapon's handle (parry only)
				if (float(t) / HorizontalTracePerSection < HandlePercent)
				{
					HorizontalTracePointsType[HorizontalTraceIdx] = ETracerType_ParryImmediately;
				}
				else
				{
					HorizontalTracePointsType[HorizontalTraceIdx] = ETracerType_Attack;
				}
			}
		}

		// Last EndTraceLoc is the tip
		CurrentTipLocation = HorizontalTraceLoc;
		// Avian - Going to test to see if this breaks or not.
		// Avian - Looks like HorizontalTraceLoc and EndTraceLoc make no difference.
        
		// Calculate Parry Tracer Points - Use the direction of the last known tracerv
		TraceIncDir = Normal(TraceIncDir) * ParryCheckTraceInc;
		for (i = NumAttackTracerPoints; i < NumTracerPoints; i++)
		{
			AllTracePoints[i] = AllTracePoints[i - 1] + (i - 11.5) * TraceIncDir;
			TracePointsType[i] = ETracerType_CheckParryOnly;
		}

		// Calculate Horizontal Parry Tracer Points
		HorizontalTraceIncDir = Normal(HorizontalTraceIncDir) * ParryCheckTraceInc;
		for (i = NumHorizontalAttackTracerPoints; i < NumHorizontalTracerPoints; i++) {
			HorizontalTracePoints[i] = HorizontalTracePoints[i - 1] + (i - 4.5) * HorizontalTraceIncDir;
            HorizontalTracePointsType[i] = ETracerType_CheckParryOnly;
		}

		if (DebugWeaponTracers())
		{
			DrawDebugTracerLine(AllTracePoints[0], AllTracePoints[11], 0, 255, 0);
            DrawDebugTracerLine(HorizontalTracePoints[0], HorizontalTracePoints[4], 0, 255, 0);
		}

		// Start with a parry trace straight through the weapon
		HitActor = Trace(HitLoc, hitNormal, AllTracePoints[0], AllTracePoints[11], true,,HitInfo, TRACEFLAG_BULLET);

		if (AOCPawn(HitActor) != none )
		{
			Hit(HitActor, HitLoc, hitNormal, HitInfo, Vect(0,0,0),0,ETracerType_CheckParryOnly);
		}
        // Avian - Check to see if Horizontal Tracers Hit
        HitActor = Trace(HitLoc, hitNormal, HorizontalTracePoints[0], HorizontalTracePoints[4], true,,HitInfo, TRACEFLAG_BULLET);
		if (AOCPawn(HitActor) != none )
		{
			Hit(HitActor, HitLoc, hitNormal, HitInfo, Vect(0,0,0),0,ETracerType_CheckParryOnly);
		}
		PerformTracers(NumTracerPoints);
        PerformHorizontalTracers(NumHorizontalTracerPoints);
	}

    /** Avian - The original note on this typo'd shield for "sheild", god bless america. */
    simulated function GetBucklerTracerPoints(out vector beginTracePos, out vector endTracePos)
	{
		super.GetBucklerTracerPoints(beginTracePos, endTracePos);
	}

    simulated function GetSpecialTracerPoints(out vector beginTracePos, out vector endTracePos)
	{
		super.GetSpecialTracerPoints(beginTracePos, endTracePos);
	}

    simulated function SpecialWeaponTracers()
	{
		super.SpecialWeaponTracers();
	}
}

// AVIAN - READ THIS, YOU NEED TO SET THIS UP TO THE PROPERTIES YOU WANT FOR THE WEAPON, YOU PROBABLY KNOW HOW SO I WON'T FILL IT OUT.
DefaultProperties
{

KickOffset=(X=50, Y=0, Z=-65)
	KickSize=20.f

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'Curvedblade.WEP_Curvedblade'
		Scale=1.0
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'Curvedblade.WEP_Curvedblade'
		Scale=1.0
	End Object

	WeaponID=EWEP_Messer
	WeaponClass=class'SlumpModWeapon_Curvedblade'

	WeaponSocket=wep2hpoint
	bUseAlternativeKick=true

	AttackTypeInfo(0)=(fBaseDamage=90, fForce=24000, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=95, fForce=24000, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=45.0, fForce=24000, cDamageType="AOC.AOCDmgType_pierce", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=0.0, fForce=40500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=36400, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)

	Skins(0)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath=""
		)};

	Skins(1)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_hengest_horsa_png"
		)};

	Skins(2)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_hengest_horsa_png"
		)};

	Skins(3)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath=""
		)};

	Skins(4)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_hengest_horsa_png"
		)};

	Skins(5)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath=""
		)};

	Skins(6)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_hengest_horsa_png"
		)};

	Skins(7)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath=""
		)};

	Skins(8)={(
		SkeletalMeshPath="Curvedblade.WEP_Curvedblade",
		StaticMeshPath="Curvedblade.Curvedblade_mesh",
		MaterialPath="",
		StaticMeshScale=1.0,
		ImagePath="ui_custweaponimages_swf.skin_hengest_horsa_png"
		)};
}
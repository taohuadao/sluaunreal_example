// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;
using System.Collections.Generic;

public class HitBoxMakerBlueprintTarget : TargetRules
{
	public HitBoxMakerBlueprintTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Game;
        bUsePCHFiles = false;
		DefaultBuildSettings = BuildSettingsVersion.V2;

		ExtraModuleNames.AddRange( new string[] { "HitBoxMakerBlueprint" } );
	}
}

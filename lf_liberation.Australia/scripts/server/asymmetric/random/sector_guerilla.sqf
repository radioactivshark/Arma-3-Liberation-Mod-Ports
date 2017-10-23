params ["_sector"];

if (KP_liberation_asymmetric_debug > 0) then {private _text = format ["[KP LIBERATION] [ASYMMETRIC] Sector %1 (%2) - sector_guerilla spawned on: %3", (markerText _sector), _sector, debug_source];_text remoteExec ["diag_log",2];};

private _startpos = (markerPos _sector) getPos [(1200 + (round (random 400))), (random 360)];

while {(([_startpos, 500, GRLIB_side_friendly] call F_getUnitsCount) > 0) || (surfaceIsWater _startpos)} do {
	_startpos = (markerPos _sector) getPos [(1200 + (round (random 400))), (random 360)];
};

private _grp = [_startpos] call F_spawnGuerillaGroup;

while {(count (waypoints _grp)) != 0} do {deleteWaypoint ((waypoints _grp) select 0);};
{_x doFollow (leader _grp)} forEach (units _grp);

_waypoint = _grp addWaypoint [markerpos _sector, 100];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "AWARE";
_waypoint setWaypointCombatMode "YELLOW";
_waypoint setWaypointCompletionRadius 30;
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointType "CYCLE";

waitUntil {sleep 60; !(_sector in active_sectors)};

sleep 60;

if (!isNull _grp) then {
	{
		if (alive _x) then {
			deleteVehicle _x;
			KP_liberation_guerilla_strength = KP_liberation_guerilla_strength + 1;
		};
	} forEach (units _grp);
	if (!isServer) then {
		publicVariableServer "KP_liberation_guerilla_strength";
	};
};

if (KP_liberation_asymmetric_debug > 0) then {private _text = format ["[KP LIBERATION] [ASYMMETRIC] Sector %1 (%2) - sector_guerilla dropped on: %3", (markerText _sector), _sector, debug_source];_text remoteExec ["diag_log",2];};

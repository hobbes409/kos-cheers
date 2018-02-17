// Geostationary circularization script

REQUIRE("maneuver.ks").

NOTIFY("").
RUN storage.ks

SET dV TO maneuverCompletion.
SET mnvTime to MNV_TIME(dV).
SET startTime TO TIME:SECONDS + ETA:APOAPSIS - mnvTime / 2.

NOTIFY("").

// Lock steering ahead of time
WAIT UNTIL TIME:SECONDS > startTime - 10.
NOTIFY("").
LOCK STEERING TO PROGRADE.

// Begin the burn
WAIT UNTIL TIME:SECONDS > startTime.
NOTIFY("").
LOCK THROTTLE TO 1.

// End the burn
WAIT UNTIL TIME:SECONDS > startTime + mnvTime.
LOCK THROTTLE TO 0.
NOTIFY("").

// Align for sunlight
WAIT 5.
NOTIFY("").
LOCK STEERING TO HEADING(0,0).
WAIT 5.

// Turn on the dish antenna
NOTIFY("Activating dish antenna").
SET p TO SHIP:PARTSTITLED("Comms DTS-M1")[1].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "Mun").

// Enable reflectron
SET p TO SHIP:PARTSTITLED("Reflectron KR-7")[0].
SET m TO p:GETMODULE("ModuleRTAntenna").
m:DOEVENT("Activate").
m:SETFIELD("target", "active-vessel").



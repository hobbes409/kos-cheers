// Rescuer Rendezvous 2 v1.0.0
// Following Cheers Kevin, Episode 10, 11
// Rename files to match episodes:
// KOS10.ks
// KOS10.1.ks
// KOS10.2.ks
// KOS10.3.ks
// KOS10.4.ks

DOWNLOAD("orbit.ks").  // orbit.ks
DOWNLOAD("rescuer.functions.ks"). // rescuer.function.ks
RUN orbit.ks.
RUN rescuer.functions.ks.

SET victim TO "Name of second Craft".
SET TARGET TO ORBITABLE(victim).


NOTIFY("Beginning rendezvous procedure").

// Start our rendezvous adjustment at periapsis
WAIT UNTIL ETA:PERIAPSIS < 10.
SET targetAngle     TO TARGET_ANGLE(victim).
SET desiredPeriod   TO TARGET:OBT:PERIOD * (1 + ((360 -targetAngle) / 360 / 3)).

// Boost our orbit, and circle around thrice
CHANGE_PERIOD(desiredPeriod).
SET startTime TO TIME:SECONDS.
WAIT UNTIL TIME:SECONDS > startTime + (desiredPeriod * 2.5).
WAIT UNTIL ETA:PERIAPSIS < 10.

// Bring us in closer by steps
UNTIL TARGET:DISTANCE < 1000 {
    AWAIT_CLOSEST_APPROACH().
    CANCEL RELATIVE_VELOCITY().
    APPROACH().
}

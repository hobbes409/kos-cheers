// Rescuer Rendezvous 1 v1.0.0
// Following along with Cheers Kevin Episode 10

Download("orbit.ks").
Download("rescuer.functions.ks").
RUN orbit.ks.
RUN rescuer.functions.ks.

SET victim to "name of craft".
SET TARGET to ORBITABLE(victim).

NOTIFY("Beginning rendezvous procedure").

// Start our rendezvous adjustment at periapsis
WAIT UNTIL ETA:periapsis < 10.
SET targetAngle to  TARGET_ANGLE(victim).
SET desiredPeriod to TARGET:OBT:PERIOD * (1 + ((360 - targetAngle) / 360)).

// Boost our orbit, and circle around
CHANGE_PERIOD(desiredPeriod).
WAIT UNTIL ETA:periapsis < 10.

// Bring us in closer by steps
UNTIL TARGET:DISTANCE < 1000 {
    AWAIT_CLOSEST_APPROACH().
    CANCEL_RELATIVE_VELOCITY().
    APPROACH().
}

// Kill remaining relative velocity
CANCEL_RELATIVE_VELOCITY().



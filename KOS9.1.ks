// Kerbal Space Programming
// Second scripted craft, KOS - 1


SET pScale TO 0.002.

FUNCTION P_LOOP {
	PARAMETER target.
	PARAMETER current.

	RETURN (target - current) * pScale.
	}

// Get us 500 meters up

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 0.4.
STAGE.
WAIT UNTIL ALTITUDE > 500.

// Test our proportional function

SET autoThrottle TO 0.
LOCK THROTTLE TO autoThrottle.

SWITCH TO 0.
SET startTime TO TIME:SECONDS.

UNTIL SHIP:LIQUIDFUEL < 10 {
	SET autoThrottle TO P_LOOP(500, ALTITUDE).
	SET autoThrottle TO MAX(0, MIN(autoThrottle, 1)).
	WAIT 0.1.
	LOG (TIME:SECONDS - startTime) + "," + ALTITUDE + "," + autoThrottle TO "KOS1_PID_testflight.csv".
	}	

// Recover the vessel
LOCK THROTTLE TO 0.
STAGE.

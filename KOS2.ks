// Kerbal Space Programming
// Second scripted craft, KOS - 1

SET kP TO 0.001.
SET kI TO 0.0001.
SET kD TO 0.01.

SET lastP TO 0.
SET lastTime TO 0.
SET totalP TO 0.

FUNCTION P_LOOP {
	PARAMETER target.
	PARAMETER current.
	
	SET output TO 0.
	SET now to TIME:SECONDS.

	// Change output
	SET P TO target - current.
	SET I TO 0.
	SET D TO 0.

	IF lastTime > 0 {
		SET I TO totalP + ((P + lastP)/2 * (now - lastTime)).
		SET D TO (P - lastP) / (now - lastTime).
	}

	SET output TO P * kP + I * kI + D * kD.

	CLEARSCREEN.
	PRINT "P: " + P.
	PRINT "I: " + I.
	PRINT "D: " + D.
	PRINT "Output: " + output.

	SET lastP TO P.
	SET lastTime TO now.
	SET totalP TO I.

	RETURN output.
	}

// Get us 500 meters up

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 0.5.
STAGE.
WAIT UNTIL ALTITUDE > 100.

// Test our proportional function
SET autoThrottle TO 0.
LOCK THROTTLE TO autoThrottle.

SWITCH TO 0.
SET startTime TO TIME:SECONDS.

UNTIL SHIP:LIQUIDFUEL < 2 {
	SET autoThrottle TO P_LOOP(500, ALTITUDE).
	SET autoThrottle TO MAX(0, MIN(autoThrottle, 1)).
	WAIT 0.001.
	LOG (TIME:SECONDS - startTime) + "," + ALTITUDE + "," + autoThrottle TO "KOS2_EP9_PID_testflight.csv".
	}	

// Recover the vessel
LOCK THROTTLE TO 0.
STAGE.
SWITCH to 1.

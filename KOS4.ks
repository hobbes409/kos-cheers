// Kerbal Space Programming
// Episode 10, Orbital Rescue
// KOS4.ks

SET burnoutCheck TO "reset".
FUNCTION BURNOUT {
    PARAMETER autoStage.

    IF burnoutCheck = "reset" {
    SET burnoutCheck to MAXTHRUST.
    RETURN FALSE.
    }

    IF burnoutCheck - MAXTHRUST > 10 {
        IF autoStage {
            SET currentThrottle to THROTTLE.
            LOCK THROTTLE TO 0.
            WAIT 0.5. STAGE. WAIT 0.5.
            LOCK THROTTLE TO currentThrottle.
        }
        SET burnoutCheck TO "reset".
        RETURN TRUE.
    }

    RETURN FALSE.
}

// Stage 1 Launch
LOCK THROTTLE TO 0.
LOCK STEERING TO HEADING (90, 90).
STAGE.

// Wait for boosters to burnout
WAIT UNTIL BURNOUT(FALSE).

// Wait for escape system test conditions
WAIT UNTIL ALTITUDE > 13000 AND ALTITUDE < 25000 AND VERTICALSPEED > 200 AND VERTICALSPEED < 500.

// Ditch boosters and start gravity turn
STAGE. WAIT 2.
LOCK THROTTLE TO 1.
LOCK STEERING TO HEADING(90, 45)

// Pitch towards the horizon
WAIT UNTIL APOAPSIS > 60000.
LOCK STEERING TO HEADING(90, 10).

// Wait until we're going to space
WAIT UNTIL APOAPSIS > 80000.
LOCK THROTTLE TO 0.

// Coast to Apoapsis
WAIT UNTIL ETA:APOAPSIS < 20.
LOCK STEERING TO HEADING(90, 0).
LOCK THROTTLE TO 1.

// Wait for orbit, staging as needed
UNTIL PERIAPSIS > 71000 {
    BURNOUT(TRUE).
    WAIT 0.01
    }
LOCK THROTTLE TO 0.

// Enable Antenna
TOGGLE LIGHTS.

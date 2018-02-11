// Kerbal Space Programming
// For logging position data to plot trajectories
// Testing various craft configurations for a SpaceX-style return to the launchpad

SET startTime TO TIME:SECONDS.
SET startLon TO SHIP:LONGITUDE.
SET startAltitude TO SHIP:ALTITUDE.
SET currentLon TO 0.
SET elapsedTime TO 0. 
SET currentAltitude TO 0.
SET altimeter_max to -1.  //initialize altimeter to below surface

// Launch the vehicle

// STAGE.  //using Mechjeb for now

SWITCH TO 0.  //set environment to global file folder for recording data


UNTIL (elapsedTime > 420)  //record for at least seven minutes, and until altitude is back below 10 (omitted)
    {
    IF (altimeter_max < SHIP:ALTITUDE) SET altimeter_max TO SHIP:ALTITUDE.
    SET elapsedTime TO (TIME:SECONDS - startTime).
    SET currentLon TO (SHIP:LONGITUDE - startLon).
    SET currentAltitude TO (SHIP:ALTITUDE - startAltitude).
	LOG elapsedTime + "," + currentLon + "," + currentAltitude + "," + SHIP:AIRSPEED + "," + altimeter_max  + "," + SHIP:LIQUIDFUEL TO "KOS3_SpaceX_Attempt_Log_Data.csv".
    WAIT 0.001.
	}	


SWITCH to 1.  //set environment back to local craft

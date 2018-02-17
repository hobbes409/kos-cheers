// Tsiolkovsky rocket equation

// delta V equals exhaust velocity times the natural logarithm of the initial total mass divided by the final total mass, without propellant, aka dry mass

// exhaust velocity is engine specific impulse (Isp) times local gravitational constant times the natural logarithm of the intial mass divided by final mass

//Ship's delta-v

FUNCTION TLM_DELTAV {
    LIST ENGINES IN shipEngines.
    SET dryMass TO SHIP:MASS - ((SHIP:LIQUIDFUEL + SHIP:OXIDIZER) * 0.005).
    RETURN shipEngines[0]:ISP * 9.81 * LN(SHIP:MASS / dryMass).
}

// Time to complete a maneuver
FUNCTION MNV_TIME {
    PARAMETER deltaV.

    SET maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
    RETURN deltaV / maxAccel.
}

// Delta V requirements for Hohmann Transfer
FUNCTION MNV_HOHMANN_DV {

    PARAMETER desiredAltitude.

    SET u to SHIP:OBT:BODY:MU.
    SET r1 TO SHIP:OBT:SEMIMAJORAXIS.
    SET r2 TO desiredAltitude + SHIP:OBT:BODY:RADIUS.


    // v1
    SET v1 to SQRT(u / r1) * (SQRT((2 * r2) / (r1 + r2)) - 1).

// delta V for first Hohmann transfer burn equals square root of mu divided by starting radius times the square root of two times the final radius,
// divided by starting radius plus final radius, minus one

    // v2
    SET v2 to SQRT(u / r2) * (1 - SQRT((2 * r1) / (r1+r2))).

    RETURN LIST(v1, v2).
}

PRINT "Testing functions".
PRINT "Ship's Delta-V: " + TLM_DELTAV().
PRINT "Time for 100m/s maneuver: " + MNV_TIME(100).
PRINT "Transfer delta-V to 400km: " + MNV_HOHMANN_DV(400000).

WAIT 500.


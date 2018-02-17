// Tsiolkovsky rocket equation

// delta V equals exhaust velocity times the natural logarithm of the initial total mass divided by the final total mass, without propellant, aka dry mass

// exhaust velocity is engine specific impulse (Isp) times local gravitational constant times the natural logarithm of the intial mass divided by final mass

//Ship's delta-v

// F=ma,  a = F/m
// a = F / M0 - deltaM * time
// deltaV = integral of F / M0 - deltaMass * time, dT, from zero to T1
// F = Isp * deltaMass * gzero (gravitational constant)
// deltaMass = Force divided by specific impulse times gee zero, F/Isp * g0
// deltaV = integral of F / M0 - (F/Isp * g0) * time, dT, from zero to T1
// this integral = -g * Isp * ln(g * M * Isp - F * t)
// Delta V = Delta V (t1) - Delta V (t0)



FUNCTION TLM_DELTAV {
    LIST ENGINES IN shipEngines.
    SET dryMass TO SHIP:MASS - ((SHIP:LIQUIDFUEL + SHIP:OXIDIZER) * 0.005).
    RETURN shipEngines[0]:ISP * 9.81 * LN(SHIP:MASS / dryMass).
}

// Time to complete a maneuver
FUNCTION MNV_TIME {
    PARAMETER dV.       // Delta-V

    // SET maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.  these two lines are incorrect!  mass changes over time
    // RETURN deltaV / maxAccel.

    LIST ENGINES IN en.

    LOCAL f IS en[0]:MAXTHRUST * 1000.  // Engine thrust (kg * m/s^2)
    LOCAL m IS  SHIP:MASS * 1000.       // Starting mass (kg)
    LOCAL e IS CONSTANT():E.            // Base of natural logarithm   
    LOCAL p IS en[0]:ISP.               // Engine Isp (s)
    LOCAL g IS 9.80665.                 // Gravitational acceleration constant (m/s^2)

    RETURN g * m * p * (1 - e^(-dV/(g*p))) / f.
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


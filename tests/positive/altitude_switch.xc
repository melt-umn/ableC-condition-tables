#include <stdio.h>

/* This sample file uses condition tables to specify part of an
   altitude switch, part of an avioics systems that controls the
   altitude of an aircraft.
 
   It determines if the aircraft should attempt to gain altitude when
   the altitude falls below a certain threshold, plus a hysteresis
   factor.
  
   The altitude status is initially unknown.  It is then set to
   'above' if the quality of the altitude reading is good and either
   this determinations is being makde for the first time (previous
   status is unknown) and the aircraft is above the threshold, or the
   status has been set and the altitude is above the threshold, plus
   the hysteresis.  The status is set to below' if the readings are
   good and the altitude is less than (or equal to) the threshold.  If
   the altitude sensor readings are of poor quality then the status is
   set to 'unknown'.

   This natural language description is a bit dense and thus the
   so-called condition tables developed in requirements specification
   languages such as SCR and RSML-e provide nice syntax for specifying
   these complex Boolean conditions.

   This is seen in the applicatin of an altitude switch below.
*/
 

/* The altitude status of a hypothetical aircraft is specified as
   being either above or below a desired altitude.  It may also be
   unknown if aircraft sensors are not providing the requisite data 
 */
typedef enum Status { unknown, above, below } status;

/* The quality of the altitude sensor readings are characterized as
   being good or poor.
 */
typedef enum AltQuality { good, poor } quality;


status determine_status (quality alt_quality, int alt_thres, int hyst, 
                         int altitude, status prevStatus ) {
    status new_status;

    if (table { prevStatus == unknown       : T *
                alt_quality == good         : T T
                altitude > alt_thres        : T T
                altitude > alt_thres + hyst : * T })
        new_status = above;
    else
    if (table { alt_quality == good         : T
                altitude > alt_thres        : F })
        new_status = below;

    else
    if (alt_quality == good) 
        new_status = unknown;

    else
        new_status = prevStatus;


    return new_status;
}

int main() {

    // define some sample sensor readings and settings.

    quality aq = good;    // altitude quality
    int at = 1500;        // altitude threshold
    int h = 50;           // hysterisis factor
    int a = 2500;         // altitute
    status ps = unknown;  // previous status setting

    status new_status = determine_status (aq, at, h, a, ps);

    switch (new_status) {
    case unknown: 
        printf ("status unknown.\n");
        break;
    case above:
        printf ("status above.\n");
        break;
    case below:
        printf ("status below.\n");
        break;
    }
}

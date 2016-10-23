C   04/11/81 809081600  MEMBER NAME  $HIST    (SOURCE)      FORTRAN
C
C   04-11-81   16:00      CHANGED MEMBERS (DEBUGGED)
C        ELGOBS, ENGLOS
C
C   11-12-81   XX:00      CHANGED MEMBERS
C        POSENDN          NEW VERSION OF POSEND.(DEBUGGED BY TAKEDA)
C
C   14-12-81   09:00      CHANGED MEMBERS
C        LGMESG           MODIFIED FOR DETAIED MESSAGE.
C
C   14-12-81   16:25      CHANGED MEMBERS
C        POSEND           DEBUGGED.    ENERGY CORRECTION WAS NOT
C                         CORRECT FOR END-CAP CLUSTER < 600 MEV.
C                         THE OLD VERSION WAS RENAMED AS POSEND0.
C   14-12-81   16:25
C        LGECOR           ENERGY LOSS WAS INCORPOLATED FOR THE END-
C                         CAP CLUSTERS.  THE THICKNESS OF MATERIALS
C                         IN FRONT OF LEAD GLASS IS 1.17 X0.
C                         ALSO THE THICKNESS OF MATERIALS FOR
C                         BARREL PART WAS CHANGED.
C                            OLD THICKNESS   7.88 CM
C                            NEW THICKNESS   0.97*8.9 CM
C   13-06-81   21:45      CHANGED
C        LGECOR           CORRECTION FOR FINE POSITION DEPENDENCE IN
C                         BARREL PART WAS CHANGED TO USE A NEW ROUTINE
C                         'BRLGN' INSTEAD OF 'LGPOSC'.
C                         THE ITERATION METHOD OF ENERGY CORRECTION
C                         WAS ALSO CHANGED.
C                         THE OLD VERSION WAS RENAMED AS 'LGECOR1'.
C   14-06-82   14:40      CHANGED AND LOAD
C       LGADCD            IF THE LG-DATA IS EMPTY, RETURN AFTER
C                         THE LNGTH IS PRINTED.
C   06-09-82   13:40      NEW LGINIT IS LOADED. COMMON /CLGPRM/ IS
C                         MODIFIED TO INCLUDE JCALFL.
C   12-10-82   15:00      DEAD COUNTER INFORMATION UPDATED.
C     LGDEAD              TAKEDA
C   20-08-84    9:00      NEW LG...
C   24-01-86   11:00      CORRECTED VERSIONS FROM M.KUHLEN INSTALLED.
C     LGANAL,LGERSE       OLD VERSION NOW LGANAL0,LGERSE0    J.OLSSON
C   03-09-86   20:30      CORRECTED BUG IN LGCDIR (MC CLUSTERS).
C     LGCDIR              OLD VERSION NOW LGCDIR0            J.OLSSON
C   16-09-86   19:00      ADDED SEVERAL DEAD COUNTERS TO THE
C     LGDEAD              LGDEAD LIST. #753 IS DEAD SINCE 1984
C                         ALREADY !                        N.MAGNUSSEN
C   19-01-87   15:00      UPDATED ELGOBS TO CORRECT MATERIAL THICKNESS
C     ELGOBS              IN FRONT OF BARREL. ENDCAP LOSS ALSO INCLUDED
C                         OLD VERSION = ELGOBS0            J.OLSSON
C   21-12-87   21:00      UPDATED ENGLOS,LGECOR,LGCLPB, ADDED NEW SUB-
C     ENGLOS,ETC...       ROUTINES LKCORR,ENLOSG,THCORR,BBLEAK.
C                         AS PRESENTED IN JADE MEETING 14.12.87
C                         OLD VERSIONS LGECOR0,ENGLOS0,LGCLPB0
C                            J.O. D.P.
C   14-01-88   10:30      LGECOR WAS CHANGED 12.19 13.1.88 BY MISTAKE
C     LGECOR              THE VERSION EXISTED TILL 14.1.88, 1030 AND DID
C                         NOT PERFORM CORRECTIONS AS IT SHOULD. PRESENT
C                         VERSION IDENTICAL TO OLD ONE FROM 21.12.87
C                            J.O. D.P.
C   06-04-88   17:30      SECOND HALFWORD IN ALGN-BANK ( HNORML IN
C     LGCLPB              WORK-COMMON ) STEERS CALL TO BBLEAK. D.PITZL
C   22-06-88   16:30      NEW CORRECTION VALUES IN THCORR FROM GEANT-MC
C     THCORR              ESPECIALLY FOR YEARS 79-82.          D.PITZL
C   11-07-88   11:00      CHANGED LGECOR TO AGREE WITH NEW VERSION OF
C     LGECOR              THCORR                               D.PITZL
C   25-07-88   12:15      IDATTM SCRATCHED. IT HAS A BUG; AN IDENTICAL
C     IDATTM              VERSION ON F11LHO.JADEGS/GL IS UPDATED J.O.
C   02-08-88   17:00      NEW VERSIONS OF SEVERAL ROUTINES FOR BETTER
C                         PHOTON RECONSTRUCTION (D.PITZL)
C     LGANAL9             LGANAL9 CALLS CALCOR
C       CALCOR            CALCOR PERFORMS LG CALIBRATION CORRECTION
C         BBCORR          BBCORR HAS CALIBRATION CORRECTION CONSTANTS
C       LGCLPB9           LGCLPB9 RESET TO VERSION BEFORE 12/87.
C     LGCDIR9             LGCDIR9 PASSES # OF BLOCKS TO LGECOR9
C       LGECOR9           LGECOR9 HAS # OF BLOCKS AS ARGUMENT
C                         FOR CHARGED CLUSTERS: ENGLOS, ANGBAR, BRLGN
C                         FOR PHOTONS IN DATA AND SHOWER-MC: ENCORR,
C                                              THCOFA
C                         FOR PHOTONS IN MEI-MAG-MC: ENGLOS, THCORR,
C                                      THCOFA, ANGBAR
C         ENCORR          ENERGY CORRECTION FOR PHOTONS
C         THCOFA          THRESHOLD CORRECTION FOR 1- AND MORE BLOCK
C                         PHOTONS ( T.OEST)
C   12-08-88   10:20      REMOVED BUG FOR PHOTONS WITH |COS THETA|
C     ENCORR, THCOFA      > 0.80                   T.OEST, D.PITZL
C   08-09-88   16:00      LOADED LGDEAD, THIS WAS NOT DONE SINCE
C     LGDEAD              AUG 85                   T.OEST, D.PITZL

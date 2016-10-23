C   31/01/79 106101756  MEMBER NAME  KTMCON0  (JADEGS)      FORTRAN
      FUNCTION KTMCON(ITIME,NOW,INITL)
C---
C---     FUNCTION WHICH CONVERTS INPUT ARRAY "ITIME(6)", WHICH CONTAINS
C---     TIME AT WHICH THE CURRENT EVENT WAS RECORDED: SECONDS, MINUTES
C---     HOURS, DAY OF THE MONTH, MONTH AND YEAR, IN THAT ORDER, INTO
C---     SECONDS ELAPSED SINCE THE BEGINNING OF 1979. THE SECOND ARGU-
C---     MENT "INITL" GIVES A DEFAULT VALUE, WHICH THE FUNCTION ASSUMES
C---     IN CASE THE DATA IN "ITIME" ARE INVALID, E.G. IF THE TIME
C---     SPECIFIED IN "ITIME" IS BEFORE JANUARY 1, 1979 OR AFTER THE
C---     TIME AT WHICH THE PROGRAM IS EXECUTING, OR IF A NON-EXISTENT
C---     MONTH, DAY OR THE MONTH OR TIME OF DAY IS SPECIFIED.
C---
      IMPLICIT INTEGER*2 (H)
      LOGICAL*1 LBREAD
      COMMON/CWORK/HCORE(40)
      COMMON /CADMIN/ IEVTP,NRREAD,NRWRIT,NRERR,LBREAD(4),IFLG,IERCAL
#include "cgraph.for"
      DIMENSION JETZT(5),ITIME(6),NDPM(12),INTDPM(12)
      DATA NDPM/31,28,31,30,31,30,31,31,30,31,30,31/
      DATA IERR/0/
      DATA ICALL/0/
      IF(ICALL.NE.0) GO TO 1
      ICALL=1
C---
C---     "NDPM" HOLDS THE NUMBER OF DAYS IN EACH OF THE TWELVE MONTHS
C---     OF A NORMAL (NON-LEAP) YEAR. NOW FILL THE ARRAY "INTDPM" WITH
C---     THE CUMULATIVE NUMBERS OF DAYS ELAPSED BETWEEN THE BEGINNING
C---     OF THE YEAR AND THE END OF THE PREVIOUS MONTH.
C---
      INTDPM(1)=0
      DO 2 I=2,12
      INTDPM(I)=INTDPM(I-1)+NDPM(I-1)
    2 CONTINUE
    1 CONTINUE
C---
C---     VERIFY VALIDITY OF INPUT DATA "ITIME".
C---
      IF(ITIME(6).LT.1979) GO TO 3
      IF(ITIME(6).GT.1999) GO TO 3
      IF(ITIME(5).LT.   1) GO TO 3
      IF(ITIME(5).GT.  12) GO TO 3
C---
C---     SET NUMBER OF DAYS IN MONTH SPECIFIED.
C---
      NDTM=NDPM(ITIME(5))
C---
C---     CORRECT IN CASE MONTH IS FEBRUARY AND SPECIFIED YEAR IS A LEAP
C---     YEAR. ALSO SET "NLEAP", THE NUMBER OF LEAP YEARS BETWEEN 1979
C---     AND THE YEAR SPECIFIED IN "ITIME", NOT INCLUDING THE LATTER
C---     YEAR IF IT ITSELF IS A LEAP YEAR.
C---
      LEAP=0
      NLEAP=(ITIME(6)-1977)/4
      IF((ITIME(6)-1977-4*NLEAP).EQ.3) LEAP=1
      IF((ITIME(5).EQ.2).AND.(LEAP.EQ.1)) NDTM=NDTM+1
      IF(ITIME(4).LT.   1) GO TO 3
      IF(ITIME(4).GT.NDTM) GO TO 3
      IF(ITIME(3).LT. 0) GO TO 3
      IF(ITIME(3).GT.23) GO TO 3
      IF(ITIME(2).LT. 0) GO TO 3
      IF(ITIME(2).GT.59) GO TO 3
      IF(ITIME(1).LT. 0) GO TO 3
      IF(ITIME(1).GT.59) GO TO 3
C---
C---     "NDAYS" IS THE NUMBER OF DAYS ELAPSED BETWEEN THE BEGINNING
C---     OF 1979 AND THE END OF THE DAY BEFORE THE DAY SPECIFIED IN
C---     "ITIME", THUS THE SUBTRACTION OF ONE AT THE LINE BELOW.
C---
      NDAYS=365*(ITIME(6)-1979)+NLEAP+INTDPM(ITIME(5))+ITIME(4)-1
C---
C---     CORRECT NDAYS IN CASE THE DATE SPECIFIED IN "ITIME" IS AFTER
C---     FEBRUARY 29 IN A LEAP YEAR.
C---
      IF(ITIME(5).GT.2) NDAYS=NDAYS+LEAP
      NSEC=86400*NDAYS+3600*ITIME(3)+60*ITIME(2)+ITIME(1)
C---
C---     "NSEC" IS THE NUMBER OF SECONDS FROM THE BEGINNING OF 1979
C---     UNTIL THE CURRENT EVENT WAS RECORDED. IDEALLY THE TIME THE
C---     EVENT WAS RECORDED SHOULD BE IN THE PAST. GET PRESENT TIME
C---     FROM THE IBM.
C---
      CALL DAY2(JETZT)
C---
C---     "JETZT(5)" HOLDS, IN THE FOLLOWING ORDER, THE LAST TWO DIGITS
C---     OF THE YEAR, THE DAY OF THE YEAR COUNTING JANUARY 1 AS DAY ONE,
C---     AND THE HOURS, MINUTES AND SECONDS OF THE TIME OF DAY.
C---
      NLEAP=(JETZT(1)-77)/4
      NDAYS=365*(JETZT(1)-79)+NLEAP+JETZT(2)-1
      NOW=86400*NDAYS+3600*JETZT(3)+60*JETZT(4)+JETZT(5)
      IF(NSEC.LT.NOW) GO TO 4
    3 CONTINUE
C---
C---     THE INPUT TIME IS INVALID. SET FUNCTION TO DEFAULT SPECIFIED
C---     IN THE ARGUMENT FIELD.
C---
      NSAVE=NSEC
      NSEC=INITL
      IERR=IERR+1
      IF(IERR.GT.20) GO TO 4
      WRITE(6,100)
  100 FORMAT('0KTMCON CALLED WITH INVALID INPUT.')
      WRITE(6,101) ITIME,NSAVE
  101 FORMAT(' ITIME AND NSAVE=',6I5,I15)
      WRITE(6,102) JETZT,NOW
  102 FORMAT(' JETZT AND NOW=  ',5I5,I20)
      WRITE(6,103) NSEC
  103 FORMAT(' FUNCTION SET TO DEFAULT:',I15)
    4 CONTINUE
      KTMCON=NSEC
      IERCAL = IERR
      RETURN
      END

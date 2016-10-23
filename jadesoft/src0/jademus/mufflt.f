C   22/10/83 805261726  MEMBER NAME  MUFFLT   (JADEMUS)     FORTRAN
C
C LAST CHANGE  9.40 14/04/88 J. HAGEMANN - CORRECT CALC. OF EXTR. ERRORS
C      CHANGE 22.00 22/10/83 HUGH MCCANN - PARALLEL MUFFLY CHANGES.
C      CHANGE 03.10 14/07/83 HUGH MCCANN - VARIOUS CHANGES.
C      CHANGE 18.27 16/03/82 CHRIS BOWDERY- FOR THE 'LET-OFF' TEST
C      CHANGE 14.50 08/02/82 HUGH MCCANN  - KDEPTH LIMIT INCREASED TO 4.
C      CHANGE 17.20 23/09/81 CHRIS BOWDERY- REMOVE RESL & REST FROM
C                                           'LET OFF' TEST. KILLS BUG.
C      CHANGE 15.07 04/08/81 CHRIS BOWDERY- INCLUDE Z EDGE TEST AGAIN
C-----------------------------------------------------------------------
      SUBROUTINE MUFFLT
C-----------------------------------------------------------------------
C
C MUFFLT TAKES THE REFITTED TRACK AND TRACKS IT THROUGH THE FILTER AGAIN
C LOOKING FOR INEFFICIENCIES. REGIONS WILL BE 'LET OFF' IF THE TRACK DID
C NOT PASS THROUGH THE ACTIVE PART OF THE REGION , IF THE TRACK COULD
C HAVE SCATTERED INTO A DEAD CHAMBER OR SCATTERED OUT OF THE ACTIVE AREA
C
C-----------------------------------------------------------------------
C
C NCEPTS  IS THE NUMBER OF INTERCEPTS FOUND BY MUREGY.
C INEFF   IS NO. OF TIMES A HIT WAS NOT FOUND AND THERE WAS NO
C           DEAD CHAMBER TO EXPLAIN ITS ABSENCE.
C NHLAYR  IS RELATED TO THE NO. OF LAYERS WITH HITS WHICH ARE
C           ASSOCIATED WITH THIS TRACK.
C NGLAYR  IS AS NHLAYR - BUT APPLIES TO ALL INTERCEPTED LAYERS WHETHER
C           THEY HAD A HIT OR NOT.
C INFLAG  IS SET = 1 IF AN INEFFICIENCY IS FOUND, AND SET = 0 IF A HIT
C           IS FOUND WITHIN CUTS.  SO IF IT IS STILL 1 WHEN THIS ROUTINE
C           HAS FINISHED IT MEANS THERE WAS AN INEFFICIENCY IN THE LAST
C           LAYER INTERCEPTED.
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL LETDCE,LCOVAR
C
C             COMMONS AND ARRAY DECLARATIONS
C
#include "cmuffl.for"
#include "cmufwork.for"
#include "cmureg.for"
#include "cmucalib.for"
      COMMON /CMUIEV/ IEV,NEV,IRD,KRUN,KREC,
     +                ISECS,IMINS,IHOURS,IDAY,IMONTH,IYEAR
      COMMON /CMULOC/ ALLDEV(12,2),ALLABS(12),REGDEV(30),REGDCE(60),
     +                REGZE(60),LOCHRS(60),ABLOCH(60)
      COMMON /CMUPTC/ XEXTRP,YEXTRP,ZEXTRP,VTZCV,LCOVAR
C
      DIMENSION KTYPE(4),KREGN(4)
C
C             CHAMBER RESOLUTIONS PICKED UP FROM /CMUFFL/.
C
C-----------------------------------------------------------------------
C
C             START OF EXECUTABLE STATEMENTS.
C
      IF(NCEPTS.LE.0) RETURN
C
C             SET KDEPTH, WHICH RECORDS HOW MANY REGIONS ONE IS IN
C             AT ANY ONE TIME. NORMALLY THIS IS 0 OR 1 BUT CAN BE
C             UP TO 4 BECAUSE CHAMBER REGIONS ARE ARTIFICIALLY
C             EXTENDED IN MUREG AND CAN THEREFORE OVERLAP.
C
      KDEPTH=0
C
C             CLEAR THE ARRAY STORING THE START AND STOP POSITIONS
C             OF DEAD CHAMBERS AND REGION EDGES USED IN 'LET-OFFS'
C
      CALL VZERO(REGDCE,60)
      CALL VZERO(REGZE,60)
      IDCEP = 1
      IZEP  = 1
C
C-----------------------------------------------------------------------
C START OF MAIN LOOP ---------------------------------------------------
C-----------------------------------------------------------------------
C
C                  LOOK THROUGH INTERCEPTS.
C
      DO 1000  ICEPT = 1,NCEPTS
C
C                  PROPAGATE TO INTERCEPT.
C
        JTYPE=0
        DSTEP=RDOTD(ICEPT)
        IF(ICEPT.GT.1) DSTEP = DSTEP - RDOTD(ICEPT-1)
        IF(KDEPTH.NE.0) GO TO 1010
          GMSTEP=0.
          ABSTEP=0.
          RDSTEP=0.
          DESTEP=0.
          GO TO 1011
C
C                  FIND DENSEST TYPE - JTYPE.
C
 1010   DO 1015  K=1,KDEPTH
          IF( JTYPE.LT.KTYPE(K) ) JTYPE = KTYPE(K)
          IF( JTYPE.EQ.KTYPE(K) ) IRONRG= KREGN(K)
 1015   CONTINUE
C
C           OCTOBER 1983 :  FIX-UP FOR YOKE END PLATES .
C           THEY ARE COMPLETELY DEFINED BY HRFACE/IUNIT(IREGN)=5,6/3  ,
C           SINCE THEY ARE THE ONLY PARTS OF UNIT 3 (= MAGNET & PLINTH)
C           WHICH ARE IN FACES 5 AND 6.
C           IF MOST DENSE REGION IS NOT YOKE END PLATE, CARRY ON.
          IF( JTYPE.NE.3 )  GO TO 1016
C               THE REGION NO. OF THE IRON REGION WAS NOTED ABOVE.
C               NOTE : CAN'T BE IN 2 IRON REGIONS AT SAME TIME.
              IF(HRFACE(IRONRG).NE.5.AND.HRFACE(IRONRG).NE.6)GO TO 1016
                  IF(HUNIT(IRONRG).NE.3)GO TO 1016
                      JCEPT=ICEPT
                      CALL MUENDP(JCEPT,IRONRG,FACSTP)
C
C                        N.B.  DSTEP IS NOT CHANGED.
                      GMSTEP = (FACSTP*DSTEP)*GMG(JTYPE)
                      ABSTEP = (FACSTP*DSTEP)*ABG(JTYPE)
                      RDSTEP = (FACSTP*DSTEP)*RDG(JTYPE)
                      DESTEP = (FACSTP*DSTEP)*DEG(JTYPE)
                      GO TO 1011
 1016     CONTINUE
C
C
        GMSTEP=DSTEP*GMG(JTYPE)
        ABSTEP=DSTEP*ABG(JTYPE)
        RDSTEP=DSTEP*RDG(JTYPE)
        DESTEP=DSTEP*DEG(JTYPE)
 1011   CONTINUE
C+++
C     WRITE(6,8935)JTYPE
C8935 FORMAT(' JTYPE',I5)
C+++
C
C                  CALCULATE ENERGY LOSS,MULTIPLE SCATTERING ETC.
C                  IF THE TRACK STOPS, GO DIRECT TO CALL OF MULOCH
C
        CALL MUFFLS(&99)
C
C-----------------------------------------------------------------------
C
C                  FIND OUT WHAT TYPE OF INTERCEPT.
C
        IREGN=IREG(ICEPT)
        ITYPE=HRTYPE(IREGN)
C                  IS THIS A NEW REGION BOUNDARY?
        IF(KDEPTH.EQ.0) GO TO 1012
        DO 1013 K=1,KDEPTH
          IF( IREGN.EQ.KREGN(K) ) GO TO 1014
 1013   CONTINUE
        GO TO 1012
C IT MUST BE AN EXIT POINT - DELETE REFERENCE AND DECREMENT KDEPTH.
C  (THIS MAY SEEM UNNECESSARILY COMPLICATED BUT WITH OVERLAPPING
C   REGIONS AN EXIT POINT DOES NOT NECCESARILY FOLLOW THE CORRESPONDING
C   ENTRY POINT.)
 1014   JDEPTH=0
        DO 1019 K=1,KDEPTH
          IF(IREGN.EQ.KREGN(K)) GO TO 1019
          JDEPTH=JDEPTH+1
          IF(JDEPTH.EQ.K) GO TO 1019
          KREGN(JDEPTH)=KREGN(K)
          KTYPE(JDEPTH)=KTYPE(K)
 1019   CONTINUE
        KDEPTH=JDEPTH
C+++
C       WRITE(6,1657)            KDEPTH,KREGN,KTYPE
C1657   FORMAT('            KDEPTH,KREGN,KTYPE',I15,2(I15,3I5))
C+++
        GO TO 1000
C
C                  IT IS A NEW REGION - INCREMENT KDEPTH.
C
 1012   IF(KDEPTH.LT.4) GO TO 97
          CALL MUERRY('MUFFLT',KDEPTH,'REGIONS OVERLAPPING TOO MUCH.^')
          GO TO 1000
 97     KDEPTH=KDEPTH+1
        KREGN(KDEPTH)=IREGN
        KTYPE(KDEPTH)=ITYPE
C+++
C       WRITE(6,1656)IREGN,ITYPE,KDEPTH,KREGN,KTYPE
C1656   FORMAT(' IREG,ITYPE,KDEPTH,KREGN,KTYPE',3I5,2(I15,3I5))
C+++
C
C                  GO TO NEXT INTERCEPT IF NOT A CHAMBER REGION.
C
        IF(ITYPE.NE.1) GO TO 1000
C
C-----------------------------------------------------------------------
C
C                  CHAMBER INTERCEPTED.
C
        IFIRST=HRFIRS(IREGN)
        ILAST=HRLAST(IREGN)
        IOR=HRORI(IREGN)
        IFRAME=HFR(IFIRST)
        IFRAML=HFR(ILAST)
C
C******  AS OF 16/03/83 , APPLY SOFTWARE SHIFT TO WIRE POSITION FOR ALL
C******  DATA AFTER BEGINNING OF 1980 :
C
C  FIRST FOR THE LOW EDGE OF THE REGION :
        ISHIFE=0
        IF(IYEAR.GE.1980)ISHIFE=HLSF(4,IFIRST)
        IF(IABS(ISHIFE).GT.300)ISHIFE=0
C**** DON'T APPLY SOFTWARE SHIFTS TO MONTE-CARLO DATA.
        IF(KRUN.EQ.0)ISHIFE=0
C  THEN FOR THE HIGH EDGE OF THE REGION :
        ISHIFL=0
        IF(IYEAR.GE.1980)ISHIFL=HLSF(4,ILAST)
        IF(IABS(ISHIFE).GT.300)ISHIFL=0
C**** DON'T APPLY SOFTWARE SHIFTS TO MONTE-CARLO DATA.
        IF(KRUN.EQ.0)ISHIFL=0
C
C
C  FOR CALCULATION OF ANGLE CORRECTION OF FRAME POSITION WITH "Z" :
C  LOW EDGE OF REGION :
        IANGE=HANG(IFRAME)
C  HIGH EDGE OF REGION :
        IANGL=HANG(IFRAML)
C  ASSUME THAT FRAMES IN ANY REGION HAVE SAME END POSITIONS :
        ZMID=0.5*( HCLLO(IFRAME) + HCLHI(IFRAME) )
        ZHAF=0.5*( HCLHI(IFRAME) - HCLLO(IFRAME) )
C
        IOVALL=HOVALL(HUNIT(IFRAME))
        LINC=2
        IF( HLAYER( HFR( IFIRST) ).EQ.1 ) LINC = 1
C
C                  WAS THERE A HIT IN THIS REGION?
C
        DO 1022 I=1,LAYRAB
          IF( IREGN.EQ.IEFFRG(I) ) GO TO 1023
 1022   CONTINUE
        GO TO 1024
C
C-----------------------------------------------------------------------
C
C AT LEAST ONE HIT HAS BEEN FOUND FOR THIS TRACK IN THIS REGION.
C UPDATE SPECIAL VARIABLES, BUT NOT IF THERE HAS BEEN MORE THAN 1
C   INEFFICIENCY PRIOR TO THIS.
C
 1023   IF(INEFF.LE.1) CALL UCOPY(X,X0,NSPECI)
C
C INCREMENT NHLAYR , DEPENDING ON LAYER AS FOLLOWS:
C  IF THIS IS A LAYER 1 HIT , INCREMENT =1 ; IF IT'S ANY OTHER
C  LAYER , INCREMENT = 2.  THEN , IF SUM OF NHLAYR IS ODD, THE
C  TRACK IS KNOWN TO HAVE AN INNER LAYER HIT ASSOCIATED.
C
        INFLAG=0
        NHLAYR=NHLAYR+LINC
        GO TO 4000
C
C-----------------------------------------------------------------------
C
C NO HIT IN THIS CHAMBER REGION - SEARCH FOR A REASON.
C
C***********************************************************************
C FROM HERE TO NEXT ROW OF STARS IS A TEMPORARY MEASURE. ULTIMATELY
C   THE RESULTS OF RE-FITTING THE MUON HITS (MUFFLR) WILL BE USED TO
C   ESTIMATE THE TRACK UNCERTAINTIES.
C
C ADD MULTIPLE SCATTERING AND TRACK FITTING ERRORS TO PRODUCE VARIANCES
C   ON DEVIATIONS AND COVARIANCES BETWEEN ANGLES AND DEVIATIONS
C   NORMAL TO TRACK IN THE 2 PLANES (THE A- & B-PLANES OF JADE NOTE 68.
C   NOTE THAT THE A-PLANE GETS THE LABEL 'Z' & THE B-PLANE 'XY' HERE.)
C
 1024 IF( LCOVAR ) GOTO 995
         VZP = VTZD + VTZANG*(D-DTC)**2
         VZD = VMSD + VZP
         CZ  = CMS + VTZANG*(D-DTC)
         GOTO 996
 995  CONTINUE
         R0P = SQRT(X**2 + Y**2)
         VZP = VTZD + 2.0*R0P*VTZCV + R0P**2*VTZANG
         VZD = VMSD + VZP
         CZ  = CMS + (R0P*VTZANG+VTZCV)/COSEC
C
CCC   VXYD  = VMSD + VTXYD + VTXYAN*(D-DTC)**2
 996  DFXY2 = (X-XEXTRP)**2 + (Y-YEXTRP)**2
      VXYP  = VTXYD + VTXYAN*DFXY2
      VXYD  = VMSD + VXYP
CCC   CXY   = CMS + VTXYAN*(D-DTC)*COSEC
      CXY   = CMS + VTXYAN*SQRT(DFXY2)
C+++
C     WRITE(6,7491)VMSD,CMS,VZP,VZD,CZ,VXYP,CXY
C7491 FORMAT(' MUFFLT: VMSD,CMS,VZP,VZD,CZ,VXYP,CXY',/7G15.5)
C+++
C
C NOW PREPARE COEFFICIENTS FOR PROJECTING ONTO CHAMBER PLANES.
C
        IF(IOR.EQ.3) GO TO 1003
        AA=-COSEC
        CC=0.
        IF(IOR.EQ.2) GO TO 1005
        BB=DCY*DCZ*COSEC/DCX
        DD=1./(DCX*COSEC)
        GO TO 1002
C
 1005   BB=-DCX*DCZ*COSEC/DCY
        DD=-1./(DCY*COSEC)
        GO TO 1002
C
 1003   AA=DCY*COSEC/DCZ
        BB=DCX*COSEC
        CC=DCX*COSEC/DCZ
        DD=-DCY*COSEC
 1002   CONTINUE
C+++
C       WRITE(6,2398)AA,BB,CC,DD
C2398   FORMAT(' AA,BB,CC,DD',4G15.5)
C+++
C
C WORK OUT VARIANCES IN DRIFT (TRANSVERSE) AND WIRE (LONG.) DIRECTIONS.
C
        VL1  = AA**2*VZD+BB**2*VXYD
        VT1  = CC**2*VZD+DD**2*VXYD
C       CTL1 = AA*CC*VZD+BB*DD*VXYD
C+++
C       WRITE(6,2399)VL1,VT1,CTL1
C2399   FORMAT(' VL1,VT1,CTL1',3G15.5)
C+++
C***********************************************************************
C
C PREPARE DEVIATIONS. PROJECT TO MEAN CHAMBER PLANE.
C
        D1MEAN=0.5*(HD1(IFIRST)+HD1(IFIRST+1))
        GO TO (2101,2102,2103),IOR
C
 2101   DDC=(HDIST(IFRAME)+D1MEAN+IOVALL-X)/DCX
        CT=DCY*DDC+Y
        CL=DCZ*DDC+Z
        GO TO 2200
C
 2102   DDC=(HDIST(IFRAME)+D1MEAN-Y)/DCY
        CT=DCX*DDC+X
        CL=DCZ*DDC+Z
        GO TO 2200
C
 2103   DDC=(HDIST(IFRAME)+D1MEAN-Z)/DCZ
        CT=DCX*DDC+X
        CL=DCY*DDC+Y
C
C
C-----------------------------------------------------------------------
C
C  FIRST , LOOK TO SEE IF THE EDGE OF THE SENSITIVE REGION OF THIS
C  FRAME IS WITHIN N*SIGMA(DRIFT)/3*SIGMA(LONGL) OF THE EXTRAPOLATED
C  TRACK (WHERE SIGMA=  SIGMA(TRACK)  & N IS THE FACTOR (SEE CMUFFL)).
C  IF SO,THAT EXPLAINS ABSENCE OF HIT,SO DON'T RECORD AN INEFFICIENCY.
C  ALL 'LET-OFF' CLAIMS ARE CHECKED BY SUBROUTINE MULOCH.
C
 2200   ALLOWT=FACTOR*SQRT(VT1)
        ALLOWL=FACTOR*SQRT(VL1)
        LETDCE = .FALSE.
C
C          CALCULATE ANGLE CORRECTION OF FRAME POSITION WITH TRACK "Z" :
C
        CHAMZ = CL-ZMID
        IF(ABS(CHAMZ).GT.ZHAF)CHAMZ=SIGN(ZHAF,CHAMZ)
        CANGE = CHAMZ*FLOAT(IANGE)/10000.
        CANGL = CHAMZ*FLOAT(IANGL)/10000.
C
CCC     CTLO=HCTLO(IFRAME)
        CTLO=HCTLO(IFRAME)-ISHIFE+CANGE
C THIS NEXT STATEMENT REALLY DOES SAY IFRAML - 'L' FOR 'LAST'.
CCC     CTHI=HCTHI(IFRAML)
        CTHI=HCTHI(IFRAML)-ISHIFL+CANGL
        IFACE  = HFACE(IFRAME)
        IF(IOR.EQ.1) GO TO 2300
        CTLO=CTLO+IOVALL
        CTHI=CTHI+IOVALL
 2300   CLLO=HCLLO(IFRAME)
        CLHI=HCLHI(IFRAME)
C+++
C       WRITE(6,1278)CT,ALLOWT,CTLO,CTHI
C1278   FORMAT(' CT,ALLOWT,CTLO,CTHI',4G15.5)
C       WRITE(6,1279)CL,ALLOWL,CLLO,CLHI
C1279   FORMAT(' CL,ALLOWL,CLLO,CLHI',4G15.5)
C+++
        IFAZ = 1
        IF(CL+ALLOWL.LT.CLHI ) GO TO 3008
          REGZE(IZEP)   = IREGN
          REGZE(IZEP+1) = AB
          IF(IFACE.EQ.6) IFAZ = -1
          RZE1          = IFAZ * (CLHI-CL) /SQRT(VL1)
          RZE2          = IFAZ * (CLHI+5000-CL) /SQRT(VL1)
          REGZE(IZEP+2) = AMIN1(RZE1,RZE2)
          REGZE(IZEP+3) = AMAX1(RZE1,RZE2)
          IZEP  = IZEP + 4
          LETDCE = .TRUE.
          IFAZ = 1
 3008   IF(CL-ALLOWL.GT.CLLO ) GO TO 3009
          REGZE(IZEP)   = IREGN
          REGZE(IZEP+1) = AB
          IF(IFACE.EQ.5) IFAZ = -1
          RZE1          = IFAZ * (CLLO-CL) /SQRT(VL1)
          RZE2          = IFAZ * (CLLO-5000-CL) /SQRT(VL1)
          REGZE(IZEP+2) = AMIN1(RZE1,RZE2)
          REGZE(IZEP+3) = AMAX1(RZE1,RZE2)
          IZEP  = IZEP + 4
          LETDCE = .TRUE.
C                         WHEN A TRACK CHANGES FACES THE DEVIATIONS
C                         MUST HAVE THE SAME LEFT/RIGHT SIGN CONV.
 3009   IFAS = 1
        IF(IFACE.EQ.2 .OR. IFACE.EQ.3) IFAS = -1
        IF( CT+ALLOWT.LT.CTHI ) GO TO 3003
C
C                       SAVE THE REGION NUMBER AND UPPER AND LOWER
C                       LIMITS OF THE TRUE REGION EDGE IN SIGMA UNITS
C
          REGDCE(IDCEP)   = IREGN
          REGDCE(IDCEP+1) = AB
          RDCE1           = IFAS * (CTHI-CT) /SQRT(VT1)
          RDCE2           = IFAS * (CTHI+5000-CT) /SQRT(VT1)
          REGDCE(IDCEP+2) = AMIN1(RDCE1,RDCE2)
          REGDCE(IDCEP+3) = AMAX1(RDCE1,RDCE2)
          IDCEP  = IDCEP + 4
          LETDCE = .TRUE.
 3003   IF( CT-ALLOWT.GT.CTLO ) GO TO 3007
          REGDCE(IDCEP)   = IREGN
          REGDCE(IDCEP+1) = AB
          RDCE1           = IFAS * (CTLO-CT-5000) /SQRT(VT1)
          RDCE2           = IFAS * (CTLO-CT) /SQRT(VT1)
          REGDCE(IDCEP+2) = AMIN1(RDCE1,RDCE2)
          REGDCE(IDCEP+3) = AMAX1(RDCE1,RDCE2)
          IDCEP  = IDCEP + 4
          LETDCE = .TRUE.
C***********************************************************************
C
C  LOOK FOR DEAD CHAMBER WHICH MIGHT EXPLAIN ABSENCE OF HIT.
C  AT SAME TIME,LOOK FOR NEAREST GOOD CHAMBER SO ITS INEFFICIENCY
C    CAN BE RECORDED (IF THERE WAS NO DEAD CHAMBER NEARBY).
C
 3007   ADTMIN=1.E6
        DO 2500 ICHAM=IFIRST,ILAST
C
C  GET WIRE CTW,FRAME NO. FOR THIS CHAM,ORIENTATION,X OVAL DISP.
C
C
C******  AS OF 16/03/83 , APPLY SOFTWARE SHIFT TO WIRE POSITION FOR ALL
C******  DATA AFTER BEGINNING OF 1980 :
C
          ISHIFT=0
          IF(IYEAR.GE.1980)ISHIFT=HLSF(4,ICHAM)
          IF(IABS(ISHIFT).GT.300)ISHIFT=0
C             **** DON'T APPLY SOFTWARE SHIFTS TO MONTE-CARLO DATA.
          IF(KRUN.EQ.0)ISHIFT=0
CCC       ICWIRE=HCTW(ICHAM)
          ICWIRE=HCTW(ICHAM)-ISHIFT
C
C          CALCULATE ANGLE CORRECTION TO CHAMBER POSITION WITH "Z" :
C
          IFRAME=HFR(ICHAM)
          IANG=HANG(IFRAME)
          ZMID=0.5*( HCLLO(IFRAME) + HCLHI(IFRAME) )
          ZHAF=0.5*( HCLHI(IFRAME) - HCLLO(IFRAME) )
          CHAMZ=CL-ZMID
          IF(ABS(CHAMZ).GT.ZHAF)CHAMZ=SIGN(ZHAF,CHAMZ)
          CANG =CHAMZ*FLOAT(IANG)/10000.
          ICWIRE=ICWIRE+CANG
C
          IF(IOR.GT.1)ICWIRE=ICWIRE+IOVALL
          DT = ICWIRE - CT
          ADT=ABS(DT)
C
C FIND SMALLEST DT AND RECORD CHAMBER NUMBER.
C
          IF(ADT.GE.ADTMIN) GO TO 2461
          ADTMIN=ADT
          JCHAM=ICHAM
C
C CHECK FOR DEAD CHAMBER WITHIN ALLOWT+15CMS OF TRACK. IF FOUND, KEEP
C                                                                GOING.
 2461     IF(HMCSTA(ICHAM).EQ.0) GO TO 2500
C+++
C         WRITE(6,8723)ADT,ALLOWT
C8723     FORMAT(' ADT,ALLOWT',2G15.5)
C+++
          IF(ADT.GT.ALLOWT+150.) GO TO 2500
C
C                       SAVE THE REGION NUMBER,ABSORBER SO FAR AND
C                       THE UPPER AND LOWER LIMITS OF THE DEAD
C                       CHAMBER IN SIGMA UNITS.
C
            LETDCE = .TRUE.
            REGDCE(IDCEP)   = IREGN
            REGDCE(IDCEP+1) = AB
            RDCE1           = IFAS * ( DT - 150. )/SQRT(VT1)
            RDCE2           = IFAS * ( DT + 150. )/SQRT(VT1)
            REGDCE(IDCEP+2) = AMIN1(RDCE1,RDCE2)
            REGDCE(IDCEP+3) = AMAX1(RDCE1,RDCE2)
            IDCEP = IDCEP + 4
C
 2500   CONTINUE
        IF(LETDCE) GO TO 1000
C
C DID NOT FIND EDGE OR DEAD CHAMBER WHICH CAN EXPLAIN ABSENCE OF HIT.
C THEREFORE , MUST HAVE CHAMBER INEFFICIENCY . INCREMENT INEFF.
C ---- BUT KEEP TRACKING !
C
        INFLAG=1
        INEFF=INEFF+1
        IF(INEFF.GT.10) GO TO 4000
        INCHAM(INEFF)=JCHAM
        INREG(INEFF)=IREGN
        GO TO 4000
C
C-----------------------------------------------------------------------
C
C UPDATE A FEW THINGS FOR THIS 'GOOD' CHAMBER LAYER.
C
C
C UPDATE X8, ETC., THE VALUES AT LAST BUT ONE GOOD CHAMBER LAYER.
C
 4000   CALL UCOPY(X9,X8,NSPECI)
C
C UPDATE X9, ETC., THE VALUES AT LAST GOOD CHAMBER LAYER.
C
        CALL UCOPY(X,X9,NSPECI)
        NGLAYR=NGLAYR+LINC
C
 1000 CONTINUE
C
C-----------------------------------------------------------------------
C END OF MAIN LOOP OVER REGIONS. ---------------------------------------
C-----------------------------------------------------------------------
C
C             PERFORM MULOCH - THE MUON 'LET-OFF' CHECK
C
 99   CALL MULOCH
C
      RETURN
      END

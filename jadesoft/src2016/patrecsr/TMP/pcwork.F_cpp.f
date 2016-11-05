C   29/01/80 004241343  MEMBER NAME  PCWORK   (PATRECSR)    FORTRAN
      SUBROUTINE PCWORK(IF1,IF2,IF3,IF4,IF5)
      IMPLICIT INTEGER*2(H)
C
C
C----------------------------------------------------------------------
C         --------------  SUBROUTINE PCWORK  -----------------
C         --- G.F.PEARCE .. LAST UPDATE : 1400 ON 10/09/79 ---
C
C   SUBROUTINE TO DUMP ALL OR PARTS OF THE PATTERN RECOGNITION /CWORK/
C   THE LEVEL OF OUTPUT IS CONTROLLED BY THE FLAGS 'IF' VIZ.
C
C   IF1 = 1/0 => PRINT/NOPRINT OF TRACK ELEMENT HIT LABEL ARRAY
C   IF2 = 1/0 => PRINT/NOPRINT OF TRACK ELEMENTS
C   IF3 = 1/0 => PRINT/NOPRINT OF BACKTR RESULTS (CONNECTED TR.ELEMENTS)
C   IF4 = 1/0 => PRINT/NOPRINT OF TRACK COORDINATES (FXYZ/PATROL)
C   IF5 = 1/0 => PRINT/NOPRINT OF CWORK TRACK BANK (XYFIT/ZRFIT/CNTREL)
C----------------------------------------------------------------------
C
C
C=======================================================================
C
C  CONTENTS OF /CWORK/  ####### COMPILED BY G.F.PEARCE #######
C  ====================
C                        IN JET CHAMBER PATTERN RECOGNITION PROGRAMS
C
C       ----------------------
C   1). POINTERS AND WORKSPACE
C       ----------------------
C  HPLAST     = POINTER TO LAST AVAILABLE LOCATION IN ARRAY WRK
C  HPFREE     = POINTER TO FIRST CURRENTLY AVAILABLE LOCATION IN WRK
C  HPWRK      = RESERVED FOR POINTERS (SEE HPHT0 ETC.. BELOW)
C  HPHT0      = POINTER TO FIRST WORD OF HIT COORDINATE ARRAY
C  HPHT9      = POINTER TO LAST  WORD OF HIT COORDINATE ARRAY
C  HLDHT      = NUMBER OF 4 BYTE WORDS STORED PER HIT IN COORD. ARRAY
C  HPHT0A     = POINTER TO FIRST WORD OF SECOND ARRAY OF HIT COORDINATES
C               THIS ARRAY IS USED IN CASES WHERE THE BACKTRACE ROUTINE
C               COULD NOT UNAMBIGUOUSLY RESOLVE THE L/R AMBIGUITY. IN
C               SUCH A CASE THE HIT COORDINATES ARE COMPUTED FOR BOTH
C               L/R SOLUTIONS AND THE SECOND SOLUTION STORED HERE.
C               WHEN THE L/R AMBIGUITY IS RESOLVED THIS POINTER IS -VE.
C               AND THE SECOND SET OF COORDINATES DO NOT EXIST.
C  HPHT9A     = POINTER TO LAST WORD OF SECOND HIT COORDINATE ARRAY
C  HLDHTA     = NUMBER OF 4 BYTE WORDS STORED PER HIT ISECOND ARRAY
C  HPHTLM     = LIMIT ON HPHT0 FOR ADDING NEW HITS
C  HPTR0      = POINTER TO FIRST WORD OF TRACK BANK
C  HPTR9      = POINTER TO LAST  WORD OF TRACK BANK
C  HLDTR      = NUMBER OF 4 BYTE WORDS STORED PER FIT IN TRACK BANK
C  HPHL0      = POINTER TO FIRST WORD OF HIT LABEL ARRAY
C  HPHL9      = POINTER TO LAST WORD OF HIT LABEL ARRAY
C  HLDHL      = NUMBER OF WORDS STORED FOR EACH HIT IN HIT LABEL
C
C  ADWRK    ..   WORK ARRAY 600 WORDS LONG.
C
C       -----------------------------------
C   2). OUTPUT FROM TRACK ELEMENT ROUTINES.
C       -----------------------------------
C
C  HPRO       = ?
C
C  HNTR       = TOTAL NUMBER OF TRACK ELEMENTS IN ALL RINGS
C
C  HNTCEL(I)  = ELEMENT NUMBER OF FIRST TRACK ELEMENT IN CELL I
C                (IF (I).EQ.(I+1) THERE IS NO ELEMENT IN CELL I)
C
C  ITRKAR(I,J) = INFORMATION FOR I'TH TRACK ELEMENT. J AS FOLLOWS
C   J   NAME               CONTENTS
C  --- ------             ----------
C   1  IPCL  = CELL NUMBER CONTAINING TRACK ELEMENT I
C   2  NRHT  = NUMBER OF HITS ON TRACK ELEMENT
C   3  NWR1  = WIRE NUMBER OF FIRST HIT ON TRACK ELEMENT (0->15)
C   4  DS1   = DRIFT DISTANCE OF FIRST HIT ON TRACK ELEMENT (MM)
C   5  SL1   = DRIFT SLOPE FOR 1ST HIT ON TRACK ELEMENT(MM/WIRE SPACING)
C              ( (DS(2)-DS(0))/2 WHERE DS(0)=DRIFT DISTANCE FOR WIRE 0)
C   6  NWR2  = WIRE NUMBER OF LAST HIT ON TRACK ELEMENT (0->15)
C   7  DS2   = DRIFT DISTANCE OF LAST HIT ON TRACK ELEMENT (MM)
C   8  SL2   = DRIFT SLOPE FOR LAST HIT ON TRACK ELEMENT ( SEE SL1 )
C   9  LBL   = TRACK ELEMENT BIT CODED HISTORY WORD
C              BIT 13 ON  =>  L/R AMBIGUITY UNSOLVED
C  10  NTREL = TRACK ELEMENT NUMBER WRITTEN INTO THE HIT LABEL OF
C              EACH HIT ON THIS TRACK ELEMENT.
C  11  ICRO  =  WIRE NUMBER OF FIRST WIRE STRUCK AFTER TRACK ELEMENT
C               CROSSED WIRE BOUNDARY. IF ZERO NO CROSSING HAS OCCURED.
C
C
C       -------------------------------
C   3). OUTPUT FROM BACKTRACING ROUTINE
C       -------------------------------
C
C   NTR        = TOTAL NUMBER OF TRACKS FOUND BY BACKTRACE PROGRAM.
C   HNREL(I)   = NUMBER OF TRACK ELEMENTS ASSOCIATED WITH TRACK I
C   HISTR(I,J) = TRACK ELEMENT NUMBER FOR EACH TRACK ELEMENT (J)
C                 ASSIGNED TO TRACK NUMBER I.
C   HRES(I)    = RESERVED FOR GRAPHICS
C
C
C       ----------------------------------
C   4). OUTPUT FROM HIT COORDINATE ROUTINE (FXYZ+PATROL)
C       ----------------------------------
C
C     RELEVANT POINTERS ARE HPHT0,HPHT9,HLDHT (SEE 'POINTERS' ABOVE)
C
C     LOCATION     ALIAS               CONTENTS
C     --------     -----               --------
C     WRK      ..   HIT AND FIT INFORMATION .. SEE BELOW
C
C     FOR EACH HIT THE FOLLOWING INFORMATION IS STORED IN WRK/IWRK
C     ( HIT 1 BEING USED AS AN EXAMPLE )
C
C     IWRK(HPHT0+ 0) = LAYER NUMBER (0-15)
C     IWRK(HPHT0+ 1) = POINTER TO FIRST DATA WORD (IN BCS)
C     IWRK(HPHT0+ 2) = POINTER TO TRACK ELEMENT HIT LABEL WORD IN CWORK
C     WRK (HPHT0+ 3) = X COORDINATE (MMS)
C     WRK (HPHT0+ 4) = Y COORDINATE (MMS)
C     WRK (HPHT0+ 5) = Z COORDINATE (MMS)
C     WRK (HPHT0+ 6) = R COORDINATE (MMS)
C     WRK (HPHT0+ 7) = Z-COORDINATE ERROR FLAG. 0 => GOOD HIT IN R-Z FIT
C                                               2 => BAD  HIT IN R-Z FIT
C                                              10 => BAD L/R AMPLITUDES
C     IWRK(HPHT0+ 8) = TRACK ELEMENT NUMBER ON WHICH HIT WAS FOUND
C                      CARRIES SIGN OF L/R AMBIGUITY(-VE=LEFT,+VE=RIGHT)
C                      IF THIS IS +/- 1000, THEN HIT WAS FOUND BY PATROL
C     IWRK(HPHT0+ 9) = CELL NUMBER
C     IWRK(HPHT0+10) = X-Y FIT ERROR FLAG. 0 => GOOD HIT USED IN XYFIT
C                                          1 => BAD  HIT USED IN XYFIT
C                                        > 1 => BAD  HIT NOT USED IN FIT
C     WRK (HPHT0+11) = 1/COSINE OF ANGLE OF TRACK TO THE NORMAL TO THE
C                      DRIFT SPACE USED FOR ABERATION CORRECTION.
C     IWRK(HPHT0+12) = RING NUMBER
C     WRK (HPHT0+13) = RESIDUAL (FITTED-MEASURED) OF HIT FROM X-Y FIT.
C
C
C
C       ---------------------------
C   4). OUTPUT FROM FITTING PROGRAM (XYFIT)..  I.E. TRACK BANK
C       ---------------------------
C
C     RELEVANT POINTERS ARE HPTR0,HPTR9,HLDTR .. SEE 'POINTERS' ABOVE.
C
C     IWRK(HPTR0+ 0) = TRACK NUMBER
C     IWRK(HPTR0+ 1) = IDENTIFIER OF PROGRAM
C     IWRK(HPTR0+ 2) = DATE OF PRODUCTION
C     IWRK(HPTR0+ 3) = TYPE OF POINT (FOR FIRST MEASURED POINT)
C     IWRK(HPTR0+ 4) = X COORDINATE  (FOR FIRST MEASURED POINT)
C     IWRK(HPTR0+ 5) = Y COORDINATE  (FOR FIRST MEASURED POINT)
C     WRK (HPTR0+ 6) = Z COORDINATE  (FOR FIRST MEASURED POINT)
C     WRK (HPTR0+ 7) = DX            (FOR FIRST MEASURED POINT)
C     WRK (HPTR0+ 8) = DY            (FOR FIRST MEASURED POINT)
C     WRK (HPTR0+ 9) = DZ            (FOR FIRST MEASURED POINT)
C     WRK (HPTR0+10) = TYPE OF POINT (FOR LAST  MEASURED POINT)
C     WRK (HPTR0+11) = X COORDINATE  (FOR LAST  MEASURED POINT)
C     WRK (HPTR0+12) = Y COORDINATE  (FOR LAST  MEASURED POINT)
C     WRK (HPTR0+13) = Z COORDINATE  (FOR LAST  MEASURED POINT)
C     WRK (HPTR0+14) = DX            (FOR LAST  MEASURED POINT)
C     WRK (HPTR0+15) = DY            (FOR LAST  MEASURED POINT)
C     WRK (HPTR0+16) = DZ            (FOR LAST  MEASURED POINT)
C     IWRK(HPTR0+17) = TYPE OF FITTING PROGRAM USED IN X-Y PLANE
C                    = 1 FOR CIRCLE FIT
C                    = 2 FOR PARABOLA FIT
C     IWRK(HPTR0+18) = FIRST FIT PARAMETER  FROM XYFIT
C     IWRK(HPTR0+19) = SECOND FIT PARAMETER FROM XYFIT
C     IWRK(HPTR0+20) = THIRD FIT PARAMETER  FROM XYFIT
C     IWRK(HPTR0+21) = FOURTH FIT PARAMETER FROM XYFIT
C     IWRK(HPTR0+22) = RMS PER D.F. FROM XYFIT
C     WRK (HPTR0+23) = NUMBER OF POINTS USED IN XYFIT
C     WRK (HPTR0+24) = TRACK CURVATURE
C     WRK (HPTR0+25) = DELTA CURVATURE
C     WRK (HPTR0+26) = TRACK CURVATURE AT FIRST MEASURED POINT
C     WRK (HPTR0+27) = TRACK CURVATURE AT LAST  MEASURED POINT
C     IWRK(HPTR0+28) = TYPE OF FITTING PROGRAM USED IN Z-R PLANE
C     WRK (HPTR0+29) = FIRST FIT PARAMETER FROM ZRFIT  (SLOPE)
C     WRK (HPTR0+30) = SECOND FIT PARAMETER FROM ZRFIT(INTERCEPT)
C     WRK (HPTR0+31) = RMS PER D.F. FROM ZRFIT
C     IWRK(HPTR0+32) = NUMBER OF POINTS USED IN ZRFIT
C     IWRK(HPTR0+33) = CELL NUMBERS THAT CONTAIN HITS ON THE TRACK
C     IWRK(HPTR0+34) =   "     "      "     "      "   "  "    "
C     IWRK(HPTR0+35) =   "     "      "     "      "   "  "    "
C     IWRK(HPTR0+36) =   "     "      "     "      "   "  "    "
C     IWRK(HPTR0+37) =   "     "      "     "      "   "  "    "
C     IWRK(HPTR0+38) =   "     "      "     "      "   "  "    "
C     IWRK(HPTR0+39) = POINTER TO CORRESPONDING LEAD GLASS CLUSTER
C     IWRK(HPTR0+40) = POINTER TO CORRESPONDING MUON CHAMBER HITS
C     IWRK(HPTR0+41) = POINTER TO CORRESPONDING TRACK BANK IN TP BANK
C     IWRK(HPTR0+42) = POINTER TO CORRESPONDING TOF BANK
C     IWRK(HPTR0+43) = FREE
C     IWRK(HPTR0+44) = FREE
C     IWRK(HPTR0+45) = FREE
C     IWRK(HPTR0+46) = FREE
C     IWRK(HPTR0+47) = BIT CODED ERROR CODE (ALL BITS OFF => ALL OK)
C                      BIT 31 => BAD FIT IN X-Y PLANE
C                      BIT 30 => L/R AMBIGUITY OF TRACK UNCERTAIN
C                      BIT 29 => XYFIT TRIED REJECTING THE TRACK ELEMENT
C                               WITH THE WORST CHI**2 TO RECOVER FROM A
C                               BAD INITIAL FIT.
C                      BIT 28 => XYFIT TRIED RESTARTING BY FITTING ONLY
C                               THE LONGEST TRACK ELEMENT IN ORDER TO
C                               RECOVER FROM A BAD INITIAL FIT AFTER
C                               THE BIT 29 PROCEDURE ABOVE FAILED.
C                      BIT 27 => PATROL ADDED > IXYF( ) (SEE CPATLM) NEW
C                                HITS TO THE TRACK WHICH ALSO BELONG TO
C                                ANOTHER TRACK IN THIS EVENT
C                      BIT 26 => PATROL CALLED FOR A RE-FIT TO THE TRACK
C                                AFTER FINDING SOME NEW HITS AND THIS
C                                FAILED (BAD CHI**2). THE FIT IN THE
C                                TRACK BANK WILL CORRESPOND TO THE LAST
C                                GOOD FIT OF THIS TRACK.
C                      BIT 25 => VERY LOW MOMENTUM TRACK
C                      BIT 24 => BAD FIT IN Z-R PLANE
C                      BIT 23 => > N POINTS REJECTED BY ZRFIT.
C                      BIT 22 => TRACK NOT CONNECTED INTO RING 1 BY
C                                BACKTRACE PROGRAM (ALTHOUGH IF SUCH
C                                HITS EXIST THEY WILL HAVE BEEN FOUND
C                                AT A LATER STAGE BY THE PATROL PROGRAM
C                                AND INCLUDED ON THE TRACK).
C                      BIT 21 => TRACK NOT CONNECTED INTO RING 2 BY
C                                BACKTRACE PROGRAM ALTHOUGH BOTH RINGS
C                                1 AND 3 WERE PRESENT.  (AGAIN IF SUCH
C                                HITS EXIST THEY WILL HAVE BEEN FOUND
C                                AT A LATER STAGE BY THE PATROL PROGRAM
C                                AND INCLUDED ON THE TRACK).
C
C=======================================================================
C----------------------------------------------
C  MACRO CWORKPR .... PATTERN RECOGNITION CWORK
C----------------------------------------------
      COMMON /CWORK/ HPLAST,HPFREE,HPWRK(30),ADWRK(600),
     ,               HPRO,HNTR,HNTCEL(98),IPCL(200),NRHT(200),
     ,               NWR1(200),DS1(200),SL1(200),
     ,               NWR2(200),DS2(200),SL2(200),
     ,               LBL(200),NTREL(200),ICRO(200),
     ,               NTR,HNREL(100),HISTR(9,100),HRES(168),
     ,               NTRLM,RLMTR(3,5),
     ,               WRK(7000)
                     DIMENSION TRKAR(200,11),ITRKAR(200,11),
     ,                         LMRTR(3,5)
                     EQUIVALENCE (IPCL(1),TRKAR(1,1),ITRKAR(1,1))
                     EQUIVALENCE (LMRTR(1,1),RLMTR(1,1))
         DIMENSION IWRK(7000),HWRK(14000),IDWRK(600),HDWRK(1200)
                     EQUIVALENCE (IWRK(1),WRK(1),HWRK(1))
                     EQUIVALENCE (IDWRK(1),ADWRK(1),HDWRK(1))
C---------- END OF MACRO CWORKPR --------------
C-------------------------------------------------------
C  MACRO CWORKEQ .... PATTERN RECOGNITION CWORK POINTERS
C-------------------------------------------------------
      EQUIVALENCE
C                POINTERS FOR FXYZ HIT ARRAY .. PRIMARY L/R SOLUTION
     +          (HPHT0,HPWRK( 1)),(HPHT9,HPWRK( 2)),(HLDHT,HPWRK( 3))
C                POINTERS FOR CWORK SINGLE TRACK PATR BANK
     +         ,(HPTR0,HPWRK( 4)),(HPTR9,HPWRK( 5)),(HLDTR,HPWRK( 6))
C                POINTERS FOR TRACK ELEMENT HIT LABEL ARRAY
     +         ,(HPHL0,HPWRK( 7)),(HPHL9,HPWRK( 8)),(HLDHL,HPWRK( 9))
C                POINTERS FOR FXYZ HIT ARRAY .. OPPOSITE L/R SOLUTION
     +         ,(HPHT0A,HPWRK(10)),(HPHT9A,HPWRK(11)),(HLDHTA,HPWRK(12))
C               POINTER LIMIT ON FXYZ HIT ARRAY
     +         ,(HPHTLM,HPWRK(13))
C               POINTERS FOR
     +         ,(HPTE0,HPWRK(14)),(HPTE9,HPWRK(15)),(HLDTE,HPWRK(16))
C-------------- END OF MACRO CWORKEQ ------------------
C----------------------------------------------------------------------
C             MACRO CDATA .... BOS COMMON.
C
C             THIS MACRO ONLY DEFINES THE IDATA/HDATA/ADATA NAMES.
C             THE ACTUAL SIZE OF /BCS/ IS FIXED ON MACRO CBCSMX
C             OR BY OTHER MEANS. A DEFAULT SIZE OF 40000 IS GIVEN HERE.
C
C----------------------------------------------------------------------
C
      COMMON /BCS/ IDATA(40000)
      DIMENSION HDATA(80000),ADATA(40000),IPNT(50)
      EQUIVALENCE (HDATA(1),IDATA(1),ADATA(1)),(IPNT(1),IDATA(55))
      EQUIVALENCE (NWORD,IPNT(50))
C
C------------------------ END OF MACRO CDATA --------------------------
C
C
C----------------------------------------------------------------------
C                      DUMP OF CWORK HIT LABEL ARRAY
C----------------------------------------------------------------------
C
      IF (IF1.EQ.0) GOTO20
C=====
      PRINT11,HPHL0,HPHL9,HLDHL
 11   FORMAT(
     + 1X,46('-')/
     + ' DUMP OF TREL HIT LABEL ARRAY FROM PATREC CWORK',
     + ' .. HPHL0  =',I5,' HPHL9  =',I5,' HLDHL  =',I5/
     + 1X,46('-'))
      I1 = HPHL0
      I2 = HPHL9
      PRINT12,(HWRK(I),I=I1,I2)
 12   FORMAT(   13(    ' ',Z4,',',Z4     ) )
C
C----------------------------------------------------------------------
C              DUMP OF RESULTS OF TRACK ELEMENT ROUTINE
C----------------------------------------------------------------------
C
 20   IF (IF2.EQ.0) GOTO30
C=====
      PRINT21
 21   FORMAT(
     + 1X,40('-')/
     + ' DUMP OF TRACK ELEMENTS FROM PATREC CWORK'/
     + 1X,40('-'))
C=====
      PRINT22,HPRO,HNTR,(HNTCEL(I),I=1,98)
 22   FORMAT(
     +' HPRO =',I10,5X,'HNTR = TOTAL NO OF TRACK ELEMENTS =',I6/
     +' HNTCEL =',31I4/9X,31I4/9X,31I4/9X,4I4)
C=====
      PRINT23
 23   FORMAT(
     +' TREL IPCL NRHT',
     +'  NWR1    DS1    SL1 ',
     +'  NWR2    DS2    SL2 ',
     +'   LABEL   NTREL ICRO')
      IMAX = HNTR
C=====
      PRINT24,(I,IPCL(I),NRHT(I),NWR1(I),DS1(I),SL1(I),NWR2(I),
     +DS2(I),SL2(I),LBL(I),NTREL(I),ICRO(I),I=1,IMAX)
 24   FORMAT(1X,I3,1X, I4,1X, I4,1X, I5,1X, F7.1, F7.1, I6,1X,
     + F7.1 , F7.1 , 3X,Z8, I5,1X, I3)
C=====
      PRINT29
 29   FORMAT(1X,20('-'),' END OF TRACK ELEMENT DUMP ',20('-'))
C
C----------------------------------------------------------------------
C               DUMP OF RESULTS OF BACKTRACE PROGRAM
C----------------------------------------------------------------------
C
 30   IF (IF3.EQ.0) GOTO40
C=====
      PRINT31
 31   FORMAT(
     + 1X,42('-')/
     + ' DUMP OF BACKTRACE RESULT FROM PATREC CWORK'/
     + 1X,42('-'))
C=====
      PRINT32,NTR
 32   FORMAT(' NTR = NUMBER OF TRACKS =',I4)
C=====
      DO 34 I=1,NTR
      JJ=HNREL(I)
      PRINT33,I,JJ,(HISTR(J,I),J=1,JJ)
 33   FORMAT(' TRACK',I3,I6,' TRACK ELEMENTS =',9I4)
 34   CONTINUE
      PRINT39
 39   FORMAT(1X,20('-'),' END OF BACKTRACE DUMP ',20('-'))
C
C----------------------------------------------------------------------
C              DUMP OF HIT COORDINATE ARRAY (FXYZ)
C----------------------------------------------------------------------
C
 40   IF (IF4.EQ.0) GOTO50
C=====
      NHIT = 0
      IF (HLDHT.GT.0) NHIT = (HPHT9-HPHT0+1)/HLDHT
C=====
      PRINT41,HPHT0,HPHT9,HLDHT,HPHL0,HPHL9,HLDHL
     +       ,HPHT0A,HPHT9A,HLDHTA
     +       ,HPHTLM,NHIT
 41   FORMAT(
     + 1X,30('-'), ' .. HPHT0  =',I5,' HPHT9  =',I5,' HLDHT  =',I3,
     +             ' .. HPHL0  =',I5,' HPHL9  =',I5,' HLDHL  =',I5/
     +  ' FXYZ HIT ARRAY IN PATREC CWORK',
     +  ' .. HPHT0A =',I5,' HPHT9A =',I5,' HLDHTA =',I3/
     + 1X,30('-'), ' .. HPHTLM =',I4,' TOTAL NUMBER OF HITS =',I4)
C=====
      IF (HPHT0.LE.0) GOTO45
      IF (HLDHT.LE.0) GOTO45
      IF (HPHT9.LE.HPHT0) GOTO45
      IF (HPHT9.GT.10000) GOTO45
C=====
      PRINT42
 42   FORMAT(' LOCN'
     +,   ' RING CELL LAYER  TREL'
     +,   '  DATA  DRIFT   IAMPL  IAMPR'
     +,   ' HPHL'
     +,   '   BETA'
     +,   '     X        Y        Z        R   '
     +,   '  XY-CHI'
     +,   '  XYF ZRF')
C=====
      I1 = HPHT0
      I2 = HPHT9
      I3 = HLDHT
      DO 43 I=I1,I2,I3
      JJ  = IWRK(I+1)
      IAL = HDATA(JJ+1)
      IAR = HDATA(JJ+2)
      IDS = HDATA(JJ+3)
      PRINT44,I,
     + IWRK(I+12),IWRK(I+9),IWRK(I),IWRK(I+8),
     + IWRK(I+1),IDS,IAL,IAR,
     + IWRK(I+2),WRK(I+11),WRK(I+3),WRK(I+4),
     + WRK(I+5),WRK(I+6),WRK(I+13),IWRK(I+10),
     + IWRK(I+7)
 43   CONTINUE
 44   FORMAT(I5
     +,      I4 , I5 , I5 , I7
     +,      I7,I7,I7,I7
     +,      I6
     +,      F7.3
     +,      4(1X,F8.2)
     +,      F8.3
     +,      2I4)
      GOTO48
C=====
 45   PRINT46
 46   FORMAT(' ------ POINTER ERROR ------')
C=====
 48   CONTINUE
      PRINT49
 49   FORMAT(1X,20('-'),' END OF HIT COORDINATE DUMP ',20('-'))
C
C----------------------------------------------------------------------
C                    DUMP OF TRACK BANK FROM CWORK
C----------------------------------------------------------------------
C
 50   IF (IF5.EQ.0) GOTO60
C=====
      I = HPTR0
      PRINT51,IWRK(I),IWRK(I+1),IWRK(I+2) , HPTR0,HPTR9,HLDTR
 51   FORMAT(
     + 1X,35('-')/
     +  ' DUMP OF TRACK BANK FROM PATREC CWORK',
     +  ' .. TRACK',I3,' PROGRAM =',I3,' DATE =',I9/
     + 1X,35('-'),
     + 2X,'HPTR0 =',I5,2X,'HPTR9 =',I5,2X,'HLDTR =',I4)
C=====
      PRINT52
C      START POINT TYPE,X,Y,Z,DX,DY,DZ
     +,IWRK(I+3),WRK(I+4),WRK(I+5),WRK(I+6),WRK(I+7),WRK(I+8),WRK(I+9)
C      END   POINT TYPE,X,Y,Z,DX,DY,DZ
     +,IWRK(I+10),WRK(I+11),WRK(I+12),WRK(I+13),WRK(I+14),WRK(I+15)
     +           ,WRK(I+16)
C      FIT TYPE, FIT PARAMETERS, RMS AND NO. POINTS USED FOR X-Y PLANE
     +,IWRK(I+17),WRK(I+18),WRK(I+19),WRK(I+20),WRK(I+21),WRK(I+22)
     +,IWRK(I+23)
C      TRACK CURVATURES FROM X-Y FIT
     +,WRK(I+24),WRK(I+25),WRK(I+26),WRK(I+27)
C
 52   FORMAT(
     +' FIRST POINT ON TRACK ... TYPE =',I3,
     +' (X,Y,Z) = (',3E11.4,')',' (DX,DY,DZ) = (',3E11.4,')'/
C    #
     +' LAST  POINT ON TRACK ... TYPE =',I3,
     +' (X,Y,Z) = (',3E11.4,')',' (DX,DY,DZ) = (',3E11.4,')'/
C    #
     +' XYFIT .. PROGRAM TYPE =',I3,' FITTED PARAMETERS = (',4E11.4,')',
     +' RMS =',E11.4,' POINTS USED =',I4/
C    #
     + 28X,'CURVATURE =(',E11.4,' +-',E11.4,')',
     +'   CURVATURE AT START AND END POINTS = (',E11.4,',',E11.4,')')
C=====
      PRINT53,IWRK(I+28),WRK(I+29),WRK(I+30),WRK(I+31),IWRK(I+32)
 53   FORMAT(
     +' ZRFIT .. PROGRAM TYPE =',I3,' FITTED PARAMETERS = (',2E12.4,')',
     +' RMS =',E11.4,' POINTS USED =',I4)
C=====
      PRINT54,IWRK(I+33),IWRK(I+34),IWRK(I+35),IWRK(I+36),IWRK(I+37),
     +        IWRK(I+38)
 54   FORMAT(' CELLS CONTAINING HITS ON THE TRACK ARE',6I4)
C=====
      PRINT55,IWRK(I+39),IWRK(I+40),IWRK(I+41),IWRK(I+42)
 55   FORMAT(' POINTERS TO THE CONNECTED :',
     +'  1) LEAD GLASS CLUSTER =',I5,
     +'  2) MUON HITS =',I5,
     +'  3) TP TRACK BANK =',I5,
     +'  4) TOF BANK =',I5)
C=====
      PRINT58,IWRK(I+47)
 58   FORMAT(' TRACK ERROR CODE BIT STRUCTURE =',Z4)
C=====
      PRINT59
 59   FORMAT(1X,20('-'),' END OF TRACK BANK DUMP ',20('-'))
 60   CONTINUE
      RETURN
      END

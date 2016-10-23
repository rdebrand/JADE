C   14/05/81 203291919  MEMBER NAME  GBOOK    (JADESR)      FORTRAN
C
C-----------------------------------------------------------------------
C
C  GFP 14/5/81
C
C  SIMPLISTIC HISTOGRAM PACKAGE PATCHED UP TO LOOK LIKE HBOOK
C  INTENDED FOR USE IN JADE REDUC1 PACKAGE AT RUTHERFORD TO SAVE CORE
C  ONLY 1-D HISTOGRAMS ARE PROCESSED -- 2-D PLOTS ARE IGNORED
C
C
C
C
C
C
C     ALL DATA IS STORED IN COMMON/CGBOOK/. THIS VERSION STORES
C     1 HISTOGRAM, BUT THIS CAN BE INCREASED BY CHANGING THE
C     SIZE OF THE ARRAY PLOT(116,10) IN YOUR OWN PROGRAM
C
C
C
C     THE HISTOGRAM BINNING FORMULA IS
C
C          IBIN=(XHIST-START)/BINSIZE+1
C
C     EVALUATED TO THE RULES OF OS/370 FORTRAN G1.
C     THIS IMPLIES THAT IF YOU EQUATE AN INTEGER TO A FLOATING
C     POINT NUMBER AND THEN HISTOGRAM THE FLOATING POINT,IT WILL
C     OCCUR AT THE LEFT-HAND EDGE OF A BIN.
C
C     NOTE -- WEIGHTS ARE IGNORED; YOU ALWAYS GET 100 BINS.
C     ----
C
C STORAGE SPACE IN ARRAY PLOT USED AS FOLLOWS :
C
C    PLOT(1->100) = HISTOGRAM
C    PLOT(101) = XMIN
C    PLOT(102) = XMAX
C    PLOT(103) = BINSIZE
C    PLOT(104) = UNDERFLOWS
C    PLOT(105) = OVERFLOWS
C    PLOT(106) = PLOT XREF IDENTIFIER  (INTEGER)
C    PLOT(107->116) = TITLE
C
C-----------------------------------------------------------------------
      SUBROUTINE HBOOK1(IDREF,ITIT,NBINS,XMIN,XMAX)
      COMMON/CGBOOK/PLOT(116,1)
      COMMON/CGB947/MAXLIN,MAXPLO
      INTEGER ITIT(1)
      LOGICAL*1 TIT(40)
      LOGICAL*1 BLANK/' '/,LOGTIT(2)/' ',' '/,TITEND
      INTEGER*4    IPLOT(116,1)
      INTEGER*2 COMTIT,DOLLAR/' $'/
      EQUIVALENCE (PLOT(1,1),IPLOT(1,1)),(COMTIT,LOGTIT(1))
C
C -- CHECK FOR DOUBLE DEFINITION
C
      CALL UCOPY(ITIT(1),TIT(1),10)
      IF(MAXPLO.EQ.0)GOTO30
      DO 20 I=1,MAXPLO
      IF(IPLOT(106,I).NE.IDREF)GOTO20
      PRINT10,IDREF
 10   FORMAT(' *** GBOOK1 PLOT ',I5,' DOUBLY DEFINED')
      GOTO60
 20   CONTINUE
C
C -- INITIALISE NEW PLOT
C
 30   ID=MAXPLO+1
      CALL UZERO(PLOT(1,ID),1,105)
       PLOT(101,ID)=XMIN
       PLOT(102,ID)=XMAX
       PLOT(103,ID)=(XMAX-XMIN)/100.
      IPLOT(106,ID)=IDREF
C -- TITLE
      TITEND=.FALSE.
      DO 40 I=1,40
      LOGTIT(2)=TIT(I)
      IF(COMTIT.EQ.DOLLAR)TITEND=.TRUE.
 40   IF(TITEND)TIT(I)=BLANK
      CALL UCOPY(TIT(1),PLOT(107,ID),10)
      MAXPLO=ID
      PRINT50,ID,IDREF,PLOT(101,ID),PLOT(102,ID),(PLOT(I,ID),I=107,116)
  50  FORMAT(' GBOOK1 PLOT ',I3,' .. ID',I4,3X,
     + 'XMIN =',E11.4,2X,'XMAX =',E11.4,3X,10A4)
  60  RETURN
      END
      SUBROUTINE HBOOK2(IDREF,TIT,NBINX,XMIN,XMAX,NBINY,YMIN,YMAX)
      INTEGER TIT(1)
      RETURN
      END
      SUBROUTINE HF2(IDREF,X,Y,WEIGHT)
      RETURN
      END
      SUBROUTINE HFILL(IDREF,X,Y,WEIGHT)
      CALL HF1(IDREF,X)
      RETURN
      END
      SUBROUTINE HF1(IDREF,X,WEIGHT)
      COMMON/CGBOOK/PLOT(116,10)
      INTEGER*4    IPLOT(116,1)
      COMMON/CGB947/MAXLIN,MAXPLO
      EQUIVALENCE (PLOT(1,1),IPLOT(1,1))
C
C -- FIND PLOT NUMBER
C
      DO 10 ID=1,MAXPLO
      IF(IPLOT(106,ID).EQ.IDREF)GOTO20
 10   CONTINUE
      RETURN
C
C -- LOAD ENTRY
C
 20   IF(PLOT(103,ID).EQ.0.0)RETURN
      IF(X.LT.PLOT(101,ID))GOTO30
      IF(X.GE.PLOT(102,ID))GOTO40
      B=X-PLOT(101,ID)
      IBIN = (X-PLOT(101,ID)) / PLOT(103,ID) + 1
      PLOT(IBIN,ID)= PLOT(IBIN,ID)+1.
      RETURN
 30   PLOT(104,ID) = PLOT(104 ,ID)+1.
      RETURN
 40   PLOT(105,ID) = PLOT(105 ,ID)+1.
      RETURN
      END
      SUBROUTINE HISTDO
      COMMON/CGBOOK/PLOT(116,10)
      INTEGER*4    IPLOT(116,1)
      COMMON/CGB947/MAXLIN,MAXPLO
      DIMENSION PLOT1(100),LINE(100),POINT(10)
      LOGICAL*1 ALINE(4,100)
      INTEGER SPACE/'    '/,STAR/'XXXX'/
      EQUIVALENCE (PLOT(1,1),IPLOT(1,1)),(LINE(1),ALINE(1,1))
C
C -- LOOP OVER THE PLOTS
C
      DO 200 ID=1,MAXPLO
C -- ZERO BINSIZE ?
      IF(PLOT(103,ID).EQ.0.0)GO TO 200
C
C LARGEST BIN, WEIGHTED TOTAL AND SUM TOTAL
C
      TOT=0.
      TAV=0.0
      TMAX=0.
      DO 30 J=1,100
      IF(PLOT(J,ID).GT.TMAX)TMAX=PLOT(J,ID)
      FI=FLOAT(J)-0.5
      TAV=TAV+(PLOT(101,ID)+FI*PLOT(103,ID))*PLOT(J,ID)
 30   TOT=TOT+PLOT(J,ID)
C -- EMPTY ?
      IF( (TOT+PLOT(104,ID)+PLOT(105,ID)) .LT. 1.0)GOTO200
C
C -- PRINT TITLE
C
      PRINT40,IPLOT(106,ID),(PLOT(J,ID),J=107,116)
 40   FORMAT(1H1,10X,'PLOT NUMBER',I5,5X,10A4)
      PRINT50
 50   FORMAT(1H0,10X,10('I',9X),/11X,100('-'))
C
C -- PRINT HISTOGRAM
C
      FULL=MAXLIN-20
      TMAX2=TMAX
      IF(TMAX2.LT.FULL)TMAX2=FULL
      DO 60 J=1,100
 60   PLOT1(J)=(PLOT(J,ID)*FULL)/TMAX2+0.0001
      ILINE=FULL
      DO 90 J=1,ILINE
      KBACK=ILINE-J
C SINGLE HORIZONTAL LINE
      DO 70 K=1,100
      LINE(K)=SPACE
      ISTAR=PLOT1(K)
 70   IF(ISTAR.GT.KBACK)LINE(K)=STAR
      PRINT80,LINE
 80   FORMAT(1H ,9X,'I',100A1,'I')
 90   CONTINUE
      PRINT100
 100  FORMAT(1H ,10X,100('-'),/11X,10('L',9X))
C
C -- PRINT X-COORDINATES
C
      DO 110 KK=1,10
 110  POINT(KK)=PLOT(101,ID)+(KK-1)*PLOT(103,ID)*10.0
      PRINT120,POINT
 120  FORMAT(6X,10(E9.3,1X),/1X)
C
C -- PRINT HISTOGRAM BIN CONTENTS
C
      LSUM=0
      DO 140 KK=1,5
      K=6-KK
      DO 130 JJ=1,100
      FIB=(PLOT(JJ,ID)+0.0001) / (10**K)
      IB1 = FIB * 10
      IB2 = FIB
      LIN = 0.0001 + IB1 - 10.0*IB2
      LSUM=LSUM+LIN
      LIN=LIN+240
      IF( (LIN.EQ.240) .AND. (LINE(JJ).EQ.SPACE.OR.KK.EQ.1) ) LIN=SPACE
      LINE(JJ) = LIN
 130  CONTINUE
      IF(LSUM.GT.0)PRINT150,(ALINE(4,JJ),JJ=1,100)
 140  CONTINUE
 150  FORMAT(1H ,10X,100A1)
C
C -- PRINT PLOT STATISTICS
C
      PRINT160,TOT,TMAX,PLOT(104,ID),PLOT(105,ID)
 160  FORMAT(1H0,'NUMBER OF EVENTS IN PLOT =',F10.0,10X,
     1 'MAXIMUM BIN CONTENTS =',F10.0,//1X,'UNDERFLOWS =',F10.0,
     2 10X,'OVERFLOWS =',F10.0)
C
C -- CALCULATE MEAN AND SIGMA
C
      IF(TOT.LT.2.)GO TO 200
      TAV=TAV/TOT
      STDDEV=0.0
      DO 170 J=1,100
      FJ=FLOAT(J)-0.5
 170  STDDEV=STDDEV+(((PLOT(101,ID)+FJ*PLOT(103,ID))-TAV)**2)*PLOT(J,ID)
      STDDEV=SQRT(STDDEV/(TOT-1.0))
      PRINT180,TAV,STDDEV
  180 FORMAT(1H0,'MEAN=',E11.4,'   STD DEVIATION=',E11.4)
  200 CONTINUE
      RETURN
      END
      SUBROUTINE HBLACK(I)
      RETURN
      END
      SUBROUTINE HLIMIT(I)
      RETURN
      END
      SUBROUTINE H1EVLI(I)
      RETURN
      END
      BLOCK DATA
      COMMON/CGB947/MAXLIN,MAXPLO
      INTEGER*4 MAXLIN/60/,MAXPLO/0/
      END

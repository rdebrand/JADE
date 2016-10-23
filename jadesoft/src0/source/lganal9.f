C   11/07/79 808021741  MEMBER NAME  LGANAL9  (SOURCE)      FORTRAN

C---- MAIN SUBROUTINE FOR THE 1-ST STEP L-GLASS ANALYSIS.

C=======================================================================
      SUBROUTINE LGANAL
C=======================================================================
C
C     S.YAMADA  31-10-78  14:35
C          MODIFICATION    01-08-79  24:00  IZ=0&31 KILLED
C          MODIFICATION    07-01-79  24:00  NEG ENERGY TO 20000
C                                                 Y.WATANABE
C.....THE #WORDS/CLUSTER IS NOW 16..  13/6/80     Y.WATANABE
C          MOD.     04-12-84   18:25    WORK SPACE CLEAR (5200->5520)
C                                                 S.YAMADA

C       MOD. 16/01/86 : POSSIBILITY TO ERASE ONLY THE UNPHYSICAL
C                       HALFRINGS FORESEEN. FOR FURTHER COMMENTS SEE
C                       SUBROUTINE LGERSE.
C                                                         M. KUHLEN

C---   CHANGED TO CALL CALCOR FOR REAL DATA  02.08.88  D.PITZL


      IMPLICIT INTEGER *2 (H)

#include "'f11god.patrecsr.for"

#include "'jadelg.source.for"

C---  NCLST = NO.OF THE LOCATED CLUSTERS.
C     MAPCL(J)=THE INDEX OF THE FIRST MEMBER OF THE J-TH CLUSTER
C               IN THE HLGADC. (THE FIRST 51 WORDS OF CLMPRP)

      COMMON /CLGPRM/ ITH,MAXCLS,IRLTHD,IRLTH2,IRLTH3, ZVRTX,DZ

      COMMON /CLGMSB/ MSGVAL

      DATA NMLGCL/'LGCL'/,  LGANVR/1/,  MESS/0/

      DATA NCALL / 0 /

      NCALL = NCALL + 1
      DATA IINIT / 0 /

      IF ( IINIT .GT. 0 ) GO TO 14
      IINIT = 1
      IPLGCL = IBLN ( NMLGCL )
14    CONTINUE

C---- FOR THE FIRST CALL PRINT THE LG-CLUSTER FINDING PARAMETERS.
      IF ( MESS ) 1001,1000,1001
 1000 CALL LGMESG( 2, 0)
      MESS = 1


C---- FILL HEADER AND CONSTANTS IN THE GENERAL LG-INF. OF THE EVENT.
 1001 IDENT(1) = LGANVR
      IDENT(2) = IDATTM(DUM)

C---- CLEAR CLUSTER RESULTS ARRAY
      CALL SETSL(NCLST,0,5520,0)

C---- SET NO.OF WORDS/CLUSTER
      NWPCL = 16

C---- SET THE FLAG OF LG-ANALYSIS STEP-1.
      IFLAG(2) = 1
C
C*******************************************************************

C       LEAD GLASS CLUSTER FINDING

C     LG-ADC DATA IS MOVED FROM 'ALGN' TO /CWORK/.
      CALL LGDCPY( NP, IFLAG(1))

C---- CHECK IF THERE IS ANY LG-DATA.
      IF(NP.LE.0) GO TO 5

C---- IF DATA FORMAT ERROR IS FOUND,SKIP ANALYSIS AND MAKE AN EMPTY RES.
C     IFLAG(1)=1,IF NOT CALIBRATED.
C     IFLAG(1)=2,IF NOT ALL DATA ARE COPIED DUE TO THE BUFFER SIZE.
C     IFLAG(1)=1024,IF FORMAT CONVRSION IS NOT DONE.

      IF(IFLAG(1).GE.1024) GO TO 5

C#####KILL IZ=0&31 RINGS BECAUSE THEY ARE NOT REAL.
      NHIT=LNG-3
      IF ( NHIT .LE. 0 ) GO TO 85
      IF ( HLGADC (1,1) .GE. 2688 ) HPOINT(2)=1
 150  CONTINUE
      DO 80 I=1, NHIT
C        PROTECTION HERE TO CORRECT NEGATIVE ENRGY DUE TO OVERFLOW.
         HPH = HLGADC (2,I)
         IF ( HPH .LT. 0 ) HLGADC(2,I)=20000
         IADC = HLGADC (1,I)
         IF ( IADC .GT. 2687 ) GO TO 80
         IRING = MOD ( IADC, 32 )

C  TO ERASE ONLY THE UNPHYSICAL TWO HALFRINGS REMOVE THE FOOLOWING
C  THREE STATEMENTS. THIS HAS ALSO TO BE DONE IN LGERSE!!!!!!!
C        IROW = 1 + IADC/32
C        IF( IRING.EQ. 0 .AND. (IROW.GE.22.AND.IROW.LE.63) ) GOTO 80
C        IF( IRING.EQ.31 .AND. (IROW.LE.21 .OR.IROW.GE.64) ) GOTO 80

      IF ( IRING .EQ. 0  .OR.  IRING .EQ. 31 ) HLGADC(2,I)=0
80    CONTINUE
85    CONTINUE

C---     CHANGED 02.08.88 :   CORRECTION OF CALIBRATION SYSTEMATICS
C                             FOR REAL DATA ONLY
C              HNORML = 10000 FOR CALIBRATED DATA WITHOUT CORRECTIONS
C              HNORML = 22000 FOR CALIBRATED DATA WITH CORRECTIONS


      IHEAD = IDATA ( IBLN ( 'HEAD' ) )
      NRUN  = HDATA ( 2*IHEAD + 10 )

      IF( NCALL .EQ. 1 ) PRINT 990, NRUN, HNORML
 990  FORMAT ( T2,'JADELG.LOAD (LGANAL9) CALLED:',
     +   ' NRUN = ',I6,' ,HNORML = ',I6 )

      IF ( NRUN .GT. 100 .AND. HNORML .LT. 11000 ) CALL CALCOR

C---      END CHANGE


C---- CLUSTER FINDING    (NCLST,NCLBEC(1-3) ARE FILLED. MAP IS MADE.)
      CALL LGCCTL ( IFLAG(1) )

C---- CLUSTER POSITIONS AND ENERGIES ARE CALCULATED FOR THE BARREL AND
C     END CAPS.
      IF ( NCLBEC(1) ) 2,2,1
    1 CALL LGCLPB
    2 IF ( NCLBEC(2) + NCLBEC(3) ) 4,4,3
    3 CALL LGCLPC

C---- TOTAL ENERGY IS CALCULATED.
    4 ETOT(1) = ETOT(2)+ETOT(3)+ETOT(4)


C****************************************************************
C---- COPY LG-RESULT INTO A NEW BANK/LGCL/.

C---- FIX POINTERS OF THREE PARTS.
    5 NPNT(1) = 5
      NPNT(2) = 26
      NPNT(3) = NCLST+27
      NPNT(4) = NPNT(3)+NWPCL*NCLST

      IF ( NCLST .EQ. 0 .OR. NCLST .EQ. MAXCLS ) GO TO 10
C---- SHIFT DATA TO FILL THE GAP BETWEEN MAPCL AND CLSPRP
      CALL MVCL(CLMPRP(NCLST+2),0,CLMPRP(MAXCLS+2),0, 4*NCLST*NWPCL)

   10 LNGCL = NPNT(4)-1

C---- CREATE THE LGCL BANK.
      NPLGCL=IDATA(IPLGCL)
      IF ( NPLGCL .LT. 1 ) GO TO 12
      MSGVAL = 1
      CALL LGMESG( 2, 3)
      CALL BDLS(NMLGCL,1)

12    CALL BCRE(NPLGCL,NMLGCL,1,LNGCL,&91,IER)
      CALL BSAW( 1, NMLGCL)
      IF ( IER .EQ. 0 ) GO TO 20

C---- BCRE ENDS WITH AN ERROR.
C     THE 'LGCL' EXISTS ALREADY.
      MSGVAL = IER
      CALL LGMESG( 2, 3)

C---- COPY
   20 CALL BSTR( NPLGCL, NPNT, LNGCL)
      GO TO 30

C---- NOT ENOUGH SPACE IN /BCS/.
   91 IFLAG(1) = IFLAG(1)+100
      MSGVAL = IER
      CALL LGMESG( 2, 2)

C---- OVERWRITE 'ALGN'-BANK WITH THE SORTED LG-ADC'S.
   30 IF(NP.GT.0) CALL MVCL(IDATA,4*NP,HNORD,0,4*LNG)

  100 RETURN
      END

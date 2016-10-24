C   19/02/84 807251441  MEMBER NAME  BANKPR   (S)        M  FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE BANKPR 
C-----------------------------------------------------------------------
C
C   AUTHOR:   L. O'NEILL     ?     :  PRINT BOS BANK NAMES OR CONTENTS.
C
C        MOD: J. OLSSON   15/11/83 :
C        MOD: C. BOWDERY  14/02/84 :  RESOLVE PROBLEM WITH DELETED BANKS
C        MOD: C. BOWDERY  14/02/84 :  NAMES PRINTED BY S/R EVBKPR
C        MOD: J. HAGEMANN 26/11/84 :  VERTEX CHAMBER BANKS PRINTOUT
C                                  :  ADDED AND IMPROVED PATR-BANK
C                                  :  PRINTOUT
C        MOD: J. HAGEMANN 24/06/85 :  IMPROVED PRINTOUT FOR
C                                  :  BPCH-BANK
C        MOD: J. HAGEMANN 23/09/85 :  PRINTOUT FOR VTHT- * VPAT- BANKS
C        MOD: J. HAGEMANN 10/02/86 :  PRINTOUT FOR VCVW- * TTOP- BANKS
C        MOD: J. HAGEMANN 02/05/86 :  IMPROVED PRINTOUT FOR JHTL-BANK
C                                     COMPLETELY NEW STRUCTURE,
C                                     PRINTOUT FOR SOME BANKS DONE VIA
C                                     SUBROUTINES
C        MOD: J. HAGEMANN 20/05/86 :  PRINTOUT FOR PALL-BANK
C        MOD: J. HAGEMANN 21/07/86 :  IMPROVED PRINTOUT FOR PATR-BANK
C        MOD: J. OLSSON   04/08/86 :  EXTENSION ZTRG FORMAT DESCR.2
C        MOD: J. OLSSON   20/08/86 :  DEDX PRINT OF MOM. ERROR
C        MOD: E  ELSEN    26/08/86 :  J68K PRINT
C        MOD: J. HAGEMANN 09/09/86 :  FOR BANK NAME PASSED BY FIRST
C                                     COMMAND ARGUMENT "ACMD" AND BANK
C                                     NUMBER BY SECOND COMMAND ARGUMENT
C                                     "BCMD"
C        MOD: J. HAGEMANN 06/04/87 :  FOR OUTPUT ON LASER PRINTERS
C        MOD: J. HAGEMANN 30/06/87 :  FOR SELECTION OF VECT-BANK / BCMD
C   LAST MOD: J. HAGEMANN 19/01/88 :  FOR PRINTOUT OF HWDS,HHTL-BANKS
C
C
C  IRETUR :   -1 = BANK PRINTOUT FINISHED
C              0 = RETURN AFTER CONTINUATION OF PRINTOUT OF BANK NOT
C                  CONTAINED IN BANK LIST
C         1 - 28 = RETURN AFTER CONTINUATION OF PRINTOUT OF BANK
C                  CONTAINED IN BANK LIST
C        41 - 44 = RETURN AFTER CONTINUATION OF PRINTOUT OF FAMP BANK
C                  (SEVERAL SECTIONS)
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
      LOGICAL TBIT
C
      LOGICAL DSPDTM
C
      REAL*8 DATE,TIME
      REAL*8 DESTPL
C
#include "cgraph.for"
#include "cdata.for"
C
      COMMON / CWORK  / HDUM(8000),
     +                  HADC(2,42),HTDC(2,42),HTDC1(2,42),HADCF(2,16),
     +                  HTDCF(2,16),HTSPAR(16)
      COMMON / CWORK1 / HWORK(70),DATE,TIME
      COMMON / CHEADR / HEAD(108)
      COMMON / CGRAP2 / BCMD,DSPDTM(30),ISTVW,JTVW
C
      DIMENSION HDSPL(68),HSYM(10),HDATSV(22),HTX(6),HTM1(4),HTM2(4)
      DIMENSION NAMES(30), HELP(2)
      DIMENSION HBYTE(500)
C
      EQUIVALENCE (IZWORD,HELP(1))
      EQUIVALENCE (HWORK(1),NAME)
      EQUIVALENCE (HWORK(3),HDSPL(1))
      EQUIVALENCE (HDATSV(1),IDATSV(1)),(DATE,HTM1(1)),(TIME,HTM2(1))
      EQUIVALENCE (ABN1,NAMEB)
C
      DIMENSION DESTPL(7)
C
      DATA DESTPL  / 'L1      ','L2      ','L3      ','L4      ',
     *               'L5      ','PLOTTER ','EXTPLOTT' /
C
      DATA NAMES  /'JETC','PATR','TAGC','JHTL','ZETC',
     *             'GVTX','DEDX','ZVTX','LGCL','TOFR',
     *             'TPEV','TPTR','ATOF','TPVX','VECT',
     *             'TRIG','N50S','MPRS','BK17','ZTRG',
     *             'FAMP','BPCH','VTXC','VTHT','VPAT',
     *             'VCVW','J68K','PALL','HWDS','HHTL'/
C
      DATA HSYM /'0 ','1 ','2 ','3 ','4 ','5 ','6 ','7 ','8 ','9 '/
      DATA HBLANK/'  '/,HMINUS/'- '/, NNAMES /30/
      DATA HTX /'DS','N ','DA','TE','TI','ME'/
*** PMF 17/11/99: add variables needed for emulation of DESYLIB routine 'CORE'  
      CHARACTER cHWORK*140,cHDSPL*136,cfmt*7
      EQUIVALENCE (cHWORK,HWORK(1)),(cHDSPL,HDSPL(1))
*** PMF(end)
C
C
C------------------  C O D E  ------------------------------------------
C
      IF( ACMD .EQ. 0.0 ) GO TO 10
      IF( ACMD .LT. 0.0 .AND. ACMD .GT. -11.0 ) GO TO 5
         ABN1 = ACMD
         GO TO 15
C
C                            NEGATIVE INDEX --> PRINT BOS BANK NAMES
C
    5    CALL EVBKPR(ICODE)
         IF( ICODE .EQ. 0 ) RETURN
         CALL TRMOUT(80,'Error in BMRT (currentlist),  called in BANKPR^
     *')
         RETURN
C
   10 CALL TRMOUT(80,' * * Please enter NAME of desired BANK.^')
      CALL TRMIN( 4, NAMEB )
   15 IBANK  = IBLN(NAMEB)
      IPBANK = IDATA(IBANK)
      LIM1   = IPBANK - 2
      IF( LIM1 .GE. 1 ) GO TO 30
   20    CALL TRMOUT(80,'The BANK is EMPTY or does NOT EXIST.^')
         RETURN
C** CHECK IF MORE THAN ONE BANK WITH SAME NAME; IF SO, REQUEST NUMBER.
   30 IF( IDATA(LIM1+1) .EQ. 0 .OR. NAMEB .EQ. NAMES(15) ) GO TO 80
         IF( BCMD .LE. 0.0  .OR.  BCMD .GT. 99.0 ) GO TO 35
            NBOS = IFIX(BCMD)
            GO TO 60
   35    CALL TRMOUT(80,'Following BOS BANK NUMBERS are present:^')
         LM1 = LIM1
   40    CALL DIAGIN('                    ',1,IDATA(LM1),N,N,N,N,N)
         IF( IDATA(LM1+1) .EQ. 0 ) GO TO 50
            LM1 = IDATA(LM1+1)-2
            GO TO 40
   50    CALL TRMOUT(80,'Please ENTER desired BOS BANK NUMBER.^')
         NBOS = TERNUM(DUMMY)
   60    IF( NBOS .EQ. IDATA(LIM1) ) GO TO 80
            IF( IDATA(LIM1+1) .NE. 0 ) GO TO 70
               GO TO 20
   70       LIM1 = IDATA(LIM1+1) - 2
            GO TO 60
   80 CALL ERASE
      IRETUR = -1
C********************** WRITE CAPTION
      CALL HOME
      CALL CHRSIZ(4)
      HWORK(1) = HTX(1)
      HWORK(2) = HTX(2)
      HWORK(3) = HBLANK
      DO 90  I = 1,22
         HWORK(I+3) = HDATSV(I)
   90 CONTINUE
      CALL EOUTST( 50, HWORK )
      KCNT   = 0
      IHEAD  = IBLN('HEAD')
      IPHEAD = IDATA(IHEAD)
      IHHEAD = 2*IPHEAD
      DO 110 III = 1,3
         IF( III .EQ. 1 ) NUMCAP = HDATA(IHHEAD+10)
         IF( III .EQ. 2 ) NUMCAP = HDATA(IHHEAD+11)
         IF( III .EQ. 3 ) NUMCAP = ICREC
         IF( NUMCAP .LT. 0 ) KCNT = KCNT + 1
         IF( NUMCAP .LT. 0 ) HWORK(KCNT) = HMINUS
         NUMCAP = IABS(NUMCAP)
         NDIG   = 1
         ACAP   = NUMCAP
         IF( NUMCAP .GT. 0 ) NDIG = 1 + ALOG10(ACAP+0.001)
         IF( NDIG .GT. 8 ) NDIG = 8
         DO 100 JJJ = 1,NDIG
            KKK    = KCNT + NDIG - JJJ + 1
            NTEN   = NUMCAP/10
            IDIG   = NUMCAP - 10*NTEN
            HWORK(KKK) = HSYM(IDIG+1)
            NUMCAP = NTEN
  100    CONTINUE
         KCNT = KCNT + NDIG
         IF( III .LT. 3 ) KCNT = KCNT + 1
         IF( III .LT. 3 ) HWORK(KCNT) = HBLANK
  110 CONTINUE
      KCNT = 2*KCNT
      CALL NEWLIN
      CALL EOUTST( KCNT, HWORK )
C WRITE DATE AND TIME
      CALL DAY( DATE, TIME )
      HWORK(1) = HTX(3)
      HWORK(2) = HTX(4)
      HWORK(3) = HBLANK
      DO 120  I = 1,4
         HWORK(I+3) = HTM1(I)
  120 CONTINUE
      CALL NEWLIN
      CALL EOUTST(14,HWORK)
      HWORK(1) = HTX(5)
      HWORK(2) = HTX(6)
      HWORK(3) = HBLANK
      DO 130  I = 1,4
         HWORK(I+3) = HTM2(I)
  130 CONTINUE
      CALL NEWLIN
      CALL EOUTST(14,HWORK)
      CALL NEWLIN
      CALL CHRSIZ(3)
      CALL NEWLIN
C****************************** WRITE BANK HEADER
      LIM2  = LIM1 + 3
      LIMX  = LIM2 - 1
      LIMHX = 2*LIMX
      NAME  = IDATA(LIM1-1)
      CALL CORE(HDSPL,76)
      WRITE(cHDSPL,140)(IDATA(LHO),LHO=LIM1,LIMX),(HDATA(LIMHX+J),J=1,2)! PMF 17/11/99: UNIT=10 -> UNIT=cHDSPL 
  140 FORMAT(3I10,2I10)
      CALL EOUTST(80,HWORK)
      CALL NEWLIN
      CALL SEELOC(IXT,IYT)
      XS = IXT
      YS = IYT
      IYT0 = IYT
      CALL CHRSIZ(4)
      CALL CSIZE(IX,IXT)
      SIZE   = IXT*.8
      DEL    = 1.7*SIZE
C****************************** WRITE BANK CONTENT
      NWO    = IDATA(LIM2-1) - 1
      LENGB  = 2*NWO
      NCYCLE = 1 + (LENGB-1)/20
      INNAM  = 0
      DO 150  INN = 1,NNAMES
         IF( NAMEB .NE. NAMES(INN) ) GO TO 150
            INNAM = INN
            GO TO 160
  150 CONTINUE
      GO TO 500
  160 GOTO( 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000,10000,
     *     11000,12000,13000,14000,15000,16000,17000,18000,19000,20000,
     *     19000,22000,23000,24000,25000,26000,27000,28000, 2000, 4000),
     * INNAM
C-------------- NORMAL PRINT OF BANKS, INTEGER*2 FORMAT
  500 CONTINUE
      DO 505 LHO = 1,NCYCLE
  501    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 502
            IRETUR = 0
            GO TO 90000
  502    LIML = 2*LIM2 + 20*(LHO-1) + 1
         LIMU = LIML + 19
         IF( LIMU .GT. (2*LIM2+LENGB) ) LIMU = 2*LIM2 + LENGB
         ILIM = LIMU - LIML + 1
         IF( ILIM .LE. 0 ) GO TO 90100
         DO 503  I = 1,ILIM
            LLO = LIML + I - 1
            HWORK(I+100) = HDATA(LLO)
  503    CONTINUE
         IILIM = 6*ILIM + 1
         CALL CORE(HWORK,IILIM)
         WRITE(cHWORK,504) (HWORK(LLO+100),LLO=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
  504    FORMAT(' ',20I6)
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
  505 CONTINUE
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR JETC BANK
 1000 LENGB  = LENGB + 2
      NCYCLE = 1 + (LENGB-1)/20
      LENGB  = LENGB - 2
      DO 1006 LHO = 1,NCYCLE
 1001    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 1002
            IRETUR = 1
            GO TO 90000
 1002    LIML = 2*LIM2 + 20*(LHO-1) + 1
         IF( LHO .GT. 5 ) LIML = LIML - 2
         LIMU = LIML + 19
         IF( LHO .EQ. 5 ) LIMU = LIMU - 2
         IF( LIMU .GT. (2*LIM2 + LENGB) ) LIMU = 2*LIM2 + LENGB
         ILIM = LIMU - LIML + 1
         IF( ILIM .LE. 0 ) GO TO 90100
         DO 1003  I = 1,ILIM
            LLO = LIML + I - 1
            HWORK(I+100) = HDATA(LLO)
 1003    CONTINUE
         IF( LHO .LE. 5 ) GO TO 1005
            DO 1004  I = 1,ILIM,4
               IX = HWORK(I+100)
               IX = ISHFTR(IX,3)
               HWORK(I+100) = IX
 1004       CONTINUE
 1005    IILIM = 6*ILIM + 1
         CALL CORE(HWORK,IILIM)
         WRITE(cHWORK,504) (HWORK(LLO+100),LLO=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
 1006 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR PATR BANKS
 2000 LIM2  = LIM2 - 1
      NPATR = IDATA(LIM2-2)
      LO    = IDATA(LIM2+1)
      NTR   = IDATA(LIM2+2)
      LTR   = IDATA(LIM2+3)
      IPO   = LIM2 + LO
      CALL CORE(HWORK,47)
      WRITE(cHWORK,2001) (IDATA(LIM2+II),II=1,LO) ! PMF 17/11/99: JUSCRN changed to cHWORK
 2001 FORMAT('  ',3I5,2X,Z8,4I5)
      CALL SYSSYM(XS,YS,SIZE,HWORK,47,0.)
      IF( NTR .GT. 100 ) RETURN
      ICNT = 0
 2002 ICNT = ICNT + 1
      IF( ICNT .GT. NTR ) GO TO 90100
 2003 YS = YS - DEL
      IF( YS .GT. 200.0 ) GO TO 2004
         IRETUR = 2
         GO TO 90000
 2004 IPP = IPO + (ICNT-1)*LTR
      CALL CORE(HWORK,122)
      WRITE(cHWORK,2005) IDATA(IPP+1),IDATA(IPP+2), ! PMF 17/11/99: JUSCRN changed to cHWORK
     * (IDATA(IPP+I),I=3,4),(ADATA(IPP+I),I=5,10),
     *                  IDATA(IPP+11),(ADATA(IPP+I),I=12,17)
 2005 FORMAT(' ',I2,1X,Z8,1X,I5,I3,1X,2F8.3,F10.3,3F7.3,2X,I3,1X,
     * 2F8.3,F10.3,3F7.3)
      CALL SYSSYM(XS,YS,SIZE,HWORK,122,0.)
      YS = YS - DEL
      CALL CORE(HWORK,124)
      IF(IDATA(IPP+18).EQ.1)
     *WRITE(cHWORK,2006) IDATA(IPP+18),(ADATA(IPP+I),I=19,23), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                   IDATA(IPP+24),(ADATA(IPP+I),I=25,28),
     *                   IDATA(IPP+29),(ADATA(IPP+I),I=30,32),
     *                   IDATA(IPP+33)
 2006 FORMAT(' ',I2,1X,E10.4,F8.3,E11.4,1X,F8.3,F7.3,I3,1X,4E11.4,1X,I2,
     * 3F7.2,I3)
      IF(IDATA(IPP+18).EQ.2)
     *WRITE(cHWORK,2007) IDATA(IPP+18),(ADATA(IPP+I),I=19,23), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                   IDATA(IPP+24),(ADATA(IPP+I),I=25,28),
     *                   IDATA(IPP+29),(ADATA(IPP+I),I=30,32),
     *                   IDATA(IPP+33)
 2007 FORMAT(' ',I2,1X,E10.4,2F8.3,1X,E11.4,F7.3,I3,1X,4E11.4,1X,I2,
     * 3F7.2,I3)
      CALL SYSSYM(XS,YS,SIZE,HWORK,124,0.)
      YS = YS - DEL
      IF( NPATR .NE. 12 ) GO TO 2009
         CALL CORE(HWORK,118)
         WRITE(cHWORK,2008) (IDATA(IPP+I),I=34,48), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                      (HDATA(IPP*2+I),I=3,4)
 2008    FORMAT(' ',6I4,2X,8I5,2X,Z8,2X,' PART.NO.',I4,1X,'IN VECT 0',
     *          '    PART.TYPE',I3)
         CALL SYSSYM(XS,YS,SIZE,HWORK,118,0.)
         GO TO 2011
 2009 CALL CORE(HWORK,89)
      WRITE(cHWORK,2010) (IDATA(IPP+I),I=34,44),(ADATA(IPP+I),I=45,46), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                   (IDATA(IPP+I),I=47,48)
 2010 FORMAT(' ',6I4,2X,4I6,I4,2F8.1,I8,2X,Z8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,89,0.)
 2011 CONTINUE
      IF(LTR .LT. 62) GO TO 2002
      IF((LTR .LT. 64) .OR.
     *   (LTR.EQ.64 .AND.
     *    (.NOT.TBIT(IDATA(IPP+2),19).OR.ABS(ADATA(IPP+51)).LT.0.01)
     *    .AND. INNAM.NE.29))
     *                        GO TO 2020
         YS = YS - DEL
         CALL CORE(HWORK,114)
         IF(IDATA(IPP+18).EQ.1)WRITE(cHWORK,2012) (ADATA(IPP+I),I=49,58) ! PMF 17/11/99: JUSCRN changed to cHWORK
 2012    FORMAT(' ',2X,F9.3,E11.4,F9.3,1X,6E12.4,F8.3)
         IF(IDATA(IPP+18).EQ.2)WRITE(cHWORK,2013) (ADATA(IPP+I),I=49,58) ! PMF 17/11/99: JUSCRN changed to cHWORK
 2013    FORMAT(' ',2X,F9.3,F9.3,2X,F9.3,1X,6E12.4,F8.3)
         CALL SYSSYM(XS,YS,SIZE,HWORK,114,0.)
         YS = YS - DEL
         IF( LTR .GT. 64 ) GOTO 2015
            CALL CORE(HWORK,65)
            WRITE(cHWORK,2014) (IDATA(IPP+I),I=59,64) ! PMF 17/11/99: JUSCRN changed to cHWORK
 2014       FORMAT(' ',26X,I3,2X,Z8,1X,Z8,1X,3I5)
            CALL SYSSYM(XS,YS,SIZE,HWORK,65,0.)
            GO TO 2002
 2015    CONTINUE
         CALL CORE(HWORK,115)
         WRITE(cHWORK,2016) (IDATA(IPP+I),I=59,68) ! PMF 17/11/99: JUSCRN changed to cHWORK
 2016    FORMAT(' ',26X,I3,2X,Z8,1X,Z8,1X,3I5,2X,4E12.4)
         CALL SYSSYM(XS,YS,SIZE,HWORK,115,0.)
         GO TO 2002
 2020 CONTINUE
      YS = YS - DEL
      CALL CORE(HWORK,124)
      WRITE(cHWORK,2021) (ADATA(IPP+I),I=49,59), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                   (IDATA(IPP+I),I=60,62)
 2021 FORMAT(' ',2X,11E10.3,I7,2I2)
      CALL SYSSYM(XS,YS,SIZE,HWORK,124,0.)
      GO TO 2002
C--------------- SPECIAL FORMAT FOR TAGC BANK
 3000 CONTINUE
      DO 3005 LHO = 1,NCYCLE
 3001    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 3002
            IRETUR = 3
            GO TO 90000
 3002    LIML = 2*LIM2 + 20*(LHO-1) + 1
         LIMU = LIML + 19
         IF( LIMU .GT. (2*LIM2+LENGB) ) LIMU = 2*LIM2 + LENGB
         ILIM = LIMU - LIML + 1
         IF( ILIM .LE. 0 ) GO TO 90100
         DO 3003  I = 1,ILIM
            LLO = LIML + I - 1
            HWORK(I+100) = HDATA(LLO)
 3003    CONTINUE
         IILIM = 6*ILIM + 1
         CALL CORE(HWORK,IILIM)
         WRITE(cHWORK,3004) (HWORK(LLO+100),LLO=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
 3004    FORMAT(' ',20I6)
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
 3005 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR JHTL BANK
 4000 CONTINUE
      LIM2   = LIM2 - 1
      LENGTH = IDATA(LIM2)
      LENGB  = LENGTH - 1
      NCYCLE = 1 + (LENGB-1)/4
      DO 4008 I = 1,NCYCLE
 4001    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 4002
            IRETUR = 4
            GO TO 90000
 4002    LIML = LIM2 + 4*(I-1) + 1
         LIMU = LIML + 4
         IF( LIMU .GT. (LIM2+LENGTH) ) LIMU = LIM2 + LENGTH
         ILIM = LIMU - LIML
         IF( ILIM .LE. 0 ) GO TO 90100
         DO 4003  J = 1,ILIM
            LLO  = LIML + J
            IWD  = IDATA(LLO)
            IJK  = (J-1)*10 + 100
            HWORK(IJK+ 1) = LAND(ISHFTR(IWD,27), 31)
            HWORK(IJK+ 2) = LAND(ISHFTR(IWD,25),  3)
            HWORK(IJK+ 3) = LAND(ISHFTR(IWD,24),  1)
            HWORK(IJK+ 4) = LAND(ISHFTR(IWD,17),127)
            HWORK(IJK+ 5) = LAND(ISHFTR(IWD,16),  1)
            HWORK(IJK+ 6) = LAND(ISHFTR(IWD,11), 31)
            HWORK(IJK+ 7) = LAND(ISHFTR(IWD, 9),  3)
            HWORK(IJK+ 8) = LAND(ISHFTR(IWD, 8),  1)
            HWORK(IJK+ 9) = LAND(ISHFTR(IWD, 1),127)
            HWORK(IJK+10) = LAND(IWD          ,  1)
 4003    CONTINUE
         IILIM = 30*ILIM + 1
         ILIMP = 100 + ILIM*10
         CALL CORE(HWORK,IILIM)
         IF( ILIM .EQ. 1 )
     *   WRITE(cHWORK,4004) (HWORK(JJ),JJ=101,ILIMP) ! PMF 17/11/99: JUSCRN changed to cHWORK
 4004    FORMAT(' ','/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X)
         IF( ILIM .EQ. 2 )
     *   WRITE(cHWORK,4005) (HWORK(JJ),JJ=101,ILIMP) ! PMF 17/11/99: JUSCRN changed to cHWORK
 4005    FORMAT(' ','/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X,
     *              '/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X)
         IF( ILIM .EQ. 3 )
     *   WRITE(cHWORK,4006) (HWORK(JJ),JJ=101,ILIMP) ! PMF 17/11/99: JUSCRN changed to cHWORK
 4006    FORMAT(' ','/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X,
     *              '/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X,
     *              '/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X)
         IF( ILIM .EQ. 4 )
     *   WRITE(cHWORK,4007) (HWORK(JJ),JJ=101,ILIMP) ! PMF 17/11/99: JUSCRN changed to cHWORK
 4007    FORMAT(' ','/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X,
     *              '/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X,
     *              '/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X,
     *              '/',I2,I3,I2,I3,I2,' *',I2,I3,I2,I3,I2,3X)
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
 4008 CONTINUE
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR ZETC BANK
 5000 LENGB  = LENGB + 2
      NCYCLE = 1 + (LENGB-1)/20
      LENGB  = LENGB - 2
      DO 5005 LHO = 1,NCYCLE
 5001    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 5002
            IRETUR = 5
            GO TO 90000
 5002 LIML = 2*LIM2 + 20*(LHO-1) + 1
      LIMU = LIML + 19
      IF( LIMU .GT. (2*LIM2 + LENGB) ) LIMU = 2*LIM2 + LENGB
      ILIM = LIMU - LIML + 1
      IF( ILIM .LE. 0 ) GO TO 90100
      DO 5003  I = 1,ILIM
         LLO = LIML + I - 1
         HWORK(I+100) = HDATA(LLO)
 5003 CONTINUE
      DO 5004  I = 1,ILIM,4
         IX = HWORK(I+100)
         IX = ISHFTR(IX,3)
         HWORK(I+100) = IX
 5004 CONTINUE
      IILIM = 6*ILIM + 1
      CALL CORE(HWORK,IILIM)
      WRITE(cHWORK,504) (HWORK(LLO+100),LLO=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
      CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
 5005 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR GVTX BANKS
 6000 NV  = IDATA(LIM2)
      IPO = LIM2
      DO 6002  INV = 1,NV
         IPO = LIM2+(INV-1)*10
         CALL CORE(HWORK,72)
         WRITE(cHWORK,6001) IDATA(IPO+1),(ADATA(IPO+1+JJ),JJ=1,6), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                      IDATA(IPO+8),ADATA(IPO+9),IDATA(IPO+10)
 6001    FORMAT(' ',I3,3F8.2,3F8.2,I4,F8.2,I8)
         CALL SYSSYM(XS,YS,SIZE,HWORK,72,0.)
         YS = YS - DEL
 6002 CONTINUE
      NT = IDATA(IPO+11)
      CALL CORE(HWORK,4)
      WRITE(cHWORK,6003) NT ! PMF 17/11/99: JUSCRN changed to cHWORK
 6003 FORMAT(' ',I3)
      CALL SYSSYM(XS,YS,SIZE,HWORK,4,0.)
      YS = YS - DEL
      IPO = IPO + 11 - 15
      DO 6007  INTnn = 1,NT
         IPO = IPO + 15
         CALL CORE(HWORK,64)
         WRITE(cHWORK,6004) IDATA(IPO+1),(ADATA(IPO+1+JJ),JJ=1,8) ! PMF 17/11/99: JUSCRN changed to cHWORK
 6004    FORMAT(' ',I3,F8.2,2F7.3,3F8.2,2F7.3)
         CALL SYSSYM(XS,YS,SIZE,HWORK,64,0.)
         YS = YS - DEL
         CALL CORE(HWORK,42)
         WRITE(cHWORK,6005) (ADATA(IPO+1+JJ),JJ=9,11), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       IDATA(IPO+13),IDATA(IPO+14),ADATA(IPO+15)
 6005    FORMAT(' ',3F8.2,I4,I3,F10.2)
         CALL SYSSYM(XS,YS,SIZE,HWORK,42,0.)
         YS = YS - DEL
         IF( YS .GT. 80.0 ) GO TO 6007
            IRETUR = 6
            GO TO 90000
 6006    CONTINUE
 6007 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR DEDX BANKS
 7000 NTR = IDATA(LIM2+1)
      CALL CORE(HWORK,4)
      WRITE(cHWORK,7001) NTR ! PMF 17/11/99: JUSCRN changed to cHWORK
 7001 FORMAT(' ',I3)
      CALL SYSSYM(XS,YS,SIZE,HWORK,4,0.)
      NTR = MIN0(NTR,60)
      YS  = YS - DEL
      DO 7004  ITR = 1,NTR
         IPO = LIM2 + 1 + (ITR-1)*10
         CALL CORE(HWORK,92)
         WRITE(cHWORK,7002) IDATA(IPO+1),(ADATA(IPO+1+JJ),JJ=1,6), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                      IDATA(IPO+8),ADATA(IPO+9),ADATA(IPO+10)
 7002    FORMAT(' ',I3,2F8.2,4E12.4,I4,2F10.3)
         CALL SYSSYM(XS,YS,SIZE,HWORK,92,0.)
         YS = YS - DEL
         IF( YS .GT. 80.0 ) GO TO 7004
            IRETUR = 7
            GO TO 90000
 7003    CONTINUE
 7004 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR ZVTX BANKS
 8000 LIM2 = LIM2 - 1
      CALL PRZVTX( LIM2, XS, YS, DEL, SIZE )
      GO TO 90100
C--------------- SPECIAL FORMAT FOR LGCL BANKS
 9000 LIM2 = LIM2 - 1
      CALL CORE(HWORK,29)
      WRITE(cHWORK,9001) (IDATA(LIM2+LL),LL=1,4) ! PMF 17/11/99: JUSCRN changed to cHWORK
 9001 FORMAT(' ',4I7)
      CALL SYSSYM(XS,YS,SIZE,HWORK,29,0.)
      LIM2 = LIM2 + 4
      YS   = YS - DEL
      CALL CORE(HWORK,118)
      WRITE(cHWORK,9002) (IDATA(LIM2+LL),LL=1,6),(ADATA(LIM2+LL),LL=7,10 ! PMF 17/11/99: JUSCRN changed to cHWORK
     *),IDATA(LIM2+11),(ADATA(LIM2+LL),LL=12,15),(IDATA(LIM2+L),L=16,21)
 9002 FORMAT(' ',I3,I9,4I4,4F8.3,I4,4F8.3,2I3,I6,3I3)
      CALL SYSSYM(XS,YS,SIZE,HWORK,118,0.)
      NCLST  = IDATA(LIM2+3)
      NWPCL  = IDATA(LIM2+21)
      ILABEL = IDATA(LIM2+17)
      NCLS2  = NCLST*2+ 2
      LIM2   = LIM2 + 21
      LIM22  = 2*LIM2
      YS     = YS - DEL
      CALL CORE(HWORK,101)
*PMF26/11/99 WRITE(cHWORK,9003) ((HDATA(LIM22+L),HDATA(LIM22+L+1)),L=1,NCLS2,2) ! PMF 17/11/99: JUSCRN changed to cHWORK
*       CALL SYSSYM(XS,YS,SIZE,HWORK,101,0.)
      nnnn=ncls2
      print *,int((ncls2-1)/20)
      do iiii=1,1+int((ncls2-1)/20)
       write(chwork,9003) (hdata(lim22+l+20*(iiii-1)),l=1,min(20,nnnn)) ! PMF 17/11/99: JUSCRN changed to cHWORK
       call syssym(xs,ys,size,hwork,101,0.)
       ys=ys-del
       nnnn=nnnn-20
      enddo
*PMF(end)
 9003 FORMAT(' ',20I5)! PMF 26/11/99: 20I5->20I4 
      IF( NCLST .LE. 0 ) GO TO 90100
      LIM2 = LIM2 + NCLST + 1
      YS   = YS - DEL
      DO 9006  ITR = 1,NCLST
         IPO = LIM2 + (ITR-1)*NWPCL
         CALL CORE(HWORK,119)
         WRITE(cHWORK,9004) IDATA(IPO+1),(ADATA(IPO+1+JJ),JJ=1,6), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                      IDATA(IPO+8),(ADATA(IPO+JJ),JJ=9,NWPCL)
 9004    FORMAT(' ',I3,2F8.3,2F9.2,2F8.3,I4,4F8.3,F10.3,2F6.3,F7.3)
         CALL SYSSYM(XS,YS,SIZE,HWORK,119,0.)
         YS = YS - DEL
         IF( YS .GT. 80.0 ) GO TO 9006
            IRETUR = 9
            GO TO 90000
 9005    CONTINUE
 9006 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR TOFR BANKS
10000 NTR  = IDATA(LIM2)
      LIM2 = LIM2 - 1
      CALL CORE(HWORK,17)
      WRITE(cHWORK,10001) (IDATA(LIM2+I),I=1,4) ! PMF 17/11/99: JUSCRN changed to cHWORK
10001 FORMAT(' ',4I4)
      CALL SYSSYM(XS,YS,SIZE,HWORK,17,0.)
      YS = YS - DEL
      DO 10004  ITR = 1,NTR
         IPO = LIM2 + 4 + (ITR-1)*14
         CALL CORE(HWORK,118)
         WRITE(cHWORK,10002) (IDATA(IPO+I),I=1,3),(ADATA(IPO+I),I=4,14) ! PMF 17/11/99: JUSCRN changed to cHWORK
10002    FORMAT(' ',3I3,F8.3,F8.1,4F8.4,4F12.3,E12.4)
         CALL SYSSYM(XS,YS,SIZE,HWORK,118,0.)
         YS = YS - DEL
         IF( YS .GT. 80.0 ) GO TO 10004
            IRETUR = 10
            GO TO 90000
10003    CONTINUE
10004 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR TPEV BANK
11000 LIM2 = LIM2 - 1
      CALL PRTPEV( LIM2, XS, YS, DEL, SIZE )
      GO TO 90100
C--------------- SPECIAL FORMAT FOR TPTR BANKS
12000 LIM2 = LIM2 - 1
      CALL PRTPTR( LIM2, XS, YS, DEL, SIZE )
      GO TO 90100
C--------------- SPECIAL FORMAT FOR ATOF BANK
13000 IPTOF = LIM2-1
      CALL AGRPR(IPTOF,*13001)
      GO TO 13003
13001 WRITE(JUSCRN,13002)
13002 FORMAT(' ATFUGR ERROR, WRONG BANK DESCRIPTOR...' )
      RETURN
13003 CALL PRATOF( XS, YS, DEL, SIZE )
      GO TO 90100
C--------------- SPECIAL FORMAT FOR TPVX BANK
14000 LIM2 = LIM2 - 1
      CALL PRTPVX( LIM2, XS, YS, DEL, SIZE )
      GO TO 90100
C--------------- SPECIAL FORMAT FOR VECT BANK
C-  FIRST VECT 0, THEN VECT 1 IF IT EXISTS
C-
15000 IVPS = 0
      LIM2 = LIM2 - 1
      IF( NBOS .EQ. 1 ) GO TO 15010
15001 LO   = IDATA(LIM2+1)
      LTR  = IDATA(LIM2+2)
      NTR  = IDATA(LIM2+4)
      IPO  = LIM2 + LO
      CALL CORE(HWORK,106)
      WRITE(cHWORK,15002) (IDATA(LIM2+II),II=1,LO) ! PMF 17/11/99: JUSCRN changed to cHWORK
15002 FORMAT('  ',6I8,2F8.4,5I8)
      LOO = LO*8 + 2
      CALL SYSSYM(XS,YS,SIZE,HWORK,LOO,0.)
      LO1 = MIN0(12,LO)
      IF( LO1 .LT. 7 ) GO TO 15004
         YS = YS - DEL
         CALL CORE(HWORK,124)
         WRITE(cHWORK,15003) (ADATA(LIM2+II),II=7,LO1) ! PMF 17/11/99: JUSCRN changed to cHWORK
15003    FORMAT(' HEADER WORDS 7-.. ',6E14.6)
         LOO = (LO1-6)*14 + 19
         CALL SYSSYM(XS,YS,SIZE,HWORK,LOO,0.)
15004 ICNT = 0
15005 ICNT = ICNT + 1
      IF( ICNT .GT. NTR .AND. IVPS .EQ. 1 ) GO TO 90100
      IF( ICNT .GT. NTR .AND. IVPS .EQ. 0 ) GO TO 15010
15006 YS = YS - DEL
      IF( YS .GT. 50.0 ) GO TO 15007
         IRETUR = 15
         GO TO 90000
15007 IPP = IPO + (ICNT-1)*LTR
      IF( LTR .EQ. 10 ) CALL CORE(HWORK,102)
      IF( LTR .EQ. 12 ) CALL CORE(HWORK,122)
      IF( LTR .EQ. 10 )
     *  WRITE(cHWORK,15008) ICNT,(ADATA(IPP+I),I=1,5), ! PMF 17/11/99: JUSCRN changed to cHWORK
     * (IDATA(IPP+I),I=6,7),(ADATA(IPP+I),I=8,10)
15008 FORMAT(' ',I4,3X,4F10.4,2X,F10.6,2X,2I4,2X,3F10.3)
      IF( LTR .EQ. 12 )
     *  WRITE(cHWORK,15009) ICNT, ! PMF 17/11/99: JUSCRN changed to cHWORK
     * (ADATA(IPP+I),I=1,5),(IDATA(IPP+I),I=6,7),
     * (ADATA(IPP+I),I=8,10),HDATA(2*IPP+21),HDATA(2*IPP+22),
     *  ADATA(IPP+12)
15009 FORMAT(' ',I4,3X,4F10.4,2X,F10.6,2X,2I4,2X,3F10.3,2I5,F10.2)
      IF( LTR .EQ. 10 ) CALL SYSSYM(XS,YS,SIZE,HWORK,102,0.)
      IF( LTR .EQ. 12 ) CALL SYSSYM(XS,YS,SIZE,HWORK,122,0.)
      GO TO 15005
15010 CONTINUE
      LIM2 = IDATA(LIM2-1)
      IF( LIM2 .LT. 1 ) GO TO 90100
      IVPS = 1
C* WRITE BANK HEADER FOR VECT 1
      call setlin(ys)           !PMF 29/11/99: let newlin know the current line
      CALL NEWLIN
      CALL NEWLIN
      LIM1  = LIM2 - 2
      LIMX  = LIM2
      LIMHX = 2*LIMX
      NAME  = IDATA(LIM2-3)
      CALL CORE(HDSPL,76)
      WRITE(cHDSPL,140)(IDATA(LHO),LHO=LIM1,LIMX),(HDATA(LIMHX+J),J=1,2) ! PMF 17/11/99: UNIT=10 changed to cHDSPL
      CALL EOUTST(80,HWORK)
      CALL NEWLIN
      CALL SEELOC(IXT,IYT)
      XS = IXT
      YS = IYT
      CALL CHRSIZ(4)
      CALL CSIZE(IX,IXT)
      GO TO 15001
C--------------- SPECIAL FORMAT FOR TRIG BANK
16000 CONTINUE
      DO 16005 LHO = 1,NCYCLE
16001    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 16002
            IRETUR = 16
            GO TO 90000
16002    LIML = 2*LIM2 + 20*(LHO-1) + 1
         LIMU = LIML + 19
         IF( LIMU .GT. (2*LIM2+LENGB) ) LIMU = 2*LIM2 + LENGB
         ILIM = LIMU - LIML + 1
         IF( ILIM .LE. 0 ) GO TO 90100
         DO 16003  I = 1,ILIM
            LLO = LIML + I - 1
            HWORK(I+100) = HDATA(LLO)
16003    CONTINUE
         IILIM = 6*ILIM + 1
         CALL CORE(HWORK,IILIM)
         WRITE(cHWORK,16004) (HWORK(LLO+100),LLO=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
16004    FORMAT(' ',20I6)
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
16005 CONTINUE
      GO TO 90100
C--------------- SPECIAL FORMAT FOR N50S BANKS
17000 LIM2 = LIM2 - 1
      CALL PRN50S( LIM2, XS, YS, DEL, SIZE )
C
C MPRS BANK PART, INCLUDE SO THAT ALSO INDEPENDENT PRINT POSSIBLE
C
      IPLNAM = IDATA(IBLN('MPRS'))
      IF( IPLNAM .LE. 0 ) GO TO 90100
      LIM2 = IPLNAM + 1
      YS   = YS - DEL
      CALL CORE(HWORK,54)
      WRITE(cHWORK,17001) ! PMF 17/11/99: JUSCRN changed to cHWORK
17001 FORMAT(' ------------->>>   MIPROC RESULTS   <<<--------------')
      CALL SYSSYM(XS,YS,SIZE,HWORK,54,0.)
C--------------- SPECIAL FORMAT FOR MPRS BANKS
18000 LIM2 = LIM2 - 1
      CALL PRMPRS( LIM2, XS, YS, DEL, SIZE )
      GO TO 90100
C
C--------------- SPECIAL FORMAT FOR FAMP BANKS (NOW TEMPORARILY BK17)
19000 LIM2 = LIM2 - 1
      LH2  = LIM2*2
      YS   = YS - DEL
      CALL CORE(HWORK,28)
      WRITE(cHWORK,19001) HDATA(LH2+3) ! PMF 17/11/99: JUSCRN changed to cHWORK
19001 FORMAT(' FAMP PROGRAM VERSION ',I6)
      CALL SYSSYM(XS,YS,SIZE,HWORK,28,0.)
C TRIGGERS
      NTRI = HDATA(LH2+4)
      IF( NTRI .LE. 0 ) GO TO 19003
         YS = YS - DEL
         CALL CORE(HWORK,77)
         WRITE(cHWORK,19002) (HDATA(LH2+NTRI+K),K=1,4) ! PMF 17/11/99: JUSCRN changed to cHWORK
19002    FORMAT(' #T2 TRACKS ',I3,' R3 TRACKS CELLS 33-48 ',Z4,
     *          '  CELLS 17-32 ',Z4,'  CELLS 1-16 ',Z4)
         CALL SYSSYM(XS,YS,SIZE,HWORK,77,0.)
C COUNTERS
19003 NCOU = HDATA(LH2+5)
      IF( NCOU .LE. 0 ) GO TO 19005
         AA = HDATA(LH2+NCOU+2)*.1
         YS = YS - DEL
         CALL CORE(HWORK,53)
         WRITE(cHWORK,19004) HDATA(LH2+NCOU+1),AA,HDATA(LH2+NCOU+3), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       HDATA(LH2+NCOU+4)
19004    FORMAT(' #TOFS ',I3,' TDIF(NS) ',F8.1,' ZVTOF ',I6,' ZVLG ',I6)
         CALL SYSSYM(XS,YS,SIZE,HWORK,53,0.)
C LEAD GLASS
19005 NL = HDATA(LH2+6)
      IF( NL .LE. 0 ) GO TO 19007
         AA1 = HDATA(LH2+NL+5)*.001
         AA2 = HDATA(LH2+NL+6)*.001
         AA3 = HDATA(LH2+NL+7)*.001
         AA4 = HDATA(LH2+NL+8)*.001
         YS  = YS - DEL
         CALL CORE(HWORK,124)
         WRITE(cHWORK,19006) (HDATA(LH2+NL+K),K=1,4),AA1,AA2,AA3,AA4, ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       (HDATA(LH2+NL+KK),KK=9,10)
19006    FORMAT(' NR CLUSTERS TOTAL,BARREL,-EC,+EC : ',4I5,
     *          ' ENERGIES: ',4F8.3,' NHCLI ',I6,' ERES ',I6)
         CALL SYSSYM(XS,YS,SIZE,HWORK,124,0.)
C INNER DETECTOR ANALYSIS
19007 ND = HDATA(LH2+7)
      IF( ND .GT. 0 ) GO TO 19009
         YS = YS - DEL
         CALL CORE(HWORK,35)
         WRITE(cHWORK,19008) ! PMF 17/11/99: JUSCRN changed to cHWORK
19008    FORMAT(' ---> NO INNER DETECTOR INFORMATION')
         CALL SYSSYM(XS,YS,SIZE,HWORK,35,0.)
         GO TO 19033
19009 CONTINUE
      YS = YS - DEL
      CALL CORE(HWORK,46)
      WRITE(cHWORK,19010) (HDATA(LH2+ND+K),K=1,3) ! PMF 17/11/99: JUSCRN changed to cHWORK
19010 FORMAT(' ID ZVTX FLAG ',I3,'  ZVTX IN MM ',I6,' INRGZV ',I2)
      CALL SYSSYM(XS,YS,SIZE,HWORK,46,0.)
      YS     = YS - DEL
      INRGZV = HDATA(LH2+ND+3)
      NTR    = HDATA(LH2+ND+4)
      NTRT   = HDATA(LH2+ND+5)
      CALL CORE(HWORK,49)
      IF( NTR .LT. 0 ) WRITE(cHWORK,19011) ! PMF 17/11/99: JUSCRN changed to cHWORK
19011 FORMAT(' PATTERN RECOGNITION NOT PERFORMED              ')
      IF( NTR .EQ. 0 ) WRITE(cHWORK,19012) ! PMF 17/11/99: JUSCRN changed to cHWORK
19012 FORMAT(' PATTERN RECOGNITION PERFORMED, NO TRACKS FOUND ')
      IF( NTR .LE. 0 ) CALL SYSSYM(XS,YS,SIZE,HWORK,47,0.)
      IF( NTR .LE. 0 ) GO TO 19033
         WRITE(cHWORK,19013) NTRT,NTR ! PMF 17/11/99: JUSCRN changed to cHWORK
19013    FORMAT(' PATREC PERFORMED,',I3,' TRACKS FOUND',I3,
     *          ' TRACK BANKS')
         CALL SYSSYM(XS,YS,SIZE,HWORK,49,0.)
         LORT = HDATA(LH2+ND+6)
         LTRT = HDATA(LH2+ND+7)
         MWR1 = HDATA(LH2+ND+8)
         MWR2 = HDATA(LH2+ND+9)
         MWR3 = HDATA(LH2+ND+10)
         IEFA = HDATA(LH2+ND+11)
         IPLT = LH2+ND+LORT-LTRT
         YS   = YS - DEL
         CALL CORE(HWORK,102)
         WRITE(cHWORK,19014) NTRT,LORT,LTRT,MWR1,MWR2,MWR3,IEFA ! PMF 17/11/99: JUSCRN changed to cHWORK
19014    FORMAT(' TRACKS LISTED ',I4,'  LO AND LT FOR EACH ',2I4,
     *          ' NR WORDS MAP RING1-3: ',3I5,' ERROR FLAG ',Z4)
         CALL SYSSYM(XS,YS,SIZE,HWORK,102,0.)
C
         DO 19018  ITR = 1,NTR
            IPLT    = IPLT + LTRT
            IFTR    = HDATA(IPLT)
            RR1     = HDATA(IPLT+1)*.1
            FI1     = HDATA(IPLT+2)
            Z1      = HDATA(IPLT+3)*.1
            RR2     = HDATA(IPLT+4)*.1
            FI2     = HDATA(IPLT+5)
            Z2      = HDATA(IPLT+6)*.1
            HELP(1) = HDATA(IPLT+8)
            HELP(2) = HDATA(IPLT+9)
            RR      = FLOAT(IZWORD)*.1
            SIGXY   = HDATA(IPLT+10)*.01
            NXY     = HDATA(IPLT+11)
            TANTH   = HDATA(IPLT+12)*001
            Z0      = HDATA(IPLT+13)*.1
            SIGZ    = HDATA(IPLT+14)*.1
            NZ      = HDATA(IPLT+15)
            YS      = YS - DEL
            IF( YS .GT. 50.0 ) GO TO 19015
               IRETUR = 19
               GO TO 90000
19015       CONTINUE
            CALL CORE(HWORK,120)
            WRITE(cHWORK,19016) ITR,IFTR,RR1,FI1, ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                          Z1,RR2,FI2,Z2,RR,SIGXY,NXY
19016       FORMAT(' ',I2,' SEC. ',I3,' R-FI-Z 1 ',F8.1,F5.0,F8.1,
     *             ' R-FI-Z 2 ',F8.1,F5.0,F8.1,
     *             ' RCURV SIGXY NHITXY ',E14.6,F8.2,I4)
            CALL SYSSYM(XS,YS,SIZE,HWORK,120,0.)
C
            YS = YS - DEL
            CALL CORE(HWORK,115)
            WRITE(cHWORK,19017) TANTH,Z0,SIGZ,NZ ! PMF 17/11/99: JUSCRN changed to cHWORK
19017       FORMAT(' ',59X,' TANTHETA ',F10.5,' Z0 ',F8.2,
     *             ' SIGZ(MM) ',F7.4,' NZ ',I2)
            CALL SYSSYM(XS,YS,SIZE,HWORK,115,0.)
C
19018 CONTINUE
      IPLT  = IPLT + LTRT
      IPLT1 = IPLT
      IPLT2 = IPLT1+MWR1
      IPLT3 = IPLT2+MWR2
      IPLT4 = IPLT3+MWR3
      YS    = YS - DEL
      IF( YS .GT. 50.0 ) GO TO 19019
         IRETUR = 41
         GO TO 90000
19019 CONTINUE
      CALL CORE(HWORK,44)
      WRITE(cHWORK,19020) IPLT1,IPLT2,IPLT3,IPLT4 ! PMF 17/11/99: JUSCRN changed to cHWORK
19020 FORMAT(' FAMP HIT MAP POINTERS: ',4I5)
      CALL SYSSYM(XS,YS,SIZE,HWORK,44,0.)
      IF( IPLT2 .EQ. IPLT1 ) GO TO 19024
19021    IPLT22 = IPLT2-1
         IF( IPLT22 .GT. IPLT1+19 ) IPLT22 = IPLT1+19
         IRESV = 22+5*(IPLT22-IPLT1+1)
         YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 19022
            IRETUR = 42
            GO TO 90000
19022    CONTINUE
         CALL CORE(HWORK,IRESV)
         WRITE(cHWORK,19023) (HDATA(II),II=IPLT1,IPLT22) ! PMF 17/11/99: JUSCRN changed to cHWORK
19023    FORMAT(' ',14X,' RING1 ',20(Z4,1X))
         CALL SYSSYM(XS,YS,SIZE,HWORK,IRESV,0.)
         IF( IPLT22 .GE. IPLT2-1 ) GO TO 19024
            IPLT1 = IPLT22 + 1
            GO TO 19021
19024 CONTINUE
      IF( IPLT3 .EQ. IPLT2 ) GO TO 19028
19025    IPLT33 = IPLT3-1
         IF( IPLT33 .GT. IPLT2+19 ) IPLT33 = IPLT2 + 19
         IRESV = 22 + 5*(IPLT33-IPLT2+1)
         YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 19026
            IRETUR = 43
            GO TO 90000
19026    CONTINUE
         CALL CORE(HWORK,IRESV)
         WRITE(cHWORK,19027) (HDATA(II),II=IPLT2,IPLT33) ! PMF 17/11/99: JUSCRN changed to cHWORK
19027    FORMAT(' ',14X,' RING2 ',20(Z4,1X))
         CALL SYSSYM(XS,YS,SIZE,HWORK,IRESV,0.)
         IF( IPLT33 .GE. IPLT3-1 ) GO TO 19028
            IPLT2 = IPLT33 + 1
            GO TO 19025
19028 CONTINUE
      IF( IPLT4 .EQ. IPLT3 ) GO TO 19032
      IF( INRGZV .NE. 3 ) GO TO 19032
19029    IPLT44 = IPLT3-1
         IF( IPLT44 .GT. IPLT3+19 ) IPLT44 = IPLT3 + 19
         IRESV = 22 + 5*(IPLT44-IPLT3+1)
         YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 19030
            IRETUR = 44
            GO TO 90000
19030    CONTINUE
         CALL CORE(HWORK,IRESV)
         WRITE(cHWORK,19031) (HDATA(II),II=IPLT3,IPLT44) ! PMF 17/11/99: JUSCRN changed to cHWORK
19031    FORMAT(' ',14X,' RING3 ',20(Z4,1X))
         CALL SYSSYM(XS,YS,SIZE,HWORK,IRESV,0.)
         IF( IPLT44 .GE. IPLT4-1 ) GO TO 19032
            IPLT3 = IPLT44+1
            GO TO 19029
19032 CONTINUE
C
19033 NM = HDATA(LH2+8)
      IF( NM .LE. 0 ) GO TO 19036
         YS  = YS - DEL
         NMU = HDATA(LH2+NM)
         IF( NMU .GT. 5 ) NMU =  5
         NCORE = 44 + NMU*4
         NMU   = 2*NMU + 1
         CALL CORE(HWORK,64)
         WRITE(cHWORK,19034) HDATA(LH2+NM),HDATA(LH2+NM+1), ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                      (HDATA(LH2+NM+K),K=2,NMU,2)
19034    FORMAT(' NR MUON TRACKS ',I2,'   IN BARREL ',I3,
     *          ' POSITION ',5I4)
         CALL SYSSYM(XS,YS,SIZE,HWORK,NCORE,0.)
         YS = YS - DEL
         CALL CORE(HWORK,64)
         WRITE(cHWORK,19035) (HDATA(LH2+NM+K+1),K = 2,NMU,2) ! PMF 17/11/99: JUSCRN changed to cHWORK
19035    FORMAT('                ',3X,'             ',3X,
     *          ' QUALITY ',5I4)
         CALL SYSSYM(XS,YS,SIZE,HWORK,NCORE,0.)
C
19036 CONTINUE
      NTG = HDATA(LH2+9)
      IF( NTG .LE. 0 ) GO TO 19038
         YS = YS - DEL
         CALL CORE(HWORK,50)
         WRITE(cHWORK,19037) (HDATA(LH2+NTG+K),K=1,2) ! PMF 17/11/99: JUSCRN changed to cHWORK
19037    FORMAT(' TAGGING ENERGIES(MEV) IN -Z, +Z: ',2I8)
         CALL SYSSYM(XS,YS,SIZE,HWORK,50,0.)
19038 CONTINUE
      GO TO 90100
C-------------------------
C----   SPECIAL FORMAT FOR ZTRG BANKS
C-------------------------
20000 LIM2   = LIM2 - 1
      LEZTRG = IDATA(LIM2)
      IZDESC = HDATA(2*LIM2+1)
      IF(IZDESC.GE.2) GO TO 20100
C  OLD FORMAT
      HPOINT = 2*( LIM2 + 1 )
      HZLENG = 2*( LEZTRG - 1 )
      YS     = YS - DEL
C                    WRITE HEADER
      IILIM  = 110
      CALL CORE(HWORK,IILIM)
      WRITE(cHWORK,20001) ! PMF 17/11/99: JUSCRN changed to cHWORK
20001 FORMAT(' DATA  B15 CHANNEL FIFOF HITCN UFLOW OFLOW Z-VALUE',10X,
     *' DATA  B15 CHANNEL FIFOF HITCN UFLOW OFLOW Z-VALUE')
      CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
C
      DO 20004 IHIT = 1,HZLENG,2
         HELP(2) = HDATA(HPOINT+IHIT)
         IZWRD1  = IZWORD
         KANAL1  = LAND( ISHFTR(IZWORD,11),15)
         HITCN1  = LAND( ISHFTR(IZWORD,8),3)
         IBT151  = 0
         IF( TBIT(IZWORD,16) ) IBT151 = 1
         IZWRT1  = LAND( IZWORD,63 )
         IOVRF1  = 0
         IF( LAND(IZWORD,64) .NE. 0 ) IOVRF1 = 1
         IUNDF1  = 0
         IF( LAND(IZWORD,128) .NE. 0 ) IUNDF1 = 1
         IFIFF1  = 0
         IF( LAND(IZWORD,1024) .NE. 0 ) IFIFF1 = 1
C
         HELP(2) = HDATA(HPOINT+IHIT+1)
         IZWRD2  = IZWORD
         KANAL2  = LAND( ISHFTR(IZWORD,11),15)
         HITCN2  = LAND( ISHFTR(IZWORD,8),3)
         IBT152 = 0
         IF( TBIT(IZWORD,16) ) IBT152 = 1
         IZWRT2 = LAND( IZWORD,63 )
         IOVRF2 = 0
         IF( LAND(IZWORD,64) .NE. 0 ) IOVRF2 = 1
         IUNDF2 = 0
         IF( LAND(IZWORD,128) .NE. 0 ) IUNDF2 = 1
         IFIFF2 = 0
         IF( LAND(IZWORD,1024) .NE.0 ) IFIFF2 = 1
C
         YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 20002
            IRETUR = 20
            GO TO 90000
20002    CONTINUE
         IILIM = 108
         CALL CORE(HWORK,IILIM)
         WRITE(cHWORK,20003) IZWRD1,IBT151,KANAL1,IFIFF1,HITCN1,IUNDF1, ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       IOVRF1,IZWRT1,
     *                       IZWRD2,IBT152,KANAL2,IFIFF2,HITCN2,IUNDF2,
     *                       IOVRF2,IZWRT2
20003    FORMAT(' ',Z4,3X,I1,4X,I2,5X,I1,5X,I1,5X,I1,5X,I1,4X,I5,
     *          13X,Z4,3X,I1,4X,I2,5X,I1,5X,I1,5X,I1,5X,I1,4X,I5)
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
20004 CONTINUE
      GO TO 90100
C
C  NEW FORMAT
C
20100 HPOINT = 2*( LIM2 + 1 ) + 1
      HZLENG = HDATA(HPOINT)
      YS     = YS - DEL
C                    WRITE HEADER
      IILIM  = 112
      CALL CORE(HWORK,IILIM)
      WRITE(cHWORK,20101) HZLENG ! PMF 17/11/99: JUSCRN changed to cHWORK
20101 FORMAT(' DATA  B15 CRATE SLOT SUBADR. OR UL LL OV Z-VALUE',5X,
     *' DATA  B15 CRATE SLOT SUBADR. OR UL LL OV Z-VALUE  L: ',I4)
      CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
C
      DO 20104 IHIT = 1,HZLENG,2
         HELP(2) = HDATA(HPOINT+IHIT)
         IZWRD1  = IZWORD
         IF(HELP(2).LT.0) GO TO 20105
C  DATA WORD
         IBT151  = 0
         IZWRT1  = LAND( IZWORD,63 )
         IOVRF1  = 0
         IF( LAND(IZWORD,64) .NE. 0 ) IOVRF1 = 1
         ILL1  = 0
         IF( LAND(IZWORD,128) .NE. 0 ) ILL1 = 1
         IUL1  = 0
         IF( LAND(IZWORD,256) .NE. 0 ) IUL1 = 1
         IOR1  = 0
         IF( LAND(IZWORD,512) .NE. 0 ) IOR1 = 1
         GO TO 20106
C
20105    ISUB1 = LAND(IZWORD,3)
         ISLO1 = LAND(IZWORD,MSKSLO)
         ISLO1 = ISHFTR(ISLO1,2)
         ICRA1 = LAND(IZWORD,MSKCRA)
         ICRA1 = ISHFTR(ICRA1,7)
         IBT151 = 1
C
20106    HELP(2) = HDATA(HPOINT+IHIT+1)
         IZWRD2  = IZWORD
         IF(HELP(2).LT.0) GO TO 20107
C  DATA WORD
         IBT152  = 0
         IZWRT2  = LAND( IZWORD,63 )
         IOVRF2  = 0
         IF( LAND(IZWORD,64) .NE. 0 ) IOVRF2 = 1
         ILL2  = 0
         IF( LAND(IZWORD,128) .NE. 0 ) ILL2 = 1
         IUL2  = 0
         IF( LAND(IZWORD,256) .NE. 0 ) IUL2 = 1
         IOR2  = 0
         IF( LAND(IZWORD,512) .NE. 0 ) IOR2 = 1
         GO TO 20108
C
20107    ISUB2 = LAND(IZWORD,3)
         ISLO2 = LAND(IZWORD,MSKSLO)
         ISLO2 = ISHFTR(ISLO2,2)
         ICRA2 = LAND(IZWORD,MSKCRA)
         ICRA2 = ISHFTR(ICRA2,7)
         IBT152 = 1
C
C
20108    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 20102
            IRETUR = 26
            GO TO 90000
20102    CONTINUE
         IILIM = 106
         CALL CORE(HWORK,IILIM)
C ONLY DATA WORDS
         IF(IBT151.EQ.0.AND.IBT152.EQ.0)
     *   WRITE(cHWORK,20103) IZWRD1,IBT151,IOR1,IUL1,ILL1, ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       IOVRF1,IZWRT1,
     *                       IZWRD2,IBT152,IOR2,IUL2,ILL2,
     *                       IOVRF2,IZWRT2
20103 FORMAT(' ',Z4,3X,I1,                 22X,I1,2X,I1,2X,I1,2X,I1,4X,
     * I2, 8X,Z4,3X,I1,                 22X,I1,2X,I1,2X,I1,2X,I1,4X,I2)
C  DATA + ADRESS
         IF(IBT151.EQ.0.AND.IBT152.NE.0)
     *   WRITE(cHWORK,20109) IZWRD1,IBT151,IOR1,IUL1,ILL1, ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       IOVRF1,IZWRT1,
     *                       IZWRD2,IBT152,ICRA2,ISLO2,ISUB2
20109 FORMAT(' ',Z4,3X,I1,                 22X,I1,2X,I1,2X,I1,2X,I1,4X,
     * I2, 8X,Z4,3X,I1,4X,I1,3X,I2,5X,I1)
C   ADRESS + DATA
         IF(IBT151.NE.0.AND.IBT152.EQ.0)
     *   WRITE(cHWORK,20110) IZWRD1,IBT151,ICRA1,ISLO1,ISUB1, ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       IZWRD2,IBT152,IOR2,IUL2,ILL2,
     *                       IOVRF2,IZWRT2
20110 FORMAT(' ',Z4,3X,I1,4X,I1,3X,I2,5X,I1,5X,
     *    25X,Z4,3X,I1,                 22X,I1,2X,I1,2X,I1,2X,I1,4X,I2)
C  ONLY ADRESS WORDS
         IF(IBT151.NE.0.AND.IBT152.NE.0)
     *   WRITE(cHWORK,20111) IZWRD1,IBT151,ICRA1,ISLO1,ISUB1, ! PMF 17/11/99: JUSCRN changed to cHWORK
     *                       IZWRD2,IBT152,ICRA2,ISLO2,ISUB2
20111 FORMAT(' ',Z4,3X,I1,4X,I1,3X,I2,5X,I1,5X,
     *    25X,Z4,3X,I1,4X,I1,3X,I2,5X,I1)
C
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
20104 CONTINUE
C
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR BPCH BANK
22000 LIM2 = LIM2 - 1
      LIMLIM = 2*LIM2
      LENGB  = 2*IDATA(LIM2)
      IAPOIN = LIMLIM + 2
      ILSUM = 0
22001 ILMPST = HDATA( IAPOIN + 1 )/2
C                            CHECK IF MP-STRING IS CORRECT
         IF( HDATA(IAPOIN + ILMPST) .NE. -2 ) GO TO 22002
             GO TO 22003
22002    IF( HDATA(IAPOIN + ILMPST) .NE. -1  .OR.
     *       HDATA(IAPOIN + ILMPST - 1) .NE. -2 ) GO TO 22090
C
C                            PROCESS MICROPROCESSOR-STRING
22003    YS = YS - DEL - DEL
C
         IPMPST = IAPOIN + 6
         ILSUMW = 0
         IMPROC = (HDATA(IPMPST+2)+41)/42
C
         CALL CORE(HWORK,66)
         WRITE(cHWORK,22004) (HDATA(IAPOIN+I),I=1,6), IMPROC ! PMF 17/11/99: JUSCRN changed to cHWORK
22004    FORMAT(' ',I4,I6,'   $',Z4,2I6,'   $',Z4,10X,'***   MP',I3,
     *          '   ***')
         CALL SYSSYM(XS,YS,SIZE,HWORK,66,0.)
C
22005    YS = YS - DEL
         IF( YS .GT. 150.0 ) GO TO 22006
            IRETUR = 22
            GO TO 90000
22006    ILWSDB = HDATA(IPMPST+1)
         ILWSID = ILWSDB/2
C                  CHECK IF WIRESIDE STRING IS CORRECT
         IF( HDATA( IPMPST + ILWSID) .NE. -8 ) GO TO 22049
C
C                            PROCESS WIRESIDE-STRING
            IWIRSD = HDATA(IPMPST+2)
            ILSTR  = ILWSDB - 6
            IEND   = ILWSID - 3
C
22007       DO 22008 I = 1, IEND
               ILB = I*2
               IHB = ILB - 1
***PMF 10/06/99   HBYTE(IHB) = LAND( HDATA( IPMPST+2+I ), 65280 )/256
***               HBYTE(ILB) = LAND( HDATA( IPMPST+2+I ), 255 )
              HBYTE(IHB) = hLAND( HDATA( IPMPST+2+I ), hint(65280) )/256
              HBYTE(ILB) = hLAND( HDATA( IPMPST+2+I ), hint(255) )
***PMF (end)
22008       CONTINUE
C
            IF( ILSTR .GT. 37 ) GO TO 22010
               ICORE = 12 + 3*ILSTR
               CALL CORE(HWORK,ICORE)
               WRITE(cHWORK,22009) ILWSDB, IWIRSD, (HBYTE(I),I=1,ILSTR) ! PMF 17/11/99: JUSCRN changed to cHWORK
22009          FORMAT(' ',I4,I4,'   ',37(Z2,1X))
               CALL SYSSYM(XS,YS,SIZE,HWORK,ICORE,0.)
               GO TO 22020
C
22010          CALL CORE(HWORK,123)
               WRITE(cHWORK,22009) ILWSDB, IWIRSD, (HBYTE(I),I=1,37) ! PMF 17/11/99: JUSCRN changed to cHWORK
               CALL SYSSYM(XS,YS,SIZE,HWORK,123,0.)
C
               YS = YS - DEL
               ILCON = ILSTR - 37
               ICORE = 12 + 3*ILCON
               CALL CORE(HWORK,ICORE)
               WRITE(cHWORK,22011) (HBYTE(37+I),I=1,ILCON) ! PMF 17/11/99: JUSCRN changed to cHWORK
22011          FORMAT(' ',11X,37(Z2,1X))
               CALL SYSSYM(XS,YS,SIZE,HWORK,ICORE,0.)
C
C                            CHECK IF LAST WS-STRING
22020       ILSUMW = ILSUMW + ILWSID
C                            SAFETY CHECK IF END OF MP-STRING
            IF( ILSUMW .GT. (ILMPST-7) ) GO TO 22050
C                            SET FLAG FOR LAST WIRESIDE-STRING
            IF( ILSUMW .EQ. (ILMPST-7) .OR. ILSUMW .EQ. (ILMPST-8) )
     *                                         GO TO 22050
               IPMPST = IPMPST + ILWSID
               GO TO 22005
22049    CALL TRMOUT(80,' BANKPR: error in wireside-string^')
22050 CONTINUE
C
C                            CHECK IF LAST MP-STRING
            ILSUM  = ILSUM + ILMPST
C                            SAFETY CHECK IF END OF BANK
            IF( ILSUM .GT. LENGB-2 ) GO TO 22099
C                            SET FLAG FOR LAST MP-STRING
            IF( ILSUM .EQ. LENGB-2 .OR. ILSUM .EQ. LENGB-3 ) GO TO 22099
               IAPOIN = IAPOIN + ILMPST
               GO TO 22001
22090    CALL TRMOUT(80,' BANKPR: error in microprocessor-string^')
22099 CONTINUE
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR VTXC BANK
23000 LIM2   = LIM2 - 1
      LIMLIM = 2*LIM2
      LOL    = 5
      LOLLOL = 10
      CALL CORE(HWORK,41)
      WRITE(cHWORK,23001) (IDATA(LIM2 + I),I=1,LOL) ! PMF 17/11/99: JUSCRN changed to cHWORK
23001 FORMAT(' ',5I8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,41,0.)
      LENGTH = 2*IDATA(LIM2)
      LENGB = LENGTH - LOLLOL
      NCYCLE = 1 + (LENGB - 1)/20
      DO 23005 LHO = 1,NCYCLE
23002    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 23003
            IRETUR = 23
            GO TO 90000
23003    LIML = LIMLIM + 20*(LHO - 1) + LOLLOL
         LIMU = LIML + 20
         IF( LIMU .GT. (LIMLIM+LENGTH) ) LIMU = LIMLIM + LENGTH
         ILIM = LIMU - LIML
         IF( ILIM .LE. 0 ) GO TO 90100
         DO 23004 I = 1, ILIM
            LLO = LIML + I
            HWORK(I+100) = HDATA(LLO)
23004    CONTINUE
         IILIM = 6*ILIM + 1
         CALL CORE(HWORK,IILIM)
         WRITE(cHWORK,504) (HWORK(100+I),I=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
         CALL SYSSYM(XS,YS,SIZE,HWORK,IILIM,0.)
23005 CONTINUE
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR VTHT BANK
24000 LIM2   = LIM2 - 1
      LIMLIM = 2*LIM2
      LOLLOL = 6
      YS     = YS - DEL
      CALL CORE(HWORK,44)
      WRITE(cHWORK,24001) (HDATA(LIMLIM + I),I=1,LOLLOL) ! PMF 17/11/99: JUSCRN changed to cHWORK
24001 FORMAT(' ',I3,5I8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,44,0.)
      LENGTH = 2*IDATA(LIM2)
      LENGB  = LENGTH - LOLLOL
      NCYCLE = 1 + (LENGB - 1)/8
      YS     = YS - DEL
      DO 24005 LHO = 1,NCYCLE
24002    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 24003
            IRETUR = 24
            GO TO 90000
24003    LIML = LIMLIM + 8*(LHO - 1) + LOLLOL
         LIMU = LIML + 8
         IF( LIMU .GT. (LIMLIM+LENGTH) ) LIMU = LIMLIM + LENGTH
         ILIM = LIMU - LIML
         IF( ILIM .LE. 0 ) GO TO 90100
         CALL CORE(HWORK,50)
         WRITE(cHWORK,24004) (HDATA(LIML+I),I=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
24004    FORMAT('  ',8I6)
         CALL SYSSYM(XS,YS,SIZE,HWORK,50,0.)
24005 CONTINUE
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR VPAT BANK
25000 LIM2   = LIM2 - 1
      LIMLIM = 2*LIM2
      LOLLOL = 6
      YS     = YS - DEL
      CALL CORE(HWORK,44)
      WRITE(cHWORK,25001) (HDATA(LIMLIM + I),I=1,LOLLOL) ! PMF 17/11/99: JUSCRN changed to cHWORK
25001 FORMAT(' ',I3,5I8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,44,0.)
      LENGTH = 2*IDATA(LIM2)
      LENGB = LENGTH - LOLLOL
      NCYCLE = 1 + (LENGB - 1)/12
      YS = YS - DEL
      DO 25005 LHO = 1,NCYCLE
25002    YS = YS - DEL
         IF( YS .GT. 50.0 ) GO TO 25003
            IRETUR = 25
            GO TO 90000
25003    LIML = LIMLIM + 12*(LHO - 1) + LOLLOL
         LIMU = LIML + 12
         IF( LIMU .GT. (LIMLIM+LENGTH) ) LIMU = LIMLIM + LENGTH
         ILIM = LIMU - LIML
         IF( ILIM .LE. 0 ) GO TO 90100
         CALL CORE(HWORK,74)
         WRITE(cHWORK,25004) (HDATA(LIML+I),I=1,ILIM) ! PMF 17/11/99: JUSCRN changed to cHWORK
25004    FORMAT('  ',12I6)
         CALL SYSSYM(XS,YS,SIZE,HWORK,74,0.)
25005 CONTINUE
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR VCVW BANK
26000 LIM2   = LIM2 - 1
      LIMLIM = 2*LIM2
      LOLLOL = 6
      YS     = YS - DEL
      CALL CORE(HWORK,44)
      WRITE(cHWORK,26001) (HDATA(LIMLIM + I),I=1,LOLLOL) ! PMF 17/11/99: JUSCRN changed to cHWORK
26001 FORMAT(' ',I3,5I8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,44,0.)
      LENGTH = 2*IDATA(LIM2)
      IPARRY = LIMLIM + LOLLOL
26002 YS = YS - DEL
      IF( YS .GT. 150.0 ) GO TO 26003
         IRETUR = 26
         GO TO 90000
26003 ILENWS = HDATA(IPARRY+1)
      IF( ILENWS .GT. 24 ) GO TO 26005
         ICORE = 2 + ILENWS*5
         CALL CORE(HWORK,ICORE)
         WRITE(cHWORK,26004) (HDATA(IPARRY+I),I=1,ILENWS) ! PMF 17/11/99: JUSCRN changed to cHWORK
26004    FORMAT(' ',I4,I5,2X,22I5)
         CALL SYSSYM(XS,YS,SIZE,HWORK,ICORE,0.)
         GO TO 26007
26005 CALL CORE(HWORK,122)
      WRITE(cHWORK,26004) (HDATA(IPARRY+I),I=1,24) ! PMF 17/11/99: JUSCRN changed to cHWORK
      CALL SYSSYM(XS,YS,SIZE,HWORK,122,0.)
C
      YS = YS - DEL
      ILCON = ILENWS - 24
      ICORE = 12 + 5*ILCON
      CALL CORE(HWORK,ICORE)
      WRITE(cHWORK,26006) (HDATA(IPARRY+24+I),I=1,ILCON) ! PMF 17/11/99: JUSCRN changed to cHWORK
26006 FORMAT(' ',11X,22I5)
      CALL SYSSYM(XS,YS,SIZE,HWORK,ICORE,0.)
26007 IPARRY = IPARRY + ILENWS
      IF( HDATA(IPARRY+1) .LE. 0 ) GO TO 90100
         IF( IPARRY .LT. LIMLIM+LENGTH ) GO TO 26002
      GO TO 90100
C____________________________ SPECIAL FORMAT FOR J68K BANK
27000 IRETUR = 0
      DEL = 0.7 * DEL
      SIZE = 0.7 * SIZE
27001 CALL PRJ68K( XS, YS, DEL, SIZE, IRETUR )
      IF( IRETUR.NE.0 ) GO TO 90000
      GO TO 90100
C--------------- SPECIAL FORMAT FOR PALL BANKS
28000 LIM2  = LIM2 - 1
      LO    = IDATA(LIM2+1)
      LTR   = IDATA(LIM2+2)
      NPA   = IDATA(LIM2+4)
      IPO   = LIM2 + LO
      CALL CORE(HWORK,79)
      WRITE(cHWORK,28001) (IDATA(LIM2+II),II=1,6),(ADATA(LIM2+JJ),JJ=7,8 ! PMF 17/11/99: JUSCRN changed to cHWORK
     *),IDATA(LIM2+9)
28001 FORMAT(' ',6I8,2F11.4,I8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,79,0.)
      YS   = YS - DEL
      ICNT = 0
28002 ICNT = ICNT + 1
      IF( ICNT .GT. NPA ) GO TO 90100
28003 YS = YS - DEL
      IF( YS .GT. 50.0 ) GO TO 28004
         IRETUR = 28
         GO TO 90000
28004 IPP = IPO + (ICNT-1)*LTR
      CALL CORE(HWORK,95)
      WRITE(cHWORK,28005) ! PMF 17/11/99: JUSCRN changed to cHWORK
     *     ICNT,(ADATA(IPP+II),II=1,5),(IDATA(IPP+JJ),JJ=6,9)
28005 FORMAT(' ',I4,3X,4F11.4,F11.6,4I8)
      CALL SYSSYM(XS,YS,SIZE,HWORK,95,0.)
      GO TO 28002
C---------------    CONTINUATION SECTION
90000 CONTINUE
      CALL CORE(HWORK,14)
      WRITE(cHWORK,90001) ! PMF 17/11/99: JUSCRN changed to cHWORK
90001 FORMAT(' CONTINUED ...')
      CALL SYSSYM(XS,YS,SIZE,HWORK,14,0.)
      GO TO 90200
90100 IRETUR = -1
90200 CALL TRMOUT(80,'Hardcopy ?^')
      CALL DECIDE(IANSW)
      IF( IANSW .NE. 1 ) GO TO 90300
90290    CALL TRMOUT(80,'Hardcopy on Laser Printer L1 .. L5 ?  (1 .. 5)^
     *')
         CALL TRMOUT(80,'Hardcopy on INTERNAL PLOTTER ?  (6)^')
         CALL TRMOUT(80,'Hardcopy on EXTERNAL PLOTTER ?  (7)^')
         CALL TRMOUT(80,'Enter your choice (1 .. 7 ) :^')
         CALL FYRINT(NDEST,ID2,ID3,ID4)
         IF( NDEST .LT. 1 .OR. NDEST .GT. 7 ) GO TO 90290
         IF( NDEST .LT. 6 ) CALL PTRANS(335,100)
         CALL HDCDST(DESTPL(NDEST))
90300 IF(IRETUR .EQ. -1 ) GO TO 99999
      IF( IANSW .EQ. 1 ) CALL PROMPT
      CALL ERASE
      YS = IYT0
      CALL TRMOUT(80,'TERMINATE THIS LISTING?^')
      CALL DECIDE(IANSW)
      IF( IANSW .EQ. 1 ) GO TO 99999
      CALL ERASE
      IF( IRETUR .EQ. 0 ) GO TO 501
      GOTO ( 1001, 2003, 3001, 4001, 5001, 6006, 7003,99999, 9005,10003,
     *      99999,99999,99999,99999,15006,16001,99999,99999,19015,20002,
     *      19015,22005,23002,24002,25002,26002,27001,28003, 2003, 4001,
     *      19019,19022,19026,19030,99999,99999,99999,99999,99999,99999)
     *   ,IRETUR
99999 RETURN
      END
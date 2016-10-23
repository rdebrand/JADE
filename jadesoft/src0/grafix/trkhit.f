C   01/11/84 810171933  MEMBER NAME  TRKHIT   (S)           FORTRAN
C
C-----------------------------------------------------------------------
      SUBROUTINE TRKHIT
C-----------------------------------------------------------------------
C
C   AUTHOR:   J. OLSSON     ?      :  DISPLAY PATREC RESULTS
C
C        MOD: J. OLSSON   17/10/81 :
C        MOD: K.-H.                :  CHANGES FOR NEW TR 6 - LIKE TR 3
C             HELLENBRAND 21/03/84 :  BUT BAD Z HITS MARKED DIFFERENTLY
C        MOD: J. HAGEMANN 10/10/84 :  NEW HITMRK USED
C        MOD: C. BOWDERY   9/08/85 :  CALL DISPZC
C        MOD: J. HAGEMANN 28/10/85 :  CALL DISPVC
C        MOD: J. HAGEMANN 10/01/86 :  EXTENDED COMMON CVX
C        MOD: J. HAGEMANN 16/12/86 :  DUE TO UPDATED DISPVC
C        MOD: J. HAGEMANN 27/02/87 :  FOR 1986 ID-DATA SMALLER CROSSES
C                                     IN R-FI-VIEWS
C        MOD: J. HAGEMANN 18/03/87 :  FOR TR3 INCREASE NUMBER OF SELEC-
C                                     TED TRACKS FROM 6 TO 50
C   LAST MOD: J. HAGEMANN 17/10/88 :  FOR VERTEX CHAMBER VIEW
C
C     DISPLAY PATTERN RECOGNITION RESULTS
C     VARIOUS OPTIONS FOR DISPLAYING HITS ACCORDING TO TRACK ASSOCIATION
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL TBIT,REMEMB,REMB1,MUONFL
      LOGICAL FL18,FL22,FL24
      LOGICAL DSPDTM
      LOGICAL FLVCDO
      LOGICAL FLVC01,FLVC02,FLVC03
C
#include "cgeo1.for"
#include "cgraph.for"
#include "cdata.for"
C
      COMMON / CHEADR / HEAD(108)
      COMMON / CPROJ  / XMINR,XMAXR,YMINR,YMAXR,IPRJC,FL18,FL22,FL24
      COMMON / CWORK1 / R,FI,R1,FI1,X1,Y1,R2,FI2,X2,Y2,ZET,X3,Y3,X4,Y4,
     +                  KZAMP,HWORK(400),XLST(100),YLST(100),HKTR(50)
      COMMON / CJTRIG / PI,TWOPI
      COMMON / CGRAP2 / BCMD,DSPDTM(30)
      COMMON / CVX    / NNPATR,ICRSTR,NNJETC,NNVTXC
      COMMON / CGVCDO / FLVCDO(20)
C
      DIMENSION HELP1(2),HELP2(2)
      EQUIVALENCE (LABL1,HELP1(1)),(LABL2,HELP2(1))
C
      DATA HELP1/0,0/,HELP2/0,0/,HCALL/0/
      DATA MSKTR1 / ZFE/
C
C------------------  C O D E  ------------------------------------------
C
      CRLEN = 4.0
      IF( HEAD(16) .EQ. 1986 ) CRLEN = 2.75
      LSTREM = LASTVW
      IF(LASTVW.LE.11.OR.LASTVW.EQ.14.OR.LASTVW.EQ.20) GO TO 2410
      WRITE(6,2420)
2420  FORMAT(' LAST VIEW WAS NOT AN ID VIEW. THE DEFAULT VIEW RA IS CHOS
     $EN')
      CALL PROMPT
      LASTVW = 1
      CALL SETSCL(LASTVW)
2410  IF(NNPATR.LE.0) GO TO 2411
      CALL CLOC(IPJHTL,'JHTL',NNPATR)
      IF(IPJHTL.GT.0) GO TO 2702
      WRITE(6,2703) NNPATR
2703  FORMAT(' JHTL BANK NR',I3,' (GIVEN BY COMMAND PATR) NOT EXISTING')
      GO TO 2411
2702  CALL CLOC(IPJTR,'PATR',NNPATR)
      IF(IPJTR.GT.0) GO TO 2713
      WRITE(6,2704) NNPATR
2704  FORMAT(' PATR BANK NR',I3,' (GIVEN BY COMMAND PATR) NOT EXISTING')
      GO TO 2412
2411  IPJHTL = IDATA(IBLN('JHTL'))
2412  IPJTR = IDATA(IBLN('PATR'))
2713  IF(IPJHTL.GT.0.AND.IPJTR.GT.0) GO TO 1
C
C                            CANNOT CONTINUE IF PATR OR JHTL MISSING
C
 199  WRITE(JUSCRN,198)
 198  FORMAT(' ''PATR'' AND/OR ''JHTL'' BANK(S) MISSING'/
     +       ' MAYBE PATREC HAS NOT BEEN DONE?')
      GO TO 9999
C
 1    HALO = 0
      IF(ACMD.GT.100.) HALO = 1
      IF(ACMD.GT.100.) ACMD = ACMD - 100.
      NN2 = ACMD
      NCMD = BCMD
      IF(NN2.GT.6) NCMD = NN2
      IF(NN2.GT.6) NN2 = 0
      IF(NCMD.EQ.0.OR.NCMD.EQ.IDATA(IPJHTL-2)) GO TO 11
      CALL CLOC(IPJHTL,'JHTL',NCMD)
      CALL CLOC(IPJTR,'PATR',NCMD)
      IF(IPJHTL.NE.0.AND.IPJTR.NE.0) GO TO 11
      GO TO 199
11    IPJH = 2*IPJHTL+2
      IF(NNJETC.LE.0) GO TO 5100
      CALL CLOC(IPJETC,'JETC',NNJETC)
      IF(IPJETC.GT.0) GO TO 5101
      WRITE(6,5103) NNPATR
5103  FORMAT(' JETC BANK NR',I3,' (GIVEN BY COMMAND JETC) NOT EXISTING')
5100  IPJETC = IDATA(IBLN('JETC'))
5101  IPJ = 2*IPJETC + 2
      NHITS = (HDATA(IPJ+97)-HDATA(IPJ+1))/4
      NWO = 4*NHITS + 98
      NTR = IDATA(IPJTR+2)
      REMEMB = DSPDTL(6)
      REMB1 = DSPDTL(10)
      JNDEX = LASTVW
      IF(LASTVW.GT.7) JNDEX = JNDEX - 4
      MUONFL =((JNDEX.EQ.3.OR.JNDEX.EQ.6.OR.JNDEX.EQ.7).AND.DSPDTL(3))
      HCALL = HCALL + 1
      IF(HCALL.GT.1) GO TO 1601
      SH1 = BLDEP*.10
      SH2 = BLFI*.16667
      SH3 = 4.*SH2
      SH4 = 2.3*SH2
      DEFIX = TWOPI/84.
      GO TO 1601
122   CALL TRMOUT(80,'CODE 0 : DISPLAY CODE LIST^')
      CALL TRMOUT(80,'CODE 1 : DISPLAY ALL HITS ASSOCIATED WITH TRACKS^'
     +)
      CALL TRMOUT(80,'CODE 2 : DISPLAY ALL HITS NOT ASSOCIATED WITH TRAC
     +KS^')
      CALL TRMOUT(80,'CODE 3 : DISPLAY ALL HITS ASSOCIATED WITH TRACKS,
     +MARKING SELECTED ONES^')
      CALL TRMOUT(80,'CODE 4 : DISPLAY ALL HITS, MARKING TRACK-ASSOCIATE
     +D ONES^')
      CALL TRMOUT(80,'CODE 5 : DISPLAY RAW EVENT, MARKING SELECTED TRACK
     +S.^')
      CALL TRMOUT(80,'CODE 6 : SIMILAR TO CODE 3 BUT MARKING GOOD AND BA
     +D Z HITS DIFFERENTLY^')
1601  IQQ = 0
      IQQQ = 0
      IF(NN2.EQ.0) GO TO 1602
      NN = NN2 + 1
      NN2 = 0
      GO TO 2905
1602  CALL TRMOUT(80,'ENTER CODE: (0=LIST)^')
      NN = TERNUM(DUMM) + 1
2905  IF(NN.LT.1.OR.NN.GT.8) GO TO 1601
      GO TO (122,1800,1800,2000,1800,2100,2200,3000),NN
      GO TO 122
1800  KNDX = NN-1
      GO TO 222
2100  KNDX = 5
      KNDZ=0
      GO TO 2001
2200  KNDX = 3
      KNDZ=1
      GO TO 2001
2000  KNDX = 3
      KNDZ=0
2001  IKTR = 0
      DO 6101  II = 1,50
6101  HKTR(II) = 0
1019  CALL TRMOUT(80,'ENTER TRACK NR.^')
      KTR = TERNUM(DUMM)
      IF(KTR.LE.0.OR.KTR.GT.NTR) GO TO 1021
      IKTR = IKTR + 1
      IF(IKTR.LE.50) GO TO 1022
      IKTR = IKTR - 1
      GO TO 222
1022  HKTR(IKTR) = KTR
      GO TO 1019
1021  IF(IKTR.GT.0) GO TO 222
      CALL TRMOUT(80,'NO VALID TRACK NUMBER HAS BEEN ENTERED^')
      GO TO 1601
3000  IQQ = 1
      IF(NDDOUT.EQ.0) GO TO 3001
      CALL TRMOUT(80,'ENTER YES TO CONFIRM PRINT OPTION !^')
      CALL DECIDE(IANSW)
      IF(IANSW.NE.1) GO TO 1601
3001  CALL TRMOUT(80,'DO YOU WANT SPECIAL DEBUG PRINT?^')
      CALL DECIDE(IANSW)
      IF(IANSW.NE.1) GO TO 1602
      IQQ = 0
      IQQQ = 1
      GO TO 1602
C----------------------------------------------------------------------I
222   NI = IPJ + 99
      IHIT = 0
      IHITN = -1
      CALL ERASE
      IF(HALO.EQ.1) CALL JADISP(LASTVW)
C---     WRITE OUT EVENT CAPTION.
      CALL CAPMRK(LASTVW,HESUM)
C--  LOOP OVER NR OF WORDS IN EVENT
      DO 8565  II = 1,100
      XLST(II) = 0.
8565  YLST(II) = 0.
8566  IHIT = IHIT + 1
      IHITN = IHITN + 2
      IHIT1 = IHITN
      IHIT2 = IHITN + 1
      IF(IHIT.GT.NHITS) GO TO 2255
      HELP1(2) = HDATA(IHIT1+IPJH)
      HELP2(2) = HDATA(IHIT2+IPJH)
      IKFLAG = 0
      MTR = 0
      MTR2 = 0
      IF(IQQ.EQ.0) GO TO 7579
      WRITE(6,8500) IHIT,IHITN,IHIT1,IHIT2,NI,HELP1(2),HELP2(2)
8500  FORMAT(' IHIT,IHITN12,NI,HELP1,HELP2',5I5,4X,Z4,1X,Z4)
7579  IF(LABL1.NE.0.AND.KNDX.NE.2) GO TO 821
      IF(LABL1.EQ.0.AND.(KNDX.EQ.2.OR.KNDX.GT.3)) GO TO 821
824   NI = NI + 4
      GO TO 8566
821   ISGN = 0
      IF(LABL1.EQ.0) GO TO 823
      MTR = LAND(LABL1,MSKTR1)
      MTR = SHFTR(MTR,1)
      MTR2 = LAND(LABL2,MSKTR1)
      MTR2 = SHFTR(MTR2,1)
      IF(IQQ.NE.0)
     $ CALL DIAGIN('MTR IHIT NI KNDX MT2',5,MTR,IHIT,NI,KNDX,MTR2,NI)
      IF(MTR.EQ.0.AND.KNDX.NE.2.AND.KNDX.NE.5) GO TO 824
      IF(MTR.NE.0.AND.KNDX.EQ.2) GO TO 824
      ISGN = -1
      IF(TBIT(LABL1,23)) ISGN = 1
      IF(KNDX.NE.3.AND.KNDX.NE.5) GO TO 823
      DO 8255  IKT = 1,IKTR
      IF(HKTR(IKT).EQ.MTR) IKFLAG = 1
8255  IF(HKTR(IKT).EQ.MTR2) IKFLAG = 2
      IF(IKFLAG.EQ.0.AND.LASTVW.GT.3.AND.LASTVW.LT.14) GO TO 824
      IF(IKFLAG.EQ.2) ISGN = -1
      IF(IKFLAG.EQ.2.AND.TBIT(LABL2,23)) ISGN = 1
823   IVVX = 0
      IF(LASTVW.GT.3.AND.LASTVW.LT.14) IVVX = 1
      IF(IVVX.EQ.1.AND.DSPDTL(9)) DSPDTL(10) = .TRUE.
      IF(LASTVW.EQ.14) IVVX = 2
      KZAMP = 0
      CALL FICOOR(IVVX,NI,NWE)
      IF(NWE.LT.-500) GO TO 225
      IF(NWE.EQ.0) GO TO 7788
      IF(IQQ.NE.0)
     $ CALL DIAGIN('ISGN NWE IVVX IKFLAG',4,ISGN,NWE,IVVX,IKFLAG,I,I)
      IF(LABL1.NE.0.AND.KNDX.EQ.4) DSPDTL(6) = .NOT.REMEMB
      IF(LASTVW.LT.4.OR.LASTVW.GT.12) GO TO 7539
C*****************************
C**  ZX AND ZY DISPLAYS     **
C*****************************
      IF(IKFLAG.EQ.0.AND.(KNDX.EQ.3.OR.KNDX.EQ.5)) DSPDTL(6)=.NOT.REMEMB
      IF(KNDZ.EQ.0) GOTO 830
      IKSF=IKFLAG+1
      GOTO (830,827,828), IKSF
      GOTO 830
  827 IF(TBIT(LABL1,31)) GOTO 830
      GOTO 829
  828 IF(TBIT(LABL2,31)) GOTO 830
  829 DSPDTL(6)=.NOT.DSPDTL(6)
  830 IF(DSPDTL(9)) GO TO 3425
C-- TRUE PROJECTIONS -------
      IF(ISGN.LT.0.AND.KNDX.NE.5) GO TO 3421
      YPRO= X1
      IF(LASTVW.GT.7) YPRO = Y1
      CALL HITMRK( JNDEX, ZET, YPRO, 4.0, 0 )
      IF(LABL1.NE.0.AND.KNDX.NE.5) GO TO 3427
3421  YPRO = X2
      IF(LASTVW.GT.7) YPRO = Y2
      CALL HITMRK( JNDEX, ZET, YPRO, 4.0, 0 )
3422  IF(LABL1.EQ.0) GO TO 805
      IF(IKFLAG.EQ.0.AND.KNDX.EQ.5) GO TO 805
3427  IF(IKFLAG.EQ.2) GO TO 3438
      XLST(MTR) = - ZET
      YLST(MTR) = YPRO
      GO TO 805
3438  XLST(MTR2) = - ZET
      YLST(MTR2) = YPRO
      GO TO 805
3425  CONTINUE
C-- WRAPPED PROJECTIONS ---------
      IF(ISGN.LT.0.AND.KNDX.NE.5) GO TO 3426
      YPRO = R1
      CALL HITMRK( JNDEX, ZET, YPRO, 4.0, 0 )
      IF(LABL1.NE.0.AND.KNDX.NE.5) GO TO 3427
3426  YPRO = R2
      CALL HITMRK( JNDEX, ZET, YPRO, 4.0, 0 )
      GO TO 3422
C********************
C**  RFI DISPLAYS  **
C********************
7539  IF(IKFLAG.NE.0.AND.(KNDX.EQ.3.OR.KNDX.EQ.5)) DSPDTL(6)=.NOT.REMEMB
      IF(KNDZ.EQ.0) GOTO 7543
      IKRF=IKFLAG+1
      GOTO (7543,7540,7541), IKRF
      GOTO 7543
 7540 IF(TBIT(LABL1,31)) GOTO 7543
      GOTO 7542
 7541 IF(TBIT(LABL2,31)) GOTO 7543
 7542 DSPDTL(6)=.NOT.DSPDTL(6)
 7543 IF(LABL1.EQ.0) GO TO 1001
      IF(ISGN.LT.0.AND.KNDX.NE.5) GO TO 804
      IF(IKFLAG.EQ.0.AND.KNDX.EQ.5) GO TO 1001
      NTRR = MTR
      IF(IKFLAG.EQ.2) NTRR = MTR2
      XLST(NTRR) = X1
      YLST(NTRR) = Y1
1001  CALL HITMRK( LASTVW, -X1, Y1, CRLEN, 0 )
      IF(ISGN.GT.0.AND.KNDX.NE.5) GO TO 805
804   IF(LABL1.EQ.0) GO TO 1011
      IF(IKFLAG.EQ.0.AND.KNDX.EQ.5) GO TO 1011
      NTRR = MTR
      IF(IKFLAG.EQ.2) NTRR = MTR2
      XLST(NTRR) = X2
      YLST(NTRR) = Y2
1011  CALL HITMRK( LASTVW, -X2, Y2, CRLEN, 0 )
  805 DSPDTL(6) = REMEMB
      DSPDTL(10) = REMB1
      IF(IQQQ.NE.0)
     $ CALL DIAGIN('NI IPJ KNX ISGN  MTR',5,NI,IPJ,KNDX,ISGN,MTR,NI)
7788  IF(NI.LE.(IPJ+NWO)) GO TO 8566
C-- WRITE TRACK NUMBER AT POSITION OF LAST HIT
2255  IF(KNDX.EQ.2) GO TO 225
      IF(IQQQ.NE.0)
     $ CALL DIAGIN('NIIPJKNX ISGN  MTR E',5,NI,IPJ,KNDX,ISGN,MTR,NI)
      FII = 0.
      DO 2344  II = 1,NTR
      IF(ABS(XLST(II)).LT..1.AND.ABS(YLST(II)).LT..1) GO TO 2344
      CALL TRNUMB(II,0,XLST(II),YLST(II),DM)
2344  CONTINUE
225   IF(LASTVW.GT.1.AND.LASTVW.LT.4) CALL PBGRFI(SH1,SH2,SH3,DEFIX)
      IF(LASTVW.GT.4.AND.LASTVW.LT.12.AND.LASTVW.NE.8)
     $ CALL PBGRZ(LASTVW,SH1,SH2,SH3)
      IF(LASTVW.EQ.14) CALL PBGCYL(DEFIX)
      IF(LASTVW.LT.4) CALL HODRFI
C
C                            DISPLAY VERTEX CHAMBER
C
      IF( LASTVW .GT. 3 .AND. LASTVW .NE. 20 ) GO TO 4400
         IF( NN .NE. 2 ) GO TO 4300
            FLVC01 = FLVCDO(1)
            FLVC02 = FLVCDO(2)
            FLVC03 = FLVCDO(3)
            FLVCDO(1) = .FALSE.
            FLVCDO(2) = .FALSE.
            FLVCDO(3) = .TRUE.
 4300    CONTINUE
         CALL DISPVC(LASTVW,1)
         IF( NN .NE. 2 ) GO TO 4400
            FLVCDO(1) = FLVC01
            FLVCDO(2) = FLVC02
            FLVCDO(3) = FLVC03
 4400 CONTINUE
      IF( LASTVW .GE. 4 .AND. LASTVW .LE. 11 ) CALL DISPVC(LASTVW,2)
C
C                            DISPLAY Z CHAMBER
C
      IF( LASTVW .LT. 4 ) CALL DISPZC( 1 )
      IF( LASTVW .GE. 4  .AND.  LASTVW .LE. 11 ) CALL DISPZC( 2 )
C
      IF(JNDEX.GT.5) CALL FWMUHT
      IF(MUONFL) CALL MUHDSP
      IF(MUONFL.AND.DSPDTL(18)) CALL TR3DSP
9999  IF(LSTREM.EQ.LASTVW) GO TO 9998
      LASTVW = LSTREM
      CALL SETSCL(LASTVW)
9998  RETURN
      END

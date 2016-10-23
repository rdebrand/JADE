C   13/08/79 808021743  MEMBER NAME  LGCDIR9  (SOURCE)      FORTRAN
C
C=======================================================================
      SUBROUTINE LGCDIR( NPPREC, NPR, NPCL)
C=======================================================================
C
C     S.YAMADA      06-11-78  15:20
C          MOD. 01-11-79  18:30 BY Y.WATANABE(CALL TPCNST)
C          MOD. 29-02-80  14:20 BY S.YAMADA (COSTH CORRECTION)
C          MOD. 05-05-80  18:20 BY Y.WATANABE (HRUN=0. NOECOR)
C          MOD. 26-08-80  02:30 BY Y.WATANABE (INTOLG NPPREC )
C          MOD. 12-02-81  22:30 BY Y.WATANABE (ECOR FOR MC IF NEEDED)
C          MOD. 03-09-86  J.OLSSON  CORRECT BUG IN MC BANK DESCRIPTOR
C          MOD. 02-08-88  T.OEST/D.PITZL: PASS # OF BLOCKS TO LGECOR
C
C---- LEAD GLASS CLUSTER DIRECTION IS CALCULATED USING THE EVENT VERTEX.
C     ADATA(NPCLS+8--10) ARE FILLED. SEE BELOW.
C
C     THIS IS CALLED IN THE 2-ND STEP LG-ANALYSIS.
C    ******* BOS VERSION ********
C
C---- INPUT:
C         NPPREC=THE BOS POINTER TO THE PATTERN RECOGNITION RES.('PATR')
C                THE NEW FORMAT(VARIABLE LENGTH HEADER) IS ACCEPTED NOW.
C
C         NPR   =THE BOS POINTER TO THE RAW LG-ADC DATA ('ALGN')
C         NPCL  =THE BOS POINTER TO THE LG-RESULT BANK ('LGCL')
C
      IMPLICIT INTEGER *2 (H)
C
      DIMENSION HELP(2)
      EQUIVALENCE (IHELP,HELP(1))
C
#include "cdata.for"
#include "clgwork2.for"
      COMMON /CLGDMS/ X0,RADIUS(6),RADSX0(6),THX0(4),
     $                ZEND(2),ZENDX0(2),ZWID(2),ZGAP(2),PHWID(2),
     $                ZECAP(4),ZECAPX(4),THECPX(2)
C
      COMMON /CLGPRM/ ITH,MAXCLS,IRLTHD,IRLTH2,IRLTH3, ZVRTX, DZVRTX
      COMMON /CLGMSB/ MSGVAL(5)
      COMMON /CLGCHG/ NCHIND,NSTEP,CXDCHG(9,100)
      DIMENSION JBCCHG(9,100)
      EQUIVALENCE (CXDCHG(1,1),JBCCHG(1,1))
      COMMON /CLGSHP/ WWZZXX(150),EW(2),AVPH,AVZ
C
C---- SEE  JADE COMPUTER-NOTE #14.
C     IDATA(NPCLS+1)=JBC, 0 FOR BARREL, -1 FOR BOTTOM, 1 FOR TOP
C     ADATA(NPCLS+2)=CLUSTER ENERGY IN GEV
C     ADATA(NCLST+3)=SIGMA(ENERGY)
C     ADATA(NPCLS+4)=WEIGHTED AVERAGE PHI
C     ADATA(NPCLS+5)=WEIGHTED AVERAGE Z
C     ADATA(NPCLS+6)=SIGMA PHI (WEIGHTED)
C     ADATA(NPCLS+7)=SIGMA Z (WEIGHTED)
C     IDATA(NPCLS+8)=NUMBER OF CORRESPONDING INNER TRACKS
C     ADATA(NPCLS+9-11)=DIRECTION COSINES CORRECTED FOR SHOWER DEPTH.
C
      INTEGER INDEX(3)/  9, 8,10/
C
      COMMON /CLGVRN/ NVRSN(20)
      DATA NVCODE,INITL/680082602,0/
      DATA HELP /0,0/
C
      IF(INITL.GT.0) GO TO 31
      INITL=1
      IPHD=IBLN('HEAD')
      IPVX=IBLN('TPVX')
C
      PRINT 6232
 6232 FORMAT( T2, 'JADELG.LOAD (LGCDIR9) CALLED, VERSION OF 02.08.88')
C
31    CONTINUE
C
C---- CHECK POINTERS
      IF(NPCL.LE.0) GO TO 90
C---- FIX POINTERS FOR CLUSTER DATA
      NPCGI = NPCL+IDATA(NPCL+1)-1
      NPCLS = NPCL+IDATA(NPCL+3)-1
C---- GET NO.OF CLUSTERS
      NCLST = IDATA(NPCGI+3)
C............ PUT IN BKGAUSS ETC...1-11-79
          NPHD = IDATA(IPHD)
         CALL TPCNST ( NPHD )
         HRUN=HDATA(NPHD+NPHD+10)
C        USED TO DECIDE DATA OR MONTE CARLO
C        IF HRUN=0 NO ENERGY CORRECTION IS DONE.
C
      NVRSN(9) = NVCODE
C
C     CHECK IF LGANAL IS CALLED FOR THIS JOB
      IF(IDATA(NPCGI+17).EQ.2) CALL LGREIN(NPCL,NPR)
C
C---- CLEAR THE MATCH TABLE
      CALL SETSL( NCHCL2, 0,1448, 0)
C
C---- SET THE FLAG TO SHOW THAT THE 2-ND STEP ANALYSIS IS DONE.
      IDATA(NPCGI+17) = 2
C
      IF( NPR.LE.0 ) GO TO 4
C
C---- INNER TRACK CONNECTION IS DONE IF 'PATR' IS THERE.
      IF(NPPREC.LE.0) GO TO 4
C
      NCHPRE = IDATA(NPPREC+2)
      NLPTRC = IDATA(NPPREC+3)
      NPTR = NPPREC+1+IDATA(NPPREC+1)
C
C---- SKIP CH.TRACING,IF LG-CLUSTER IS NOT THERE.(TO SAVE TIME)
      IF( NCLST.GT.0 ) GO TO 6
      NCHCLS = NCHPRE
      NPOINT = 0
      NCHCL2 = NCHPRE
      GO TO 7
C
    6 CALL ILCTRC(NCHPRE,NLPTRC,IDATA(NPTR),ADATA(NPTR))
      CALL LGCHC2
C
C---- CONNECT SIMULATED CHARGE CLUSTERS AND OBSERVED ONES.
      NPMAP = NPCL+IDATA(NPCL+2)
      NPALGN = NPR+NPR+7
C
C---- NOTICE THAT IN THE INTOLG LG-ADC MAP IS TREATED AS HDATA(2,2).
      CALL INTOLG(NPCL,IDATA(NPMAP),HDATA(NPALGN),NPPREC)
C
C---- SET THE FLAG OF INNER TRACK CONNECTION
    7 IDATA(NPCGI+19) = 1
C
    4 IF( NCLST ) 100,100,8
C
C---- GET NO.OF WORDS FOR EACH CLUSTER.
    8 LSTEP = IDATA(NPCGI+21)
C
C---- VERSION NO. FOR ENERGY CORRECTION SUBROUTINE IS SET.
      CALL LGECR0( NVECOR )
C---- SHOWER ENERGY CORRECTION IS MADE
      IDATA(NPCGI+18) = NVECOR
      IF(NVECOR)42,42,41
C---- CLEAR TOTAL ENERGY TO MAKE THE SUM OF CORRECTED ENERGIES
41    CALL SETSL(ADATA(NPCGI+7),0,36,0.)
42    NEND = NCLST
      IF(NEND.GT.MAXCLS) NEND = MAXCLS
C
C---- VERTEX OF THE EVENT IS COPIED INTO ZVRTX
      NPVX=IDATA(IPVX)
      ZVRTX = 0.
      DZVRTX = 0.
      IF(NPVX.LE.0) GO TO 5
C----   SET THE VERTEX FLAG
      IDATA(NPCGI+20) = HDATA(2*NPVX+2)
      ZVRTX = ADATA(NPVX+4)
C----   LIMIT THE VERTEX POSITION RANGE FOR SAFETY.
      IF( ZVRTX.LT.ZEND(1) ) ZVRTX = ZEND(1)
      IF( ZVRTX.GT.ZEND(2) ) ZVRTX = ZEND(2)
      DZVRTX = ADATA(NPVX+7)
    5 CONTINUE
C
C
        DO 1 N=1,NEND
C----   CHARGE( NO.OF CONNECTED CHARGED TRACK*100+ THE INDEX OF THE 1-ST
C               CANDIDATE)
        IDATA(NPCLS+8) = HCLLSO(1,N)*100+HCLLSO(2,N)
        JEG=0
        ELG=ADATA(NPCLS+2)
C....   SEPARATE GAMMA, ELCTRN/POSTRN * OTHER CHARGED.
        IF(HCLLSO(1,N)-1) 205,202,204
  202   IF(ELG.GT.0.6) GO TO 204
        NC=HCLLSO(2,N)
        PC=CXDCHG(9,NC)
        IF(PC.LT.0.5 .OR. ELG.GT.0.5*PC) GO TO 204
        JEG=2
C----   KINETIC ENERGY FOR PION IS USED.
        EMEV = 1000.*(SQRT(PC*PC+0.0196)-0.14)
        GO TO 206
C
  204   JEG=1
  205   EMEV = ELG*1000.0
C
  206   IPART = IDATA(NPCLS+1)
        IF(IPART) 10,2,10
C
C----   BARREL
    2   ZAV = ADATA(NPCLS+5)
C
C----   AVERAGE DEPTH OF THE SHOWER IS CALCULATED BY ITERATION.
        CALL LGAVDP(ZAV,EMEV,JEG,DEP)
C
C----   SET DIRECTION COSINES
    3   ZZ = ADATA(NPCLS+5)-ZVRTX
        TR = SQRT((RADIUS(3)+DEP)**2+ZZ**2)
        COSTH = ZZ/TR
C----   COSTH CORRECTION
        CALL LGTHCR( ADATA(NPCLS+2),ADATA(NPCLS+15),JEG,COSTH, DCOSTH)
        COSTH = COSTH+DCOSTH
   36   RXY = SQRT(1.0-COSTH*COSTH)
        ADATA(NPCLS+9) = RXY*COS(ADATA(NPCLS+4))
        ADATA(NPCLS+10) = RXY*SIN(ADATA(NPCLS+4))
        ADATA(NPCLS+11) = COSTH
        GO TO 20
C
C----   END CAP (JEG=1 FOR SAFETY REASON)
   10   IF(JEG.EQ.2) JEG=1
        ZAV=ZECAP(IPART+2)
C----     AVERAGE DEPTH OF THE SHOWER IS CALCULATEDBY BY ITERATION
        CALL LGAVDE(ZAV,NPCLS,JEG,DEP)
        ZZ = ZECAP(IPART+2)-ZVRTX+DEP*FLOAT(IPART)
        TR = SQRT(ADATA(NPCLS+4)**2+ADATA(NPCLS+5)**2+ZZ**2)
        ADATA(NPCLS+9) = ADATA(NPCLS+4)/TR
        ADATA(NPCLS+10) = ADATA(NPCLS+5)/TR
        ADATA(NPCLS+11) = ZZ/TR
C
C----   ENERGY CORRECTION FOR DATA, ENERGY SMEARING FOR MC.
   20   CONTINUE
        IF(LSTEP.GT.15) ADATA(NPCLS+16)=ADATA(NPCLS+2)
C           SAVE UNCORRECTED OR UNSMEARED ENERGY (IF MC) IN TO #16.
        IF(HRUN-500) 212,212,213
C          MONTE CARLO
212     CONTINUE
        NPGN=NPR+NPR+2
        HELP(2)=HDATA(NPGN)
C       MCWD=HDATA(NPGN)
C         MCWD BIT;1=UNSMEARED,2=SMEARED AT GENERATION STAGE.
***PMF 26/08/99        ISMR=LAND(IHELP,2)
        ISMR=hLAND(HELP(2),hint(2)) ! PMF 26/90/99 LAND(IHELP,...) replaced by hLAND(HELP(2),hint(...))
C       ISMR=MOD(MCWD,4)
C       IF(ISMR.EQ.2) GO TO 2121
        IF(ISMR.NE.0) GO TO 2121
***PMF 26/08/99        IHELP = LOR(IHELP,4)
        IHELP = hLOR(HELP(2),hint(4))  ! PMF 26/90/99 LOR(IHELP,...) replaced by hLOR(HELP(2),hint(...))
C       HDATA(NPGN)=MCWD+4
        HDATA(NPGN)=HELP(2)
        CALL LGESMR( ADATA(NPCLS+1))
C2121    ISMR=ISHFTR(MCWD,4)
***PMF 26/08/99 2121    ISMR=LAND(IHELP,16)
2121    ISMR=hLAND(HELP(2),hint(16)) ! PMF 26/90/99 LAND(IHELP,...) replaced by hLAND(HELP(2),hint(...))
C         MCWD BIT;16=IF ON, ENERGY LOSS IS IN THE GEN. STAGE.
C       ISMR=MOD(ISMR,2)
        IF(ISMR.EQ.0) GO TO 214
C       HDATA(NPGN)=MCWD+32
        IHELP = LOR(IHELP,32)
        HDATA(NPGN)=HELP(2)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
213   CONTINUE
      IP2  = IDATA(NPCL + 2)
      IPBL = HDATA(2*(NPCL+IP2+N-1)-1)
      IPBL2= HDATA(2*(NPCL+IP2+N-1))
      NRBLOC = IPBL2 - IPBL + 1
C      WRITE(6,1144) NRBLOC
C1144  FORMAT('   LGCDIRNE  NRBLOC =' ,I10)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

C                 ENERGY CORRECTION IS TO BE DONE.
        CALL LGECOR( ADATA(NPCLS+1), DEP, NRBLOC, IFLAG )
214     CALL LGEERR( IPART, ADATA(NPCLS+2), ADATA(NPCLS+3))
C
C
        IF(NVECOR) 22,22,21
C----        SUM UP CORRECTED SHOWER ENERGY
   21   IP = INDEX( IPART+2 )
        ADATA(NPCGI+IP) = ADATA(NPCGI+IP)+ADATA(NPCLS+2)
C
C----        SUM UP GAMMA ENERGY
   22   IF(IDATA(NPCLS+8).NE.0) GO TO 50
C----        COUNT NO.OF GAMMAS
        IDATA(NPCGI+11) = IDATA(NPCGI+11)+1
        IP = INDEX( IPART+2 )+5
        ADATA(NPCGI+IP) = ADATA(NPCGI+IP)+ADATA(NPCLS+2)
C
   50   CONTINUE
C----        CHANGE THE POINTER FOR THE NEXT CLUSTER.
        NPCLS = NPCLS+LSTEP
    1   CONTINUE
C
C---- SUM UP ALL ENERGIES.
      ADATA(NPCGI+7) = ADATA(NPCGI+8)+ADATA(NPCGI+9)+ADATA(NPCGI+10)
      ADATA(NPCGI+12) = ADATA(NPCGI+13)+ADATA(NPCGI+14)+ADATA(NPCGI+15)
      GO TO 100
C
C---- WRONG POINTER
   90 MSGVAL(1) = NPPREC
      MSGVAL(2) = NPR
      MSGVAL(3) = NPCL
      CALL LGMESG( 7, 1)
C
  100 RETURN
      END

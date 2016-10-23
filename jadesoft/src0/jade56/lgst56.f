C   05/12/86 705202135  MEMBER NAME  LGST56   (S)           FORTRAN
      SUBROUTINE LGST56(JBC,PRTCLO,EMEV,AMASS2,LGMDMP)
C
C  COPIED FROM F22YAM.LG.S(LGSTRM) FOR MODIFICATION TO USE IN SF5-SF6
C
CC    S.YAMADA   18-12-78  20:30     COPIED FROM LGSTRC
CC    LAST MODIFICATION     14-06-82   14:25
C
C---- LG SHOWER TRACING BY M.C. TO GENERATE DATA FOR CLUSTER FINDING.
C     CALLED FROM LGMC56
C
C LAST CHANGE  J.OLSSON  5.12.1986   (REINSTALMENT OF LOST VERSION FROM
C                                     23.1.1986)
C
C     ON INPUT, POSITION COMPONENT OF PRTCLO (1-3,2,N) IN UNIT OF MM
C
C
      IMPLICIT INTEGER *2 (H)
C
      DIMENSION PRTCL(3,3,1000),SPTCL(3,3,1000),PRTCLO(9)
      DIMENSION PAQ(9,1000)
      EQUIVALENCE (PAQ(1,1),PRTCL(1,1,1))
      DATA MNP/1000/
C
C  SHOWER MC COMMON
C
      COMMON /CLGD56/ RADIUS(6),ZEND(2),ZWID,ZGAP,PHWID,
     2                ECXLST(24), ECYLST(24),ZECAP(4),ZPV(4),TPV,
     3                TH(4),THECP
C
      COMMON /CMATTR/ IMATTR,IMTLIS(10),XCM(10)
C
      COMMON /CCSF56/ NFINAL,NTR56
C
      COMMON /BCS/ IW(30000)
      DIMENSION HW(1),AW(1)
      EQUIVALENCE(IW(1),HW(1)),(IW(1),AW(1))
C
      COMMON / COLSON/ IPRO
      INTEGER*2 HDATE
      COMMON /TODAY/ HDATE(6)
C
C Z LIMIT OF THE SF6 PART OF THE BARREL  +- 3 ROWS
C    SET LIMIT SO THAT SF5 IS REACHED AFTER 1/3 OF BLOCK DEPTH
C    I.E. 3*106 = 318 AT 1100 + 100 DEPTH:   291.5 AT 1100
C
      DATA SF6LIM / 292./
C
C---- COPY INPUT TRACK
C
        DO 1 K=1,9
    1   PAQ(K,1) = PRTCLO(K)
C
      IF(LGMDMP.GE.3.OR.IPRO.NE.0) WRITE(6,6001) JBC,(PAQ(K,1),K=1,9)
 6001 FORMAT(' JBC,PAQ=',I3,2X,F6.1,F9.1,F6.1,3F8.1,2X,3F9.3)
C
C---- THE UNIT OF AMASS IS MEV/C**2.
C
      IF(IPRO.NE.0) WRITE(6,557) AMASS2
557   FORMAT(' LGST56: AMASS2 ',E12.4)
C
      IF(AMASS2.GT.1.0) GO TO 15
C
C-----ONLY FOR ELECTRONS AND/OR GAMMAS
C-----REMEMBER THE TRACK POSITION AND DIRECTION AND MODIFY THE
C     DIRECTION FOR SHOWER SIMULATION.
C
C
C  USE THE SPECIAL VERSION OF LSCCTL, THAT DOESNOT CHANGE TO X0 UNIT
C
      IF(IPRO.NE.0) WRITE(6,558) JBC
558   FORMAT(' LGST56: JBC AT CALL OF LSCCTL ',I4)
C
      CALL LSCCTL(PAQ(4,1),JBC)
C
      IF(LGMDMP.GT.0.OR.IPRO.NE.0) WRITE(6,6003) JBC,(PAQ(K,1),K=1,9)
 6003 FORMAT(' PAQ AFTER LSCCTL,JBC=',I3,/' ',F5.1,2F9.1,3F9.2,3F9.3)
C
C RADIATION LENGTH XCM IS GIVEN IN UNIT CM
C   START WITH AL-ABSORBER, BOTH FOR BARREL AND ENDCAPS
C
      IMATTR = 1
      XJJ = XCM(IMATTR) * 10.
C
      IF(JBC.NE.0) GO TO 11
C
C#########################################
C-                            --- BARREL PART  -----------------------
C#########################################
C
C
C  IF 1983-86, DETERMINE WHETHER IMPACT IN SF5 OR SF6 PART OF BARREL
C----
C----    PRTCLO  CHARGE      ENERGY(ELMASS)       LENGTH
C----            POS X         POS Y              POS Z      (MM)
C----           DIRCOS        DIRCOS             DIRCOS
C----
        ZTEST = PRTCLO(6)*RADIUS(3)/RADIUS(1)
C
      IMATTS = 2
      IF(HDATE(6).GT.1982.AND.ABS(ZTEST).LT.SF6LIM) IMATTS = 3
C
      IF(IPRO.NE.0) WRITE(6,559) PAQ(6,1),ZEND(1),ZEND(2)
559   FORMAT(' LGST56: PAQ(6,1) ZEND(1-2) ',3E14.6)
C
      IF(PAQ(6,1).GE.ZEND(1) .AND. PAQ(6,1).LE.ZEND(2)) GO TO 16
      JESC = 1
      GO TO 50
C                  IMATTR=1:  ALUMINIUM ABSORBER PART
   16 IMATTR = 1
C  FAR END OF MATERIAL IS GIVEN BY ARGBOU
      ARGBOU = RADIUS(2)/XJJ
C     DUM = BOUNDI(RADSX0(2))
      DUM = BOUNDI(ARGBOU)
      NP = 1
      JBACK = 0
C
C  CASSHW USES RAD. LENGTH FOR THE MATERIAL AS UNIT, CONVERT
C
      PRTCL(1,2,NP) = PRTCL(1,2,NP)/XJJ
      PRTCL(2,2,NP) = PRTCL(2,2,NP)/XJJ
      PRTCL(3,2,NP) = PRTCL(3,2,NP)/XJJ
C
      IF(IPRO.NE.0) WRITE(6,560)
560   FORMAT(' LGST56: CALL CASSHW  1 ')
C
C
      CALL CASSHW(PRTCL,SPTCL,MNP,NP,IER,JBACK)
C
C STORE INFORMATION ON RETURNING PARTICLES IN BOS-BANK SF56
C
      IF(NTR56.GT.NFINAL) GO TO 1200
      IPSF56 = IW(IBLN('SF56'))
      IF(IPSF56.GT.0) IW(IPSF56 + NTR56+1) = NP
C
C   CONVERT  BACK TO UNIT MM FOR ALL RETURNED PARTICLES  (NP)
C
1200  CONTINUE
      DO 5940 IP = 1,NP
      DO 5941 IJ = 1,3
5941  PRTCL(IJ,2,IP) = PRTCL(IJ,2,IP)*XJJ
5940  CONTINUE
C
C---- TRACE THE TRACK BEHIND THE COIL FOR THE BARREL PART.
C---- TH(2) IS THE THICKNESS OF AIRGAP   AL - LEADGLASS
C
C
      IF(IPRO.NE.0) WRITE(6,562) NP,PRTCL(1,2,NP)
562   FORMAT(' LGST56: NP BEHIND AL ',I4,' PRTCL12 ',E12.4)
C
C    TRANSPORT TO FRONT END OF LEADGLASS
C    NOTE BUG IN OLD CODE!      J.O.  24.4.87
C
      NEW =0
        DO 20 N=1,NP
C  SKIP BACKWARD DIRECTED PARTICLES
        IF(PRTCL(1,3,N).LE.0.) GO TO 20
        NEW = NEW+1
C       S = THX0(2)/PRTCL(1,3,N)
C       S = TH(2)/PRTCL(1,3,N)
        S = (RADIUS(3)-PRTCL(1,2,N))/PRTCL(1,3,N)
          DO 21 K=1,3
   21     PRTCL(K,2,NEW) = PRTCL(K,2,N)+PRTCL(K,3,N)*S
        IF(NEW.EQ.N) GO TO 23
          DO 22 K=1,3
          PRTCL(K,1,NEW) = PRTCL(K,1,N)
          PRTCL(K,3,NEW) = PRTCL(K,3,N)
   22     CONTINUE
C----   NEGLECT ESCAPING PARTICLES AT BARREL ENDS
   23   IF(ABS(PRTCL(3,2,NEW)).GT.ZEND(2)) NEW = NEW-1
   20   CONTINUE
      NP0 = NP
      NP = NEW
      IF(IPRO.NE.0) WRITE(6,5622) NP,PAQ(4,NP)
5622  FORMAT(' LGST56: NP BEHIND AL,TRANSPORTED ',I4,' PAQ4 ',E12.4)
      JESC = 0
      IF(NP.EQ.0) JESC = 1
      IF(JESC.NE.0) GO TO 50
C
      IF(LGMDMP.GT.1.OR.IPRO.NE.0)
     $ WRITE(6,6000) NP0,NP,((PAQ(I,K),I=1,9),K=1,NP)
 6000 FORMAT(' NP0,NP=',2I5,/(' ',F5.1,F9.1,F6.1,2X,3F8.1,3F8.3))
      IMATTR = IMATTS
      XJJ = XCM(IMATTR) * 10.
C
      ARGBOU = RADIUS(4)/XJJ
      DUM = BOUNDI(ARGBOU)
C     DUM = BOUNDI(RADSX0(4))
C
      IF(IPRO.NE.0) WRITE(6,561) IMATTR,XJJ,ZTEST,ARGBOU
561   FORMAT(' LGST56: IMATTR AND XJJ ZTEST ARGBOU',I3,3E12.4)
C
C
C   CONVERT  BACK TO UNIT RAD.LENGTH FOR ALL PARTICLES
C
      DO 5943 IP = 1,NP
      DO 5942 IJ = 1,3
5942  PRTCL(IJ,2,IP) = PRTCL(IJ,2,IP)/XJJ
5943  CONTINUE
C
C
      IF(IPRO.NE.0) WRITE(6,572) NP
572   FORMAT(' LGST56: NP CALLING CASSHW 2 ',I4)
C
      IF(IPRO.NE.0)
     $ WRITE(6,6500) ((PAQ(I,K),I=1,9),K=1,NP)
 6500 FORMAT(' ',F5.1,F9.1,F6.1,2X,3F8.1,3F8.3)
      CALL CASSHW( PRTCL,SPTCL, MNP,NP, IER,JBACK)
C
      IF(IPRO.NE.0) WRITE(6,573) IER
573   FORMAT(' LGST56: IER AFTER CALLING CASSHW 2:',I4)
C
      IF(IER) 90,100,90
C
C########################################
C-                           --- END CAP ----------------------------
C########################################
C
C  11 DUM = BOUNDI(ZECAPX(4))
C
   11 ARGBOU = ZPV(4) / XJJ
      DUM = BOUNDI(ARGBOU)
      NP = 1
      JBACK = 0
C
C  CASSHW USES RAD. LENGTH FOR THE MATERIAL AS UNIT, CONVERT
C
      PRTCL(1,2,NP) = PRTCL(1,2,NP)/XJJ
      PRTCL(2,2,NP) = PRTCL(2,2,NP)/XJJ
      PRTCL(3,2,NP) = PRTCL(3,2,NP)/XJJ
C
C
      IF(IPRO.GT.0) WRITE(6,574) NP
574   FORMAT(' LGST56: NP BEFORE CALLING CASSHW 3:',I4)
C
      CALL CASSHW( PRTCL,SPTCL, MNP,NP,IER,JBACK)
C
C   CONVERT  BACK TO UNIT MM FOR ALL RETURNED PARTICLES
C
      DO 5945 IP = 1,NP
      DO 5944 IJ = 1,3
5944  PRTCL(IJ,2,IP) = PRTCL(IJ,2,IP)*XJJ
5945  CONTINUE
C
C---- TRACE THE TRACK BEHIND THE I.C. ENDCAP TILL LG FRONT SURFACE
C      ZECAP(3) IS FRONT END OF +Z ENDCAP LG   ZPV(4) IS BACK END OF AL
C
      NEW =0
C
      IF(IPRO.GT.0) WRITE(6,575) NP
575   FORMAT(' LGST56: NP AFTER AL               :',I4)
C
C   TRANSPORT TO FRONT END OF LEAD GLASS, NOTE BUG IN PREVIOUS CODE
C     CORRECTED 24.4.87   J.O.
C
        DO 30 N=1,NP
        IF(PRTCL(1,3,N).LE.0.) GO TO 30
        NEW = NEW+1
C       S = (ZECAP(3)-ZPV(4))/PRTCL(1,3,N)
        S = (ZECAP(3)-ABS(PRTCL(1,2,N)))/PRTCL(1,3,N)
          DO 31 K=1,3
   31     PRTCL(K,2,NEW) = PRTCL(K,2,N)+PRTCL(K,3,N)*S
        IF(NEW.EQ.N) GO TO 33
          DO 32 K=1,3
          PRTCL(K,1,NEW) = PRTCL(K,1,N)
          PRTCL(K,3,NEW) = PRTCL(K,3,N)
   32     CONTINUE
C----   NEGLECT ESCAPING PARTICLES.
   33   IF(SQRT(PRTCL(2,2,NEW)**2+PRTCL(3,2,NEW)**2).GE.RADIUS(1) )
     $       NEW = NEW - 1
   30   CONTINUE
      NP0 = NP
      NP = NEW
      JESC = 0
      IF(NP.EQ.0) JESC = 1
      IF(JESC.NE.0) GO TO 50
C
      IF(LGMDMP.GT.1.OR.IPRO.GT.0)
     $ WRITE(6,6000) NP0,NP,((PAQ(I,K),I=1,9),K=1,NP)
C
C   SF5 TYPE LEAD GLASS
C
      IMATTR = 2
      XJJ = XCM(IMATTR)*10.
C
      ARGBOU = ZECAP(4)/XJJ
      DUM = BOUNDI(ARGBOU)
C
C   CONVERT  BACK TO UNIT RAD.LENGTH FOR ALL PARTICLES
C
      DO 5947 IP = 1,NP
      DO 5946 IJ = 1,3
5946  PRTCL(IJ,2,IP) = PRTCL(IJ,2,IP)/XJJ
5947  CONTINUE
C
C
      IF(IPRO.GT.0) WRITE(6,576) NP
576   FORMAT(' LGST56: NP BEFORE CALLING CASSHW 5:',I4)
C
      CALL CASSHW( PRTCL,SPTCL, MNP,NP, IER,JBACK)
C
      IF(IPRO.GT.0) WRITE(6,577) IER
577   FORMAT(' LGST56: IER AFTER CALLING CASSHW 5:',I4)
C
C
      IF(IER) 90,100,90
C
C---- CHARGED TRACK PENETRATION THROUGH THE LEAD GLASS
C
   15 CALL LGCHRG( EMEV,AMASS2,PAQ(4,1),JBC, JESC )
C
      IF(JESC) 50,100,50
   50 IF(LGMDMP.GE.3) WRITE(6,6004) JBC,JESC
 6004 FORMAT(' OUT OF DET. JBC=',I4,'   JESC=',I4)
  100 RETURN
C
C---- ERROR IN CASSHW
   90 WRITE(6,690) IER
  690 FORMAT(' *** ERROR IN CASSHW   PRINTED IN LGST56,IER=',I4)
      RETURN
      END

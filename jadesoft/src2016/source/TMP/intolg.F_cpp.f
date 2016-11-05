C   11/03/79 008260241  MEMBER NAME  INTOLG                 FORTRAN
      SUBROUTINE INTOLG(NPCL,HCLMAP,HLGADC,NPPREC)
C
C     S.YAMADA   11-12-78  14:10    COPIED FROM INTOLG(LGSOURCE)
C     LAST MODIFICATION   26-10-79 17:57 BY Y.WATANABE
C      (THE CONNECTED LG# IS WRITTEN INTO THE PATR BANK)
C
C---- CONNECT CALCULATED INNER TRACK CLUSTESTERS TO THE OBSERVED LG.CLUS
C     CHOOSE AT MOST ONE CLUSTER PAR ONE TRACK
C     THE CRITERION IS;MAX OVERLAPPING CLUSTER. IF OVERLAPPING IS EQUAL,
C     CHOOSE THE CLOSEST ONE AMONG THEM.
C
C     NPCL  =THE BOS POINTER TO THE LG-RESULT BANK ('LGCL')
C     NPPREC =THE BOS POINTER TO THE LATEST PATR BANK
C                                GIVEN AS AN ARGUMENT 26/8/80
      IMPLICIT INTEGER *2 (H)
C
C
C     USED IN LGCDIR PART OF ANALYSIS
C     INCREASE UP TO 100 TRACKS ON 20/9/79
      COMMON /CWORK/ NCHCLS,NPOINT,MAPCCL(101),HCLADR(1600),
     $               NCHCL2,HCLIST(4,100),  NCLST2,HCLLSO(4,80)
      DATA NPMAX/1600/
      COMMON /CLGDMS/ X0,RADIUS(6),RADSX0(6),THX0(4),
     $                ZEND(2),ZENDX0(2),ZWID(2),ZGAP(2),PHWID(2),
     $                ZECAP(4),ZECAPX(4),THECPX(2)
C
      COMMON /CLGCHG/ NCHIND,NSTEP,CXDCHG(9,100)
      DIMENSION JBCCHG(9,100)
      EQUIVALENCE (CXDCHG(1,1),JBCCHG(1,1))
C---- CXDCHG  CONTAINS INNER TRACK INFORMATION
C     JBCCHG(1,N)     HITTING PART 0=BARREL, +/-1=+/-Z END CAP
C     CXDCHG(2,N)     CHARGE
C     CXDCHG(3-5,N)   HITTING POSITION ON THE COIL OR ON THE END CAP
C     CXDCHG(6-8,N)   DIRECTION COSIGNS
C     CXDCHG(9,N)     ABSOLUTE MOMENTUM IN GEV/C
C
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
C---- SEE  JADE COMPUTER-NOTE #14.
C     IDATA(NPCLS+1)=JBC, 0 FOR BARREL, -1 FOR BOTTOM, 1 FOR TOP
C     ADATA(NPCLS+2)=CLUSTER ENERGY IN GEV
C     ADATA(NCLST+3)=SIGMA(ENERGY)
C     ADATA(NPCLS+4)=WEIGHTED AVERAGE PHI
C     ADATA(NPCLS+5)=WEIGHTED AVERAGE Z
C     ADATA(NPCLS+6)=SIGMA PHI (WEIGHTED)
C     ADATA(NPCLS+7)=SIGMA Z (WEIGHTED)
C     IDATA(NPCLS+8)=NUMBER OF CORRESPONDING INNER TRACKS
C     ADATA(NPCLS+9-11)=DIRECTION COSIGNS CORRECTED FOR SHOWER DEPTH.
C
      DIMENSION HCLMAP(2,2), HLGADC(2,2)
C
C
      DATA IFLAG/0/
      IF(IFLAG.GT.0) GO TO 5
      IFLAG=1
C     IPTR= IBLN('PATR')
5     CONTINUE
      IF(NCHCLS.LT.1) RETURN
      NPCGI = NPCL+IDATA(NPCL+1)-1
C---- GET NO.OF CLUSTERS
      NCLST = IDATA(NPCGI+3)
      IF(NCLST.LT.1) RETURN
C
      NCHCL2 = NCHCLS
      IF(NCHCL2.GT.100) NCHCL2 = 100
      NCLST2 = NCLST
      LSTEP = IDATA(NPCGI+21)
      NPCL0 = NPCL+IDATA(NPCL+3)-1-LSTEP
      RM=(RADIUS(3)+RADIUS(4))/2.
C     LOCATE PATR BANK AND SET POINTER TO THE WORD. 26-10-79
C     NPTR = IDATA(IPTR)
      NPTR = NPPREC
      LTR=IDATA(NPTR+3)
      NPTR=NPTR+IDATA(NPTR+1)+40 -LTR
C
        DO 100 N=1,NCHCL2
        NPTR=NPTR+LTR
        IDATA(NPTR)=0
        NS = MAPCCL(N)
        NE = MAPCCL(N+1)-1
        MARK=-2
        IF(NS.GT.NE) GO TO 99
        JCHB=JBCCHG(1,N)
        IF(IABS(JCHB).GT.1) GO TO 99
C
C----   GO THROUGH ALL THE OBSERVED CLUSTERS
          NPCLS=NPCL0
          COMAX=0.
          DR2MIN=1.E15
          DO 80 L=1,NCLST
          NPCLS=NPCLS+LSTEP
          LS = HCLMAP(1,L)
          LE = HCLMAP(2,L)
          IF(LE.LT.LS) GO TO 80
C----     COMPARE  ALL THE COMPONENTS OF THE N-TH SIMULATED CLUSTER
C         AND L-TH OBSERVED CLUSTER.
          IF(IDATA(NPCLS+1).NE.JCHB) GO TO 80
C         (CHECK IF IS THE SAME PART OF THE APPARATUS)
            COM=0.
            DO 30 NN=NS,NE
            HADR = HCLADR(NN)
C----       TRY TO FIND HADR AMONG THE OBSERVED CLUSTER COMPONENTS.
              DO 10 LL=LS,LE
              IF(HLGADC(1,LL).EQ.HADR) GO TO 20
10            CONTINUE
              GO TO 30
20          COM=COM+1.
30          CONTINUE
            IF(COM.LE.0.) GO TO 80
          COM=COM/(NE-NS+1)
          IF(HCLIST(1,N).LT.1) GO TO 40
          IF(COM-COMAX) 80,40,70
C
C         THE SAME DEGREE OF OVERLAPP. CHOOSE THE CLOSER ONE
40        IF(JCHB.NE.0) GO TO 50
C         BARREL PART
          PHI=ADATA(NPCLS+4)
          DX=RM*COS(PHI)-CXDCHG(3,N)
          DY=RM*SIN(PHI)-CXDCHG(4,N)
          DR2=DX*DX+DY*DY+(ADATA(NPCLS+5)-CXDCHG(5,N))**2
          GO TO 60
50        DX=ADATA(NPCLS+4)-CXDCHG(3,N)
          DY=ADATA(NPCLS+5)-CXDCHG(4,N)
          DR2=DX*DX+DY*DY
60        IF(DR2.GT.DR2MIN) GO TO 80
          DR2MIN=DR2
70        COMAX=COM
          HCLIST(1,N)=1
          HCLIST(2,N)=L
          IDATA(NPTR)=L
80        CONTINUE
C
C     FILL IN INVERSE LIST
        IF(HCLIST(1,N).LT.1) GO TO 90
        L=HCLIST(2,N)
        LCOM=HCLLSO(1,L)+1
        IF(LCOM.LE.3) HCLLSO(LCOM+1,L)=N
        HCLLSO(1,L)=LCOM
        GO TO 100
C----   IF THERE IS NO MATCHED LG-CLUSTER,MARK IT.
90      MARK = -2
        JSUMC = 0
C----   JSUMC IS THE COUNTER FOR THE EDGE BLOCKS.
          DO 95 NN= NS,NE
          CALL LGCRN2( HCLADR(NN), JSUMC )
95        CONTINUE
        DR2=FLOAT(JSUMC)/(NE-NS+1)
        IF(DR2.GT.0.5) MARK=-1
99      HCLIST( 1,N ) = MARK
100     CONTINUE
      RETURN
      END

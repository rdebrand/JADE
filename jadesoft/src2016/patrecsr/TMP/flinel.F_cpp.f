      SUBROUTINE FLINEL
      IMPLICIT INTEGER*2 (H)
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
      EQUIVALENCE
     ,           (ICELL ,IDWRK(1)),(NHIT  ,IDWRK(2)),(IRING ,IDWRK(3))
     ,         , (IERRCD,IDWRK(4)),(NTRKEL,IDWRK(5))
C----------------------------------------------
C  MACRO CPATLM .... PATTERN RECOGNITION LIMITS
C----------------------------------------------
      COMMON /CPATLM/ PATRLM(5),FLINLM(10),TRELLM(20),ZFITLM(10),BKK(20)
     *               ,XYF(20),IGFP(20),XBKK(40),IADMIN(5),YBKK(20)
      INTEGER IXYF(20),LMPATR(5),LMFLIN(10)
      INTEGER LMTREL(20),LMZFIT(10),IBKK(20)
      DIMENSION GFP(20),IXBKK(40),IYBKK(20)
      EQUIVALENCE (PATRLM(1),LMPATR(1)),(IXBKK(1),XBKK(1)),(IYBKK(1),
     *YBKK(1))   ,(FLINLM(1),LMFLIN(1)),(TRELLM(1),LMTREL(1))
     *           ,(ZFITLM(1),LMZFIT(1)),(BKK(1),IBKK(1))
     *           ,(XYF(1),IXYF(1)),(GFP(1),IGFP(1)),(IADMIN(1),IMCERT)
     *           ,(IYBKK(20),IPPASS),(IADMIN(2),IPFAST)
C----------- END OF MACRO CPATLM --------------
      I9 = HPHL0 + 39
      IP1 = HPHT0
      IP9 = HPHT9
      IPD = HLDHT
      IP8 = IP9 - IPD
      IP7 = IP8 - IPD
      IP  = IP1 - IPD
15000 CONTINUE
      IF(
     - IP.LT.IP7
     -)THEN
      IP = IP + IPD
      IF(
     - IWRK(IP+7).EQ.0
     -)THEN
        ILAY0 = IWRK(IP)
        DS0 = WRK(IP+2)
      ASSIGN 17001 TO IZZZ01
      GOTO 17000
17001 CONTINUE
      ENDIF
      GOTO 15000
      ENDIF
15001 CONTINUE
      ASSIGN 17003 TO IZZZ02
      GOTO 17002
17003 CONTINUE
      RETURN
17000 CONTINUE
        IPHT = IP
        IPA = IP
        IPALST = 0
15002 CONTINUE
      IF(
     - IPA.LT.IP8
     -)THEN
        IPA = IPA + IPD
          IDLAYR = IWRK(IPA) - ILAY0
          DS = WRK(IPA+2)
      IF(
     - IDLAYR.EQ.2
     -)THEN
      IF(
     - IPALST.EQ.0
     -)THEN
              IF(IWRK(IPHT+7).EQ.0) IWRK(IPHT+7) = -1
      GOTO 15003
      ENDIF
            IPHT = IPALST
      IF(
     - IWRK(IPHT+7).GT.0
     -)THEN
      GOTO 15003
      ENDIF
            IPA = IPHT + IPD
            ILAY0 = IWRK(IPHT)
            DS0 = WRK(IPHT+2)
            IDLAYR = IWRK(IPA) - ILAY0
            DS = WRK(IPA+2)
            IPALST = 0
      ENDIF
      IF(
     - IDLAYR.GT.1
     -)THEN
      GOTO 15003
      ENDIF
          DDS = DS-DS0
      IF(
     - ABS(DDS).LT.FLINLM(1)
     -)THEN
      IF(
     - IDLAYR.EQ.1
     -)THEN
      IF(
     - IWRK(IPHT+7).LE.0
     -)THEN
                WRK (IPHT+10) = DDS
                IWRK(IPHT+ 7) = IPA
                IPALST = IPA
      ELSE
                IWRK(IPHT+4) = LOR(IWRK(IPHT+4),32)
      IF(
     - ABS(DDS).LT.ABS(WRK(IPHT+10))
     -)THEN
                  WRK (IPHT+10) = DDS
                  IWRK(IPHT+ 7) = IPA
                  IPALST = IPA
      ENDIF
      ENDIF
      IF(
     - IWRK(IPA+5).EQ.0
     -)THEN
                IWRK(IPA+ 5) = IPHT
                WRK (IPA+ 8) = DDS
      ELSE
                IWRK(IPA +4) = LOR(IWRK(IPA +4), 8)
      IF(
     - ABS(DDS).LT.ABS(WRK(IPA+ 8))
     -)THEN
                  IWRK(IPA+ 5) = IPHT
                  WRK (IPA+ 8) = DDS
      ENDIF
      ENDIF
      ELSE
      IF(
     - IWRK(IPHT+6).EQ.0
     -)THEN
                IWRK(IPHT+ 6) = IPA
                WRK (IPHT+ 9) = DDS
      ELSE
      IF(
     - ABS(DDS).LT.ABS(WRK(IPHT+ 9))
     -)THEN
                  IWRK(IPHT+ 6) = IPA
                  WRK (IPHT+ 9) = DDS
      ENDIF
      ENDIF
      IF(
     - IWRK(IPA+6).EQ.0
     -)THEN
                IWRK(IPA+ 6) = IPHT
                WRK (IPA+ 9) = DDS
      ELSE
      IF(
     - ABS(DDS).LT.ABS(WRK(IPA+ 9))
     -)THEN
                  IWRK(IPA+ 6) = IPHT
                  WRK (IPA+ 9) = DDS
      ENDIF
      ENDIF
      ENDIF
      ENDIF
      GOTO 15002
      ENDIF
15003 CONTINUE
      GOTO IZZZ01
17002 CONTINUE
      IPHT = IP1
16000 CONTINUE
      IF(
     - LAND(IWRK(IPHT+4),40).NE.0
     -)THEN
      ASSIGN 17005 TO IZZZ03
      GOTO 17004
17005 CONTINUE
      ENDIF
      IPHT = IPHT + IPD
      IF(.NOT.(
     - IPHT.GT.IP9
     -))GOTO 16000
16001 CONTINUE
      DO 13000 IPHT = IP1,IP9,IPD
        IPAL = IWRK(IPHT+5)
        IPAH = IWRK(IPHT+7)
        DDS = 100000.
      IF(
     - IPAH.GT.0
     -)THEN
      IF(
     - IPAL.GT.0
     -)THEN
            SL = WRK(IPAH+2) - WRK(IPAL+2)
            DDS= WRK(IPAH+2)+WRK(IPAL+2) - WRK(IPHT+2)*2
            LB = 3
            IF(ABS(DDS).LE.FLINLM(2)) LB = 7
      ELSE
            SL = (WRK(IPAH+2) - WRK(IPHT+2)) * 2
            LB = 2
      ENDIF
      ELSE
          IF(IPAH.LT.0) IWRK(IPHT+7) = 0
      IF(
     - IPAL.GT.0
     -)THEN
            SL = (WRK(IPHT+2) - WRK(IPAL+2)) * 2
            LB = 1
      ELSE
            SL = 0
            LB = 0
      ENDIF
      ENDIF
        IF(IWRK(IPHT+6).NE.0) LB = LOR(LB,16)
        WRK (IPHT+ 3) = SL
        IWRK(IPHT+ 4) = LOR(IWRK(IPHT+4),LB)
        WRK (IPHT+ 8) = 0
        WRK (IPHT+ 9) = 0
        WRK (IPHT+10) = 0
        WRK (IPHT+11) = DDS
13000 CONTINUE
13001 CONTINUE
      DO 13002 IPHT = IP1,IP9,IPD
        IPAL = IWRK(IPHT+5)
        IPAH = IWRK(IPHT+7)
        LB   = IWRK(IPHT+4)
      IF(
     - IPAL.GT.0
     -)THEN
          IPALH = IWRK(IPAL+7)
      IF(
     - IPALH.NE.IPHT
     -)THEN
            LB = LOR(LB, 256)
            IWRK(IPALH+4) = LOR(IWRK(IPALH+4), 512)
            IWRK(IPAL +4) = LOR(IWRK(IPAL +4),1024)
      ENDIF
      ENDIF
      IF(
     - IPAH.GT.0
     -)THEN
          IPAHL = IWRK(IPAH+5)
      IF(
     - IPAHL.NE.IPHT
     -)THEN
            LB = LOR(LB, 256)
            IWRK(IPAHL+4) = LOR(IWRK(IPAHL+4), 512)
            IWRK(IPAH +4) = LOR(IWRK(IPAH +4),1024)
      ENDIF
      ENDIF
        IWRK(IPHT +4) = LB
13002 CONTINUE
13003 CONTINUE
      GOTO IZZZ02
17004 CONTINUE
        IPAL = IWRK(IPHT+5)
        IPAH = IWRK(IPHT+7)
      IF(
     - IPAH.GT.0 .AND. IPAL.GT.0
     -)THEN
        DDS = WRK(IPHT+10) - WRK(IPHT+ 8)
      IF(
     - ABS(DDS).GT.FLINLM(2)
     -)THEN
          ILAY0 = IWRK(IPHT)
          DS0 = WRK(IPHT+2)
          DSLM = 100000.
          IPUP = IPHT
15004 CONTINUE
      IF(
     - IPUP.LT.IP8
     -)THEN
          IPUP = IPUP + IPD
      IF(
     - IWRK(IPUP)-ILAY0.GT.0
     -)THEN
      IF(
     - IWRK(IPUP)-ILAY0.GT.1
     -)THEN
      GOTO 15005
      ENDIF
              SLH = WRK(IPUP+2) - DS0
              IPDW = IPHT
15006 CONTINUE
      IF(
     - IPDW.GT.IP1
     -)THEN
              IPDW = IPDW - IPD
      IF(
     - ILAY0-IWRK(IPDW).GT.0
     -)THEN
      IF(
     - ILAY0-IWRK(IPDW).GT.1
     -)THEN
      GOTO 15007
      ENDIF
                  SLL = DS0 - WRK(IPDW+2)
                  DSL = ABS(SLH-SLL)
      IF(
     - DSL.LT.DSLM
     -)THEN
                    DSLM = DSL
                    IPAL = IPDW
                    IPAH = IPUP
      ENDIF
      ENDIF
      GOTO 15006
      ENDIF
15007 CONTINUE
      ENDIF
      GOTO 15004
      ENDIF
15005 CONTINUE
          IWRK(IPHT+ 5) = IPAL
          IWRK(IPHT+ 7) = IPAH
          WRK (IPHT+ 8) = DS0 - WRK(IPAL+2)
          WRK (IPHT+10) = WRK(IPAH+2) - DS0
          IF(IWRK(IPAL+ 7).LE.0)  WRK(IPAL+10) = WRK(IPHT+ 8)
          IF(IWRK(IPAL+ 7).LE.0) IWRK(IPAL+ 7) = IPHT
          IF(IWRK(IPAH+ 5).LE.0)  WRK(IPAH+ 8) = WRK(IPHT+10)
          IF(IWRK(IPAH+ 5).LE.0) IWRK(IPAH+ 5) = IPHT
          DATA IPR /0/
          IPR = IPR + 1
      ENDIF
      ENDIF
      GOTO IZZZ03
      END
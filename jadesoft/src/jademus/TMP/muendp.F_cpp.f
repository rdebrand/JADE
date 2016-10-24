C   13/10/83 310222221  MEMBER NAME  MUENDP   (JADEMUS)     FORTRAN
C
C LAST CHANGE 22.00 22/10/83 HUGH MCCANN .
C             10.00 14/10/83 HUGH MCCANN .
C
      SUBROUTINE MUENDP(JCEPT,IRONRG,FACSTP)
C
C        THIS ROUTINE ENSURES THAT TRACKS 'SEE' THE REAL THICKNESS
C        OF THE YOKE END PLATES. THEY ARE SET TO BE 340 MM THICK IN
C        MUREG, BUT IN FACT THE THICKNESS VARIES WITH THE DISTANCE
C        FROM THE BEAM LINE AS FOLLOWS :
C        (A)
C                   RADIUS < INNER RADIUS OF COIL , T = 340 MM
C                             ( RCOILI = 968 MM )
C            THIS COINCIDES WITH THE DEFINITION OF'END PLUG' IN MUFFLE
C            AND USES THE SAME FICTITIOUS THICKNESS AS IS USED THERE.
C            ( SEE BLOCK DATA FOR CMUFFL ).
C
C        (B)
C        RCOILI <   RADIUS <   END PLUG COLLAR OUTER RADIUS , T = 290 ;
C                               (  FLOAT(IREP4) = 1400. MM )
C           THIS IS ALSO A FICTITOUS THICKNESS, FOR THE SAME REASON AS
C           ABOVE. THE REAL THICKNESS IS 340 MM. THE POSSIBILITY THAT
C           THE TRACK MIGHT LEAVE THE IRON THRO' THE CYLINDER
C           X**2+Y**2=(COLLAR OUTER RADIUS) IS ALSO TAKEN INTO ACCOUNT.
C
C        (C)
C        1400.  <   RADIUS   , T = 210 MM  .  AT LAST , A REAL THICKNESS
C                                             VIZ. ACTUAL YOKE END PLATE
C
C
      IMPLICIT INTEGER*2 (H)
C
C   20/10/81 408081453  MEMBER NAME  CMUFFL   (S)           FORTRAN
C
C LAST CHANGE 15.00 08/08/84 - CKB PWA     - ADD NALLWM,PMXFLG
C      CHANGE 15.00 03/12/83 - HUGH MCCANN - NEW LEAD GLASS PARAMETERS.
C      CHANGE 08.00 12/10/81 - HUGH MCCANN - TO ADD OVLCUT(FOR OVERLAPS)
C      CHANGE 09.33 17/06/81 - JOHN ALLISON - TO ADD RESOLUTIONS.
C
C-------------START OF MACRO CMUFFL-------------------------------------
C
      COMMON / CMUFFL / XYSTEP,RCOILI,RCOILO,PGMID,WMU,WMUSQ,DUMF1(4),
     +                  NSPECI,XPBAR,XPROT,XPION,XKAON,DUMF2(5),
     +                  TBP,GMBP,ABBP,RDBP,DEBP,
     +                  TJETI,GMJETI,ABJETI,RDJETI,DEJETI,
     +                  TJET1,GMJET1,ABJET1,RDJET1,DEJET1,
     +                  TJET2,GMJET2,ABJET2,RDJET2,DEJET2,
     +                  TJET4,GMJET4,ABJET4,RDJET4,DEJET4,
     +                  TJETO,GMJETO,ABJETO,RDJETO,DEJETO,
     +                  TCOIL,GMCOIL,ABCOIL,RDCOIL,DECOIL,
     +                  ZJETE,TJETE,GMJETE,ABJETE,RDJETE,DEJETE,
     +                  ZEPLG,TEPLG,GMEPLG,ABEPLG,RDEPLG,DEEPLG,
     +                  RLG,ZLG,TLG,GMLG,ABLG,RDLG,DELG,
     +                  ZEP,TEP,GMEP,ABEP,RDEP,DEEP,
     +                  GMG(3),ABG(3),RDG(3),DEG(3),
     +                  VDRES,VLRES,
     +                  REST1,REST2,RESTMX,RESL,RESLMX,FACTOR,OVLCUT,
     +                  ZLGHAF,TLGHAF,ZLGC,GMLGC,ABLGC,RDLGC,DELGC,
     +                  NALLWM,PMXFLG
C
C FOR EXPLANATION SEE BLOCK DATA AFTER SUBROUTINE MUFFLE.
C
C--------------END OF MACRO CMUFFL--------------------------------------
C   20/10/81 202041521  MEMBER NAME  CMUFWORK (JADEMUS)     FORTRAN
C   12/10/81 110152138  MEMBER NAME  CMUFWORK (JADEMUS1)    FORTRAN
C-------------START OF MACRO CMUFWORK-----------------------------------
C LAST CHANGED 21.30 15/10/81 HUGH MCCANN  - EXTEND IOVLAP TO ALLOW
C                                            > 10 ASSOC HITS IN MUFFLY.
C LAST CHANGED 10.00 04/10/81 HUGH MCCANN  - FOR USE OF OVERLAP HITS.
C LAST CHANGED 14.46 17/06/81 JOHN ALLISON - TO ADD 'OVER' VARIABLES.
C LAST CHANGED 23.00 09/04/81 HUGH MCCANN - JADEMUS UPDATE.
C
      COMMON /CWORK/X,Y,Z,DCX,DCY,DCZ,P,PSQ,E,ESQ,D,GM,AB,RD,DE,PPIDK,
     *PKDK,PPBPEN,PPPEN,PPIPEN,PKPEN,DUMW1(29),X8,Y8,Z8,DCX8,DCY8,
     *DCZ8,P8,PSQ8,E8,ESQ8,D8,GM8,AB8,RD8,DE8,PPIDK8,PKDK8,PPBPE8,
     *PPPEN8,PPIPE8,PKPEN8,DUMW28(29),X0,Y0,Z0,DCX0,DCY0,DCZ0,P0,PSQ0,
     *E0,ESQ0,D0,GM0,AB0,RD0,DE0,PPIDK0,PKDK0,PPBPE0,PPPEN0,PPIPE0,
     *PKPEN0,DUMW2(29),X9,Y9,Z9,DCX9,DCY9,DCZ9,P9,PSQ9,E9,ESQ9,D9,GM9,
     *AB9,RD9,DE9,PPIDK9,PKDK9,PPBPE9,PPPEN9,PPIPE9,PKPEN9,DUMW29(29),
C-----200 WORDS UP TO HERE----------------------------------------------
     *X1,Y1,Z1,X2,Y2,Z2,XMID,YMID,ZMID,X3,Y3,Z3,D1,D2,D3,DTC,DUMW3(4),
     *DSTEP,GMSTEP,ABSTEP,RDSTEP,DESTEP,DUMW4(15),ADCZ,COSEC,STPINI,CURV
     *,DANG,DX,DY,DZ,R,RSQ,PT,DPINA,DKNA,DUMW5(7),VX,VY,VZ,RMSXY,RMSZ,
     *VTXYD,VTZD,VTXYAN,VTZANG,VMSANG,VMSD,CMS,DUMW6(8),SDS(10),DUMW7(1000002000
C
C    *SDX,SDY,SDZ,SDTXYD,SDTZD,SDTXYA,SDTZAN,SDMSAN,SDMSD,SDCMS,DM7(10),
C
C NOTE ABOVE CARD SHORTENED TO SDS(10),DUMW7(10), SO THAT STATEMENT DOES
C   NOT EXCEED 19 CONTINUATION CARDS.  I THINK SD--'S ARE NOT USED.
     *),CHISQT,NDFT,CHIPRT,CHISTL,NDFTL,CHIPTL,NBADCH,DUMW8(13),IDTRK,
     *NCEPTS,NTHIS,INEFF,NHLAYR,INFLAG,NELIPS,NGLAYR,DUMW9(72),IREG(200)
C-----600 WORDS UP TO HERE----------------------------------------------
     *,RDOTD(200),CINT(3,200),NFLAG(200),ITEM(200),EM(30,30),DALONG(10),
C-----2710 WORDS UP TO HERE---------------------------------------------
     *DEV(30),VXYDA(10),VZDA(10),CXYA(10),CZA(10),INCUT(30),BADA(30),G(200003100
     *0,20),DEVA(20),IPERM(10),MWORK(20),ITHISA(10),IJA(10),EM1(20,20),E
     *MG(20,20),ELIPSE(700),INCHAM(10),INREG(10),IAPPRO(30),HBADCH(1000)
     *,CTDASH(10),CLDASH(10),VTDASH(10),VLDASH(10),IHTREG(20),LAYRAB,IEF
C-----5421 WORDS UP TO HERE---------------------------------------------
     *FRG(10),DUMW10(69),AAA(10),BBB(10),CCC(10),DDD(10),DOVER,GMOVER,AB
     *OVER,RDOVER,DEOVER,DUMW11(55),X7(50),IHTP(30),IOVLAP(20,20)
C-----6080 WORDS UP TO HERE---------------------------------------------
      DIMENSION ILIPSE(700)
      INTEGER*2 HLIPSE(1400)
      DIMENSION IHTPER(10),IHTEMP(10),IPTEMP(10)
      EQUIVALENCE (ILIPSE(1),HLIPSE(1),ELIPSE(1))
      EQUIVALENCE (IHTP(1) ,IHTPER(1)),
     *            (IHTP(11),IHTEMP(1)),
     *            (IHTP(21),IPTEMP(1))
      LOGICAL INCUT,BADA
C
C-----------------------------------------------------------------------
C
C THE FIRST 50 LOCATIONS ARE RESERVED FOR SPECIAL WORKING VARIABLES.
C THE NEXT 150 LOCATIONS ARE RESERVED FOR COPIES OF THESE SPECIAL
C    VARIABLES, IF, E.G., ONE WISHES TO PRESERVE THEIR VALUES AT
C    THE BEGINNING OF A STEP.
C THE COPIES HAVE A SUFFIX 0 FOR VALUES AT LAST ASSOCIATED HIT.
C THE COPIES HAVE A SUFFIX 7 FOR VALUES AFTER LEAD-GLASS BARREL OR
C    YOKE END-PLUG (X7 IS LATER IN COMMON - SEE BELOW).
C THE COPIES HAVE A SUFFIX 8 FOR VALUES AT LAST BUT ONE GOOD
C    CHAMBER LAYER.
C THE COPIES HAVE A SUFFIX 9 FOR VALUES AT LAST GOOD CHAMBER LAYER.
C NSPECI (SET IN BLOCK DATA BEHIND MUFFLE) IS THE NUMBER OF SUCH
C    VARIABLES ACTUALLY USED.
C
C SPECIAL VARIABLES....
C
C X,Y,Z       = CURRENT COORDINATES.
C DCX,DCY,DCZ = CURRENT DIRECTION COSINES OF TRACK.
C P,PSQ       = CURRENT MOMENTUM (AND ITS SQUARE).
C E,ESQ       = CURRENT ENERGY (AND ITS SQUARE).
C D           = CURRENT DISTANCE FROM VERTEX (MM).
C GM          = MATERIAL TRAVERSED TO CURRENT POSITION (GM CM**-2).
C AB          = ABSORPTION LENGTHS SO FAR.
C RD          = RADIATION LENGTHS SO FAR.
C DE          = ENERGY LOSS (GEV).
C PPIDK       = PROBABILITY OF PION DECAYING TO MUON BEFORE INTERACTING.
C PKDK        = PROBABILITY OF KAON DECAYING TO MUON BEFORE INTERACTING.
C PPBPEN      = ANTI-PROTON ) ( PENETRATION PROBABILITY, I.E. PROBAB-
C PPPEN       = PROTON      ) ( ILITY OF NOT BEING ABSORBED BY A NUCLEUS
C PPIPEN      = PI          ) ( AND NOT DECAYING.  SEE SUBROUTINE
C PKPEN       = K           ) ( MUFFLS FOR FURTHER DETAILS.
C
C-----------------------------------------------------------------------
C
C THE NEXT 200 LOCATIONS ARE RESERVED FOR VARIABLES THAT DO NOT NEED
C    SPECIAL PRESERVATION.
C
C OTHER VARIABLES...
C
C X1,Y1,Z1    = COORDS OF 1ST POINT ON TRACK.
C X2,Y2,Z2    = COORDS OF LAST POINT ON TRACK.
C XMID,YMID,ZMID = COORDS OF MID POINT ON TRACK.
C X3,Y3,Z3    = COORDS OF POINT WHERE TRACK LEAVES MAGNETIC FIELD.
C D1          = DISTANCE TRAVELLED TO (X1,Y1,Z1).
C D2          = DISTANCE TRAVELLED TO (X2,Y2,Z2).
C D3          = DISTANCE TRAVELLED TO (X3,Y3,Z3).
C DTC         = DISTANCE TRAVELLED TO MID-POINT OF TRACK.
C
C DSTEP       = STEP LENGTH THIS STEP (FOR MUFFLU) (MM).
C GMSTEP      = MATERIAL THIS STEP (GM CM**-2).
C ABSTEP      = ABSORPTION LENGTHS THIS STEP.
C RDSTEP      = RADIATION LENGTHS THIS STEP.
C DESTEP      = ENERGY LOSS OF MINIMUM IONISING PARTICLE THIS STEP,
C
C ADCZ        = ABS(DCZ)
C COSEC       = ABS(COSEC(THETA)), WHERE THETA IS ANGLE TO BEAM.
C STPINI      = STEP LENGTH IN INITIAL TRACKING TO COIL OR END PLUG.
C CURV        = CURVATURE FROM 'PATR' BANK.
C DANG        = ANGLE OF TURN FOR EACH STEP.
C DX,DY,DZ    = CHANGES OF X,Y,Z.
C R,RSQ       = DISTANCE FROM BEAM (RADIUS) AND ITS SQUARE.
C PT          = MOMENTUM COMPONENT PERPENDICULAR TO BEAM.
C DPINA       = INTEGRAL OF (DECAY LENGTH)*(PROBABILTY OF NOT INTER-
C                 ACTING) FOR PION. (NO LONGER USED. CAN BE RESURECTED
C DKNA        = SIMILARLY FOR KAON. (BY UN-COMMENTING IN MUFFLS.
C
C VX,VY,VZ    = CURRENT VARIANCES ON X,Y,Z.
C RMSXY       = RMS DEV. NORMAL TO CHORD IN XY FIT.     )
C RMSZ        = RMS Z DEV. IN RZ FIT.                   ) FROM
C VTXYD       = VARIANCE ON DEVIATION NORMAL TO         ) TRACK
C                 TRACK IN XY PLANE AT TRACK CENTRE.    ) RECON-
C VTZD        = VARIANCE ON DEVIATION NORMAL TO         ) STRUCTION
C                 TRACK IN RZ PLANE AT TRACK CENTRE.    ) ERRORS.
C VTXYAN      = VARIANCE ON ANGLE IN XY PLANE (PHI)     )
C VTZANG      = VARIANCE ON ANGLE IN RZ PLANE (THETA)   )
C VMSANG      = VARIANCE OF MULTIPLE SCATTERING ANGLE.
C VMSD        = VARIANCE OF MULTIPLE SCATTERING DEVIATION NORMAL TO
C                 TRACK.
C CMS         = COVARIANCE OF ABOVE TWO QUANTITIES.
C SD--        = CORRESPONDING STANDARD DEVIATIONS (SQUARE ROOTS).
C
C CHISQT      = CHI-SQUARED OF DEVIATION OF HITS FROM   ) FOR
C                 PROJECTED TRACK.                      ) TRANSVERSE
C NDFT        = NUMBER OF DEGREES OF FREEDOM.           ) (DRIFT)
C CHIPRT      = CHI-SQUARED PROBABILITY.                ) COORDS.
C
C CHISTL      = CHI-SQUARED OF DEVIATION OF HITS FROM   ) FOR
C                 PROJECTED TRACK.                      ) TRANSVERSE
C NDFTL       = NUMBER OF DEGREES OF FREEDOM.           ) & LONG'L
C CHIPTL      = CHI-SQUARED PROBABILITY.                ) COORDS.
C
C NBADCH      = NO. OF BAD CHAMBERS (AS DEFINED BY HMCSTA).
C
C IDTRK       = INNER DETECTOR TRACK NUMBER.
C NCEPTS      = NUMBER OF INTERCEPTS FOUND BY MUREGY.
C NTHIS       = NUMBER OF MUON HITS ASSOCIATED WITH PROJECTED INNER
C                DETECTOR TRACK.
C INEFF       = NUMBER OF INEFFICIENCIES IN MUON SYSTEM FOUND THIS TRACK
C NHLAYR      = NUMBER WHICH REPRESENTS NUMBER OF MUON LAYERS WITH
C                ASSOCIATED MUON HITS. ADD 1 FOR THE INNER LAYER AND
C                2 FOR EACH SUBSEQUENT LAYER.
C INFLAG      = 1 IF LAST LAYER INTERCEPTED WAS INEFFICIENT.
C NELIPS      = NUMBER OF MULTIPLE SCATTERING ELIPSES ENTERED IN ELIPSE.
C NGLAYR      = AS NHLAYR, BUT FOR 'GOOD' LAYERS WHETHER THERE WAS AN
C                ASSOCIATED HIT OR NOT.
C
C-----------------------------------------------------------------------
C
C THE NEXT 1400 LOCATIONS USED BY MUREGY (CALCULATES REGION INTERCEPTS).
C
C IREG        = REGION NUMBER.                           )(IN PAIRS,I.E.
C RDOTD       = R.DOT.(DIR. COSINES) FOR EACH INTERCEPT. )( 2 INTERCEPTS
C CINT        = X,Y,Z COORDINATES OF EACH INTERCEPT.     )( PER REGION.
C NFLAG       = USED INTERNALLY BY MUREGY.
C ITEM        = USED INTERNALLY BY MUREGY.
C
C-----------------------------------------------------------------------
C
C THE NEXT 3600 LOCATIONS USED BY MUFFLE, ETC., TO ACCUMULATE
C   QUANTITIES NEEDED FOR CALCULATING CHI-SQUARED. IN THE DESCRIPTION
C   BELOW I,J GO AS FOLLOWS..
C     1   LEFT DRIFT COORDINATE    )  OF 1ST
C     2   RIGHT DRIFT COORDINATE   )  ASSOCIATED
C     3   LONGITUDINAL COORDINATE  )  HIT
C     4    ETC. FOR NEXT ASSOCIATED HIT.
C   K REFERS TO K'TH ASSOCIATED HIT.
C
C EM(I,J)     = 'ERROR MATRIX', I.E. VARIANCE (I=J) OR COVARIANCE (I.NE.
C                J) FOR COORDINATE I,J.
C DALONG(K)   = DISTANCE OF ASSOCIATED HIT K ALONG TRACK.
C DEV(I)      = DEVIATION OF COORDINATE I FROM EXTRAPOLATED INNER
C                DETECTOR TRACK.
C VXYDA(K)    = VARIANCE ON DEVIATION IN XY PLANE FOR HIT K.
C VZDA(K)     = VARIANCE ON DEVIATION IN RZ PLANE FOR HIT K.
C CXYA(K)     = COVARIANCE BETWEEN DEVIATION AND ANGLE IN XY PLANE.
C CZA(K)      = COVARIANCE BETWEEN DEVIATION AND ANGLE IN RZ PLANE.
C INCUT(I)    = .TRUE. IF COORDINATE I IS IN CUT (SEE MUFFLY).
C BADA(I)     = .TRUE. IF COORDINATE I IS BAD.
C G           = INVERSE ERROR MATRIX.
C DEVA        = CORRESPONDING DEVIATIONS.
C IPERM(K)    = USED TO PERMUTE LEFT/RIGHT AMBIGUITIES.
C MWORK       = USED BY MATRIX INVERTING ROUTINE AS WORKING SPACE.
C ITHISA(K)   = HIT NUMBER OF K'TH ASSOCIATED HIT.
C IJA(K)      = INDEX FOR K'TH ASSOCIATED HIT FOR ENTRY IN BANKS 2 & 3.
C EM1         = COPY OF RELEVANT PART OF ERROR MATRIX FOR TEST PURPOSES.
C EMG         = PRODUCT OF ERROR MATRIX AND ITS INVERSE. SHOULD BE UNIT
C                MATRIX. USED FOR TEST PURPOSES.
C ELIPSE      = TEMPORARY STORAGE FOR MULTIPLE SCATTERING ELIPSES.
C INCHAM      = LIST OF INEFFICIENT CHAMBERS ON THIS TRACK.
C INREG       = LIST OF INEFFICIENT REGIONS (PLANES) ON THIS TRACK.
C IAPPRO      = USED AS WORKING SPACE IN MUFFLX.
C HBADCH      = LIST OF BAD CHAMBERS (AS DEFINED BY HMCSTA).
C CTDASH(K)   = TRANSVERSE COORD. ESTIMATED FROM I.D. PROJECTION.
C CLDASH(K)   = LONGITUD'L COORD. ESTIMATED FROM I.D. PROJECTION.
C VTDASH(K)   = VARIANCE ON CTDASH.
C VLDASH(K)   = VARIANCE ON CLDASH (FOR K'TH ASSOCIATED HIT).
C
C-----------------------------------------------------------------------
C
C THE NEXT  380 LOCATIONS USED FOR VARIOUS IMPROVEMENTS TO MUFFLE, ETC.
C
C IHTREG      = FOR EACH ASSOCIATED HIT, THE REGION NO. IN WHICH
C               THE HIT OCCURS.
C LAYRAB      = ABSOLUTE NO. OF LAYERS WHICH HAVE ASSOCIATED HITS.
C IEFFRG      = LIST OF REGION NOS. OF THOSE REGIONS WHICH HAVE AN
C               ASSOCIATED HIT.
C   IHTPER = FLAG FOR EACH ASSOCIATED HIT TO TELL IF IT'S TO
C            GO FORWARD INTO THE CHI**2 CALCULATION . ONLY ONE
C            HIT PER LAYER IS TO BE USED ,APART FROM OVERLAP HITS.
C   IHTEMP = LIST OF HITS WHICH ARE TEMPORARILY IN THE HIT PERMUTATION
C            DUE TO OVERLAPS WITH THE CURRENT AMBIGUITYOF ONE OF THE
C            HITS IN IHTPER.
C   IPTEMP =  AS IHTEMP, BUT FOR L/R AMBIGUITIES.
C IOVLAP   =  MATRIX OF OVERLAP HITS. IOVLAP(I,J)=1 MEANS THAT THERE
C             IS AN OVERLAP BETWEEN ASSOCIATED HITS I & J ( I & J BOTH
C             IN THE RANGE 1 TO NTHIS ).
C AAA(K)      = TRANSFORMATION COEFF. A FOR K'TH ASSOCD. HIT.
C BBB(K)      = TRANSFORMATION COEFF. B FOR K'TH ASSOCD. HIT.
C CCC(K)      = TRANSFORMATION COEFF. C FOR K'TH ASSOCD. HIT.
C DDD(K)      = TRANSFORMATION COEFF. D FOR K'TH ASSOCD. HIT.
C
C DOVER, ETC. = STORES QUANTITIES LEFT OVER AFTER LEAVING LAST ABSORBER.
C
C X7          = VALUES OF SPECIAL VARIABLES AFTER LEAD-GLASS BARREL OR
C               YOKE END-PLUG - USED FOR RE-FITTING, ETC.
C
C-------------END OF MACRO CMUFWORK-------------------------------------
C------------START OF MACRO CMUREG--------------------------------------
C
      COMMON /CMUREG/NREGS,XRLO(100),XRHI(100),YRLO(100),YRHI(100),
     * ZRLO(100),ZRHI(100),HRMASK(100),HRFACE(100),HRTYPE(100),
     * HRORI(100),HRFIRS(100),HRLAST(100)
C
C NREGS IS NUMBER OF REGIONS.
C XRLO ETC. ARE REGION BOUNDARIES.
C HRMASK =1 (FACE 1), =2 (FACE 2), =4 (FACE 3), =8 (FACE 4), ETC.
C HRFACE = FACE NUMBER, =1-6 FOR -X,+X,-Y,+Y,-Z,+Z.
C HRTYPE =1, MU CHAMBER SENSITIVE REGION,
C        =2, CONCRETE REGION,
C        =3, IRON REGION,
C        =4, LEAD GLASS. (IRTYPE=4 USED ONLY IN MUFFLD.)
C HRORI  = ORIENTATION OF NORMAL, =1 (|| X), =2 (||Y), =3 (|| Z).
C HRFIRS = FIRST CHAMBER NUMBER.
C HRLAST = LAST CHAMBER NUMBER.
C
C------------END OF MACRO CMUREG----------------------------------------
C
C
C
C
C
C=======================<< MACRO CMUCALIB >>============================
C
C LAST CHANGE  25/09/79  13.20 UHR   HARRISON PROSPER
C
C BANK NAMES, NUMBERS AND LENGTHS
C
C  NAME/NUMBER LENGTH  CONTENTS
C  MUCD   0      16    VERSION NUMBER AND DESCRIPTION.
C  MUOV   0       3    OVERALL JADE UNIT TRANSLATIONS.
C  MFFI   2     370    FIXED FRAME PARAMETERS.
C  MCFI   3     318    FIXED CHAMBER PARAMETERS.
C  MFSU   4     246    'SURVEY' FRAME PARAMETERS.
C  MCSU   5     634    'SURVEY' CHAMBER PARAMETERS.
C  MCEL   6    2220    'ELECTRONIC' CHAMBER PARAMETERS.
C  MCST   7     317    CHAMBER STATUS WORDS.
C  MUFI   8      36    FILTER (ABSORBER BLOCK) PARAMETERS.
C  MUYO   9      10    SIDE, TOP AND BOTTOM YOKE PARAMETERS.
C  MUEN  10      15    YOKE END-PLUG PARAMETERS.
C
C TOTAL LENGTH 4185 WORDS.
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      COMMON /CALIBR/ LARRY(100),MUCAL(4185)
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C
C               NVERSN
      DIMENSION DESCRP(15),HOVALL(6)
C                                                    19 WORDS
C
      EQUIVALENCE ( NVERSN,MUCAL(1) ),( DESCRP(1),MUCAL(2) ),
     *            ( HOVALL(1),MUCAL(17) )
C----------------------------------------------------19 WORDS SO FAR
C
C     HMFFIX(740)                                   370 WORDS
      DIMENSION HMFFIX(740)
      EQUIVALENCE ( HMFFIX(1),MUCAL(20) )
      DIMENSION HFACE(82),HSECT(82),HLAYER(82),HNORM(82),HLONG(82),
     *          HTRANS(82),HAC(82),HAL(82),HUNIT(82)
      EQUIVALENCE (HMFFIX(1),NFRAMS),(HMFFIX(3),HFACE(1)),
     *            (HMFFIX(85),HSECT(1)),(HMFFIX(167),HLAYER(1)),
     *            (HMFFIX(249),HNORM(1)),(HMFFIX(331),HLONG(1)),
     *            (HMFFIX(413),HTRANS(1)),(HMFFIX(495),HAC(1)),
     *            (HMFFIX(577),HAL(1)),(HMFFIX(659),HUNIT(1))
C---------------------------------------------------389 WORDS SO FAR
C
C
C     HMCFIX(636)                                   318 WORDS
      DIMENSION HMCFIX(636)
      EQUIVALENCE ( HMCFIX(1),MUCAL(390) )
      DIMENSION HFR(634)
      EQUIVALENCE (HMCFIX(1),NCHAMS),(HMCFIX(3),HFR(1))
C---------------------------------------------------707 WORDS SO FAR
C
C     HMFSUR(492)                                   246 WORDS
      DIMENSION HMFSUR(492)
      EQUIVALENCE ( HMFSUR(1),MUCAL(708) )
      DIMENSION HDIST(82),HANG(82),HCLLO(82),HCLHI(82),HCTLO(82),
     *          HCTHI(82)
      EQUIVALENCE (HMFSUR(1),HDIST(1)),(HMFSUR(83),HANG(1)),
     *            (HMFSUR(165),HCLLO(1)),(HMFSUR(247),HCLHI(1)),
     *            (HMFSUR(329),HCTLO(1)),(HMFSUR(411),HCTHI(1))
C---------------------------------------------------953 WORDS SO FAR
C
C
C     HMCSUR(1268)                                  634 WORDS
      DIMENSION HMCSUR(1268)
      EQUIVALENCE ( HMCSUR(1),MUCAL(954) )
      DIMENSION HD1(634),HCTW(634)
      EQUIVALENCE (HMCSUR(1),HCTW(1)),(HMCSUR(635),HD1(1))
C--------------------------------------------------1587 WORDS SO FAR
C
C
C     HMCELE(4440)                                 2220 WORDS
      DIMENSION HMCELE(4440)
      EQUIVALENCE ( HMCELE(1),MUCAL(1588) )
      DIMENSION HDTP(634),HLTP(634),HLSF(4,634),HVDRFT(634)
      EQUIVALENCE (HMCELE(1),HVDR),(HMCELE(2),HDTP(1)),
     *            (HMCELE(636),HLTP(1)),(HMCELE(1270),HLSF(1,1)),
     *            (HMCELE(3806),HMCEDM),(HMCELE(3807),HVDRFT(1))
C--------------------------------------------------3807 WORDS SO FAR
C
C
C     HMCSTA(634)                                   317 WORDS
      DIMENSION HMCSTA(634)
      EQUIVALENCE ( HMCSTA(1),MUCAL(3808) )
C--------------------------------------------------4124 WORDS SO FAR
C
C
C     HFILDA(72)                                     36 WORDS
      DIMENSION HFILDA(72)
      EQUIVALENCE ( HFILDA(1),MUCAL(4125) )
      INTEGER*2 HBLLO(6),HBLHI(6),HBTLO(6),HBTHI(6),HBNLIM(36)
      INTEGER*4 IFCIND(6)
      INTEGER*2 HFILDA
      EQUIVALENCE (HBLLO(1),HFILDA(1)),(HBLHI(1),HFILDA(7)),
     *            (HBTLO(1),HFILDA(13)),(HBTHI(1),HFILDA(19)),
     *            (HBNLIM(1),HFILDA(25)),(IFCIND(1),HFILDA(61))
C--------------------------------------------------4160 WORDS SO FAR
C
C
C     HYKNMI(4),HYKNMO(4),HYKLDM(4),HYKTDM(4),BYOKE, 10 WORDS
C     IYKIND
      DIMENSION HYKNMI(4),HYKNMO(4),HYKLDM(4),HYKTDM(4)
      INTEGER*2 HYKTDM,HYKLDM,HYKNMI,HYKNMO
      EQUIVALENCE ( HYKNMI(1),MUCAL(4161) ),
     *            ( HYKNMO(1),MUCAL(4163) ),
     *            ( HYKLDM(1),MUCAL(4165) ),
     *            ( HYKTDM(1),MUCAL(4167) ),
     *            ( BYOKE,MUCAL(4169) ),( IYKIND,MUCAL(4170) )
C--------------------------------------------------4170 WORDS SO FAR
C
C
C    IZEII,IZEIO,IREP1,IREP2,IREP3,IREP4,IXYEP5,     15 WORDS
C    IZOEP1,IZOEP2,IZOEP3,IZOEP4,IZOEP5,CAEP2,
C    IEPIND,IEPSCT
C
      EQUIVALENCE ( IZEII,MUCAL(4171) ),( IZEIO,MUCAL(4172) ),
     *            ( IREP1,MUCAL(4173) ),( IREP2,MUCAL(4174) ),
     *            ( IREP3,MUCAL(4175) ),( IREP4,MUCAL(4176) ),
     *            ( IXYEP5,MUCAL(4177) ),( IZOEP1,MUCAL(4178) ),
     *            ( IZOEP2,MUCAL(4179) ),( IZOEP3,MUCAL(4180) ),
     *            ( IZOEP4,MUCAL(4181) ),( IZOEP5,MUCAL(4182) ),
     *            ( CAEP2,MUCAL(4183) ),( IEPIND,MUCAL(4184) ),
     *            ( IEPSCT,MUCAL(4185) )
C--------------------------------------------------4185 WORDS SO FAR
C
C=======================<< MACRO CMUCALIB >>============================
C
C
C
C
C
      DATA THICK/290./
      COLLAR=FLOAT(IREP4)
      ZLIMEP=FLOAT(IZOEP5)
C
      FACSTP=1.
      ZENTER=ZRLO(IRONRG)
      IF(HRFACE(IRONRG).EQ.5)  ZENTER=ABS(ZRHI(IRONRG))
C
C       IF THE CURRENT STEP BRINGS THE TOTAL Z TRAVERSAL OF THE END
C       PLATE TO LESS THAN THE SMALLEST THICKNESS ( THE OUTER LIMIT OF
C       WHICH IS ZLIMEP ) , THEN NO MODIFICATION OF THE STEP
C       IS NEEDED.  I.E. GO TO 100 WITH FACSTP = 1.   .
C
      IF(  ABS(CINT(3,JCEPT)).LT.ZLIMEP  )   GO TO 100
C
C              CHECK THAT THE STARTING POINT OF THE STEP IS IN IRON.
           RSTART=SQRT( X**2 + Y**2 )
           IF( RSTART.LT.RCOILI )  GO TO 20
               IF( RSTART.GT.COLLAR )  GO TO 10
C                    IN THE COLLAR REGION.
                   IF( ABS(Z).LT.(ZENTER+THICK) )  GO TO 20
                       FACSTP=0.
                       GO TO 100
C                   BARE END PLATE REGION.
   10          IF( ABS(Z).LT.ZLIMEP )  GO TO 20
                   FACSTP=0.
                   GO TO 100
C
C               THE STARTING POINT IS IN IRON.  NOW CHECK END POINT.
   20      REND=SQRT(   CINT(1,JCEPT)**2  +  CINT(2,JCEPT)**2   )
           IF( REND.LT.RCOILI )  GO TO 100
C                 DISTANCE ALONG TRACK FROM CURRENT POSITION (X,Y,Z)
C                 TO EXIT FROM THE IRON IS ESTEP.
C                 IF DSTEP </= ESTEP , NO MODIFICATION NEEDED.
               IF( REND.GT.COLLAR )  GO TO 40
                  ESTEP= (ZENTER+THICK-ABS(Z))/ABS(DCZ)
                  GO TO 80
   40          ESTEP= (ZLIMEP-ABS(Z))/ABS(DCZ)
C                 IT IS POSSIBLE THAT THE TRACK WILL ACTUALLY LEAVE
C                 THE IRON THRO' THE CYLINDER X**2 + Y**2 = COLLAR.
               CSTEP=COLLAR/SQRT(1.00001-DCZ**2) - SQRT(X**2+Y**2+Z**2)
               IF(CSTEP.GT.ESTEP)  ESTEP=CSTEP
C
   80          IF( ESTEP.LT.DSTEP )  FACSTP=ESTEP/DSTEP
C
  100 RETURN
      END
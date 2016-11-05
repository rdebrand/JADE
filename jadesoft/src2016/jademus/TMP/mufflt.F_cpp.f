C   22/10/83 805261726  MEMBER NAME  MUFFLT   (JADEMUS)     FORTRAN
C
C LAST CHANGE  9.40 14/04/88 J. HAGEMANN - CORRECT CALC. OF EXTR. ERRORS
C      CHANGE 22.00 22/10/83 HUGH MCCANN - PARALLEL MUFFLY CHANGES.
C      CHANGE 03.10 14/07/83 HUGH MCCANN - VARIOUS CHANGES.
C      CHANGE 18.27 16/03/82 CHRIS BOWDERY- FOR THE 'LET-OFF' TEST
C      CHANGE 14.50 08/02/82 HUGH MCCANN  - KDEPTH LIMIT INCREASED TO 4.
C      CHANGE 17.20 23/09/81 CHRIS BOWDERY- REMOVE RESL * REST FROM
C                                           'LET OFF' TEST. KILLS BUG.
C      CHANGE 15.07 04/08/81 CHRIS BOWDERY- INCLUDE Z EDGE TEST AGAIN
C-----------------------------------------------------------------------
      SUBROUTINE MUFFLT
C-----------------------------------------------------------------------
C
C MUFFLT TAKES THE REFITTED TRACK AND TRACKS IT THROUGH THE FILTER AGAIN
C LOOKING FOR INEFFICIENCIES. REGIONS WILL BE 'LET OFF' IF THE TRACK DID
C NOT PASS THROUGH THE ACTIVE PART OF THE REGION , IF THE TRACK COULD
C HAVE SCATTERED INTO A DEAD CHAMBER OR SCATTERED OUT OF THE ACTIVE AREA
C
C-----------------------------------------------------------------------
C
C NCEPTS  IS THE NUMBER OF INTERCEPTS FOUND BY MUREGY.
C INEFF   IS NO. OF TIMES A HIT WAS NOT FOUND AND THERE WAS NO
C           DEAD CHAMBER TO EXPLAIN ITS ABSENCE.
C NHLAYR  IS RELATED TO THE NO. OF LAYERS WITH HITS WHICH ARE
C           ASSOCIATED WITH THIS TRACK.
C NGLAYR  IS AS NHLAYR - BUT APPLIES TO ALL INTERCEPTED LAYERS WHETHER
C           THEY HAD A HIT OR NOT.
C INFLAG  IS SET = 1 IF AN INEFFICIENCY IS FOUND, AND SET = 0 IF A HIT
C           IS FOUND WITHIN CUTS.  SO IF IT IS STILL 1 WHEN THIS ROUTINE
C           HAS FINISHED IT MEANS THERE WAS AN INEFFICIENCY IN THE LAST
C           LAYER INTERCEPTED.
C
C-----------------------------------------------------------------------
C
      IMPLICIT INTEGER*2 (H)
C
      LOGICAL LETDCE,LCOVAR
C
C             COMMONS AND ARRAY DECLARATIONS
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
      COMMON /CMUIEV/ IEV,NEV,IRD,KRUN,KREC,
     +                ISECS,IMINS,IHOURS,IDAY,IMONTH,IYEAR
      COMMON /CMULOC/ ALLDEV(12,2),ALLABS(12),REGDEV(30),REGDCE(60),
     +                REGZE(60),LOCHRS(60),ABLOCH(60)
      COMMON /CMUPTC/ XEXTRP,YEXTRP,ZEXTRP,VTZCV,LCOVAR
C
      DIMENSION KTYPE(4),KREGN(4)
C
C             CHAMBER RESOLUTIONS PICKED UP FROM /CMUFFL/.
C
C-----------------------------------------------------------------------
C
C             START OF EXECUTABLE STATEMENTS.
C
      IF(NCEPTS.LE.0) RETURN
C
C             SET KDEPTH, WHICH RECORDS HOW MANY REGIONS ONE IS IN
C             AT ANY ONE TIME. NORMALLY THIS IS 0 OR 1 BUT CAN BE
C             UP TO 4 BECAUSE CHAMBER REGIONS ARE ARTIFICIALLY
C             EXTENDED IN MUREG AND CAN THEREFORE OVERLAP.
C
      KDEPTH=0
C
C             CLEAR THE ARRAY STORING THE START AND STOP POSITIONS
C             OF DEAD CHAMBERS AND REGION EDGES USED IN 'LET-OFFS'
C
      CALL VZERO(REGDCE,60)
      CALL VZERO(REGZE,60)
      IDCEP = 1
      IZEP  = 1
C
C-----------------------------------------------------------------------
C START OF MAIN LOOP ---------------------------------------------------
C-----------------------------------------------------------------------
C
C                  LOOK THROUGH INTERCEPTS.
C
      DO 1000  ICEPT = 1,NCEPTS
C
C                  PROPAGATE TO INTERCEPT.
C
        JTYPE=0
        DSTEP=RDOTD(ICEPT)
        IF(ICEPT.GT.1) DSTEP = DSTEP - RDOTD(ICEPT-1)
        IF(KDEPTH.NE.0) GO TO 1010
          GMSTEP=0.
          ABSTEP=0.
          RDSTEP=0.
          DESTEP=0.
          GO TO 1011
C
C                  FIND DENSEST TYPE - JTYPE.
C
 1010   DO 1015  K=1,KDEPTH
          IF( JTYPE.LT.KTYPE(K) ) JTYPE = KTYPE(K)
          IF( JTYPE.EQ.KTYPE(K) ) IRONRG= KREGN(K)
 1015   CONTINUE
C
C           OCTOBER 1983 :  FIX-UP FOR YOKE END PLATES .
C           THEY ARE COMPLETELY DEFINED BY HRFACE/IUNIT(IREGN)=5,6/3  ,
C           SINCE THEY ARE THE ONLY PARTS OF UNIT 3 (= MAGNET * PLINTH)
C           WHICH ARE IN FACES 5 AND 6.
C           IF MOST DENSE REGION IS NOT YOKE END PLATE, CARRY ON.
          IF( JTYPE.NE.3 )  GO TO 1016
C               THE REGION NO. OF THE IRON REGION WAS NOTED ABOVE.
C               NOTE : CAN'T BE IN 2 IRON REGIONS AT SAME TIME.
              IF(HRFACE(IRONRG).NE.5.AND.HRFACE(IRONRG).NE.6)GO TO 1016
                  IF(HUNIT(IRONRG).NE.3)GO TO 1016
                      JCEPT=ICEPT
                      CALL MUENDP(JCEPT,IRONRG,FACSTP)
C
C                        N.B.  DSTEP IS NOT CHANGED.
                      GMSTEP = (FACSTP*DSTEP)*GMG(JTYPE)
                      ABSTEP = (FACSTP*DSTEP)*ABG(JTYPE)
                      RDSTEP = (FACSTP*DSTEP)*RDG(JTYPE)
                      DESTEP = (FACSTP*DSTEP)*DEG(JTYPE)
                      GO TO 1011
 1016     CONTINUE
C
C
        GMSTEP=DSTEP*GMG(JTYPE)
        ABSTEP=DSTEP*ABG(JTYPE)
        RDSTEP=DSTEP*RDG(JTYPE)
        DESTEP=DSTEP*DEG(JTYPE)
 1011   CONTINUE
C+++
C     WRITE(6,8935)JTYPE
C8935 FORMAT(' JTYPE',I5)
C+++
C
C                  CALCULATE ENERGY LOSS,MULTIPLE SCATTERING ETC.
C                  IF THE TRACK STOPS, GO DIRECT TO CALL OF MULOCH
C
        CALL MUFFLS(*99)
C
C-----------------------------------------------------------------------
C
C                  FIND OUT WHAT TYPE OF INTERCEPT.
C
        IREGN=IREG(ICEPT)
        ITYPE=HRTYPE(IREGN)
C                  IS THIS A NEW REGION BOUNDARY?
        IF(KDEPTH.EQ.0) GO TO 1012
        DO 1013 K=1,KDEPTH
          IF( IREGN.EQ.KREGN(K) ) GO TO 1014
 1013   CONTINUE
        GO TO 1012
C IT MUST BE AN EXIT POINT - DELETE REFERENCE AND DECREMENT KDEPTH.
C  (THIS MAY SEEM UNNECESSARILY COMPLICATED BUT WITH OVERLAPPING
C   REGIONS AN EXIT POINT DOES NOT NECCESARILY FOLLOW THE CORRESPONDING
C   ENTRY POINT.)
 1014   JDEPTH=0
        DO 1019 K=1,KDEPTH
          IF(IREGN.EQ.KREGN(K)) GO TO 1019
          JDEPTH=JDEPTH+1
          IF(JDEPTH.EQ.K) GO TO 1019
          KREGN(JDEPTH)=KREGN(K)
          KTYPE(JDEPTH)=KTYPE(K)
 1019   CONTINUE
        KDEPTH=JDEPTH
C+++
C       WRITE(6,1657)            KDEPTH,KREGN,KTYPE
C1657   FORMAT('            KDEPTH,KREGN,KTYPE',I15,2(I15,3I5))
C+++
        GO TO 1000
C
C                  IT IS A NEW REGION - INCREMENT KDEPTH.
C
 1012   IF(KDEPTH.LT.4) GO TO 97
          CALL MUERRY('MUFFLT',KDEPTH,'REGIONS OVERLAPPING TOO MUCH.^')
          GO TO 1000
 97     KDEPTH=KDEPTH+1
        KREGN(KDEPTH)=IREGN
        KTYPE(KDEPTH)=ITYPE
C+++
C       WRITE(6,1656)IREGN,ITYPE,KDEPTH,KREGN,KTYPE
C1656   FORMAT(' IREG,ITYPE,KDEPTH,KREGN,KTYPE',3I5,2(I15,3I5))
C+++
C
C                  GO TO NEXT INTERCEPT IF NOT A CHAMBER REGION.
C
        IF(ITYPE.NE.1) GO TO 1000
C
C-----------------------------------------------------------------------
C
C                  CHAMBER INTERCEPTED.
C
        IFIRST=HRFIRS(IREGN)
        ILAST=HRLAST(IREGN)
        IOR=HRORI(IREGN)
        IFRAME=HFR(IFIRST)
        IFRAML=HFR(ILAST)
C
C******  AS OF 16/03/83 , APPLY SOFTWARE SHIFT TO WIRE POSITION FOR ALL
C******  DATA AFTER BEGINNING OF 1980 :
C
C  FIRST FOR THE LOW EDGE OF THE REGION :
        ISHIFE=0
        IF(IYEAR.GE.1980)ISHIFE=HLSF(4,IFIRST)
        IF(IABS(ISHIFE).GT.300)ISHIFE=0
C**** DON'T APPLY SOFTWARE SHIFTS TO MONTE-CARLO DATA.
        IF(KRUN.EQ.0)ISHIFE=0
C  THEN FOR THE HIGH EDGE OF THE REGION :
        ISHIFL=0
        IF(IYEAR.GE.1980)ISHIFL=HLSF(4,ILAST)
        IF(IABS(ISHIFE).GT.300)ISHIFL=0
C**** DON'T APPLY SOFTWARE SHIFTS TO MONTE-CARLO DATA.
        IF(KRUN.EQ.0)ISHIFL=0
C
C
C  FOR CALCULATION OF ANGLE CORRECTION OF FRAME POSITION WITH "Z" :
C  LOW EDGE OF REGION :
        IANGE=HANG(IFRAME)
C  HIGH EDGE OF REGION :
        IANGL=HANG(IFRAML)
C  ASSUME THAT FRAMES IN ANY REGION HAVE SAME END POSITIONS :
        ZMID=0.5*( HCLLO(IFRAME) + HCLHI(IFRAME) )
        ZHAF=0.5*( HCLHI(IFRAME) - HCLLO(IFRAME) )
C
        IOVALL=HOVALL(HUNIT(IFRAME))
        LINC=2
        IF( HLAYER( HFR( IFIRST) ).EQ.1 ) LINC = 1
C
C                  WAS THERE A HIT IN THIS REGION?
C
        DO 1022 I=1,LAYRAB
          IF( IREGN.EQ.IEFFRG(I) ) GO TO 1023
 1022   CONTINUE
        GO TO 1024
C
C-----------------------------------------------------------------------
C
C AT LEAST ONE HIT HAS BEEN FOUND FOR THIS TRACK IN THIS REGION.
C UPDATE SPECIAL VARIABLES, BUT NOT IF THERE HAS BEEN MORE THAN 1
C   INEFFICIENCY PRIOR TO THIS.
C
 1023   IF(INEFF.LE.1) CALL UCOPY(X,X0,NSPECI)
C
C INCREMENT NHLAYR , DEPENDING ON LAYER AS FOLLOWS:
C  IF THIS IS A LAYER 1 HIT , INCREMENT =1 ; IF IT'S ANY OTHER
C  LAYER , INCREMENT = 2.  THEN , IF SUM OF NHLAYR IS ODD, THE
C  TRACK IS KNOWN TO HAVE AN INNER LAYER HIT ASSOCIATED.
C
        INFLAG=0
        NHLAYR=NHLAYR+LINC
        GO TO 4000
C
C-----------------------------------------------------------------------
C
C NO HIT IN THIS CHAMBER REGION - SEARCH FOR A REASON.
C
C***********************************************************************
C FROM HERE TO NEXT ROW OF STARS IS A TEMPORARY MEASURE. ULTIMATELY
C   THE RESULTS OF RE-FITTING THE MUON HITS (MUFFLR) WILL BE USED TO
C   ESTIMATE THE TRACK UNCERTAINTIES.
C
C ADD MULTIPLE SCATTERING AND TRACK FITTING ERRORS TO PRODUCE VARIANCES
C   ON DEVIATIONS AND COVARIANCES BETWEEN ANGLES AND DEVIATIONS
C   NORMAL TO TRACK IN THE 2 PLANES (THE A- * B-PLANES OF JADE NOTE 68.
C   NOTE THAT THE A-PLANE GETS THE LABEL 'Z' * THE B-PLANE 'XY' HERE.)
C
 1024 IF( LCOVAR ) GOTO 995
         VZP = VTZD + VTZANG*(D-DTC)**2
         VZD = VMSD + VZP
         CZ  = CMS + VTZANG*(D-DTC)
         GOTO 996
 995  CONTINUE
         R0P = SQRT(X**2 + Y**2)
         VZP = VTZD + 2.0*R0P*VTZCV + R0P**2*VTZANG
         VZD = VMSD + VZP
         CZ  = CMS + (R0P*VTZANG+VTZCV)/COSEC
C
CCC   VXYD  = VMSD + VTXYD + VTXYAN*(D-DTC)**2
 996  DFXY2 = (X-XEXTRP)**2 + (Y-YEXTRP)**2
      VXYP  = VTXYD + VTXYAN*DFXY2
      VXYD  = VMSD + VXYP
CCC   CXY   = CMS + VTXYAN*(D-DTC)*COSEC
      CXY   = CMS + VTXYAN*SQRT(DFXY2)
C+++
C     WRITE(6,7491)VMSD,CMS,VZP,VZD,CZ,VXYP,CXY
C7491 FORMAT(' MUFFLT: VMSD,CMS,VZP,VZD,CZ,VXYP,CXY',/7G15.5)
C+++
C
C NOW PREPARE COEFFICIENTS FOR PROJECTING ONTO CHAMBER PLANES.
C
        IF(IOR.EQ.3) GO TO 1003
        AA=-COSEC
        CC=0.
        IF(IOR.EQ.2) GO TO 1005
        BB=DCY*DCZ*COSEC/DCX
        DD=1./(DCX*COSEC)
        GO TO 1002
C
 1005   BB=-DCX*DCZ*COSEC/DCY
        DD=-1./(DCY*COSEC)
        GO TO 1002
C
 1003   AA=DCY*COSEC/DCZ
        BB=DCX*COSEC
        CC=DCX*COSEC/DCZ
        DD=-DCY*COSEC
 1002   CONTINUE
C+++
C       WRITE(6,2398)AA,BB,CC,DD
C2398   FORMAT(' AA,BB,CC,DD',4G15.5)
C+++
C
C WORK OUT VARIANCES IN DRIFT (TRANSVERSE) AND WIRE (LONG.) DIRECTIONS.
C
        VL1  = AA**2*VZD+BB**2*VXYD
        VT1  = CC**2*VZD+DD**2*VXYD
C       CTL1 = AA*CC*VZD+BB*DD*VXYD
C+++
C       WRITE(6,2399)VL1,VT1,CTL1
C2399   FORMAT(' VL1,VT1,CTL1',3G15.5)
C+++
C***********************************************************************
C
C PREPARE DEVIATIONS. PROJECT TO MEAN CHAMBER PLANE.
C
        D1MEAN=0.5*(HD1(IFIRST)+HD1(IFIRST+1))
        GO TO (2101,2102,2103),IOR
C
 2101   DDC=(HDIST(IFRAME)+D1MEAN+IOVALL-X)/DCX
        CT=DCY*DDC+Y
        CL=DCZ*DDC+Z
        GO TO 2200
C
 2102   DDC=(HDIST(IFRAME)+D1MEAN-Y)/DCY
        CT=DCX*DDC+X
        CL=DCZ*DDC+Z
        GO TO 2200
C
 2103   DDC=(HDIST(IFRAME)+D1MEAN-Z)/DCZ
        CT=DCX*DDC+X
        CL=DCY*DDC+Y
C
C
C-----------------------------------------------------------------------
C
C  FIRST , LOOK TO SEE IF THE EDGE OF THE SENSITIVE REGION OF THIS
C  FRAME IS WITHIN N*SIGMA(DRIFT)/3*SIGMA(LONGL) OF THE EXTRAPOLATED
C  TRACK (WHERE SIGMA=  SIGMA(TRACK)  * N IS THE FACTOR (SEE CMUFFL)).
C  IF SO,THAT EXPLAINS ABSENCE OF HIT,SO DON'T RECORD AN INEFFICIENCY.
C  ALL 'LET-OFF' CLAIMS ARE CHECKED BY SUBROUTINE MULOCH.
C
 2200   ALLOWT=FACTOR*SQRT(VT1)
        ALLOWL=FACTOR*SQRT(VL1)
        LETDCE = .FALSE.
C
C          CALCULATE ANGLE CORRECTION OF FRAME POSITION WITH TRACK "Z" :
C
        CHAMZ = CL-ZMID
        IF(ABS(CHAMZ).GT.ZHAF)CHAMZ=SIGN(ZHAF,CHAMZ)
        CANGE = CHAMZ*FLOAT(IANGE)/10000.
        CANGL = CHAMZ*FLOAT(IANGL)/10000.
C
CCC     CTLO=HCTLO(IFRAME)
        CTLO=HCTLO(IFRAME)-ISHIFE+CANGE
C THIS NEXT STATEMENT REALLY DOES SAY IFRAML - 'L' FOR 'LAST'.
CCC     CTHI=HCTHI(IFRAML)
        CTHI=HCTHI(IFRAML)-ISHIFL+CANGL
        IFACE  = HFACE(IFRAME)
        IF(IOR.EQ.1) GO TO 2300
        CTLO=CTLO+IOVALL
        CTHI=CTHI+IOVALL
 2300   CLLO=HCLLO(IFRAME)
        CLHI=HCLHI(IFRAME)
C+++
C       WRITE(6,1278)CT,ALLOWT,CTLO,CTHI
C1278   FORMAT(' CT,ALLOWT,CTLO,CTHI',4G15.5)
C       WRITE(6,1279)CL,ALLOWL,CLLO,CLHI
C1279   FORMAT(' CL,ALLOWL,CLLO,CLHI',4G15.5)
C+++
        IFAZ = 1
        IF(CL+ALLOWL.LT.CLHI ) GO TO 3008
          REGZE(IZEP)   = IREGN
          REGZE(IZEP+1) = AB
          IF(IFACE.EQ.6) IFAZ = -1
          RZE1          = IFAZ * (CLHI-CL) /SQRT(VL1)
          RZE2          = IFAZ * (CLHI+5000-CL) /SQRT(VL1)
          REGZE(IZEP+2) = AMIN1(RZE1,RZE2)
          REGZE(IZEP+3) = AMAX1(RZE1,RZE2)
          IZEP  = IZEP + 4
          LETDCE = .TRUE.
          IFAZ = 1
 3008   IF(CL-ALLOWL.GT.CLLO ) GO TO 3009
          REGZE(IZEP)   = IREGN
          REGZE(IZEP+1) = AB
          IF(IFACE.EQ.5) IFAZ = -1
          RZE1          = IFAZ * (CLLO-CL) /SQRT(VL1)
          RZE2          = IFAZ * (CLLO-5000-CL) /SQRT(VL1)
          REGZE(IZEP+2) = AMIN1(RZE1,RZE2)
          REGZE(IZEP+3) = AMAX1(RZE1,RZE2)
          IZEP  = IZEP + 4
          LETDCE = .TRUE.
C                         WHEN A TRACK CHANGES FACES THE DEVIATIONS
C                         MUST HAVE THE SAME LEFT/RIGHT SIGN CONV.
 3009   IFAS = 1
        IF(IFACE.EQ.2 .OR. IFACE.EQ.3) IFAS = -1
        IF( CT+ALLOWT.LT.CTHI ) GO TO 3003
C
C                       SAVE THE REGION NUMBER AND UPPER AND LOWER
C                       LIMITS OF THE TRUE REGION EDGE IN SIGMA UNITS
C
          REGDCE(IDCEP)   = IREGN
          REGDCE(IDCEP+1) = AB
          RDCE1           = IFAS * (CTHI-CT) /SQRT(VT1)
          RDCE2           = IFAS * (CTHI+5000-CT) /SQRT(VT1)
          REGDCE(IDCEP+2) = AMIN1(RDCE1,RDCE2)
          REGDCE(IDCEP+3) = AMAX1(RDCE1,RDCE2)
          IDCEP  = IDCEP + 4
          LETDCE = .TRUE.
 3003   IF( CT-ALLOWT.GT.CTLO ) GO TO 3007
          REGDCE(IDCEP)   = IREGN
          REGDCE(IDCEP+1) = AB
          RDCE1           = IFAS * (CTLO-CT-5000) /SQRT(VT1)
          RDCE2           = IFAS * (CTLO-CT) /SQRT(VT1)
          REGDCE(IDCEP+2) = AMIN1(RDCE1,RDCE2)
          REGDCE(IDCEP+3) = AMAX1(RDCE1,RDCE2)
          IDCEP  = IDCEP + 4
          LETDCE = .TRUE.
C***********************************************************************
C
C  LOOK FOR DEAD CHAMBER WHICH MIGHT EXPLAIN ABSENCE OF HIT.
C  AT SAME TIME,LOOK FOR NEAREST GOOD CHAMBER SO ITS INEFFICIENCY
C    CAN BE RECORDED (IF THERE WAS NO DEAD CHAMBER NEARBY).
C
 3007   ADTMIN=1.E6
        DO 2500 ICHAM=IFIRST,ILAST
C
C  GET WIRE CTW,FRAME NO. FOR THIS CHAM,ORIENTATION,X OVAL DISP.
C
C
C******  AS OF 16/03/83 , APPLY SOFTWARE SHIFT TO WIRE POSITION FOR ALL
C******  DATA AFTER BEGINNING OF 1980 :
C
          ISHIFT=0
          IF(IYEAR.GE.1980)ISHIFT=HLSF(4,ICHAM)
          IF(IABS(ISHIFT).GT.300)ISHIFT=0
C             **** DON'T APPLY SOFTWARE SHIFTS TO MONTE-CARLO DATA.
          IF(KRUN.EQ.0)ISHIFT=0
CCC       ICWIRE=HCTW(ICHAM)
          ICWIRE=HCTW(ICHAM)-ISHIFT
C
C          CALCULATE ANGLE CORRECTION TO CHAMBER POSITION WITH "Z" :
C
          IFRAME=HFR(ICHAM)
          IANG=HANG(IFRAME)
          ZMID=0.5*( HCLLO(IFRAME) + HCLHI(IFRAME) )
          ZHAF=0.5*( HCLHI(IFRAME) - HCLLO(IFRAME) )
          CHAMZ=CL-ZMID
          IF(ABS(CHAMZ).GT.ZHAF)CHAMZ=SIGN(ZHAF,CHAMZ)
          CANG =CHAMZ*FLOAT(IANG)/10000.
          ICWIRE=ICWIRE+CANG
C
          IF(IOR.GT.1)ICWIRE=ICWIRE+IOVALL
          DT = ICWIRE - CT
          ADT=ABS(DT)
C
C FIND SMALLEST DT AND RECORD CHAMBER NUMBER.
C
          IF(ADT.GE.ADTMIN) GO TO 2461
          ADTMIN=ADT
          JCHAM=ICHAM
C
C CHECK FOR DEAD CHAMBER WITHIN ALLOWT+15CMS OF TRACK. IF FOUND, KEEP
C                                                                GOING.
 2461     IF(HMCSTA(ICHAM).EQ.0) GO TO 2500
C+++
C         WRITE(6,8723)ADT,ALLOWT
C8723     FORMAT(' ADT,ALLOWT',2G15.5)
C+++
          IF(ADT.GT.ALLOWT+150.) GO TO 2500
C
C                       SAVE THE REGION NUMBER,ABSORBER SO FAR AND
C                       THE UPPER AND LOWER LIMITS OF THE DEAD
C                       CHAMBER IN SIGMA UNITS.
C
            LETDCE = .TRUE.
            REGDCE(IDCEP)   = IREGN
            REGDCE(IDCEP+1) = AB
            RDCE1           = IFAS * ( DT - 150. )/SQRT(VT1)
            RDCE2           = IFAS * ( DT + 150. )/SQRT(VT1)
            REGDCE(IDCEP+2) = AMIN1(RDCE1,RDCE2)
            REGDCE(IDCEP+3) = AMAX1(RDCE1,RDCE2)
            IDCEP = IDCEP + 4
C
 2500   CONTINUE
        IF(LETDCE) GO TO 1000
C
C DID NOT FIND EDGE OR DEAD CHAMBER WHICH CAN EXPLAIN ABSENCE OF HIT.
C THEREFORE , MUST HAVE CHAMBER INEFFICIENCY . INCREMENT INEFF.
C ---- BUT KEEP TRACKING !
C
        INFLAG=1
        INEFF=INEFF+1
        IF(INEFF.GT.10) GO TO 4000
        INCHAM(INEFF)=JCHAM
        INREG(INEFF)=IREGN
        GO TO 4000
C
C-----------------------------------------------------------------------
C
C UPDATE A FEW THINGS FOR THIS 'GOOD' CHAMBER LAYER.
C
C
C UPDATE X8, ETC., THE VALUES AT LAST BUT ONE GOOD CHAMBER LAYER.
C
 4000   CALL UCOPY(X9,X8,NSPECI)
C
C UPDATE X9, ETC., THE VALUES AT LAST GOOD CHAMBER LAYER.
C
        CALL UCOPY(X,X9,NSPECI)
        NGLAYR=NGLAYR+LINC
C
 1000 CONTINUE
C
C-----------------------------------------------------------------------
C END OF MAIN LOOP OVER REGIONS. ---------------------------------------
C-----------------------------------------------------------------------
C
C             PERFORM MULOCH - THE MUON 'LET-OFF' CHECK
C
 99   CALL MULOCH
C
      RETURN
      END
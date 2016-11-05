C   21/08/87 803311210  MEMBER NAME  DXMCSS   (S)           FORTRAN77
      SUBROUTINE DXMCSS( NHDEDX, ADEDX, NRUN )
C----------------------------------------------------------
C  Version of 11/11/87       Last Mod 31/03/88   E Elsen
C  Add systematic contribution to the NHDEDX amplitudes
C  stored in ADEDX according to run number NRUN.
C
C  The systematic error has been matched to agree with the
C  errors found for real data, i.e.
C     sigma( ln(dEdx/dEdxT)/(SdEdx/dEdx)) = 1
C  If ERRSYS numbers change these numbers have to be
C  modified as well.
C
C  Input:
C           NHDEDX = number of dEdx hits
C           ADEDX  = theoretical amplitudes
C           NRUN  = run number, which will be translated
C                   into K.Ambrus Calibration periods
C  Output:
C           ADEDX  = smeared amplitudes
C
C Changes
C   31.3.88  E E  now use ERDEDX to evaluate systematic
C                 contribution instead of explicit statement.
C----------------------------------------------------------
      PARAMETER (NBINS=1000,NMHITS=100)
C----                                       USED IN K.AMBRUS' ROUTINES
      INTEGER NAMPLA(NBINS)
      INTEGER NMAX / NBINS /
      REAL*4 Z1 / 1. /
      REAL*4 ADEDX(NMHITS)
C----                               -------
C
C                                           CONSTANTS FROM
C                                           F11AMB.SOURCE(BBAMP)
C                                           READ WITH MCAMPE
      REAL*4 FAMPLA /  0.7500E+02/
      INTEGER NAMPL0(100) /
     +    0,    0,    0,    0,    0,    1,    1,    4,    0,    4,
     +    6,    1,    9,   10,    9,   12,   21,   31,   30,   36,
     +   56,   62,   70,   66,   96,  109,  149,  193,  264,  324,
     +  381,  518,  751,  905, 1149, 1446, 1994, 2436, 3108, 3829,
     + 4875, 5923, 7044, 8533, 9871,11549,13710,15650,18013,20430,
     +22716,25553,28156,30971,33663,36310,39543,41633,44319,46999,
     +49546,50850,53011,54875,56478,58050,59400,60338,60620,61250,
     +61068,61207,61056,60751,61273,59899,59226,58513,57821,55912,
     +55202,53934,52830,51186,50084,48882,47922,46321,44929,43675,
     +41916,41149,39618,38164,37226,35584,34387,33235,32269,30474/
      INTEGER NAMPL1(100) /
     +29670,28922,28141,26796,25783,24917,23941,23369,22273,21810,
     +20935,20322,19275,18873,18338,17398,16911,16287,15683,15269,
     +14510,14202,13708,13349,12795,12502,11681,11594,11074,10818,
     +10631,10089, 9945, 9527, 9222, 9039, 8755, 8410, 8197, 8111,
     + 7632, 7572, 7365, 7036, 6959, 6674, 6591, 6342, 6197, 5861,
     + 5776, 5618, 5419, 5386, 5088, 5005, 4969, 4734, 4609, 4521,
     + 4509, 4283, 4169, 4265, 4021, 3889, 3748, 3738, 3660, 3500,
     + 3506, 3537, 3323, 3177, 3204, 3081, 3071, 2907, 2914, 2935,
     + 2769, 2773, 2649, 2633, 2554, 2558, 2413, 2403, 2319, 2316,
     + 2290, 2217, 2215, 2221, 2115, 2068, 1980, 1982, 1921, 1875/
      INTEGER NAMPL2(100) /
     + 1837, 1750, 1757, 1732, 1675, 1659, 1610, 1590, 1587, 1556,
     + 1527, 1416, 1468, 1400, 1400, 1376, 1328, 1365, 1309, 1304,
     + 1256, 1186, 1221, 1258, 1208, 1109, 1103, 1084, 1072, 1071,
     + 1093, 1029, 1017,  977, 1012,  967,  980,  935,  923,  889,
     +  906,  909,  860,  878,  818,  818,  810,  815,  782,  765,
     +  746,  729,  767,  731,  710,  724,  698,  691,  660,  633,
     +  625,  664,  625,  639,  629,  569,  627,  581,  635,  563,
     +  574,  575,  544,  579,  515,  531,  530,  527,  501,  535,
     +  495,  462,  466,  473,  437,  444,  424,  452,  398,  457,
     +  442,  393,  421,  403,  381,  398,  420,  412,  377,  374/
      INTEGER NAMPL3(100) /
     +  373,  330,  365,  329,  353,  343,  339,  343,  315,  341,
     +  315,  316,  299,  326,  323,  308,  283,  274,  319,  312,
     +  296,  275,  254,  287,  295,  285,  274,  261,  250,  288,
     +  247,  265,  245,  262,  219,  251,  247,  222,  238,  263,
     +  230,  235,  253,  234,  211,  215,  222,  222,  190,  224,
     +  204,  207,  221,  202,  200,  221,  192,  185,  183,  191,
     +  178,  186,  194,  183,  186,  182,  175,  174,  160,  161,
     +  166,  176,  160,  178,  158,  155,  144,  149,  149,  128,
     +  153,  165,  145,  122,  143,  140,  157,  124,  130,  137,
     +  146,  124,  124,  141,  120,  108,  134,  150,  130,  133/
      INTEGER NAMPL4(100) /
     +  112,  103,  126,  144,  108,  107,  119,  129,  118,  136,
     +  125,  111,  115,  116,  117,  123,  105,  111,   83,  102,
     +  103,   93,   94,  105,   93,  101,   92,  102,  107,   95,
     +   89,  109,   87,   92,   92,   91,   89,  101,   93,  100,
     +   74,   88,   73,   79,   95,   76,   71,   73,   97,   86,
     +   73,   78,   66,   75,   74,   70,   85,   88,   65,   80,
     +   78,   66,   81,   68,   81,   68,   74,   67,   64,   73,
     +   79,   71,   64,   70,   66,   60,   58,   65,   69,   66,
     +   60,   75,   58,   68,   55,   61,   50,   63,   59,   68,
     +   61,   63,   53,   71,   47,   53,   48,   56,   60,   52/
      INTEGER NAMPL5(100) /
     +   58,   68,   49,   50,   58,   47,   58,   58,   60,   59,
     +   48,   58,   46,   61,   48,   61,   61,   49,   60,   46,
     +   38,   44,   50,   45,   61,   36,   42,   52,   48,   39,
     +   43,   49,   42,   44,   40,   37,   42,   45,   46,   45,
     +   42,   40,   37,   37,   50,   43,   39,   33,   47,   39,
     +   33,   50,   41,   32,   39,   42,   38,   32,   36,   35,
     +   40,   44,   31,   39,   29,   30,   32,   34,   33,   34,
     +   29,   31,   28,   41,   39,   31,   49,   29,   22,   24,
     +   40,   32,   19,   20,   25,   27,   32,   34,   37,   29,
     +   28,   17,   35,   27,   32,   28,   32,   23,   31,   35/
      INTEGER NAMPL6(100) /
     +   31,   35,   27,   30,   21,   22,   29,   22,   19,   24,
     +   26,   19,   26,   26,   26,   23,   19,   19,   33,   24,
     +   22,   26,   28,   24,   30,   23,   27,   21,   24,   32,
     +   21,   19,   22,   28,   18,   22,   24,   19,   18,   18,
     +   19,   27,   25,   20,   24,   23,   19,   27,   20,   15,
     +   19,   18,   15,   15,   18,   23,   17,   16,   22,   16,
     +   22,   14,   17,   31,   16,   21,   17,   23,   20,   16,
     +   14,   20,   19,   13,   17,   20,   18,   13,   24,   21,
     +   17,   19,   25,   12,   22,   24,   19,   21,   24,   21,
     +   16,   13,   17,   19,   12,   19,   15,   14,   11,   19/
      INTEGER NAMPL7(100) /
     +   13,   14,   17,   14,   10,   14,   11,   16,   11,   17,
     +   16,   20,   23,    6,   16,   19,   18,   11,   13,   13,
     +   18,   19,   18,   16,   12,   13,   13,   13,   15,   12,
     +   19,   16,   17,   12,    9,   12,    9,   11,   10,   13,
     +   14,   12,   10,   17,   10,   17,   12,   13,   14,   10,
     +   14,    8,    3,   11,    9,    8,   12,   14,    9,   13,
     +   15,   13,   16,   13,    2,   13,   15,   11,   17,   11,
     +    7,   18,   13,    8,   11,   17,   12,    9,   11,    9,
     +   10,    8,   12,   10,    7,   10,   15,    7,   17,   13,
     +    5,    9,   16,    9,   10,    8,   11,    7,    8,    9/
      INTEGER NAMPL8(100) /
     +    9,    8,   11,   13,   12,    5,    7,   10,   12,    9,
     +   15,    7,   10,   15,    9,    8,    8,    2,   10,   13,
     +    7,   10,    8,    7,   10,   10,    7,    7,    9,   15,
     +    7,   10,    8,    7,    8,    9,    9,   11,    5,   11,
     +    9,    5,    9,   13,    7,    9,    4,   10,    9,    5,
     +    8,    6,    5,   14,    9,    7,    9,    8,    9,   12,
     +   11,    4,    8,    9,    8,    4,    4,    7,    5,   11,
     +    5,    9,    9,    6,    6,    4,    9,    5,    3,    9,
     +    8,    6,    8,    7,    9,    7,    4,    3,    7,    9,
     +   16,    7,    8,    7,    6,    7,    8,    7,    5,   10/
      INTEGER NAMPL9(100) /
     +    8,    7,    7,    4,    6,    6,    7,    3,    9,    3,
     +    6,    7,    9,    6,    9,    8,    6,    4,    3,    4,
     +    7,    9,   11,    7,    1,    5,    3,    3,    8,    8,
     +    5,    2,    7,    3,    9,    4,    9,    3,    5,    5,
     +    3,    5,   10,    7,    4,    7,    5,    3,   10,    5,
     +    6,    5,    7,    4,    4,    5,    6,    4,    4,    4,
     +    6,    6,    9,    5,    2,    7,    7,    7,    5,    2,
     +    6,    4,    5,    7,    4,    9,    5,    4,    6,    5,
     +    6,    3,    1,    5,    6,    3,    6,    7,    4,    4,
     +    1,    2,    2,    2,    4,    5,    5,    5,    4, 1575/
      EQUIVALENCE (NAMPLA(  1), NAMPL0(1) ),
     +            (NAMPLA(101), NAMPL1(1) ),
     +            (NAMPLA(201), NAMPL2(1) ),
     +            (NAMPLA(301), NAMPL3(1) ),
     +            (NAMPLA(401), NAMPL4(1) ),
     +            (NAMPLA(501), NAMPL5(1) ),
     +            (NAMPLA(601), NAMPL6(1) ),
     +            (NAMPLA(701), NAMPL7(1) ),
     +            (NAMPLA(801), NAMPL8(1) ),
     +            (NAMPLA(901), NAMPL9(1) )
C
C
      IF( NHDEDX.GT.0 ) THEN
        NDEDX = MIN(NHDEDX,NMHITS)
C                                           SYSTEMATIC ERROR
        ERRSYS = ERDEDX( 1., 0., NRUN, NDEDX )
C                                         GENERATE QUASI GAUSSIAN
C                                         WITH MEAN Z1 AND SIGMA ERRSYS
        IF( ERRSYS .GT. 0. ) THEN
          Z = 0.
          DO 9 I=1,12
    9     Z = Z + RN(DUMMY)
          Z = Z1 + ERRSYS*(Z-6.)
        ELSE
          Z = 1.
        ENDIF
C                                           AMPLITUDES
        FAC = Z/FAMPLA
        DO 10 IHIT = 1, NDEDX
          CALL DXMCSP( NMAX, NAMPLA, XDEDX )
          ADEDX(IHIT) = XDEDX*FAC*ADEDX(IHIT)
   10   CONTINUE
      ENDIF
      END

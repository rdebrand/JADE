C   26/02/80 609161859  MEMBER NAME  LGDEAD   (SOURCE)      FORTRAN
      SUBROUTINE LGDEAD(HEXP,HDEAD)
C     GIVES THE DEAD LG COUNTERS
C     HDEAD(1)=#OF DEADS, THEN LIST OF COUNTER #S
C         MUST ENLARGE TO PUT IN RUN DEPENDENCE. HEXP IS NOT REALLY NEED
C           LAST CHANGE 21/06/81 Y.WATANABE
C     COUNTER NUMBER STARTS FROM 0
C**** NOT INCLUDE THE RUNS 4992-5186 WHERE 1049-1061 WERE DEAD.
C     12/10/82   BUFFER EXTENDED FROM 20 TO 30     H.TAKEDA
C     12/10/82   DEAD COUNTER UPDATED FOR RUN 5668 - 10000
C     12/10/82   DEAD COUNTER UPDATED FOR RUN 10000-12518
C     18/04/84   DEAD COUNTER UPDATED FOR RUN 12519-16738
C     03/07/84   DEAD COUNTER UPDATED FOR RUN 14607 AND 16803
C     04/12/84   BUFFER EXTENDED FROM 30 TO 40     K. KAWAGOE
C     04/12/84   DEAD COUNTER UPDATED FOR RUN 16803-18823
C     05/12/84   DEAD COUNTER UPDATED FOR RUN 18824-18894
C     20/12/84   A BUG WAS FOUND AND CORRECTED. K.KAWAGOE
C     17/06/85   DEAD COUNTER UPDATED FOR RUN 20000 --  K.KAWAGOE
C     13/09/85   DEAD COUNTER UPDATED FOR RUN 20547 --  K.KAWAGOE
C     16/09/86   MISSING DEAD COUNTER 753(17W03) ADDED
C                WHICH IS DEAD SINCE 29/10/84           N.MAGNUSSEN
C     16/09/86   DEAD COUNTER UPDATED FOR RUN 23286 --  N.MAGNUSSEN
C     16/09/86   DEAD COUNTER UPDATED FOR RUN 23887 --  N.MAGNUSSEN
C     16/09/86   DEAD COUNTER UPDATED FOR RUN 24214 --  N.MAGNUSSEN
C     16/09/86   DEAD COUNTER UPDATED FOR RUN 25661 --  N.MAGNUSSEN
      IMPLICIT INTEGER*2 (H)
C
      COMMON /BCS/ IDATA(24000)
      DIMENSION  ADATA(24000),HDATA(48000)
      EQUIVALENCE (IDATA(1),ADATA(1)), (HDATA(1),IDATA(1))
      DIMENSION HDEAD(40),HD(40,30),HD1(40,5),HD2(40,5),HD3(40,5),
     &          HD4(40,5),HD5(40,5),HD6(40,5)
      EQUIVALENCE (HD(1,1),HD1(1,1)),(HD(1,6),HD2(1,1)),
     &            (HD(1,11),HD3(1,1)),(HD(1,16),HD4(1,1)),
     &            (HD(1,21),HD5(1,1)),(HD(1,26),HD6(1,1))
      DATA HD1/9,293,298,418,613,1153,1315,1842,2355,2609,30*0,
     2    4,298,1153,1315,1842,35*0,
     3   11,298,807,1153,1307,1315,1842,1881,1899,2427,2587,2661,28*0,
C    3    5,298,807,1153,1315,1842,14*0/
C-- RUN 5668 - 10000
     4   10,1153,1315,1669,298,1931,1807,1842,2134,1143,221,29*0,
C-- RUN 10000 - 10973
     5   21,1153,1315,1987,1669,2534,2409,298,1931,1265,1842,1715,2555,
     &      1244,1596,1916,1948,221,2705,2708,2767,2857,18*0/
C-- RUN 10974 - 12518
      DATA HD2/18,1153,1315,1987,1669,2534,2409,298,1931,1265,1842,
     &   1715,2555,1244,1596,1916,1948,221,2787,21*0,
C-- RUN 12519 - 14086
     7   14,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,25*0,
C-- RUN 14087 - 14776
     8   15,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,24*0,
C-- RUN 14777 - 16445
C--               1549-14W28 WAS BROKEN FROM RUN14607(T.T)
C--                    BUT FOUND 10/6/84 UPDATED FROM HERE
     9   17,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,142,1549,22*0,
C-- RUN 16446 - 16655
     A   18,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,142,1917,1549,21*0/
C-- RUN 16656 - 16802
      DATA HD3/ 19,1152,2632,298,56,2555,188,541,2685,1987,1452,
     &        1715,2524,124,1681,530,142,1917,1356,1549,20*0,
C-- RUN 16803 - 17267
C--               1074-18W13 WAS ADDED ON 10/6/83 (T.T)
C--                941-14W09 WAS ADDED ON 04/12/84(K.K.)
C--               2028-13T42 WAS ADDED ON 04/12/84(K.K.)
     2   22,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,142,1917,1356,1549,1073,941,2028,17*0,
C-- RUN 17268 - 17323
C--                651-12T01 WAS ADDED ON 04/12/84(K.K.)
     3   23,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,142,1917,1356,1549,1073,941,2028,651,16*0,
C-- RUN 17324 - 18064
C--               1440-01W25 WAS ADDED ON 04/12/84(K.K.)
     4   24,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,142,1917,1356,1549,1073,941,2028,651,1440,15*0,
C-- RUN 18065 - 18529
C--                708-05W02 WAS ADDED ON 04/12/84(K.K.)
     5   25,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     & 1681,530,142,1917,1356,1549,1073,941,2028,651,1440,708,14*0/
C-- RUN 18530 - 18822
C--               1312-01W21 WAS ADDED ON 04/12/84(K.K.)
      DATA HD4/26,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,
     &   2524,124,1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,13*0,
C-- RUN 18823 -18893
C--                621-14T02 WAS ADDED ON 04/12/84(K.K.)
     7   27,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,12*0,
C-- RUN 18894 -
C--      7 COUNTERS WERE DEAD DUE TO WATER LEAK.
C--                741-05W03 WAS ADDED ON 05/12/84(K.K.)
C--                750-14W03 WAS ADDED ON 05/12/84(K.K.)
C--                751-15W03 WAS ADDED ON 05/12/84(K.K.)
C--                753-17W03 WAS ADDED ON 05/12/84(K.K.)
C--                754-18W03 WAS ADDED ON 05/12/84(K.K.)
C--                585-09T03 WAS ADDED ON 05/12/84(K.K.)
C--                595-19T03 WAS ADDED ON 05/12/84(K.K.)
     8   34,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &        1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,741,750,751,753,754,585,595,5*0,
C-- RUN 20000 -
C--      7 COUNTERS ABOVE ARE ALIVE AGAIN.
C--           753-17W03 ADDED 16/09/86    N.M.
     9   28,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &   1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,753,11*0,
C-- RUN 20547 -
C--               1486-15W26 WAS ADDED ON 13/09/85(K.K.)
C--           753-17W03 ADDED 16/09/86    N.M.
     A   29,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,2524,124,
     &   1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,1486,753,10*0/
C-- RUN 22821 -
C--                110-15T18 WAS ADDED ON 13/09/85(K.K.)
C--           753-17W03 ADDED 16/09/86    N.M.
      DATA HD5/30,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,
     &   2524,124,1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,1486,110,753,9*0,
C-- RUN 23286 -
C--          1042-19W12 ADDED 16/09/86    N.M.
     A   31,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,
     &   2524,124,1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,1486,110,753,1042,8*0,
C-- RUN 23887 -
C--          1932-13W40 ADDED 16/09/86    N.M.
     A   32,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,
     &   2524,124,1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,1486,110,753,1042,1932,7*0,
C-- RUN 24214 -
C--           819-20W05 ADDED 16/09/86    N.M.
     A   33,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,
     &   2524,124,1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,1486,110,753,1042,1932,819,6*0,
C-- RUN 25661 -
C--          2760- 4E01 ADDED 16/09/86    N.M.
     A   34,1152,2632,298,56,2555,188,541,2685,1987,1452,1715,
     &   2524,124,1681,530,142,1917,1356,1549,1073,941,2028,651,1440,
     &   708,1312,621,1486,110,753,1042,1932,819,2760,5*0/
      DATA HD6/200*0/
      DATA INIT/0/
      IF(INIT.GT.0) GO TO 10
      IPHEAD = IBLN('HEAD')
      INIT=1
10    ID=1
          NPHEAD = IDATA(IPHEAD)
          IF(NPHEAD.LE.0) RETURN
          NHHEAD = NPHEAD+NPHEAD
          HRUN=HDATA(NHHEAD+10)
      IF(HEXP.GT.8) ID=2
      IF(HRUN.GE.4992) ID=3
      IF(HRUN.GE.5668) ID=4
      IF(HRUN.GE.10000) ID=5
      IF(HRUN.GE.10974) ID=6
      IF(HRUN.GE.12519) ID=7
      IF(HRUN.GE.14087) ID=8
      IF(HRUN.GE.14777) ID=9
      IF(HRUN.GE.16446) ID=10
      IF(HRUN.GE.16656) ID=11
      IF(HRUN.GE.16803) ID=12
      IF(HRUN.GE.17268) ID=13
      IF(HRUN.GE.17324) ID=14
      IF(HRUN.GE.18065) ID=15
      IF(HRUN.GE.18530) ID=16
      IF(HRUN.GE.18823) ID=17
      IF(HRUN.GE.18894) ID=18
      IF(HRUN.GE.20000) ID=19
      IF(HRUN.GE.20547) ID=20
      IF(HRUN.GE.22821) ID=21
      IF(HRUN.GE.23286) ID=22
      IF(HRUN.GE.23887) ID=23
      IF(HRUN.GE.24214) ID=24
      IF(HRUN.GE.25661) ID=25
      DO 20 I=1,40
20    HDEAD(I)=HD(I,ID)
      RETURN
      END

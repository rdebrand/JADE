C   25/10/79 001181301  MEMBER NAME  ANO101   (S)           FORTRAN
      SUBROUTINE ANO101(IRUN)
C---  ANOMALIES OF RUNS 1959 - 1965
C---  15.62 GEV      OCTOBER 1979
C
C     H.WRIEDT    27.07.79     02:20
C     LAST MODIFICATION     18.01.80     13:05
C
      IMPLICIT INTEGER*2 (H)
C
      COMMON /CPHASE/ LIMEVT,KCONST(192),LIMIT(192),LCHANN(192),
     +                LTHRES(192),LDEAD(192),LSUB(240)
      LOGICAL LCHANN,LTHRES,LDEAD,LSUB
C
C---  LCHANN:  CHANNELS WITH CONSTANT PEDESTALS
C---  LDEAD:   CHANNELS WHICH MUST BE SET TO 0 (E.G. FOR MISSING BITS
C              IN THE ADC
C---  KCONST:  CHANNELS FOR WHICH THE SUBTRACTION CONSTANT MUST BE
C              HIGHER (-1) OR LOWER (+1) THAN THE PROGRAM WOULD
C              AUTOMATICALLY CALCULATE
C---  LIMIT:   GIVES THE LOWER BOUND OF THE SUBTRACTION CONSTANT
C---  LTHRES:  CHANNELS FOR WHICH THE LOWER CUT BOUND IS SET TO 100
C              INSTEAD OF 50
C
      GOTO (1959,1960,1961,1962,1963,1964,1965),IRUN
   13 RETURN
C
 1959 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(168) = -1
      LIMIT(168) = 90
      KCONST(185) = -1
      LIMIT(185) = 330
      KCONST(187) = -1
      LIMIT(187) = 315
C
      LTHRES(7) = .TRUE.
      LTHRES(25) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(55) = .TRUE.
      LTHRES(60) = .TRUE.
      LTHRES(67) = .TRUE.
      LTHRES(80) = .TRUE.
C
      RETURN
C
 1960 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(168) = -1
      LIMIT(168) = 90
      KCONST(185) = -1
      LIMIT(185) = 315
      KCONST(187) = -1
      LIMIT(187) = 315
      KCONST(190) = -1
      LIMIT(190) = 150
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
 1961 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(168) = -1
      LIMIT(168) = 90
      KCONST(185) = -1
      LIMIT(185) = 330
      KCONST(187) = -1
      LIMIT(187) = 315
C
      RETURN
C
 1962 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(185) = -1
      LIMIT(185) = 315
      KCONST(187) = -1
      LIMIT(187) = 315
C
      LTHRES(49) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
 1963 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(168) = -1
      LIMIT(168) = 105
      KCONST(185) = -1
      LIMIT(185) = 315
      KCONST(187) = -1
      LIMIT(187) = 315
      KCONST(190) = -1
      LIMIT(190) = 135
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
C1964 PRELIMINARY
 1964 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(185) = -1
      LIMIT(185) = 300
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
C1965 PRELIMINARY
 1965 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(168) = -1
      LIMIT(168) = 105
      KCONST(185) = -1
      LIMIT(185) = 315
      KCONST(187) = -1
      LIMIT(187) = 315
      KCONST(190) = -1
      LIMIT(190) = 135
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
      END

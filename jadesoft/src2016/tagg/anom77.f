C   09/10/79 912171328  MEMBER NAME  ANOM77   (S)           FORTRAN
      SUBROUTINE ANOM77(IRUN)
C---  ANOMALIES OF RUNS 1770 - 1778
C---  15.41 GEV      OCTOBER 1979
C
C     H.WRIEDT    27.07.79     02:20
C     LAST MODIFICATION     17.12.79     13:00
C
      IMPLICIT INTEGER*2 (H)
C
      COMMON /CPHASE/ LIMEVT,KCONST(192),LIMIT(192),LCHANN(192),
     &                LTHRES(192),LDEAD(192),LSUB(240)
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
      GOTO (1770,1771,1772,1773,1774,1775,13,1777,1778),IRUN
   13 RETURN
C
 1770 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 360
C
      RETURN
C
C1771 PRELIMINARY
 1771 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 360
      KCONST(168) = -1
      LIMIT(168) = 120
      KCONST(190) = -1
      LIMIT(190) = 135
C
      RETURN
C
C1772 PRELIMINARY
 1772 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 360
      KCONST(168) = -1
      LIMIT(168) = 120
      KCONST(190) = -1
      LIMIT(190) = 135
C
      RETURN
C
C1773 PRELIMINARY
 1773 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 360
      KCONST(168) = -1
      LIMIT(168) = 120
      KCONST(185) = -1
      LIMIT(185) = 300
      KCONST(190) = -1
      LIMIT(190) = 120
C
      RETURN
C
 1774 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 360
      KCONST(168) = -1
      LIMIT(168) = 120
      KCONST(178) = -1
      LIMIT(178) = 135
      KCONST(185) = -1
      LIMIT(185) = 315
      KCONST(187) = -1
      LIMIT(187) = 315
      KCONST(190) = -1
      LIMIT(190) = 120
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(60) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
C1775 PRELIMINARY
 1775 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(166) = -1
      LIMIT(166) = 360
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(60) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
C1777 PRELIMINARY
 1777 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(168) = -1
      LIMIT(168) = 120
      KCONST(190) = -1
      LIMIT(190) = 120
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(60) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
C1778 PRELIMINARY
 1778 LCHANN(79) = .TRUE.
      LCHANN(107) = .TRUE.
      LCHANN(173) = .TRUE.
      LCHANN(181) = .TRUE.
C
      KCONST(116) = -1
      LIMIT(116) = 120
      KCONST(166) = -1
      LIMIT(166) = 375
      KCONST(168) = -1
      LIMIT(168) = 120
      KCONST(185) = -1
      LIMIT(185) = 300
      KCONST(190) = -1
      LIMIT(190) = 120
C
      LTHRES(7) = .TRUE.
      LTHRES(49) = .TRUE.
      LTHRES(60) = .TRUE.
      LTHRES(67) = .TRUE.
C
      RETURN
C
      END

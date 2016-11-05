C   07/06/96 606071902  MEMBER NAME  PHIST    (S4)          FORTG1
      SUBROUTINE PHIST(NA)
      EXTERNAL UHIST
      COMMON/BCS/IW(1)
      REAL RW(1)
      EQUIVALENCE (RW(1),IW(1))
      REAL*8 RPR(11)
      REAL*4 SP(11)
      COMMON/CCONVT/JM,PX(32,10)
      INTEGER PX
      LOGICAL*1 LX(128,10),XCH/1HX/
      EQUIVALENCE (LX(1,1),PX(1,1))
      NAA=NA
      IF(NA.NE.0) GOTO 4
      CALL BPOS('HST*')
    2 CALL BNXT(IND,*100)
      NAA=IW(IND-2)
    4 CALL QHIST(NAA,PX)
      CALL BLOC(IND,'HST*',NAA,*100)
      IF(IND.EQ.0) RETURN
      IF(IW(IND+20).GE.3) GOTO 90
      CALL PTEXT(NAA,3)
      WRITE(6,101) IW(IND+1), RW(IND+16),RW(IND+2)
      WRITE(6,102) IW(IND+2), RW(IND+16),RW(IND+2)
      CALL HISTPR(RW(IND+21),100,RW(IND+3),RW(IND+4))
   90 IW(IND+20)=3
      IF(NA.EQ.0) GOTO 2
  100 RETURN
  101 FORMAT(
     1   '0UHIST',I10,    ' AW',G13.3,' OUTL',F8.0,' MIN',G13.6,' MEAN',
     2   G12.3,' SIGMA',G11.4,' 16PC',G11.4,' 02.3PC',G11.4)
  102 FORMAT(' ENTRIES',I8,' STEP',G11.3,' OUTH',F8.0,' MAX',G13.6,
     1   ' MEDIAN',G10.3,' MSIGM',G11.3,' 84PC',G11.4,' 97.7PC',G11.4)
      END

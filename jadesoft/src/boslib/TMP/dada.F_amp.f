C   07/06/96 606071840  MEMBER NAME  DADA     (S4)          FORTG1
      SUBROUTINE DADA(IGOTO,*)
C     BOS SUBPROGRAM   =4.5=
      COMMON/BCS/IW(1)
#include "ccs.for"
      NWL=LISTE(4)
      IF(IGOTO.EQ.3) GOTO 20
      IF(IGOTO.EQ.4) LW=INDC
C     GET/DELETE
      NPT=LISTE(3)
   10 CALL BSPC(IA,LB,IDUM1,IDUM2)
      IF(LB.LT.1610) GOTO 101
      CALL RDDA(NPT,IW(IA),IW(IA+1))
      INDH=IA+4
      INDL=IA+IW(IA)
      GOTO 14
   12 IF(NPT.NE.LISTE(3)) GOTO 100
      INDH=INDH+IW(INDH)+4
   14 IF(INDH.GT.INDL) GOTO 100
      IF(IW(INDH-3).NE.LISTE(1)) GOTO 12
      IF(IW(INDH-2).NE.LISTE(2)) GOTO 12
      LL=INDH+IW(INDH)-IA
      GOTO (16,18,20,15),IGOTO
   16 NW=IW(INDH)
      CALL BSTR(INDC+IW(INDC),IW(INDH+1),NW)
      CALL BCHL(NW,*101)
      IF(IW(INDC).GE.LISTE(4)) GOTO 100
      NPT=NPT+1
      GOTO 10
   18 NRED=4+IW(INDH)
      NWL=NWL-IW(INDH)
      IS=INDH+IW(INDH)
      NS=INDL-IS
      IF(NS.GT.0) CALL UCOPY2(IW(IS+1),IW(INDH-3),NS)
      IW(IA)=IW(IA)-NRED
   19 CALL WRDA(NPT,IW(IA),IW(IA+1))
      IF(NWL.LE.0) GOTO 100
      NPT=NPT+1
      GOTO 10
   15 NWT=IW(INDH)
      CALL BSTR(INDH,IW(LW+1),NWT)
      LW=LW+NWT
      NWL=NWL-NWT
      GOTO 19
C
   20 NW=IW(INDC)
      LW=INDC
      NPT=IW(INDA+7)
      LISTE(3)=0
      LISTE(4)=NW
      CALL BSPC(IA,LB,IDUM1,IDUM2)
      IF(LB.LT.1610) GOTO 101
      CALL RDDA(NPT,IW(IA),IW(IA+1))
   22 NTOT=IW(IA)
      IF(NTOT.GT.1605) GOTO 24
      CALL BSTR(IA+NTOT,IW(INDC-3),4)
      NTOT=NTOT+4
      IW(IA)=NTOT
      NWT=MIN0(1609-NTOT,NW)
      IW(IA+NTOT)=NWT
      CALL BSTR(IA+NTOT,IW(LW+1),NWT)
      IF(LISTE(3).EQ.0) LISTE(3)=NPT
      NTOT=NTOT+NWT
      IW(IA)=NTOT
      NW=NW-NWT
      LW=LW+NWT
      CALL WRDA(NPT,IW(IA),IW(IA+1))
      IF(NW.EQ.0) GOTO 100
   24 IW(INDA+7)=IW(INDA+7)+1
      IW(IA)=0
      NPT=IW(INDA+7)
      GOTO 22
C
  100 RETURN
  101 RETURN 1
      END
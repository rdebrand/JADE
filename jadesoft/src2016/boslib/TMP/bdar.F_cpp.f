C   07/06/96 606071804  MEMBER NAME  BDAR     (S4)          FORTG1
      SUBROUTINE BDAR(NAME,N,INDA,NLIM)
C     BOS SUBPROGRAM =1.8=
C   18/10/82            MEMBER NAME  ACS      (S)           FORTRAN
      COMMON/ACS/
     1   ICOND,NLAST,NDUMP,NSPL,NAMAX,NAMAX1,NLIST,NPRIM,NFRS,NLST,
     2   NEXT,NCI,NFRE,IN,KPOS,LIND,ILOW,LFDI,LFDK,NCPL,
     3   NHISTH(11),
     4        NCOL,NZT,IBFI,NLAST1,ISLST,IMLST,INAMV,IOLST,IPLST,
     5   NER(10),
     6   NRECL,NERRL,NRIN,NROUT,NS,NEXTI,NEXTA,NEXTB,ISAVB,NSAVB,
     7   NHISTL(11),
     8        MARKWR,NOUT(3),IASW,NPRE,IDUMMY(1),NEOTP,NDUMP1
      COMMON/BCS/IW(1)
      INTEGER INDA(1)
      IW(INAMV)=NAME
      LFDI=MOD(IABS(NAMEV),NPRIM)+NAMAX1
    1 LFDI=IW(LFDI+IPLST)
      IF(IW(LFDI+INAMV).NE.IW(INAMV)) GOTO 1
      IF(LFDI.EQ.0) LFDI=IBLN(IW(INAMV))
      K=LFDI+1
      DO 10 I=1,NLIM
      K=IW(K-1)
      IF(K.EQ.0) GOTO 100
   10 INDA(I)=K
      I=NLIM+1
  100 N=I-1
      RETURN
      END

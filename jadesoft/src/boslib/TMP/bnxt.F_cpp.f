C   07/06/96 606071824  MEMBER NAME  BNXT     (S4)          FORTG1
      SUBROUTINE BNXT(IND,*)
C     BOS SUBPROGRAM =1.10=
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
      IF(KPOS.EQ.0) GOTO 10
      IND=IW(KPOS)
      KPOS=0
      GOTO 20
   10 IND=IW(IND-1)
   20 IF(IND.EQ.0) GOTO 101
  100 RETURN
  101 RETURN 1
      END

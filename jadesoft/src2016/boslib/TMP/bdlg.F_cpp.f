C   07/06/96 606071804  MEMBER NAME  BDLG     (S4)          FORTG1
      SUBROUTINE BDLG
C     BOS SUBPROGRAM =1.14=
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
C
C
C     BDLG = BDLM + BGAR, BUT FASTER IN MOST CASES
      CALL BDLM
      IF(NFRE.NE.0) CALL BGAR(IGA)
      GOTO 100
C
      ENTRY BPRM
      IF(IN.LE.0) GOTO 100
      DO 40 J=1,IN
      K=IW(NLST+J)
      I=IW(K)
      GOTO 35
   30 I=IW(I-1)
   35 IF(I.EQ.0) GOTO 40
      CALL BPRS(IW(I-3),IW(I-2))
      GOTO 30
   40 CONTINUE
      GOTO 100
C
      ENTRY BSLW
      IN=0
      IF(NS.EQ.0) GOTO 100
      DO 80 I=1,NS
      IF(IW(IMLST+I).EQ.0) GOTO 80
      IN=IN+1
      IW(NLST+IN)=IW(ISLST+I)
   80 CONTINUE
      GOTO 100
C
      ENTRY BSLT
      IN=NS
      IF(NS.EQ.0) GOTO 100
      DO 90 I=1,NS
   90 IW(NLST+I)=IW(ISLST+I)
      GOTO 100
C
      ENTRY BSLC
      NS=0
  100 RETURN
      END

C   04/08/79 410081805  MEMBER NAME  ADDON    (JADESR)      FORTRAN
      SUBROUTINE ADDON
      IMPLICIT INTEGER*2 (H)
C---
C---  BUILDS UP LONG EVENT IN CWORK1 FROM PIECES OF SAME IN CWORK.
C---  LAST CHANGE  INTRODUCE ZETC AND BPCH
C---                                      31/07/84   W.BARTEL
C---  LAST CHANGE  INTRODUCE FAMP         08/10/84   W.BARTEL
C---
C---
#include "cdata.for"
      COMMON/CADDMS/IAERKT(10)
      COMMON/CMOADD/JETPNT(3),NMOADD(3),IMOADD(3,10)
      COMMON/CWORK /NWORK ,IWORK (10000)
      COMMON/CWORK1/NWORK1,IWORK1(10000)
      DIMENSION HWORK(20000),HWORK1(20000)
      EQUIVALENCE(IWORK (1),HWORK (1))
      EQUIVALENCE(IWORK1(1),HWORK1(1))
      DIMENSION NAME(128)
      DATA NAME/'HEAD','LATC','TRG1','TRG2','TRG3','ATST','ATBP','ATOF',
     1          'ALGL','ATAG','TAGC','JETC','MUEV','SCAL','MPRS','N50S',
     1          'FAMP','ZTRG','ZETC','BPCH','BK21','BK22','BK23','BK24',
     1          'BK25','BK26','BK27','BK28','BK29','BK30','BK31','BK32',
     1          'JETV','FADC','BK35','BK36','BK37','BK38','BK39','BK40',
     1          'BK41','BK42','BK43','BK44','BK45','BK46','BK47','BK48',
     1          'BK49','BK50','BK51','BK52','BK53','BK54','BK55','BK56',
     1          'BK57','BK58','BK59','BK60','BK61','BK62','BK63','BK64',
     1          'C065','C066','C067','C068','C069','C070','C071','C072',
     1          'C073','C074','C075','C076','C077','C078','C079','C080',
     1          'C081','C082','C083','C084','C085','C086','C087','C088',
     1          'C089','C090','C091','C092','C093','C094','C095','C096',
     1          'C097','C098','C099','C100','C101','C102','C103','C104',
     1          'C105','C106','C107','C108','C109','C110','C111','C112',
     1          'C113','C114','C115','C116','C117','C118','C119','C120',
     1          'C121','C122','C123','C124','C125','C126','C127','C128'/
      DATA LSTCDE/16/
C---
C---     NWORK1.LT.0 INDICATES THIS ROUTINE HAS ALREADY ENCOUNTERED
C---     ERROR IN TRYING TO ASSEMBLE CURRENT EVENT. JUST RETURN. EVREAD
C---     WILL CLEAR THIS NEGATIVE FLAG AT THE BEGINNING OF NEXT TRUE
C---     EVENT.
C---
      IF(NWORK1.LT.0) RETURN
C---
C---     A REASONABLE PARTIAL EVENT FROM THE NORD MUST HAVE AT LEAST A
C---     HEADER BANK WITH 15 DATA WORDS AND 4 BOS HEADER WORDS, THE
C---     BOS HEADER OF AT LEAST ONE MORE BANK AND AT LEAST ONE DATA
C---     WORD FROM THAT BANK, IN ALL 24 WORDS.
C---
      IF((NWORK.LT.24).OR.(NWORK.GT.10000)) GO TO 1001
C---
C---     IWORK MUST BEGIN WITH THE NAME OF THE HEADER BANK.
C---
      IF(IWORK(1).NE.NAME(1)) GO TO 1002
C---
C---     LOOP OVER ALL THE BOS BANKS IN CWORK. COUNT THEM, CHECK THAT
C---     THEY ALL HAVE RECOGNIZED NAMES, CHECKS THAT VARIOUS LENGTHS
C---     ARE REASONABLE AND SAVE THE POINTER TO THE LAST BANK FOR USE
C---     IN LATER CALLS TO THIS ROUTINE FOR THE SAME EVENT.
C---
      IBSUM=0
      LPNT=4
    1 CONTINUE
      NBN=IWORK(LPNT-3)
      IBNK=1
    2 CONTINUE
      IF(NBN.EQ.NAME(IBNK)) GO TO 3
      IBNK=IBNK+1
      IF(IBNK.LE.128) GO TO 2
      GO TO 1003
    3 CONTINUE
C---
C---     HAVE FOUND A RECOGNIZED BANK NAME.
C---
      IBSUM=IBSUM+1
      LENGB=IWORK(LPNT)
      IF((LENGB.LT.1).OR.((LENGB+LPNT).GT.10000)) GO TO 1004
      KPLBNK=LPNT
      LPNT=LPNT+LENGB+4
      IF(LPNT.LT.NWORK) GO TO 1
C---
C---     CHECK THAT NWORK POINTS EXACTLY TO THE END OF THE LAST DATA
C---     WORD OF THE LAST BANK.
C---
      IF(LPNT.NE.(NWORK+4)) GO TO 1005
C---
C---  CHECK THAT THERE WERE AT LEAST TWO BANKS.
C---
      IF(IBSUM.LT.2) GO TO 1006
C---
C---  IS THIS THE FIRST PIECE OF A CONTINUED EVENT?
C---
      IF(NWORK1.NE.0) GO TO 4
      IF(HWORK(23).NE.2) GO TO 1008
      IF(LSTCDE.NE.16) GO TO 1008
      LSTCDE=2
C---
C---     CLEAR COUNTERS FOR THE POSSIBLE TRAILING -1S IN THE THREE
C---     JETC BANKS
C---
      NMOADD(1)=0
      NMOADD(2)=0
      NMOADD(3)=0
C---
C---     THIS IS THE FIRST NORD PSEUDO EVENT CONTRIBUTING TO THE CURRENT
C---     TRUE EVENT. SIMPLY MOVE CWORK, HEADER AND ALL INTO CWORK1.
C---
      NWORK1=NWORK
      LMOVE=4*NWORK
      CALL MVCL(IWORK1(1),0,IWORK(1),0,LMOVE)
C---
C---     LPLBNK IS ALWAYS THE POINTER TO THE LAST BANK IN CWORK1.
C---
      LPLBNK=KPLBNK
      GO TO 7
    4 CONTINUE
      IF((HWORK(23).NE.16).AND.(HWORK(23).NE.(LSTCDE+2))) GO TO 1008
      LSTCDE=HWORK(23)
C---
C---     CURRENT NORD PSEUDO EVENT HOLDS A CONTINUATION OF THE TRUE
C---     EVENT BEING BUILT UP IN CWORK1. IT ALSO HOLDS A REPEATED
C---     HEADER BANK AND, UNLESS THE LAST BANK IN CWORK1 IS COMPLETE,
C---     THE REPEATED BOS HEADER OF THAT BANK AND A REPEATED BANK
C---     DESCRIPTOR. NOW CHECK WHETHER THE FIRST BANK AFTER THE HEADER
C---     IN CWORK HAS THE SAME BOS NAME AND NUMBER AS THE LAST BANK
C---     IN CWORK1.
C---
      LHEAD=IWORK(4)
      NNAM=IWORK(LHEAD+5)
      NNUM=IWORK(LHEAD+6)
      LNAM=IWORK1(LPLBNK-3)
      LNUM=IWORK1(LPLBNK-2)
      ISPLIT=0
      IF((NNAM.EQ.LNAM).AND.(NNUM.EQ.LNUM)) ISPLIT=1
C---     IF(ISPLIT.EQ.0) WRITE(6,200) LNAM,LNUM,NNAM,NNUM,NWORK1
  200    FORMAT('0ADDON: EVENT CONTINUED. NO SPLIT: ',A4,I4,' ',A4,I4,
     1   I8)
         IF(ISPLIT.EQ.0) GO TO 6
C---     WRITE(6,201) NNAM,NNUM,NWORK1
  201    FORMAT('0ADDON: EVENT CONTINUED. BANK SPLIT: ',A4,I4,I8)
         IF(NNAM.EQ.NAME(12)) GO TO 6
         IF((HWORK1(2*NWORK1).NE.-1).AND.(HWORK1(2*NWORK1).NE.0))
     1   GO TO 6
         WRITE(6,202) NNAM,NNUM,NWORK1
  202    FORMAT('0*****WARNING. POSSIBLE SPLIT ERROR: ',A4,I4,I8)
         CALL DUMWK1
         GO TO 2000
    6 CONTINUE
C---
C---     THE NUMBER OF WORDS TO BE ADDED TO THE EVENT BEING BUILT UP
C---     IN CWORK1 IS JUST NWORK MINUS THE LENGTH OF THE REPEATED
C---     HEADER BANK, INCLUDING ITS BOS HEADER, MINUS THE LENGTH OF
C---     THE REPEATED BOS HEADER AND BANK DESCRIPTOR OF THE LAST BANK
C---     IN CWORK1 IN CASE THAT BANK IS NOT YET COMPLETE.
C---
      NADD=NWORK-LHEAD-4-5*ISPLIT
      IF((NADD.LT.1).OR.((NADD+NWORK1).GT.10000)) GO TO 1007
C---
C---     IN CASE THE LAST BANK IN CWORK1 IS BEING CONTINUED, UPDATE ITS
C---     INTERNAL BOS LENGTH PARAMETER. SUBTRACT 1 FOR THE BANK
C---     DESCRIPTOR WORD, WHICH WILL NOT BE REPEADED.
C---
      IF(ISPLIT.EQ.1) IWORK1(LPLBNK)=IWORK1(LPLBNK)+IWORK(LHEAD+8)-1
C---
C---     MOVE THE APPROPRIATE PART OF CWORK INTO CWORK1.
C---
      LMOVE=4*NADD
      CALL MVCL(IWORK1(NWORK1+1),0,IWORK(LHEAD+5+5*ISPLIT),0,LMOVE)
      LNAW=IWORK(KPLBNK-3)
      LNUW=IWORK(KPLBNK-2)
      IF((LNAW.NE.LNAM).OR.(LNUW.NE.LNUM))
     1 LPLBNK=NWORK1+KPLBNK-LHEAD-4-5*ISPLIT
      NWORK1=NWORK1+NADD
    7 CONTINUE
      NNAM=IWORK1(LPLBNK-3)
      NNUM=IWORK1(LPLBNK-2)
      IF(NNAM.NE.NAME(12)) GO TO 5
      IF(HWORK1(2*NWORK1).NE.-1) GO TO 5
C---
C---     THERE IS A TRAILING -1 IN THE JETC BANK JUST ADDED TO CWORK1.
C---     KEEP TRACK OF IT ITS ADDRESS SO THAT IF THE SAME BANK IS
C---     LATER CONTINUED WE CAN GET IT OUT OF THE MIDDLE OF THE BANK.
C---
      IF((NNUM.LT.1).OR.(NNUM.GT.3)) GO TO 1009
      JETPNT(NNUM)=LPLBNK
      NMOADD(NNUM)=NMOADD(NNUM)+1
      NMO=NMOADD(NNUM)
      IF((NMO.LT.1).OR.(NMO.GT.10)) GO TO 1010
      IMOADD(NNUM,NMO)=2*NWORK1
    5 CONTINUE
C---
C---     IF IT IS THE LAST PIECE OF THE CURRENT EVENT WHICH HAS JUST
C---     BEEN ADDED TO CWORK1, CLEAN UP THE POSSIBLE INTERNAL -1S IN
C---     THE JETC BANKS.
C---
      IF(LSTCDE.EQ.16) CALL JETMRG
      RETURN
C---
C---     ERROR MESSAGES.
C---
 1001 CONTINUE
      IAERKT(1)=IAERKT(1)+1
      IF(IERRMS.LT.0) WRITE(6,101) NWORK
  101 FORMAT('0ADDON ERROR 1. NWORK = ',I10,//)
      GO TO 2000
 1002 CONTINUE
      IAERKT(2)=IAERKT(2)+1
      IF(IERRMS.LT.0) WRITE(6,102) IDATA(1)
  102 FORMAT('0ADDON ERROR 2. IDATA(1) = ',I10,//)
      GO TO 2000
 1003 CONTINUE
      IAERKT(3)=IAERKT(3)+1
      IF(IERRMS.LT.0) WRITE(6,103) LPNT,NBN
  103 FORMAT('0ADDON ERROR 3. LPNT, NBN = ',2I10,//)
      GO TO 2000
 1004 CONTINUE
      IAERKT(4)=IAERKT(4)+1
      IF(IERRMS.LT.0) WRITE(6,104) LPNT,LENGB
  104 FORMAT('0ADDON ERROR 4. LPNT, LENGB = ',2I10,//)
      GO TO 2000
 1005 CONTINUE
      IAERKT(5)=IAERKT(5)+1
      IF(IERRMS.LT.0) WRITE(6,105) LPNT,NWORK
  105 FORMAT('0ADDON ERROR 5. LPNT, NWORK = ',2I10,//)
      GO TO 2000
 1006 CONTINUE
      IAERKT(6)=IAERKT(6)+1
      IF(IERRMS.LT.0) WRITE(6,106) LPNT,NWORK,IBSUM
  106 FORMAT('0ADDON ERROR 6. LPNT, NWORK, IBSUM = ',3I10,//)
      GO TO 2000
 1007 CONTINUE
      IAERKT(7)=IAERKT(7)+1
      IF(IERRMS.LT.0) WRITE(6,107) NWORK1,NADD
  107 FORMAT('0ADDON ERROR 7. NWORK1, NADD = ',2I10,//)
      GO TO 2000
 1008 CONTINUE
      IAERKT(8)=IAERKT(8)+1
      IF(IERRMS.LT.0) WRITE(6,108) HWORK(18),HWORK(19),HWORK(23),LSTCDE
  108 FORMAT('0ADDON ERROR 8. RUN, EVENT, CODE, LAST CODE = ',4I8,//)
      GO TO 2000
 1009 CONTINUE
      IAERKT(9)=IAERKT(9)+1
      IF(IERRMS.LT.0) WRITE(6,109) HWORK(18),HWORK(19),NNUM
  109 FORMAT('0ADDON ERROR 9. RUN, EVENT, JETC BANK NO. = ',3I8,//)
      GO TO 2000
 1010 CONTINUE
      IAERKT(10)=IAERKT(10)+1
      IF(IERRMS.LT.0) WRITE(6,110) HWORK(18),HWORK(19),NMOADD
  110 FORMAT('0ADDON ERROR 10. RUN, EVENT, JETC BANK NO. = ',5I8,//)
 2000 CONTINUE
      IERRMS=IERRMS+1
      IF(IERRMS.LE.0) CALL DUMWK1
      IF(IERRMS.LE.0) CALL LHODMP
      NWORK1=-1
      LSTCDE=16
      RETURN
      END
      SUBROUTINE DUMWK1
C
      IMPLICIT INTEGER*2 (H)
C
      COMMON/CWORK1/NWORK,HWORK(20000)
#include "cdata.for"
#include "cgraph.for"
C
      DATA ICALL /0/
      ICALL = ICALL + 1
      IF(ICALL.GT.0) RETURN
C
      DO 1 I=1,1
      IF(I.EQ.2) WRITE(JUSCRN,103)
      IF(I.EQ.2) WRITE(JUSCRN,103)
      IF(I.EQ.1) WRITE(JUSCRN,101)
      IF(I.EQ.2) WRITE(JUSCRN,102)
  101 FORMAT(' WORK1 EVENT:')
  102 FORMAT(' REFORMATTED EVENT:')
      WRITE(JUSCRN,103)
  103 FORMAT('  ')
      IF(I.EQ.1) LENG=2*NWORK
      IF(I.EQ.2) LENG=2*HDATA(208)
      IF((LENG.GE.1).AND.(LENG.LE.20000)) GO TO 3
      WRITE(JUSCRN,104) I,LENG
  104 FORMAT(' ILLEGAL LENGTH IN LHODMP. I, LENG=',2I10)
      GO TO 1
    3 CONTINUE
      LINES=1+(LENG-1)/20
      DO 2 LINE=1,LINES
      LIM1=20*(LINE-1)+1
      LIM2=LIM1+19
      IF(LIM2.GT.LENG) LIM2=LENG
      IF(I.EQ.1) WRITE(JUSCRN,105) LIM1,(HWORK(LHO),LHO=LIM1,LIM2)
      IF(I.EQ.2) WRITE(JUSCRN,105) LIM1,(HDATA(LHO),LHO=LIM1,LIM2)
  105 FORMAT(1X,I6,6X,20I6)
    2 CONTINUE
    1 CONTINUE
      RETURN
C
      END
      SUBROUTINE JETMRG
      IMPLICIT INTEGER*2 (H)
C---
C---     ROUTINE TO GET RID OF INTERNAL -1S IN JETC BANKS.
C---
      COMMON/CMOADD/JETPNT(3),NMOADD(3),IMOADD(3,10)
      COMMON/CWORK1/NWORK1,IWORK1(10000)
      DIMENSION HWORK1(20000)
      EQUIVALENCE(IWORK1(1),HWORK1(1))
C---
C---     LOOP OVER THE THREE POSSIBLE JETC BANKS
C---
      DO 1 IJET=1,3
C---
C---     HOW MANY -1S ARE IN THIS BANK? LOOK UP IN LIST SET UP BY ADDON.
C---
      NUMMIN=NMOADD(IJET)
      IF(NUMMIN.LT.1) GO TO 1
C---
C---     BY HOW MANY I*4 WORDS WILL THE LENGTH OF THIS BANK DECREASE?
C---
      NDECR=NUMMIN/2
      IODD=NUMMIN-2*NDECR
      IPNJET=JETPNT(IJET)
      IBNEND=IPNJET+IWORK1(IPNJET)
      IWORK1(IPNJET)=IWORK1(IPNJET)-NDECR
C---
C---     CLOSE UP THE -1S IN THIS BANK ONLY, STARTING FROM THE HIGHER
C---     ADDRESSES AND WORKING DOWNWARDS SO THAT THE ADDRESSES OF THE
C---     REMAINING -1S DO NOT CHANGE.
C---
      IBHEND=2*IBNEND
      DO 2 IGAP=1,NUMMIN
      INDEX=NUMMIN+1-IGAP
      IHTARG=IMOADD(IJET,INDEX)
      LMOVE=2*(IBHEND-IHTARG)
      IF(LMOVE.LT.1) GO TO 2
      IBHEND=IBHEND-1
      CALL MVCL(HWORK1(IHTARG),0,HWORK1(IHTARG+1),0,LMOVE)
    2 CONTINUE
C---
C---     IF AN ODD NUMBER OF I*2 WORDS HAVE BEEN DELETED, SET THE LAST
C---     I*2 WORD OF THE BANK TO 0, AS PER THE USUAL CONVENTION.
C---
      LASTI2=2*(IPNJET+IWORK1(IPNJET))
      IF(IODD.EQ.1) HWORK1(LASTI2)=0
C---
C---     NOW MOVE THE HIGHER ADDRESS BANKS IN CWORK1 DOWN BY THE
C---     DECREASE IN THE LENGTH OF THE CURRENT JETC BANK. FIRST FIX
C---     THE POINTERS TO THE OTHER JETC BANKS IF THEY ARE AT HIGHER
C---     ADDRESSES.
C---
      IF(NDECR.LT.1) GO TO 1
      DO 3 JJET=1,3
      IF(JETPNT(JJET).LE.IPNJET) GO TO 3
      JETPNT(JJET)=JETPNT(JJET)-NDECR
      NMO=NMOADD(JJET)
      IF(NMO.LT.1) GO TO 3
      DO 4 IGAP=1,NMO
      IMOADD(JJET,IGAP)=IMOADD(JJET,IGAP)-2*NDECR
    4 CONTINUE
    3 CONTINUE
      LMOVE=4*(NWORK1-IBNEND)
      IF(LMOVE.LT.1) GO TO 1
      CALL MVCL(IWORK1(IBNEND+1-NDECR),0,IWORK1(IBNEND+1),0,LMOVE)
      NWORK1=NWORK1-NDECR
    1 CONTINUE
      RETURN
      END
      BLOCK DATA
      COMMON/CADDMS/IAERKT(10)
      DATA IAERKT/10*0/
      END

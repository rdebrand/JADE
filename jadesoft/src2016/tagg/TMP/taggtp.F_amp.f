C   22/06/84 412061343  MEMBER NAME  TAGGTP   (S)           FORTRAN
C
C
C
C------  T A G G T P  ------  T A G G T P  ------  T A G G T P  ------
C
C------  T A G G T P  ------  T A G G T P  ------  T A G G T P  ------
C
C------  T A G G T P  ------  T A G G T P  ------  T A G G T P  ------
C
C
C
C
C     ----   STEERING ROUTINE FOR TP-ING TAGGING DATA  ----
C
C
C
C
C THIS   IS THE MAIN LEVEL OF MY ROUTINES TO TP THE TAGGING SYSTEM
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       SUBROUTINE  TAGGTP(IWRITE,EN, * , * )
C
C
C COMMONS   ETC FOR A.J.FINCH'S TP OF TAGGING SYSTEM
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       IMPLICIT INTEGER * 2 ( H)
C
#include "cdata.for"
C
#include "comtag.for"
C
#include "cwktag.for"
C
#include "ctaggo.for"
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
       INTEGER  START
       REAL  MZED
       INTEGER  PZMX
C
C PLUS   AND MINUS ZED DISTANCES OF TAGGERS
C
       DATA  PZED,MZED / 3160.0 , -3160.0 /
C
C
C----------------------- C O D E ---------------------------------------
C
C
C
C
C---                                         INITIALISATION
C
       CALL  TAGINT(*999)
C
       HWPCL  = 13
C
C ANGCUT   DEFINES COLINEARITY CRITERION
C FOR  COMPARING  CLUSTERS IN + AND - ZED
C
       ANGCUT  = 3.1
C
C  THRESH   IS THE THRESHOLD ENERGY FOR
C  STARTING   A CLUSTER SEARCH (MEV ?)
C
       THRESH  = EN * 25.0
C
       IF  ( IWRITE .EQ. 1 ) WRITE(6,6009) THRESH
 6009  FORMAT('  THRESHOLD FOR CLUSTER SEARCH IN TAGGER = ',F8.3)
C
C
       HIPM  = 4
C
       ISHALL  = IWRITE
C
C FILL   ARRAY CATAG : -
C TAGADC   DOES RETURN 1 FOR MISSING ATAG BANK - NO PROVISION YET
C NONE   REQUIRED TAGG/0 ONLY WILL BE CREATED ALL OTHER BANKS HAVE
C 0 LENGTH    SHOULD REALLY HAVE CHECKED BEFORE CALLING IT .
C
C
       CALL  TAGADC(ISHALL,*97)
C
C
C      SUBTRACT  PEDESTALS APPEARING DUE TO AC PICK UP ON SIGNAL CABLES
C
C
   97  CALL  TAGPED
C
C RECALIBRATE   USING FACTORS FOUND FROM CALIBR COMMON FILLED PREVIOUSLY
C BY KALIBR   IN CALLING ROUTINE.
C
       CALL  TAGKAL(ISHALL)
C
C WORK  OUT SMZ AND SPZ  I.E. SUM OF ALL BLOCKS AT - Z/ + Z RESPECTIVELY
C
       CALL TAGSUM(-1,SMZ,*98)
   98  CALL TAGSUM(+1,SPZ,*99)
   99  ETOT  = SMZ + SPZ
C
C SAVE   THIS INFORMATION IN WHAT WILL EVENTUALLY BE TAGG/0
C
       ATAGG0(29)  = 0.001 * ETOT
       ATAGG0(29)  = 0.001 * ETOT
       ATAGG0(32)  = 0.001 * ETOT
       ATAGG0(30)  = 0.001 * SMZ
       ATAGG0(33)  = 0.001 * SMZ
       ATAGG0(31)  = 0.001 * SPZ
       ATAGG0(34)  = 0.001 * SPZ
C
C
C NOW  PREPARE  TO DO THE FOLLOWING SECTION OF CODE FOR
C - Z  ONLY  ,LATER IT IS DONE FOR + ZED
C
       N = 0
C
C ZED  IS  - ZED   (IN MM )
C
       ZED = MZED
C
C JPART   IS - 1 FOR    - Z + 1 FOR + Z
C
       JPART = -1
C
C ISTART/IEND   = FIRST AND LAST PARTS OF CATAG TO USE ( - Z CHANNELS )
C
       ISTART = ISTMZ
       IEND   = IENDMZ
C
C IPOINT   IS A POINTER USED IN CONSTRUCTING THE CLUSTER MAP FOR OUTPUT
C
       IPOINT = 4
       HPZ    = IPOINT
C
C
C SORT   ADC'S BY SIZE ORDER  SORTED LIST IS IN SADC
C
    1  CALL TAGSR1(ISTART,IEND,ISHALL)
C
C FIND   ADDRESSES OF MEMBERS OF CLUSTERS
C
       ISHALL  = IWRITE
       CALL  TAGCLS(ISTART,IEND,THRESH,ISHALL)
C
       IF ( IWRITE .EQ. 1 ) WRITE(6,6001) NCLST,JPART
 6001  FORMAT(' TAGCLS FOUND ',I4,' CLUSTERS IN TAGGER JPART ',I4)
C
C SAVE   THE INFORMATION WE HAVE NOW FOR CLUSTERS ( NUMBER OF THEM )
C

       IF  ( JPART .EQ. -1 ) HCLZMI = NCLST
       IF  ( JPART .EQ.  1 ) HCLZPL = NCLST
C
*** PMF 15/10/99: new GOTO label introduced behind the 'END DO'-CONTINUE statement at label 10
*       IF  ( NCLST .EQ. 0 ) GOTO 10
       IF  ( NCLST .EQ. 0 ) GOTO 11
*** PMF (end)
C
C NOW  START  A LOOP OVER EACH CLUSTER IN TURN
C
       DO 10 I = 1,NCLST
          N  = N + 1
C
C SORT   EACH CLUSTER BY ENERGY ,PUT RESULT IN CLUS (9,2)
C
          CALL TAGSR2(I)
C
C CALCULATE   SUM OF ENERGY FOR CLUSTER , ANFD FILL ACLS
C      IPOINT  POINTS TO THE START OF CLUSTER N IN ACLS
C
          HMAP(1,N)  = IPOINT
C
C      FFADC  IS THE ADDRESS OF THE 'PARENT' OF THIS CLUSTER
C
          FFADC  = CMAP(I,1)
C
C      NNEI  IS THE NUMBER OF BLOCKS WHICH ARE NEIGHBOURS OF THIS BLOCK
C
          NNEI  = NLIST(FFADC,1,MARK)
C
C START   A LOOP OVER EACH MEMBER OF CLUSTER TO PUT THEM IN CLUSTER MAP
C AND  WORK  OUT SUM
C
          SUM  = 0
C
          DO 5 J = 1,NNEI
C
C      END  OF CLUSTER IF ENERGY OF THIS BLOCK IS ZERO
C
             IF  ( CLUS(J,2) .LE. 0 ) GOTO 5
             IHAPIN = IPOINT + IPOINT
C
C CONVERT   BACK FROM SOFTWARE ADDRESS TO HARDWARE ADDRESS
C TO REVERSE   ACTION TAKEN IN TAGADC (SOFTWARE ADDRESSES MAKE PROGRAM
C EASIER   TO WRITE AND READ)
C
             IADC  = CLUS(J,1)
             IHADC = TAGS2H(IADC)
C
C TAGS2H   RETURNS A VALUE OF - 1 IF IT CANT WORK OUT HARDWARE ADDRESS
C
             IF ( IHADC .EQ. -1 ) GOTO 5
C
C FILL   CLUSTER MAP - FIRST HALF WORD IS ADDRESS SECOND IS ENERGY
C
             HACLS(IHAPIN - 1) = IHADC
             HACLS(IHAPIN)     = CLUS(J,2)
C
C INCREMENT   POINTER   ALWAYS POINTS TO NEXT WORD TO BE FILLED
C
             IPOINT = IPOINT + 1
             SUM = SUM + CLUS(J,2)
 5        CONTINUE
C
          IF ( IWRITE .EQ. 1 ) WRITE(6,6005) N,JPART,SUM
 6005     FORMAT(1X,'THE ENERGY SUM FOR CLUSTER ',I4,
     1              ' IN JPART ',I4,'   IS ',F12.3)
C
C END  OF  LOOP OVER EACH MEMBER OF CLUSTER
C
C      HMAP(2,N)  IS WHERE TO FIND THE LAST MEMBER OF CLUSTER N IN ACLS
C
         HMAP(2,N)  = IPOINT - 1
C
C WORK   OUT POSITION OF CENTRE OF EACH CLUSTER
C
         CALL TAGPOS(SUM,ISHALL)
C
C WORK   OUT DIRECTION COSINES
C
         CALL TAGDIR(CAND(2 ) ,CAND(3 ) ,ZED,DX,DY,DZ)
C
C NOW  SAVE  INFORMATION FOR THIS CLUSTER
C
          IB = (N - 1) * HWPCL
          HIB = IB * 2
          HTAGG2(HIB + 1) = N
          HTAGG2(HIB + 2) = JPART
          ATAGG2(IB + 5)  = 0.001 * CAND(1 )
          ATAGG2(IB + 6)  = 0.001 * SIGEN
          ATAGG2(IB + 7)  = CAND(2)
          ATAGG2(IB + 8)  = CAND(3)
          ATAGG2(IB + 9)  = SIGX
          ATAGG2(IB + 10) = SIGY
          ATAGG2(IB + 11) = DX
          ATAGG2(IB + 12) = DY
          ATAGG2(IB + 13) = DZ
C
C END  OF  LOOP OVER EACH CLUSTER
C
   10  CONTINUE
*** PMF 15/10/99: new label added for a former GOTO statement
   11  CONTINUE
*** PMF (end) 
C
C SET  UP  FOR AND DO PLUS ZED
C
       JPART  = JPART + 2
       IF ( JPART .GT. 1 ) GOTO 15
       HIPZ   = IPOINT
       ZED    = PZED
       ISTART = ISTPZ
       IEND   = IENDPZ
       GOTO 1
C
   15  CONTINUE
C
C NOW  ALL  CLUSTERS IN - Z AND + Z HAVE BEEN FOUND AND THEIR PROPERTIES
C CALCULATED   - CALCULATE SOME MORE PROPERTIES OF THE EVENT AS A WHOLE
C
       HCLST  = HCLZPL + HCLZMI
       HNEUT  = HCLST
       HIPL   = IPOINT
       ACOLAN = 6.29316
C
C      NOW  DO ACCOLINEARITY CHECKS
C
C      FIRST  CHECK THERE ARE CLUSTERS EACH SIDE
C
*** PMF 15/10/99: new GOTO label introduced behind the 'END DO'-CONTINUE statement at label 20
*       IF ( ( HCLZMI .EQ. 0 ) .OR. ( HCLZPL .EQ. 0 ) ) GOTO 20
       IF ( ( HCLZMI .EQ. 0 ) .OR. ( HCLZPL .EQ. 0 ) ) GOTO 21
* PMF (end)
       EMAX  = 0
C
C FIND   THE CLUSTER IN - Z WITH GREATEST ENERGY (PROBABLY FIRST ONE)
C  MZMX   IS THE RECORD OF THIS (AS CLUSTER NUMBER IN TAGG/2)
C
       DO 16 I = 1,HCLZMI
          IB = (I - 1) * HWPCL
          EN = ATAGG2(IB + 5)
          IF ( EN .LT. EMAX ) GOTO 16
          EMAX = EN
          MZMX = I
   16  CONTINUE
C
C SIMILARLY    FOR + Z
C
       EMAX   = 0
       START  = HCLZMI + 1
       DO 17 I = START,HCLST
          IB = (I - 1) * HWPCL
          EN = ATAGG2(IB + 5)
          IF ( EN .LT. EMAX ) GOTO 17
          EMAX = EN
          PZMX = I
  17   CONTINUE
C
C FIND   THE ANGLE BETWEEN THE  LARGEST CLUSTERS IN + / - Z
C
       CALL TAGCOL(MZMX,PZMX,THETA)
       ACOLAN = THETA
C
C      NOW  FOR EACH CLUSTER IN - Z LOOK FOR A COLINEAR CLUSTER IN + Z
C
       START = HCLZMI + 1
C
       DO 20 I = 1,HCLZMI
C
          DO 22 J = START,HCLST
C
             CALL TAGCOL(I,J,THETA)
C
             IF ( THETA .LT. ANGCUT ) GOTO 22
C
C        COLINEAR PAIR FOUND   - FIRST COUNT HOW MANY THERE ARE
C
             HCOL = HCOL + 1
C
C TELL   - Z CLUSTER ABOUT ITS + Z PARTNER AND VICE VERSA
C
             HIB = 2 * ((I - 1) * HWPCL)
             HTAGG2(HIB + 5) = J
             HIB = 2 * ((J - 1) * HWPCL)
             HTAGG2(HIB + 5) = I
   22     CONTINUE
   20  CONTINUE
*** PMF 15/10/99: new label added for a former GOTO statement
   21  CONTINUE
*** PMF (end) 
       ATAGG0(28) = ACOLAN
C
C FILL   TP BNKS ICLST/IPOINT ARE LENGTHS OF BANKS TO CREATE
C TAGSTO   CREATES THE BOS BANKS 'ACLS' 'TAGG'/0,1,2
C
       ICLST  = HCLST
       CALL TAGSTO(ICLST,IPOINT,IERTAG)
       IF ( IERTAG .NE. 0 ) RETURN 2

       RETURN
C
  999  RETURN 1
       END

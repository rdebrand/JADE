C   12/03/84 406222054  MEMBER NAME  CLUSFN   (S)           FORTRAN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C
C
       SUBROUTINE CLUSFN(ISTART,IEND,THRESH,IWRITE)
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C THIS ROUTINE FINDS THE CLUSTERS IN THE TAGGING SYSTEM
C BY LOOKING FOR BLOCKS WITH LOTS OF ENERGY AND ASSUMING ALL
C ITS NEIGHBOURS ARE POTENTIAL MEMBERS OF THE CLUSTER AND THERFORE
C CAN'T BE PARENTS OF ANOTHER CLUSTER.
C
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
#include "comtag.for"
C
#include "cwktag.for"
C
       DIMENSION FOUND(90)
       DIMENSION FLIST(64)
C
C CLEAR CMAP,FOUND,FLIST
C
       DO  9 I = 1,10
          DO  9 J = 1,9
             CMAP(I,J) = 0.0
    9  CONTINUE
       NUM = IEND - ISTART + 1
       DO 1 N = 1,NUM
          FOUND(N)     = 0.0
          FLIST(N)     = 0.0
          FLIST(N + NUM) = 0.0
    1  CONTINUE
       NCLST = 0
       K     = 1
C
C
C MAIN LOOP >>
C
C
    4  DO 10 I = ISTMZ    ,IENDMZ
C
C CHECK IF WE HAVE ALREADY USED THIS ADC
C A 'PARENT' CANT BE THE NEIGHBOUR OF ANOTHER CLUSTER
C
          DO 5 J = 1,K
             IF ( SADC(I,1) .EQ. FOUND(J) ) GOTO 10
    5     CONTINUE
C
C CHECK IF ENERGY IS BELOW THRESHOLD TO CALL IT A CLUSTER
C
          IF ( SADC(I,2) .LT. THRESH ) GOTO 11
C
C CLUSTER FOUND - STORE THE INFORMATION
C
          NCLST = NCLST + 1
          IF ( NCLST .GT. 10 ) GOTO 999
C
C PARENT ADC IS FIRST MEMBER OF CLUSTER MAP
C
          CMAP(NCLST,1) = SADC(I,1)
C
C NO OF NEIGHBOURS = NNEI  FOUND FROM NEIGHBOUR LIST
C
          NFADC = SADC(I,1)
C
C
          NNEI = NLIST(NFADC,1,MARK)
C
C
          IELOOP = NNEI + 1
C
C NLIST 2 TO NLIST (2 + NNEI) CONTAIN THE ADDRESSES ( IN CATAG)
C OF NEIGHBOURS OF THIS 'PARENT'
C
          DO 20 L = 2, IELOOP
C
C ADC NO. OF NEIGHBOUR = NADC
C
             NADC = NLIST(NFADC,L,MARK)
C
C FILL CLUSTER MAP
C
             CMAP(NCLST,L) = NADC
C
C SAVE ADC ADDRESSES USED,SO THEY CANT BECOME PARENTSOF LATER CLUSTERS
C
             FOUND(K) = NADC
C
             K = K + 1
             IF ( K .GT. 90 ) GOTO 999
C
C COUNT NUMBER OF CLUSTERS FOR WHICH THIS IS A NEIGHBOUR
C END OF LOOP OVER NEIGHBOURS OF PARENT
C
             FLIST(NADC) = FLIST(NADC) + 1
C
   20     CONTINUE
C
   10  CONTINUE
C
   11  CONTINUE
C
       IF ( NCLST .LE. 1 ) GOTO 40
C
C
C FOR ADC'S IN MORE THAN ONE CLUSTER,DIVIDE ENERGY BY NUMBER OF CLUSTERS
C FOR WHICH IT IS A MEMBER
C
 1000  DO 30 I = ISTART,IEND
          IF ( FLIST(I) .LE. 1 ) GOTO 30
          CATAG(I) = CATAG(I) / FLIST(I)
   30  CONTINUE
C
   40  CONTINUE
       IF ( IWRITE .NE. 1 ) RETURN
       DO 50 I = 1,NCLST
          WRITE(6,602) CMAP(I,1) ,CMAP(I,2) ,CMAP(I,3) ,CMAP(I,4) ,
     *                 CMAP(I,5) ,CMAP(I,6) ,CMAP(I,7) ,CMAP(I,9 )
   50  CONTINUE
  602  FORMAT(9(2X,F10.2))
       RETURN
C
C
  999  WRITE(6,600)
  600  FORMAT(' WARNING MORE THAN 10 CLUSTERS FOUND BY CLUSFN ')
       GOTO 1000
       END

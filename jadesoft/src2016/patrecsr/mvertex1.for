C     MACRO FOR VERTEX-FIT ROUTINES
      COMMON /CWORK1/ NT,T(2000),NV,V(200),A(300),B(24),NTIND(20),S(20),
     +                CHITR(20),
     +                JTGOD(50),JTBAD(50),VSAVE(10),V2(20,20)
C
C  NOTE (JEO 23.3.97) THAT ORIGINAL MVERTEX1 HAS SOME DIFFERENCE
C    SEE F22KLE.VERTEX.S  LIBRARY
      DIMENSION IT(2),IV(8)     ! PMF 26/08/99 IV(2) changed to IV(8)
      EQUIVALENCE (T(1),IT(1)),(V(1),IV(1))

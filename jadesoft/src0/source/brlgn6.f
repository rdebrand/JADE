C   15/06/84 408162202  MEMBER NAME  BRLGN6   (SOURCE)      FORTRAN
      FUNCTION BRLGN6( EINC, COSTH, PHI )
C        FINE POSITION DEPENDENCE OF LG-GAIN IN BARREL-PART
C                            19-MAR-82  S.ODAKA
C        TEST VERSION FOR >83 DATA (SF6 LG AT THE CENTRAL PART)
C                            18.1.84  T.KAWAMOTO
C        PHI DEP.FOR SF6 INTRODUCED
C                            3.2.84   T.KAWAMOTO
C
      IMPLICIT INTEGER * 2 (H)
      COMMON /CLGDMS/ X0,RADIUS(6),RADSX0(6),THX0(4),
     1                ZEND(2),ZENDX0(2),ZWID(2),ZGAP(2),PHWID(2),
     2                ZECAP(4),ZECAPX(4),THECPX(2),
     3                ECXLST(24), ECYLST(24)
C
C   COUNTER WIDTH, AND BIN WIDTH OF PHI
      DATA CWPH/ 7.48E-2 /,BWPH/ 7.48E-3/
C
C   POSITION DEPENDENCE PARAMETERS ( = 1000*GAIN )
      DIMENSION HPD(150,5,3)
      DIMENSION HPD11(150),HPD12(150),HPD13(150),HPD14(150),HPD15(150)
      DIMENSION HPD21(150),HPD22(150),HPD23(150),HPD24(150),HPD25(150)
      DIMENSION HPD31(150),HPD32(150),HPD33(150),HPD34(150),HPD35(150)
      EQUIVALENCE (HPD(1,1,1),HPD11(1)),(HPD(1,2,1),HPD12(1)),
     &(HPD(1,3,1),HPD13(1)),(HPD(1,4,1),HPD14(1)),(HPD(1,5,1),HPD15(1))
      EQUIVALENCE (HPD(1,1,2),HPD21(1)),(HPD(1,2,2),HPD22(1)),
     &(HPD(1,3,2),HPD23(1)),(HPD(1,4,2),HPD24(1)),(HPD(1,5,2),HPD25(1))
      EQUIVALENCE (HPD(1,1,3),HPD31(1)),(HPD(1,2,3),HPD32(1)),
     &(HPD(1,3,3),HPD33(1)),(HPD(1,4,3),HPD34(1)),(HPD(1,5,3),HPD35(1))
      DIMENSION EPNT(3)
      DATA EPNT/ 7.,11.,17./, NEPNT/ 3/
C
      DATA HPD11/
     &   959, 967, 975, 987, 991,1000, 996, 987, 976, 968,
     &   948, 941, 941, 974, 987, 996, 997, 989, 981, 966,
     &   957, 958, 973, 988, 990, 986, 982, 976, 966, 961,
     &   964, 973, 977, 989, 985, 985, 979, 984, 981, 977,
     &   973, 976, 978, 989, 998,1002, 994, 986, 977, 981,
     &   980, 987, 994, 998,1003, 999, 998, 995, 987, 975,
     &   967, 974, 984, 989, 996,1000, 996, 996, 992, 990,
     &   985, 987, 994, 997, 999,1001,1003, 998, 995, 991,
     &   989, 985, 988, 993,1000, 998, 997, 993, 995, 994,
     &   995, 996, 998,1000,1002,1002,1006,1003,1001,1001,
     &   999,1001, 997,1002,1000, 999, 999,1004,1004,1005,
     &  1005,1004,1001, 999,1001,1001,1001,1003,1004,1001,
     &   996, 997, 999,1002, 999, 998, 992, 996, 994, 997,
     &  1002,1005,1007,1004,1005, 998, 998, 999,1004,1004,
     &  1002,1000,1000,1001,1005,1007,1005, 999, 998,1003/
      DATA HPD12/
     &   950, 955, 967, 978, 990, 987, 990, 982, 971, 960,
     &   940, 933, 946, 966, 982, 992, 989, 986, 971, 953,
     &   946, 948, 969, 981, 990, 981, 977, 972, 965, 956,
     &   956, 962, 978, 984, 988, 980, 979, 977, 977, 975,
     &   972, 970, 977, 984, 991, 991, 988, 975, 976, 974,
     &   977, 985, 988, 999, 996, 999, 994, 990, 982, 971,
     &   968, 970, 977, 986, 994, 994, 996, 990, 988, 984,
     &   977, 984, 985, 990, 991, 993, 998, 994, 992, 990,
     &   988, 988, 987, 993, 995, 998, 996, 996, 995, 993,
     &   993, 992, 997, 997, 998,1001, 997, 999, 996, 995,
     &   993, 992, 997, 999, 999,1000, 998,1002,1001,1001,
     &  1001,1004, 999,1000, 998,1002, 998,1000, 999, 996,
     &   995, 993, 998, 998, 997, 994, 995, 996, 998,1000,
     &   999,1002,1002,1004, 999, 999, 994, 997,1003,1003,
     &  1003,1000,1000,1002,1004,1008,1003, 998, 993, 997/
      DATA HPD13/
     &   931, 943, 949, 961, 970, 983, 975, 965, 956, 946,
     &   937, 923, 932, 962, 972, 977, 978, 971, 958, 935,
     &   924, 925, 948, 962, 971, 964, 967, 966, 958, 949,
     &   947, 951, 963, 973, 971, 968, 965, 976, 967, 966,
     &   962, 969, 966, 967, 978, 979, 973, 968, 965, 971,
     &   970, 970, 974, 984, 985, 986, 981, 984, 972, 966,
     &   955, 963, 968, 978, 983, 992, 987, 986, 978, 973,
     &   972, 973, 980, 981, 978, 983, 985, 991, 982, 985,
     &   980, 981, 983, 990, 990, 987, 987, 992, 995, 992,
     &   989, 991, 990, 991, 987, 993, 992, 993, 991, 990,
     &   989, 990, 989, 994, 991, 990, 994, 993, 995, 996,
     &   999, 996, 995, 988, 995, 994, 996, 990, 993, 992,
     &   992, 990, 990, 994, 994, 991, 993, 995,1000, 995,
     &   997, 998, 999, 998, 999, 994, 995, 993, 993,1001,
     &   996, 996, 995, 996,1002,1000, 998, 991, 988, 989/
      DATA HPD14/
     &   914, 926, 931, 955, 956, 958, 951, 946, 937, 929,
     &   911, 914, 924, 939, 955, 961, 966, 955, 943, 922,
     &   912, 909, 917, 939, 947, 951, 948, 950, 948, 939,
     &   931, 940, 948, 952, 947, 950, 950, 960, 959, 955,
     &   946, 947, 953, 957, 956, 962, 964, 963, 955, 954,
     &   949, 960, 963, 965, 961, 966, 966, 963, 954, 952,
     &   949, 952, 960, 967, 972, 978, 979, 975, 967, 963,
     &   960, 963, 971, 971, 971, 974, 973, 980, 982, 977,
     &   976, 973, 970, 972, 971, 973, 975, 979, 974, 974,
     &   978, 982, 981, 975, 977, 977, 978, 988, 982, 980,
     &   965, 975, 982, 983, 984, 983, 984, 985, 989, 983,
     &   989, 987, 989, 985, 984, 985, 984, 983, 982, 987,
     &   984, 982, 984, 981, 986, 982, 985, 990, 990, 992,
     &   989, 991, 992, 993, 992, 991, 987, 982, 984, 982,
     &   985, 986, 983, 990, 992, 994, 995, 985, 983, 982/
      DATA HPD15/
     &   906, 921, 927, 939, 946, 946, 945, 927, 925, 921,
     &   907, 912, 902, 939, 946, 954, 949, 954, 934, 925,
     &   901, 896, 907, 920, 928, 942, 935, 951, 936, 931,
     &   936, 931, 937, 928, 936, 926, 946, 949, 954, 943,
     &   942, 942, 942, 946, 954, 956, 963, 953, 954, 948,
     &   944, 945, 950, 953, 952, 947, 953, 952, 950, 937,
     &   935, 948, 947, 962, 963, 972, 968, 970, 962, 955,
     &   958, 957, 969, 970, 970, 963, 977, 972, 980, 971,
     &   971, 963, 959, 968, 957, 966, 957, 965, 970, 964,
     &   974, 972, 979, 966, 969, 969, 981, 981, 983, 970,
     &   970, 967, 973, 982, 975, 974, 981, 977, 982, 984,
     &   982, 982, 982, 972, 983, 974, 981, 973, 979, 981,
     &   982, 976, 974, 981, 980, 979, 979, 985, 985, 989,
     &   984, 990, 993, 988, 989, 990, 982, 981, 972, 976,
     &   981, 972, 987, 979, 987, 992, 984, 986, 981, 976/
      DATA HPD21/
     &   916, 934, 958, 987,1000,1005, 993, 979, 952, 942,
     &   933, 936, 952, 973, 986, 991, 995, 977, 950, 935,
     &   935, 942, 954, 969, 991, 996, 996, 984, 964, 944,
     &   941, 960, 978, 983, 984, 985, 981, 974, 969, 965,
     &   970, 979, 987, 993, 997, 990, 989, 977, 976, 960,
     &   965, 971, 988, 999,1008,1000, 987, 981, 977, 975,
     &   975, 976, 984, 984, 992, 995,1000, 994, 986, 979,
     &   982, 988, 990, 988, 992, 996, 991, 987, 989, 986,
     &   984, 989, 990, 999,1002,1005, 997, 988, 982, 983,
     &   985, 991, 994, 992, 990, 992, 994, 994, 990, 993,
     &   995, 992, 994, 997,1000,1000,1001, 999, 996, 991,
     &   991, 994, 996, 997, 997, 995, 991, 998, 997, 997,
     &   994, 996, 996, 996, 998,1004,1002,1002,1000,1001,
     &   999, 998,1000,1000,1006,1003, 999, 998, 998, 999,
     &   997, 997,1000, 997,1001,1000,1003, 998, 998, 995/
      DATA HPD22/
     &   911, 924, 938, 970, 993, 995, 982, 965, 937, 933,
     &   912, 924, 932, 958, 977, 992, 979, 968, 939, 930,
     &   921, 931, 936, 957, 971, 982, 980, 971, 954, 937,
     &   934, 947, 968, 976, 978, 980, 977, 964, 951, 950,
     &   954, 962, 970, 977, 986, 984, 976, 974, 966, 953,
     &   953, 964, 979, 995, 993, 993, 987, 975, 972, 968,
     &   970, 973, 978, 987, 988, 989, 992, 991, 981, 973,
     &   977, 980, 984, 983, 985, 984, 980, 984, 982, 982,
     &   980, 980, 985, 990, 995, 993, 991, 986, 979, 976,
     &   986, 992, 992, 990, 991, 991, 990, 983, 991, 988,
     &   996, 988, 991, 994, 995, 993, 992, 995, 990, 991,
     &   989, 989, 992, 998, 992, 995, 995, 998, 996, 993,
     &   990, 992, 989, 992, 996,1001,1000, 999, 996, 996,
     &   998, 994, 996, 996,1001,1000,1000, 995, 997, 994,
     &   995, 996, 997,1000, 999,1000, 998, 998, 996, 994/
      DATA HPD23/
     &   894, 913, 930, 967, 962, 981, 961, 944, 921, 917,
     &   903, 902, 907, 946, 954, 975, 970, 947, 931, 918,
     &   905, 896, 911, 937, 950, 952, 948, 950, 937, 929,
     &   920, 935, 944, 942, 963, 969, 954, 947, 936, 935,
     &   939, 945, 952, 956, 963, 967, 970, 954, 954, 949,
     &   950, 952, 967, 971, 978, 979, 968, 970, 959, 952,
     &   954, 958, 971, 972, 974, 978, 978, 978, 974, 963,
     &   962, 964, 973, 973, 973, 970, 971, 978, 973, 976,
     &   970, 976, 974, 970, 977, 983, 983, 977, 973, 972,
     &   983, 988, 988, 986, 984, 981, 983, 975, 974, 981,
     &   983, 980, 975, 981, 984, 985, 984, 988, 985, 983,
     &   980, 985, 984, 989, 993, 992, 993, 995, 992, 986,
     &   984, 982, 982, 979, 986, 993, 994, 990, 988, 987,
     &   989, 988, 987, 987, 990, 990, 985, 984, 988, 990,
     &   987, 989, 992, 991, 994, 994, 993, 990, 990, 987/
      DATA HPD24/
     &   867, 900, 888, 929, 959, 960, 941, 926, 920, 906,
     &   895, 898, 886, 908, 940, 944, 947, 936, 921, 902,
     &   884, 874, 901, 918, 941, 937, 935, 929, 913, 902,
     &   908, 924, 912, 936, 933, 943, 955, 931, 929, 925,
     &   927, 932, 926, 939, 942, 942, 945, 956, 950, 939,
     &   939, 943, 953, 961, 960, 958, 964, 941, 931, 941,
     &   952, 946, 950, 961, 964, 959, 959, 955, 957, 956,
     &   945, 954, 954, 959, 950, 948, 959, 965, 967, 964,
     &   963, 963, 951, 965, 952, 966, 966, 967, 965, 964,
     &   975, 978, 977, 972, 977, 973, 967, 965, 972, 977,
     &   976, 961, 964, 968, 976, 974, 977, 976, 983, 975,
     &   974, 971, 976, 977, 978, 982, 981, 982, 983, 976,
     &   978, 975, 974, 972, 976, 976, 981, 974, 979, 977,
     &   979, 980, 975, 975, 978, 981, 978, 981, 975, 986,
     &   982, 983, 986, 985, 983, 982, 981, 981, 973, 975/
      DATA HPD25/
     &   844, 902, 888, 938, 930, 942, 944, 920, 907, 932,
     &   890, 897, 882, 916, 909, 938, 931, 928, 920, 896,
     &   866, 852, 880, 933, 934, 923, 933, 910, 906, 895,
     &   898, 913, 912, 908, 916, 948, 928, 929, 928, 931,
     &   933, 920, 941, 920, 922, 944, 928, 949, 941, 949,
     &   944, 937, 955, 942, 959, 953, 945, 925, 936, 923,
     &   942, 939, 947, 940, 958, 950, 943, 953, 942, 949,
     &   941, 942, 946, 950, 934, 950, 943, 967, 959, 956,
     &   958, 961, 947, 946, 948, 955, 966, 953, 964, 960,
     &   971, 972, 967, 968, 966, 966, 963, 961, 970, 968,
     &   969, 954, 952, 956, 971, 970, 974, 978, 973, 972,
     &   967, 967, 964, 973, 974, 970, 977, 974, 976, 972,
     &   977, 970, 974, 963, 967, 970, 968, 973, 964, 973,
     &   973, 975, 969, 970, 971, 974, 971, 968, 979, 978,
     &   981, 981, 979, 977, 978, 978, 973, 978, 964, 961/
      DATA HPD31/
     &   898, 925, 951, 985, 996,1006, 995, 977, 948, 922,
     &   898, 893, 921, 962, 983, 988, 978, 957, 936, 918,
     &   927, 934, 966, 979, 989, 982, 978, 957, 939, 929,
     &   944, 960, 975, 991,1004,1000, 991, 979, 959, 944,
     &   942, 955, 979,1004,1011,1012, 992, 975, 961, 954,
     &   959, 967, 979, 996,1005,1007, 999, 984, 968, 959,
     &   962, 973, 983, 992, 997, 996, 992, 988, 985, 979,
     &   977, 983, 988, 996, 995,1001,1003,1002, 994, 991,
     &   990, 990, 994,1003,1007,1002,1000, 997, 994, 992,
     &   993, 991, 995, 997, 998,1002, 997, 997, 997, 998,
     &   995, 993, 995, 999,1002,1002,1002, 999, 995, 993,
     &   993,1000,1001,1004,1004,1005,1007,1006,1005,1004,
     &  1000, 997,1000,1006,1006,1004,1004,1007,1004,1002,
     &  1002,1003,1003,1004,1006,1007,1012,1011,1010,1009,
     &  1009,1011,1009,1009,1007,1008,1009,1009,1007,1003/
      DATA HPD32/
     &   892, 911, 932, 963, 978, 983, 986, 966, 939, 916,
     &   895, 894, 920, 963, 981, 970, 961, 939, 921, 907,
     &   904, 919, 941, 963, 974, 973, 964, 947, 929, 923,
     &   936, 948, 971, 980, 986, 986, 983, 963, 952, 937,
     &   939, 944, 968, 993,1003, 996, 984, 967, 953, 949,
     &   952, 958, 971, 982, 997,1002, 992, 978, 965, 955,
     &   961, 964, 973, 976, 990, 988, 987, 981, 975, 970,
     &   972, 976, 979, 985, 987, 994, 994, 994, 987, 983,
     &   984, 980, 987, 989, 994, 993, 992, 990, 989, 989,
     &   987, 988, 987, 993, 995, 995, 995, 991, 991, 992,
     &   992, 990, 993, 997, 996, 999, 997, 997, 992, 992,
     &   993, 993, 997, 996, 999,1001,1001, 999,1001,1000,
     &   998, 996, 999,1004,1002,1002, 999,1001,1003,1002,
     &  1001,1000,1001,1002,1003,1005,1007,1008,1008,1006,
     &  1006,1006,1008,1007,1006,1005,1008,1007,1005,1002/
      DATA HPD33/
     &   881, 898, 913, 927, 945, 955, 962, 946, 931, 910,
     &   889, 852, 873, 909, 935, 956, 944, 925, 900, 891,
     &   899, 892, 911, 928, 957, 959, 951, 937, 916, 911,
     &   920, 925, 941, 952, 963, 967, 959, 952, 927, 925,
     &   925, 936, 945, 962, 979, 980, 966, 949, 943, 945,
     &   947, 951, 955, 962, 980, 979, 982, 960, 954, 945,
     &   949, 946, 960, 968, 972, 975, 970, 965, 959, 959,
     &   956, 964, 964, 966, 972, 976, 983, 981, 975, 973,
     &   974, 973, 969, 976, 979, 978, 977, 976, 975, 978,
     &   978, 977, 978, 981, 987, 984, 981, 976, 980, 983,
     &   984, 985, 983, 987, 987, 988, 990, 989, 986, 982,
     &   985, 987, 986, 985, 986, 990, 990, 990, 992, 994,
     &   994, 992, 992, 995, 996, 993, 991, 993, 997, 997,
     &   997, 995, 994, 997, 999,1001,1004,1001,1000,1001,
     &  1000,1003,1001,1004,1000,1003, 999, 996, 995, 991/
      DATA HPD34/
     &   869, 877, 891, 910, 926, 928, 933, 926, 910, 880,
     &   852, 844, 833, 881, 906, 928, 921, 903, 875, 874,
     &   863, 873, 885, 916, 923, 930, 923, 915, 905, 898,
     &   890, 905, 921, 924, 927, 930, 943, 925, 912, 913,
     &   915, 910, 917, 934, 941, 948, 947, 938, 936, 924,
     &   933, 925, 934, 936, 953, 956, 950, 944, 941, 935,
     &   924, 932, 938, 945, 955, 959, 954, 958, 942, 943,
     &   937, 942, 947, 954, 951, 954, 959, 968, 966, 950,
     &   945, 947, 952, 947, 958, 967, 967, 963, 959, 958,
     &   960, 963, 963, 963, 964, 975, 964, 963, 964, 975,
     &   973, 968, 973, 972, 974, 979, 978, 972, 968, 961,
     &   979, 975, 972, 967, 973, 980, 977, 984, 981, 989,
     &   985, 983, 984, 986, 984, 980, 980, 987, 989, 995,
     &   992, 985, 987, 986, 991, 990, 988, 990, 990, 992,
     &   991, 991, 993, 994, 990, 992, 989, 986, 983, 981/
      DATA HPD35/
     &   858, 872, 882, 898, 916, 905, 931, 904, 899, 874,
     &   851, 827, 816, 847, 874, 917, 920, 895, 872, 860,
     &   864, 874, 874, 894, 924, 916, 918, 903, 905, 878,
     &   892, 870, 896, 909, 899, 930, 920, 919, 904, 897,
     &   909, 907, 905, 895, 937, 925, 935, 936, 917, 932,
     &   920, 917, 928, 915, 933, 940, 927, 940, 918, 928,
     &   917, 914, 933, 940, 954, 938, 951, 941, 943, 929,
     &   928, 934, 935, 947, 937, 948, 948, 960, 952, 940,
     &   941, 936, 932, 950, 946, 964, 963, 952, 951, 944,
     &   958, 953, 949, 958, 958, 957, 955, 956, 956, 968,
     &   963, 967, 956, 965, 968, 968, 971, 964, 951, 959,
     &   961, 969, 969, 958, 963, 971, 974, 977, 980, 983,
     &   981, 977, 979, 973, 978, 972, 977, 976, 992, 990,
     &   985, 982, 979, 980, 980, 988, 980, 989, 978, 993,
     &   983, 993, 985, 989, 987, 987, 980, 980, 971, 972/
C
      DIMENSION IP(2),FP(2)
      DATA INIT/0/
C
      DIMENSION HPHI(5)
      DATA HPHI/957,949,947,942,936/
      DIMENSION HTHE(30)
      DATA HTHE/977,982,986,990,993,994,994,993,991,987,
     &          984,979,977,981,984,986,986,984,982,977,
     &          974,979,983,986,986,985,983,980,976,970/
C
C -- INITIALIZATION
C
      IF( INIT.NE.0 ) GOTO 1
      INIT= 1
C
C   BIN WIDTH OF Z
      BWZ= ( ZWID(1) +ZGAP(1) )/10.
C   EDIT GAIN TABLE
C    GAIN CONST -> HCENT FOR CENTRAL PART
C      HCENT=960
C
       DO 11 K=1,3
        DO 11 J=1,5
            HCENT=HPHI(J)
          DO 12 I=1,30
            RTH=HTHE(I)
            RTH=RTH/1000.
            HPD(I,J,K)=HCENT*RTH
12        CONTINUE
           MAX=0
          DO 13 I=31,40
           IF(HPD(I,J,K).LT.MAX) GO TO 13
            MAX=HPD(I,J,K)
            IMAX=I
13        CONTINUE
         A=(MAX-HPD(30,J,K))/(IMAX-30)
          DO 14 I=31,IMAX
           HPD(I,J,K)=HPD(30,J,K)+A*(I-30)
14        CONTINUE
11    CONTINUE
      WRITE(6,6000)
 6000 FORMAT(/' NEW LG CALIBRATION(VALID FOR <G733) IS USED.'
     1        '   INITIALIZATION FINISHED.')
C
C ---------------------------------------------
    1 CONTINUE
      BRLGN6= 1.
      IF( EINC.LT.0. ) RETURN
C
C -- ENERGY-BIN
C
      DE= 0.
      DO 30 IE2=1,NEPNT
       IF( EINC.LT.EPNT(IE2) ) GOTO 5
   30 CONTINUE
      IE2= NEPNT +1
    5 IE1= IE2 -1
      IF( IE1.EQ.0 ) GOTO 6
      IF( IE1.EQ.NEPNT ) GOTO 7
      DE= ( EINC -EPNT(IE1) )/( EPNT(IE2) -EPNT(IE1) )
      GOTO 7
C
    6 DE= EINC/EPNT(1)
C
    7 CONTINUE
C
C -- Z-BIN
C
      Z= RADIUS(4)*COSTH/SQRT( 1. -COSTH**2 )
      RZ= ABS( Z )/BWZ
      IZ1= RZ +.5
      DZ= RZ -IZ1 +.5
      IF( IZ1.GT.150 ) IZ1= 150
      IZ2= IZ1 +1
      IF( IZ1.LT.1 ) IZ1= 1
      IF( IZ2.GT.150 ) IZ2= 150
C
C -- PHI-BIN
C
      IPC= PHI/CWPH
      IF( IPC.LT.0 ) IPC= 0
      IF( IPC.GT.83 ) IPC= 83
      RP= ABS( PHI -CWPH*( IPC +0.5 ) )/BWPH
      IF( RP.GT.5. ) RP= 5.
      IP(1)= RP +.5
      DP= RP -IP(1) +.5
      IP(2)= IP(1) +1
      IF( IP(1).LT.1 ) IP(1)= 1
      IF( IP(2).GT.5 ) IP(2)= 5
C
C -- INTERPOLATION
C
C   LOWER ENERGY POINT
      IF( IE1.EQ.0 ) GOTO 2
      DO 10 I=1,2
   10 FP(I)= ( 1. -DZ )*HPD(IZ1,IP(I),IE1)/1000.
     &              +DZ*HPD(IZ2,IP(I),IE1)/1000.
      BRLGN6= ( 1. -DP )*FP(1) +DP*FP(2)
C
C   HIGHER ENERGY POINT
      IF( IE1.EQ.NEPNT ) RETURN
    2 DO 20 I=1,2
   20 FP(I)= ( 1. -DZ )*HPD(IZ1,IP(I),IE2)/1000.
     &              +DZ*HPD(IZ2,IP(I),IE2)/1000.
      FHE= ( 1. -DP )*FP(1) +DP*FP(2)
C
      BRLGN6= ( 1. -DE )*BRLGN6 +DE*FHE
      RETURN
C
      END

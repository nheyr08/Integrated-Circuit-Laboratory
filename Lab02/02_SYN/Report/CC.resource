 
****************************************
Report : resources
Design : CC
Version: T-2022.03
Date   : Mon Jan 22 13:39:54 2024
****************************************


Resource Report for this hierarchy in file ../01_RTL/CC.v
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| ne_x_1         | DW_cmp         | width=8    | ne_99 (CC.v:99)            |
| eq_x_2         | DW_cmp         | width=8    | eq_110_2 (CC.v:110)        |
| sub_x_3        | DW01_sub       | width=9    | sub_95 (CC.v:95)           |
| sub_x_4        | DW01_sub       | width=9    | sub_96 (CC.v:96)           |
| sub_x_5        | DW01_sub       | width=9    | sub_97 (CC.v:97)           |
| add_x_6        | DW01_inc       | width=8    | add_100 (CC.v:100)         |
| div_7          | DW_div_tc      | a_width=17 | div_103 (CC.v:103)         |
|                |                | b_width=9  |                            |
| rem_8          | DW_div_tc      | a_width=17 | rem_104 (CC.v:104)         |
|                |                | b_width=9  |                            |
| ne_x_10        | DW_cmp         | width=17   | ne_104_2 (CC.v:104)        |
| div_11         | DW_div_tc      | a_width=17 | div_107 (CC.v:107)         |
|                |                | b_width=9  |                            |
| rem_12         | DW_div_tc      | a_width=17 | rem_108 (CC.v:108)         |
|                |                | b_width=9  |                            |
| ne_x_14        | DW_cmp         | width=17   | ne_108_2 (CC.v:108)        |
| lt_x_16        | DW_cmp         | width=24   | lt_128 (CC.v:128)          |
| eq_x_63        | DW_cmp         | width=8    | eq_110 (CC.v:110)          |
|                |                |            | eq_99 (CC.v:99)            |
| DP_OP_137J1_122_2062            |            |                            |
|                | DP_OP_137J1_122_2062 |      |                            |
| DP_OP_138J1_123_7750            |            |                            |
|                | DP_OP_138J1_123_7750 |      |                            |
| DP_OP_139J1_124_9407            |            |                            |
|                | DP_OP_139J1_124_9407 |      |                            |
| DP_OP_140J1_125_7823            |            |                            |
|                | DP_OP_140J1_125_7823 |      |                            |
| DP_OP_134J1_127_9139            |            |                            |
|                | DP_OP_134J1_127_9139 |      |                            |
| DP_OP_135J1_128_2894            |            |                            |
|                | DP_OP_135J1_128_2894 |      |                            |
=============================================================================

Datapath Report for DP_OP_137J1_122_2062
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_137J1_122_2062 | sub_101 (CC.v:101) mult_102 (CC.v:102)              |
|                      | mult_106 (CC.v:106)                                 |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 8     |                                          |
| I2    | PI   | Signed   | 8     |                                          |
| I3    | PI   | Signed   | 9     |                                          |
| I4    | PI   | Signed   | 9     |                                          |
| T8    | IFO  | Signed   | 9     | I1 - I2 (CC.v:101)                       |
| O1    | PO   | Signed   | 17    | I3 * T8 (CC.v:102)                       |
| O2    | PO   | Signed   | 17    | I4 * T8 (CC.v:106)                       |
==============================================================================

Datapath Report for DP_OP_138J1_123_7750
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_138J1_123_7750 | mult_121_5 (CC.v:121) add_121_4 (CC.v:121)          |
|                      | add_121_5 (CC.v:121) add_121_6 (CC.v:121)           |
|                      | add_121 (CC.v:121) add_121_2 (CC.v:121)             |
|                      | add_121_3 (CC.v:121) sub_121 (CC.v:121)             |
|                      | mult_121_6 (CC.v:121) mult_121_7 (CC.v:121)         |
|                      | mult_121_8 (CC.v:121) mult_121 (CC.v:121)           |
|                      | mult_121_2 (CC.v:121) mult_121_3 (CC.v:121)         |
|                      | mult_121_4 (CC.v:121) add_div_121 (CC.v:121)        |
|                      | sub_122 (CC.v:122)                                  |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 8     |                                          |
| I2    | PI   | Signed   | 8     |                                          |
| I3    | PI   | Signed   | 8     |                                          |
| I4    | PI   | Signed   | 8     |                                          |
| I5    | PI   | Signed   | 8     |                                          |
| I6    | PI   | Signed   | 8     |                                          |
| I7    | PI   | Signed   | 8     |                                          |
| I8    | PI   | Signed   | 8     |                                          |
| I9    | PI   | Unsigned | 1     |                                          |
| T33   | IFO  | Signed   | 16    | I1 * I2 (CC.v:121)                       |
| T34   | IFO  | Signed   | 16    | I3 * I4 (CC.v:121)                       |
| T36   | IFO  | Signed   | 16    | I5 * I6 (CC.v:121)                       |
| T38   | IFO  | Signed   | 16    | I7 * I8 (CC.v:121)                       |
| T26   | IFO  | Signed   | 16    | I8 * I3 (CC.v:121)                       |
| T27   | IFO  | Signed   | 16    | I2 * I5 (CC.v:121)                       |
| T29   | IFO  | Signed   | 16    | I4 * I7 (CC.v:121)                       |
| T31   | IFO  | Signed   | 16    | I6 * I1 (CC.v:121)                       |
| T113  | IFO  | Signed   | 17    | O1[17:1]                                 |
| T114  | IFO  | Signed   | 16    | O2[15:0]                                 |
| O1    | PO   | Signed   | 20    | -T33 - T34 - T36 - T38 + T26 + T27 + T29 + T31 (CC.v:121) |
| O2    | PO   | Unsigned | 17    | I9 + T113 (CC.v:121)                     |
| O3    | PO   | Signed   | 16    | $signed(1'b0) - T114 (CC.v:122)          |
==============================================================================

Datapath Report for DP_OP_139J1_124_9407
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_139J1_124_9407 | sub_125_3 (CC.v:125) sub_126 (CC.v:126)             |
|                      | mult_pow_125_3 (CC.v:125) add_125_2 (CC.v:125)      |
|                      | mult_pow_125_4 (CC.v:125) sub_125_4 (CC.v:125)      |
|                      | sub_126_3 (CC.v:126) mult_126_2 (CC.v:126)          |
|                      | sub_126_4 (CC.v:126) sub_126_5 (CC.v:126)           |
|                      | mult_126 (CC.v:126) sub_126_2 (CC.v:126)            |
|                      | mult_pow_126 (CC.v:126) eq_130 (CC.v:130)           |
|                      | mult_125 (CC.v:125) add_125 (CC.v:125)              |
|                      | mult_pow_125 (CC.v:125) sub_125 (CC.v:125)          |
|                      | mult_pow_125_2 (CC.v:125) sub_125_2 (CC.v:125)      |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 8     |                                          |
| I2    | PI   | Signed   | 8     |                                          |
| I3    | PI   | Signed   | 8     |                                          |
| I4    | PI   | Signed   | 8     |                                          |
| I5    | PI   | Signed   | 8     |                                          |
| I6    | PI   | Signed   | 8     |                                          |
| I7    | PI   | Signed   | 8     |                                          |
| I8    | PI   | Signed   | 8     |                                          |
| T49   | IFO  | Signed   | 9     | I1 - I2 ( CC.v:125 CC.v:126 )            |
| T56   | IFO  | Signed   | 9     | I6 - I3 (CC.v:126)                       |
| T57   | IFO  | Signed   | 18    | T49 * T56 (CC.v:126)                     |
| T51   | IFO  | Signed   | 9     | I3 - I4 ( CC.v:125 CC.v:126 )            |
| T59   | IFO  | Signed   | 9     | I5 - I1 (CC.v:126)                       |
| T60   | IFO  | Signed   | 18    | T51 * T59 (CC.v:126)                     |
| T61   | IFO  | Signed   | 19    | T57 - T60 (CC.v:126)                     |
| T44   | IFO  | Signed   | 9     | I7 - I5 (CC.v:125)                       |
| T45   | IFO  | Signed   | 18    | T44 * T44 (CC.v:125)                     |
| T46   | IFO  | Signed   | 9     | I8 - I6 (CC.v:125)                       |
| T47   | IFO  | Signed   | 18    | T46 * T46 (CC.v:125)                     |
| T48   | IFO  | Signed   | 19    | T45 + T47 (CC.v:125)                     |
| T50   | IFO  | Signed   | 18    | T49 * T49 (CC.v:125)                     |
| T52   | IFO  | Signed   | 18    | T51 * T51 (CC.v:125)                     |
| T53   | IFO  | Signed   | 19    | T50 + T52 (CC.v:125)                     |
| O1    | PO   | Signed   | 24    | T61 * T61 (CC.v:126)                     |
| O2    | PO   | Unsigned | 1     | $unsigned(O1) == $unsigned(O3) (CC.v:130) |
| O3    | PO   | Signed   | 24    | T48 * T53 (CC.v:125)                     |
==============================================================================

Datapath Report for DP_OP_140J1_125_7823
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_140J1_125_7823 | add_107 (CC.v:107) sub_109_aco (CC.v:109)           |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 8     |                                          |
| I2    | PI   | Signed   | 8     |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Signed   | 8     | I1 + I2 - I3 ( CC.v:107 CC.v:109 )       |
==============================================================================

Datapath Report for DP_OP_134J1_127_9139
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_134J1_127_9139 | add_103 (CC.v:103) sub_105_aco (CC.v:105)           |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 8     |                                          |
| I2    | PI   | Signed   | 8     |                                          |
| I3    | PI   | Unsigned | 1     |                                          |
| O1    | PO   | Signed   | 8     | I1 + I2 - I3 ( CC.v:103 CC.v:105 )       |
==============================================================================

Datapath Report for DP_OP_135J1_128_2894
==============================================================================
| Cell                 | Contained Operations                                |
==============================================================================
| DP_OP_135J1_128_2894 | add_116 (CC.v:116)                                  |
==============================================================================

==============================================================================
|       |      | Data     |       |                                          |
| Var   | Type | Class    | Width | Expression                               |
==============================================================================
| I1    | PI   | Signed   | 8     |                                          |
| O1    | PO   | Unsigned | 8     | I1 + $unsigned(1'b1) (CC.v:116)          |
==============================================================================


Resource Report for Ungrouped Hierarchy div_7
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy rem_8
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy rem_12
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Resource Report for Ungrouped Hierarchy div_11
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
=============================================================================


Datapath Extraction Report

Information: Operator associated with resources 'add_100 (CC.v:100)' in design 'CC' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'sub_101 (CC.v:101)'.  (HDL-120)

Information: Operator associated with resources 'mult_102 (CC.v:102)' in design 'CC' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'lt_104 (CC.v:104)'.  (HDL-120)

Information: Operator associated with resources 'mult_106 (CC.v:106)' in design 'CC' breaks the datapath extraction because there is leakage due to truncation on its fanout to operator of resources 'lt_108 (CC.v:108)'.  (HDL-120)

Information: Operator associated with resources 'lt_122 (CC.v:122)' in design 'CC' breaks the datapath extraction because there is leakage due to truncation on the fanout of its driver 'add_div_121 (CC.v:121)'.  (HDL-120)

Information: Operator associated with resources 'lt_128 (CC.v:128)' in design 'CC' breaks the datapath extraction because there is leakage due to truncation on the fanout of its driver 'mult_pow_126 (CC.v:126)'.  (HDL-120)


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| ne_x_1             | DW_cmp           | apparch (area)     |                |
| eq_x_2             | DW_cmp           | apparch (area)     |                |
| sub_x_3            | DW01_sub         | apparch (area)     |                |
| sub_x_4            | DW01_sub         | apparch (area)     |                |
| sub_x_5            | DW01_sub         | apparch (area)     |                |
| add_x_6            | DW01_inc         | pparch (speed)     |                |
| div_7              | DW_div_tc        | mlt                |                |
| rem_8              | DW_div_tc        | mlt                |                |
| ne_x_10            | DW_cmp           | apparch (area)     |                |
| div_11             | DW_div_tc        | mlt                |                |
| rem_12             | DW_div_tc        | mlt                |                |
| ne_x_14            | DW_cmp           | apparch (area)     |                |
| lt_x_16            | DW_cmp           | pparch (speed)     |                |
| eq_x_63            | DW_cmp           | apparch (area)     |                |
| DP_OP_137J1_122_2062                  |                    |                |
|                    | DP_OP_137J1_122_2062 | str (area,speed)                |
|                    |                  | mult_arch: benc_radix4              |
|                    |                  | mult_arch: benc_radix4              |
| DP_OP_138J1_123_7750                  |                    |                |
|                    | DP_OP_138J1_123_7750 | str (area,speed)                |
|                    |                  | mult_arch: benc_radix4              |
| DP_OP_139J1_124_9407                  |                    |                |
|                    | DP_OP_139J1_124_9407 | str (area,speed)                |
|                    |                  | mult_arch: benc_radix4              |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: and     |                |
|                    |                  | mult_arch: benc_radix4              |
| DP_OP_140J1_125_7823                  |                    |                |
|                    | DP_OP_140J1_125_7823 | str (area,speed)                |
| DP_OP_134J1_127_9139                  |                    |                |
|                    | DP_OP_134J1_127_9139 | str (area,speed)                |
| DP_OP_135J1_128_2894                  |                    |                |
|                    | DP_OP_135J1_128_2894 | str (area)     |                |
===============================================================================

1

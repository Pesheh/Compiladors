package Kobal_Shift_Reduce is

    type Small_Integer is range -32_000 .. 32_000;

    type Shift_Reduce_Entry is record
        T   : Small_Integer;
        Act : Small_Integer;
    end record;
    pragma Pack(Shift_Reduce_Entry);

    subtype Row is Integer range -1 .. Integer'Last;

  --pragma suppress(index_check);

    type Shift_Reduce_Array is array (Row  range <>) of Shift_Reduce_Entry;

    Shift_Reduce_Matrix : constant Shift_Reduce_Array :=
        ( (-1,-1) -- Dummy Entry

-- state  0
,( 2, 2),(-1,-3000)
-- state  1
,(-1,-1)
-- state  2
,( 35, 4)
,(-1,-3000)
-- state  3
,( 0,-3001),(-1,-3000)
-- state  4
,( 38, 7)
,(-1,-19)
-- state  5
,( 3, 8),(-1,-3000)
-- state  6
,(-1,-3000)

-- state  7
,( 35, 12),(-1,-3000)
-- state  8
,(-1,-4)
-- state  9
,( 25, 15)
,( 37, 14),(-1,-3000)
-- state  10
,(-1,-21)
-- state  11
,( 22, 16)
,( 23, 17),(-1,-3000)
-- state  12
,(-1,-26)
-- state  13
,( 2, 2)
,( 4, 24),( 8, 23),( 35, 12),(-1,-3000)

-- state  14
,(-1,-18)
-- state  15
,( 35, 12),(-1,-3000)
-- state  16
,( 12, 27)
,( 13, 28),(-1,-3000)
-- state  17
,( 35, 30),(-1,-3000)

-- state  18
,(-1,-5)
-- state  19
,(-1,-6)
-- state  20
,(-1,-7)
-- state  21
,(-1,-8)

-- state  22
,( 22, 31),( 23, 17),(-1,-3000)
-- state  23
,( 35, 32)
,(-1,-3000)
-- state  24
,( 14, 34),( 16, 40),( 18, 41)
,( 35, 43),(-1,-3000)
-- state  25
,(-1,-3)
-- state  26
,(-1,-20)

-- state  27
,(-1,-23)
-- state  28
,(-1,-24)
-- state  29
,( 35, 45),(-1,-3000)

-- state  30
,(-1,-25)
-- state  31
,( 6, 46),( 35, 47),(-1,-3000)

-- state  32
,( 3, 48),(-1,-3000)
-- state  33
,( 16, 40),( 18, 41)
,( 35, 43),(-1,-32)
-- state  34
,( 25, 50),(-1,-3000)

-- state  35
,(-1,-35)
-- state  36
,(-1,-36)
-- state  37
,(-1,-37)
-- state  38
,(-1,-38)

-- state  39
,(-1,-39)
-- state  40
,( 30, 55),( 34, 54),( 35, 43)
,( 36, 59),( 38, 58),(-1,-3000)
-- state  41
,( 30, 55)
,( 34, 54),( 35, 43),( 36, 59),( 38, 58)
,(-1,-3000)
-- state  42
,( 21, 63),( 25, 62),(-1,-3000)

-- state  43
,(-1,-47)
-- state  44
,( 5, 65),(-1,-3000)
-- state  45
,(-1,-22)

-- state  46
,( 35, 66),(-1,-3000)
-- state  47
,( 25, 67),(-1,-3000)

-- state  48
,( 7, 68),( 9, 69),( 10, 70),(-1,-3000)

-- state  49
,(-1,-34)
-- state  50
,(-1,-33)
-- state  51
,( 26, 72),(-1,-50)

-- state  52
,( 27, 73),(-1,-51)
-- state  53
,( 26, 74),( 27, 75)
,( 28, 76),( 29, 77),( 30, 78),( 31, 79)
,( 32, 80),( 33, 81),(-1,-52)
-- state  54
,( 35, 43)
,( 36, 59),( 38, 58),(-1,-3000)
-- state  55
,( 35, 43)
,( 36, 59),( 38, 58),(-1,-3000)
-- state  56
,(-1,-65)

-- state  57
,(-1,-66)
-- state  58
,( 30, 55),( 34, 54),( 35, 43)
,( 36, 59),( 38, 58),(-1,-3000)
-- state  59
,(-1,-68)

-- state  60
,( 17, 85),(-1,-3000)
-- state  61
,( 19, 86),(-1,-3000)

-- state  62
,(-1,-43)
-- state  63
,( 30, 55),( 34, 54),( 35, 43)
,( 36, 59),( 38, 58),(-1,-3000)
-- state  64
,( 24, 88)
,( 38, 89),(-1,-45)
-- state  65
,( 2, 91),(-1,-3000)

-- state  66
,( 21, 92),(-1,-3000)
-- state  67
,(-1,-10)
-- state  68
,( 35, 93)
,(-1,-3000)
-- state  69
,( 35, 12),(-1,-3000)
-- state  70
,( 38, 99)
,(-1,-3000)
-- state  71
,(-1,-11)
-- state  72
,( 30, 55),( 34, 54)
,( 35, 43),( 36, 59),( 38, 58),(-1,-3000)

-- state  73
,( 30, 55),( 34, 54),( 35, 43),( 36, 59)
,( 38, 58),(-1,-3000)
-- state  74
,( 30, 55),( 34, 54)
,( 35, 43),( 36, 59),( 38, 58),(-1,-3000)

-- state  75
,( 30, 55),( 34, 54),( 35, 43),( 36, 59)
,( 38, 58),(-1,-3000)
-- state  76
,( 30, 55),( 34, 54)
,( 35, 43),( 36, 59),( 38, 58),(-1,-3000)

-- state  77
,( 30, 55),( 34, 54),( 35, 43),( 36, 59)
,( 38, 58),(-1,-3000)
-- state  78
,( 30, 55),( 34, 54)
,( 35, 43),( 36, 59),( 38, 58),(-1,-3000)

-- state  79
,( 30, 55),( 34, 54),( 35, 43),( 36, 59)
,( 38, 58),(-1,-3000)
-- state  80
,( 30, 55),( 34, 54)
,( 35, 43),( 36, 59),( 38, 58),(-1,-3000)

-- state  81
,( 30, 55),( 34, 54),( 35, 43),( 36, 59)
,( 38, 58),(-1,-3000)
-- state  82
,(-1,-63)
-- state  83
,(-1,-64)

-- state  84
,( 37, 110),(-1,-3000)
-- state  85
,( 14, 34),( 16, 40)
,( 18, 41),( 35, 43),(-1,-3000)
-- state  86
,( 14, 34)
,( 16, 40),( 18, 41),( 35, 43),(-1,-3000)

-- state  87
,( 25, 113),(-1,-3000)
-- state  88
,( 35, 114),(-1,-3000)

-- state  89
,( 30, 55),( 34, 54),( 35, 43),( 36, 59)
,( 38, 58),(-1,-3000)
-- state  90
,(-1,-46)
-- state  91
,( 25, 117)
,(-1,-3000)
-- state  92
,( 30, 118),( 35, 121),( 36, 120)
,(-1,-3000)
-- state  93
,( 15, 123),(-1,-3000)
-- state  94
,( 25, 124)
,(-1,-3000)
-- state  95
,( 5, 125),( 35, 12),(-1,-3000)

-- state  96
,(-1,-16)
-- state  97
,(-1,-17)
-- state  98
,( 22, 127),( 23, 17)
,(-1,-3000)
-- state  99
,( 35, 12),(-1,-3000)
-- state  100
,( 28, 76)
,( 29, 77),( 30, 78),( 31, 79),( 32, 80)
,( 33, 81),(-1,-53)
-- state  101
,( 28, 76),( 29, 77)
,( 30, 78),( 31, 79),( 32, 80),( 33, 81)
,(-1,-55)
-- state  102
,( 28, 76),( 29, 77),( 30, 78)
,( 31, 79),( 32, 80),( 33, 81),(-1,-54)

-- state  103
,( 28, 76),( 29, 77),( 30, 78),( 31, 79)
,( 32, 80),( 33, 81),(-1,-56)
-- state  104
,( 28,-3000)
,( 29, 77),( 30, 78),( 31, 79),( 32, 80)
,( 33, 81),(-1,-57)
-- state  105
,( 31, 79),( 32, 80)
,( 33, 81),(-1,-58)
-- state  106
,( 31, 79),( 32, 80)
,( 33, 81),(-1,-59)
-- state  107
,(-1,-60)
-- state  108
,(-1,-61)

-- state  109
,(-1,-62)
-- state  110
,(-1,-67)
-- state  111
,( 5, 129),(-1,-3000)

-- state  112
,( 5, 130),( 20, 131),(-1,-3000)
-- state  113
,(-1,-44)

-- state  114
,(-1,-48)
-- state  115
,( 23, 133),( 37, 132),(-1,-3000)

-- state  116
,(-1,-70)
-- state  117
,(-1,-2)
-- state  118
,( 35, 121),( 36, 120)
,(-1,-3000)
-- state  119
,(-1,-29)
-- state  120
,(-1,-30)
-- state  121
,(-1,-31)

-- state  122
,( 25, 135),(-1,-3000)
-- state  123
,( 30, 118),( 35, 121)
,( 36, 120),(-1,-3000)
-- state  124
,(-1,-12)
-- state  125
,( 9, 137)
,(-1,-3000)
-- state  126
,(-1,-15)
-- state  127
,( 35, 47),(-1,-3000)

-- state  128
,( 23, 17),( 37, 138),(-1,-3000)
-- state  129
,( 17, 139)
,(-1,-3000)
-- state  130
,( 18, 140),(-1,-3000)
-- state  131
,( 14, 34)
,( 16, 40),( 18, 41),( 35, 43),(-1,-3000)

-- state  132
,(-1,-49)
-- state  133
,( 30, 55),( 34, 54),( 35, 43)
,( 36, 59),( 38, 58),(-1,-3000)
-- state  134
,(-1,-28)

-- state  135
,(-1,-9)
-- state  136
,( 24, 143),(-1,-3000)
-- state  137
,( 25, 144)
,(-1,-3000)
-- state  138
,( 11, 145),(-1,-3000)
-- state  139
,( 25, 146)
,(-1,-3000)
-- state  140
,( 25, 147),(-1,-3000)
-- state  141
,( 5, 148)
,(-1,-3000)
-- state  142
,(-1,-69)
-- state  143
,( 24, 149),(-1,-3000)

-- state  144
,(-1,-13)
-- state  145
,( 35, 150),(-1,-3000)
-- state  146
,(-1,-40)

-- state  147
,(-1,-41)
-- state  148
,( 18, 151),(-1,-3000)
-- state  149
,( 30, 118)
,( 35, 121),( 36, 120),(-1,-3000)
-- state  150
,( 25, 153)
,(-1,-3000)
-- state  151
,( 25, 154),(-1,-3000)
-- state  152
,(-1,-27)

-- state  153
,(-1,-14)
-- state  154
,(-1,-42)
);
--  The offset vector
SHIFT_REDUCE_OFFSET : array (0.. 154) of Integer :=
( 0,
 2, 3, 5, 7, 9, 11, 12, 14, 15, 18,
 19, 22, 23, 28, 29, 31, 34, 36, 37, 38,
 39, 40, 43, 45, 50, 51, 52, 53, 54, 56,
 57, 60, 62, 66, 68, 69, 70, 71, 72, 73,
 79, 85, 88, 89, 91, 92, 94, 96, 100, 101,
 102, 104, 106, 115, 119, 123, 124, 125, 131, 132,
 134, 136, 137, 143, 146, 148, 150, 151, 153, 155,
 157, 158, 164, 170, 176, 182, 188, 194, 200, 206,
 212, 218, 219, 220, 222, 227, 232, 234, 236, 242,
 243, 245, 249, 251, 253, 256, 257, 258, 261, 263,
 270, 277, 284, 291, 298, 302, 306, 307, 308, 309,
 310, 312, 315, 316, 317, 320, 321, 322, 325, 326,
 327, 328, 330, 334, 335, 337, 338, 340, 343, 345,
 347, 352, 353, 359, 360, 361, 363, 365, 367, 369,
 371, 373, 374, 376, 377, 379, 380, 381, 383, 387,
 389, 391, 392, 393);
end Kobal_Shift_Reduce;
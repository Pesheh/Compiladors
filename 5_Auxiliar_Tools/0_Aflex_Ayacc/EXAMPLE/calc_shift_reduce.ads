package  is

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
,(-1,-2)
-- state  1
,( 0,-3001),( 1, 3),( 2, 6)
,( 4, 7),( 5, 8),( 9, 5),(-1,-3000)

-- state  2
,( 0,-3001),( 6, 11),( 8, 14),( 9, 15)
,( 10, 16),( 11, 17),( 13, 18),(-1,-3000)

-- state  3
,( 0,-3001),( 6, 11),(-1,-3000)
-- state  4
,( 7, 20)
,(-1,-15)
-- state  5
,( 2, 6),( 4, 7),( 5, 8)
,( 9, 5),(-1,-3000)
-- state  6
,( 2, 6),( 4, 7)
,( 5, 8),( 9, 5),(-1,-3000)
-- state  7
,(-1,-14)

-- state  8
,(-1,-16)
-- state  9
,(-1,-3000)
-- state  10
,(-1,-1)
-- state  11
,(-1,-17)

-- state  12
,(-1,-18)
-- state  13
,(-1,-3)
-- state  14
,( 2, 6),( 4, 7)
,( 5, 8),( 9, 5),(-1,-3000)
-- state  15
,( 2, 6)
,( 4, 7),( 5, 8),( 9, 5),(-1,-3000)

-- state  16
,( 2, 6),( 4, 7),( 5, 8),( 9, 5)
,(-1,-3000)
-- state  17
,( 2, 6),( 4, 7),( 5, 8)
,( 9, 5),(-1,-3000)
-- state  18
,( 2, 6),( 4, 7)
,( 5, 8),( 9, 5),(-1,-3000)
-- state  19
,(-1,-4)

-- state  20
,( 2, 6),( 4, 7),( 5, 8),( 9, 5)
,(-1,-3000)
-- state  21
,( 13, 18),(-1,-12)
-- state  22
,( 3, 30)
,( 8, 14),( 9, 15),( 10, 16),( 11, 17)
,( 13, 18),(-1,-3000)
-- state  23
,( 10, 16),( 11, 17)
,( 13, 18),(-1,-7)
-- state  24
,( 10, 16),( 11, 17)
,( 13, 18),(-1,-8)
-- state  25
,( 13, 18),(-1,-9)

-- state  26
,( 13, 18),(-1,-10)
-- state  27
,( 13,-3000),(-1,-11)

-- state  28
,( 1, 3),( 2, 6),( 4, 7),( 5, 8)
,( 9, 5),(-1,-3000)
-- state  29
,( 8, 14),( 9, 15)
,( 10, 16),( 11, 17),( 13, 18),(-1,-6)

-- state  30
,(-1,-13)
-- state  31
,(-1,-5)
);
--  The offset vector
SHIFT_REDUCE_OFFSET : array (0.. 31) of Integer :=
( 0,
 1, 8, 16, 19, 21, 26, 31, 32, 33, 34,
 35, 36, 37, 38, 43, 48, 53, 58, 63, 64,
 69, 71, 78, 82, 86, 88, 90, 92, 98, 104,
 105);
end ;

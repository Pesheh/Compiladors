package  is

    type Small_Integer is range -32_000 .. 32_000;

    type Goto_Entry is record
        Nonterm  : Small_Integer;
        Newstate : Small_Integer;
    end record;

  --pragma suppress(index_check);

    subtype Row is Integer range -1 .. Integer'Last;

    type Goto_Parse_Table is array (Row range <>) of Goto_Entry;

    Goto_Matrix : constant Goto_Parse_Table :=
       ((-1,-1)  -- Dummy Entry.
-- State  0
,(-2, 1)
-- State  1
,(-7, 4),(-4, 2),(-3, 10)

-- State  2
,(-5, 13)
-- State  3
,(-5, 19)
-- State  4

-- State  5
,(-7, 4),(-4, 21)

-- State  6
,(-7, 4),(-4, 22)
-- State  7

-- State  8

-- State  9

-- State  10

-- State  11

-- State  12

-- State  13

-- State  14
,(-7, 4),(-4, 23)

-- State  15
,(-7, 4),(-4, 24)
-- State  16
,(-7, 4),(-4, 25)

-- State  17
,(-7, 4),(-4, 26)
-- State  18
,(-7, 4),(-4, 27)

-- State  19
,(-6, 28)
-- State  20
,(-7, 4),(-4, 29)
-- State  21

-- State  22

-- State  23

-- State  24

-- State  25

-- State  26

-- State  27

-- State  28
,(-7, 4)
,(-4, 2),(-3, 31)
-- State  29

-- State  30

-- State  31

);
--  The offset vector
GOTO_OFFSET : array (0.. 31) of Integer :=
( 0,
 1, 4, 5, 6, 6, 8, 10, 10, 10, 10,
 10, 10, 10, 10, 12, 14, 16, 18, 20, 21,
 23, 23, 23, 23, 23, 23, 23, 23, 26, 26,
 26);

subtype Rule        is Natural;
subtype Nonterminal is Integer;

   Rule_Length : array (Rule range  0 ..  18) of Natural := ( 2,
 2, 0, 2, 0, 4, 3, 3, 3,
 3, 3, 3, 2, 3, 1, 1, 1,
 1, 1);
   Get_LHS_Rule: array (Rule range  0 ..  18) of Nonterminal := (-1,
-2,-2,-3,-6,-3,-4,-4,-4,
-4,-4,-4,-4,-4,-4,-4,-7,
-5,-5);
end ;

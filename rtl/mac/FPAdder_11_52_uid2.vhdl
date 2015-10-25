-- Flopoco adder pipeline delay: 14 clock cycles
-- TODO: verilog instantiation


--------------------------------------------------------------------------------
--                           IntAdder_66_f400_uid4
--                     (IntAdderAlternative_66_f400_uid8)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_66_f400_uid4 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(65 downto 0);
          Y : in  std_logic_vector(65 downto 0);
          Cin : in std_logic;
          R : out  std_logic_vector(65 downto 0)   );
end entity;

architecture arch of IntAdder_66_f400_uid4 is
signal s_sum_l0_idx0 :  std_logic_vector(42 downto 0);
signal s_sum_l0_idx1, s_sum_l0_idx1_d1 :  std_logic_vector(24 downto 0);
signal sum_l0_idx0, sum_l0_idx0_d1 :  std_logic_vector(41 downto 0);
signal c_l0_idx0, c_l0_idx0_d1 :  std_logic_vector(0 downto 0);
signal sum_l0_idx1 :  std_logic_vector(23 downto 0);
signal c_l0_idx1 :  std_logic_vector(0 downto 0);
signal s_sum_l1_idx1 :  std_logic_vector(24 downto 0);
signal sum_l1_idx1 :  std_logic_vector(23 downto 0);
signal c_l1_idx1 :  std_logic_vector(0 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            s_sum_l0_idx1_d1 <=  s_sum_l0_idx1;
            sum_l0_idx0_d1 <=  sum_l0_idx0;
            c_l0_idx0_d1 <=  c_l0_idx0;
         end if;
      end process;
   --Alternative
   s_sum_l0_idx0 <= ( "0" & X(41 downto 0)) + ( "0" & Y(41 downto 0)) + Cin;
   s_sum_l0_idx1 <= ( "0" & X(65 downto 42)) + ( "0" & Y(65 downto 42));
   sum_l0_idx0 <= s_sum_l0_idx0(41 downto 0);
   c_l0_idx0 <= s_sum_l0_idx0(42 downto 42);
   sum_l0_idx1 <= s_sum_l0_idx1(23 downto 0);
   c_l0_idx1 <= s_sum_l0_idx1(24 downto 24);
   ----------------Synchro barrier, entering cycle 1----------------
   s_sum_l1_idx1 <=  s_sum_l0_idx1_d1 + c_l0_idx0_d1(0 downto 0);
   sum_l1_idx1 <= s_sum_l1_idx1(23 downto 0);
   c_l1_idx1 <= s_sum_l1_idx1(24 downto 24);
   R <= sum_l1_idx1(23 downto 0) & sum_l0_idx0_d1(41 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                      FPAdder_11_52_uid2_RightShifter
--                     (RightShifter_53_by_max_55_uid10)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2011)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdder_11_52_uid2_RightShifter is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(52 downto 0);
          S : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(107 downto 0)   );
end entity;

architecture arch of FPAdder_11_52_uid2_RightShifter is
signal level0 :  std_logic_vector(52 downto 0);
signal ps, ps_d1 :  std_logic_vector(5 downto 0);
signal level1 :  std_logic_vector(53 downto 0);
signal level2 :  std_logic_vector(55 downto 0);
signal level3 :  std_logic_vector(59 downto 0);
signal level4, level4_d1 :  std_logic_vector(67 downto 0);
signal level5 :  std_logic_vector(83 downto 0);
signal level6 :  std_logic_vector(115 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            ps_d1 <=  ps;
            level4_d1 <=  level4;
         end if;
      end process;
   level0<= X;
   ps<= S;
   level1<=  (0 downto 0 => '0') & level0 when ps(0) = '1' else    level0 & (0 downto 0 => '0');
   level2<=  (1 downto 0 => '0') & level1 when ps(1) = '1' else    level1 & (1 downto 0 => '0');
   level3<=  (3 downto 0 => '0') & level2 when ps(2) = '1' else    level2 & (3 downto 0 => '0');
   level4<=  (7 downto 0 => '0') & level3 when ps(3) = '1' else    level3 & (7 downto 0 => '0');
   ----------------Synchro barrier, entering cycle 1----------------
   level5<=  (15 downto 0 => '0') & level4_d1 when ps_d1(4) = '1' else    level4_d1 & (15 downto 0 => '0');
   level6<=  (31 downto 0 => '0') & level5 when ps_d1(5) = '1' else    level5 & (31 downto 0 => '0');
   R <= level6(115 downto 8);
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_56_f400_uid12
--                     (IntAdderClassical_56_f400_uid14)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_56_f400_uid12 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(55 downto 0);
          Y : in  std_logic_vector(55 downto 0);
          Cin : in std_logic;
          R : out  std_logic_vector(55 downto 0)   );
end entity;

architecture arch of IntAdder_56_f400_uid12 is
signal x0 :  std_logic_vector(10 downto 0);
signal y0 :  std_logic_vector(10 downto 0);
signal x1, x1_d1 :  std_logic_vector(41 downto 0);
signal y1, y1_d1 :  std_logic_vector(41 downto 0);
signal x2, x2_d1, x2_d2 :  std_logic_vector(2 downto 0);
signal y2, y2_d1, y2_d2 :  std_logic_vector(2 downto 0);
signal sum0, sum0_d1, sum0_d2 :  std_logic_vector(11 downto 0);
signal sum1, sum1_d1 :  std_logic_vector(42 downto 0);
signal sum2 :  std_logic_vector(3 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            x1_d1 <=  x1;
            y1_d1 <=  y1;
            x2_d1 <=  x2;
            x2_d2 <=  x2_d1;
            y2_d1 <=  y2;
            y2_d2 <=  y2_d1;
            sum0_d1 <=  sum0;
            sum0_d2 <=  sum0_d1;
            sum1_d1 <=  sum1;
         end if;
      end process;
   --Classical
   x0 <= X(10 downto 0);
   y0 <= Y(10 downto 0);
   x1 <= X(52 downto 11);
   y1 <= Y(52 downto 11);
   x2 <= X(55 downto 53);
   y2 <= Y(55 downto 53);
   sum0 <= ( "0" & x0) + ( "0" & y0)  + Cin;
   ----------------Synchro barrier, entering cycle 1----------------
   sum1 <= ( "0" & x1_d1) + ( "0" & y1_d1)  + sum0_d1(11);
   ----------------Synchro barrier, entering cycle 2----------------
   sum2 <= ( "0" & x2_d2) + ( "0" & y2_d2)  + sum1_d1(42);
   R <= sum2(2 downto 0) & sum1_d1(41 downto 0) & sum0_d2(10 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                   LZCShifter_57_to_57_counting_64_uid18
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007)
--------------------------------------------------------------------------------
-- Pipeline depth: 5 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZCShifter_57_to_57_counting_64_uid18 is
   port ( clk, rst : in std_logic;
          I : in  std_logic_vector(56 downto 0);
          Count : out  std_logic_vector(5 downto 0);
          O : out  std_logic_vector(56 downto 0)   );
end entity;

architecture arch of LZCShifter_57_to_57_counting_64_uid18 is
signal level6, level6_d1 :  std_logic_vector(56 downto 0);
signal count5, count5_d1, count5_d2, count5_d3, count5_d4, count5_d5 : std_logic;
signal level5 :  std_logic_vector(56 downto 0);
signal count4, count4_d1, count4_d2, count4_d3, count4_d4 : std_logic;
signal level4, level4_d1 :  std_logic_vector(56 downto 0);
signal count3, count3_d1, count3_d2, count3_d3 : std_logic;
signal level3, level3_d1 :  std_logic_vector(56 downto 0);
signal count2, count2_d1, count2_d2 : std_logic;
signal level2, level2_d1 :  std_logic_vector(56 downto 0);
signal count1, count1_d1 : std_logic;
signal level1, level1_d1 :  std_logic_vector(56 downto 0);
signal count0 : std_logic;
signal level0 :  std_logic_vector(56 downto 0);
signal sCount :  std_logic_vector(5 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            level6_d1 <=  level6;
            count5_d1 <=  count5;
            count5_d2 <=  count5_d1;
            count5_d3 <=  count5_d2;
            count5_d4 <=  count5_d3;
            count5_d5 <=  count5_d4;
            count4_d1 <=  count4;
            count4_d2 <=  count4_d1;
            count4_d3 <=  count4_d2;
            count4_d4 <=  count4_d3;
            level4_d1 <=  level4;
            count3_d1 <=  count3;
            count3_d2 <=  count3_d1;
            count3_d3 <=  count3_d2;
            level3_d1 <=  level3;
            count2_d1 <=  count2;
            count2_d2 <=  count2_d1;
            level2_d1 <=  level2;
            count1_d1 <=  count1;
            level1_d1 <=  level1;
         end if;
      end process;
   level6 <= I ;
   count5<= '1' when level6(56 downto 25) = (56 downto 25=>'0') else '0';
   ----------------Synchro barrier, entering cycle 1----------------
   level5<= level6_d1(56 downto 0) when count5_d1='0' else level6_d1(24 downto 0) & (31 downto 0 => '0');

   count4<= '1' when level5(56 downto 41) = (56 downto 41=>'0') else '0';
   level4<= level5(56 downto 0) when count4='0' else level5(40 downto 0) & (15 downto 0 => '0');

   ----------------Synchro barrier, entering cycle 2----------------
   count3<= '1' when level4_d1(56 downto 49) = (56 downto 49=>'0') else '0';
   level3<= level4_d1(56 downto 0) when count3='0' else level4_d1(48 downto 0) & (7 downto 0 => '0');

   ----------------Synchro barrier, entering cycle 3----------------
   count2<= '1' when level3_d1(56 downto 53) = (56 downto 53=>'0') else '0';
   level2<= level3_d1(56 downto 0) when count2='0' else level3_d1(52 downto 0) & (3 downto 0 => '0');

   ----------------Synchro barrier, entering cycle 4----------------
   count1<= '1' when level2_d1(56 downto 55) = (56 downto 55=>'0') else '0';
   level1<= level2_d1(56 downto 0) when count1='0' else level2_d1(54 downto 0) & (1 downto 0 => '0');

   ----------------Synchro barrier, entering cycle 5----------------
   count0<= '1' when level1_d1(56 downto 56) = (56 downto 56=>'0') else '0';
   level0<= level1_d1(56 downto 0) when count0='0' else level1_d1(55 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count5_d5 & count4_d4 & count3_d3 & count2_d2 & count1_d1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_66_f400_uid20
--                     (IntAdderClassical_66_f400_uid22)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_66_f400_uid20 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(65 downto 0);
          Y : in  std_logic_vector(65 downto 0);
          Cin : in std_logic;
          R : out  std_logic_vector(65 downto 0)   );
end entity;

architecture arch of IntAdder_66_f400_uid20 is
signal x0 :  std_logic_vector(17 downto 0);
signal y0 :  std_logic_vector(17 downto 0);
signal x1, x1_d1 :  std_logic_vector(41 downto 0);
signal y1, y1_d1 :  std_logic_vector(41 downto 0);
signal x2, x2_d1, x2_d2 :  std_logic_vector(5 downto 0);
signal y2, y2_d1, y2_d2 :  std_logic_vector(5 downto 0);
signal sum0, sum0_d1, sum0_d2 :  std_logic_vector(18 downto 0);
signal sum1, sum1_d1 :  std_logic_vector(42 downto 0);
signal sum2 :  std_logic_vector(6 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            x1_d1 <=  x1;
            y1_d1 <=  y1;
            x2_d1 <=  x2;
            x2_d2 <=  x2_d1;
            y2_d1 <=  y2;
            y2_d2 <=  y2_d1;
            sum0_d1 <=  sum0;
            sum0_d2 <=  sum0_d1;
            sum1_d1 <=  sum1;
         end if;
      end process;
   --Classical
   x0 <= X(17 downto 0);
   y0 <= Y(17 downto 0);
   x1 <= X(59 downto 18);
   y1 <= Y(59 downto 18);
   x2 <= X(65 downto 60);
   y2 <= Y(65 downto 60);
   sum0 <= ( "0" & x0) + ( "0" & y0)  + Cin;
   ----------------Synchro barrier, entering cycle 1----------------
   sum1 <= ( "0" & x1_d1) + ( "0" & y1_d1)  + sum0_d1(18);
   ----------------Synchro barrier, entering cycle 2----------------
   sum2 <= ( "0" & x2_d2) + ( "0" & y2_d2)  + sum1_d1(42);
   R <= sum2(5 downto 0) & sum1_d1(41 downto 0) & sum0_d2(17 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                             FPAdder_11_52_uid2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 14 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdder_11_52_uid2 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(11+52+2 downto 0);
          Y : in  std_logic_vector(11+52+2 downto 0);
          R : out  std_logic_vector(11+52+2 downto 0)   );
end entity;

architecture arch of FPAdder_11_52_uid2 is
   component FPAdder_11_52_uid2_RightShifter is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(52 downto 0);
             S : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(107 downto 0)   );
   end component;

   component IntAdder_56_f400_uid12 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(55 downto 0);
             Y : in  std_logic_vector(55 downto 0);
             Cin : in std_logic;
             R : out  std_logic_vector(55 downto 0)   );
   end component;

   component IntAdder_66_f400_uid20 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(65 downto 0);
             Y : in  std_logic_vector(65 downto 0);
             Cin : in std_logic;
             R : out  std_logic_vector(65 downto 0)   );
   end component;

   component IntAdder_66_f400_uid4 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(65 downto 0);
             Y : in  std_logic_vector(65 downto 0);
             Cin : in std_logic;
             R : out  std_logic_vector(65 downto 0)   );
   end component;

   component LZCShifter_57_to_57_counting_64_uid18 is
      port ( clk, rst : in std_logic;
             I : in  std_logic_vector(56 downto 0);
             Count : out  std_logic_vector(5 downto 0);
             O : out  std_logic_vector(56 downto 0)   );
   end component;

signal excExpFracX :  std_logic_vector(64 downto 0);
signal excExpFracY :  std_logic_vector(64 downto 0);
signal eXmeY, eXmeY_d1 :  std_logic_vector(11 downto 0);
signal eYmeX, eYmeX_d1 :  std_logic_vector(11 downto 0);
signal addCmpOp1 :  std_logic_vector(65 downto 0);
signal addCmpOp2 :  std_logic_vector(65 downto 0);
signal cmpRes :  std_logic_vector(65 downto 0);
signal swap : std_logic;
signal newX, newX_d1, newX_d2, newX_d3 :  std_logic_vector(65 downto 0);
signal newY, newY_d1 :  std_logic_vector(65 downto 0);
signal expX, expX_d1, expX_d2, expX_d3, expX_d4, expX_d5 :  std_logic_vector(10 downto 0);
signal excX :  std_logic_vector(1 downto 0);
signal excY, excY_d1 :  std_logic_vector(1 downto 0);
signal signX, signX_d1 : std_logic;
signal signY : std_logic;
signal EffSub, EffSub_d1, EffSub_d2, EffSub_d3, EffSub_d4, EffSub_d5, EffSub_d6, EffSub_d7, EffSub_d8, EffSub_d9, EffSub_d10, EffSub_d11, EffSub_d12, EffSub_d13 : std_logic;
signal sdsXsYExnXY, sdsXsYExnXY_d1 :  std_logic_vector(5 downto 0);
signal sdExnXY :  std_logic_vector(3 downto 0);
signal fracY :  std_logic_vector(52 downto 0);
signal excRt, excRt_d1, excRt_d2, excRt_d3, excRt_d4, excRt_d5, excRt_d6, excRt_d7, excRt_d8, excRt_d9, excRt_d10, excRt_d11, excRt_d12 :  std_logic_vector(1 downto 0);
signal signR, signR_d1, signR_d2, signR_d3, signR_d4, signR_d5, signR_d6, signR_d7, signR_d8, signR_d9, signR_d10, signR_d11, signR_d12 : std_logic;
signal expDiff :  std_logic_vector(11 downto 0);
signal shiftedOut : std_logic;
signal shiftVal, shiftVal_d1 :  std_logic_vector(5 downto 0);
signal shiftedFracY, shiftedFracY_d1 :  std_logic_vector(107 downto 0);
signal sticky, sticky_d1, sticky_d2 : std_logic;
signal fracYfar :  std_logic_vector(55 downto 0);
signal fracYfarXorOp :  std_logic_vector(55 downto 0);
signal fracXfar :  std_logic_vector(55 downto 0);
signal cInAddFar : std_logic;
signal fracAddResult :  std_logic_vector(55 downto 0);
signal fracGRS :  std_logic_vector(56 downto 0);
signal extendedExpInc, extendedExpInc_d1, extendedExpInc_d2, extendedExpInc_d3, extendedExpInc_d4, extendedExpInc_d5, extendedExpInc_d6 :  std_logic_vector(12 downto 0);
signal nZerosNew, nZerosNew_d1 :  std_logic_vector(5 downto 0);
signal shiftedFrac, shiftedFrac_d1 :  std_logic_vector(56 downto 0);
signal updatedExp :  std_logic_vector(12 downto 0);
signal eqdiffsign, eqdiffsign_d1, eqdiffsign_d2 : std_logic;
signal expFrac :  std_logic_vector(65 downto 0);
signal stk, stk_d1 : std_logic;
signal rnd, rnd_d1 : std_logic;
signal grd, grd_d1 : std_logic;
signal lsb, lsb_d1 : std_logic;
signal addToRoundBit : std_logic;
signal RoundedExpFrac :  std_logic_vector(65 downto 0);
signal upExc :  std_logic_vector(1 downto 0);
signal fracR :  std_logic_vector(51 downto 0);
signal expR :  std_logic_vector(10 downto 0);
signal exExpExc :  std_logic_vector(3 downto 0);
signal excRt2 :  std_logic_vector(1 downto 0);
signal excR :  std_logic_vector(1 downto 0);
signal computedR :  std_logic_vector(65 downto 0);
signal X_d1 :  std_logic_vector(11+52+2 downto 0);
signal Y_d1 :  std_logic_vector(11+52+2 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            eXmeY_d1 <=  eXmeY;
            eYmeX_d1 <=  eYmeX;
            newX_d1 <=  newX;
            newX_d2 <=  newX_d1;
            newX_d3 <=  newX_d2;
            newY_d1 <=  newY;
            expX_d1 <=  expX;
            expX_d2 <=  expX_d1;
            expX_d3 <=  expX_d2;
            expX_d4 <=  expX_d3;
            expX_d5 <=  expX_d4;
            excY_d1 <=  excY;
            signX_d1 <=  signX;
            EffSub_d1 <=  EffSub;
            EffSub_d2 <=  EffSub_d1;
            EffSub_d3 <=  EffSub_d2;
            EffSub_d4 <=  EffSub_d3;
            EffSub_d5 <=  EffSub_d4;
            EffSub_d6 <=  EffSub_d5;
            EffSub_d7 <=  EffSub_d6;
            EffSub_d8 <=  EffSub_d7;
            EffSub_d9 <=  EffSub_d8;
            EffSub_d10 <=  EffSub_d9;
            EffSub_d11 <=  EffSub_d10;
            EffSub_d12 <=  EffSub_d11;
            EffSub_d13 <=  EffSub_d12;
            sdsXsYExnXY_d1 <=  sdsXsYExnXY;
            excRt_d1 <=  excRt;
            excRt_d2 <=  excRt_d1;
            excRt_d3 <=  excRt_d2;
            excRt_d4 <=  excRt_d3;
            excRt_d5 <=  excRt_d4;
            excRt_d6 <=  excRt_d5;
            excRt_d7 <=  excRt_d6;
            excRt_d8 <=  excRt_d7;
            excRt_d9 <=  excRt_d8;
            excRt_d10 <=  excRt_d9;
            excRt_d11 <=  excRt_d10;
            excRt_d12 <=  excRt_d11;
            signR_d1 <=  signR;
            signR_d2 <=  signR_d1;
            signR_d3 <=  signR_d2;
            signR_d4 <=  signR_d3;
            signR_d5 <=  signR_d4;
            signR_d6 <=  signR_d5;
            signR_d7 <=  signR_d6;
            signR_d8 <=  signR_d7;
            signR_d9 <=  signR_d8;
            signR_d10 <=  signR_d9;
            signR_d11 <=  signR_d10;
            signR_d12 <=  signR_d11;
            shiftVal_d1 <=  shiftVal;
            shiftedFracY_d1 <=  shiftedFracY;
            sticky_d1 <=  sticky;
            sticky_d2 <=  sticky_d1;
            extendedExpInc_d1 <=  extendedExpInc;
            extendedExpInc_d2 <=  extendedExpInc_d1;
            extendedExpInc_d3 <=  extendedExpInc_d2;
            extendedExpInc_d4 <=  extendedExpInc_d3;
            extendedExpInc_d5 <=  extendedExpInc_d4;
            extendedExpInc_d6 <=  extendedExpInc_d5;
            nZerosNew_d1 <=  nZerosNew;
            shiftedFrac_d1 <=  shiftedFrac;
            eqdiffsign_d1 <=  eqdiffsign;
            eqdiffsign_d2 <=  eqdiffsign_d1;
            stk_d1 <=  stk;
            rnd_d1 <=  rnd;
            grd_d1 <=  grd;
            lsb_d1 <=  lsb;
            X_d1 <=  X;
            Y_d1 <=  Y;
         end if;
      end process;
-- Exponent difference and swap  --
   excExpFracX <= X(65 downto 64) & X(62 downto 0);
   excExpFracY <= Y(65 downto 64) & Y(62 downto 0);
   eXmeY <= ("0" & X(62 downto 52)) - ("0" & Y(62 downto 52));
   eYmeX <= ("0" & Y(62 downto 52)) - ("0" & X(62 downto 52));
   addCmpOp1<= "0" & excExpFracX;
   addCmpOp2<= "1" & not(excExpFracY);
   cmpAdder: IntAdder_66_f400_uid4  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '1',
                 R => cmpRes,
                 X => addCmpOp1,
                 Y => addCmpOp2);

   ----------------Synchro barrier, entering cycle 1----------------
   swap <= cmpRes(65);
   newX <= X_d1     when swap = '0' else Y_d1;
   newY <= Y_d1     when swap = '0' else X_d1;
   expX<= newX(62 downto 52);
   excX<= newX(65 downto 64);
   excY<= newY(65 downto 64);
   signX<= newX(63);
   signY<= newY(63);
   EffSub <= signX xor signY;
   sdsXsYExnXY <= signX & signY & excX & excY;
   sdExnXY <= excX & excY;
   ----------------Synchro barrier, entering cycle 2----------------
   fracY <= "00000000000000000000000000000000000000000000000000000" when excY_d1="00" else ('1' & newY_d1(51 downto 0));
   with sdsXsYExnXY_d1 select 
   excRt <= "00" when "000000"|"010000"|"100000"|"110000",
      "01" when "000101"|"010101"|"100101"|"110101"|"000100"|"010100"|"100100"|"110100"|"000001"|"010001"|"100001"|"110001",
      "10" when "111010"|"001010"|"001000"|"011000"|"101000"|"111000"|"000010"|"010010"|"100010"|"110010"|"001001"|"011001"|"101001"|"111001"|"000110"|"010110"|"100110"|"110110", 
      "11" when others;
   signR<= '0' when (sdsXsYExnXY_d1="100000" or sdsXsYExnXY_d1="010000") else signX_d1;
   ---------------- cycle 1----------------
   expDiff <= eXmeY_d1 when swap = '0' else eYmeX_d1;
   shiftedOut <= '1' when (expDiff >= 54) else '0';
   shiftVal <= expDiff(5 downto 0) when shiftedOut='0' else CONV_STD_LOGIC_VECTOR(55,6) ;
   ----------------Synchro barrier, entering cycle 2----------------
   RightShifterComponent: FPAdder_11_52_uid2_RightShifter  -- pipelineDepth=1 maxInDelay=5.3072e-10
      port map ( clk  => clk,
                 rst  => rst,
                 R => shiftedFracY,
                 S => shiftVal_d1,
                 X => fracY);
   ----------------Synchro barrier, entering cycle 3----------------
   ----------------Synchro barrier, entering cycle 4----------------
   sticky <= '0' when (shiftedFracY_d1(52 downto 0)=CONV_STD_LOGIC_VECTOR(0,52)) else '1';
   ---------------- cycle 3----------------
   ----------------Synchro barrier, entering cycle 4----------------
   fracYfar <= "0" & shiftedFracY_d1(107 downto 53);
   fracYfarXorOp <= fracYfar xor (55 downto 0 => EffSub_d3);
   fracXfar <= "01" & (newX_d3(51 downto 0)) & "00";
   cInAddFar <= EffSub_d3 and not sticky;
   fracAdder: IntAdder_56_f400_uid12  -- pipelineDepth=2 maxInDelay=1.57344e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => cInAddFar,
                 R => fracAddResult,
                 X => fracXfar,
                 Y => fracYfarXorOp);
   ----------------Synchro barrier, entering cycle 6----------------
   fracGRS<= fracAddResult & sticky_d2; 
   extendedExpInc<= ("00" & expX_d5) + '1';
   LZC_component: LZCShifter_57_to_57_counting_64_uid18  -- pipelineDepth=5 maxInDelay=7.37e-10
      port map ( clk  => clk,
                 rst  => rst,
                 Count => nZerosNew,
                 I => fracGRS,
                 O => shiftedFrac);
   ----------------Synchro barrier, entering cycle 11----------------
   ----------------Synchro barrier, entering cycle 12----------------
   updatedExp <= extendedExpInc_d6 - ("0000000" & nZerosNew_d1);
   eqdiffsign <= '1' when nZerosNew_d1="111111" else '0';
   expFrac<= updatedExp & shiftedFrac_d1(55 downto 3);
   ---------------- cycle 11----------------
   stk<= shiftedFrac(1) or shiftedFrac(0);
   rnd<= shiftedFrac(2);
   grd<= shiftedFrac(3);
   lsb<= shiftedFrac(4);
   ----------------Synchro barrier, entering cycle 12----------------
   addToRoundBit<= '0' when (lsb_d1='0' and grd_d1='1' and rnd_d1='0' and stk_d1='0')  else '1';
   roundingAdder: IntAdder_66_f400_uid20  -- pipelineDepth=2 maxInDelay=1.41172e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => addToRoundBit,
                 R => RoundedExpFrac,
                 X => expFrac,
                 Y => "000000000000000000000000000000000000000000000000000000000000000000");
   ---------------- cycle 14----------------
   upExc <= RoundedExpFrac(65 downto 64);
   fracR <= RoundedExpFrac(52 downto 1);
   expR <= RoundedExpFrac(63 downto 53);
   exExpExc <= upExc & excRt_d12;
   with (exExpExc) select 
   excRt2<= "00" when "0000"|"0100"|"1000"|"1100"|"1001"|"1101",
      "01" when "0001",
      "10" when "0010"|"0110"|"0101",
      "11" when others;
   excR <= "00" when (eqdiffsign_d2='1' and EffSub_d13='1') else excRt2;
   computedR <= excR & signR_d12 & expR & fracR;
   R <= computedR;
end architecture;


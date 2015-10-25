--------------------------------------------------------------------------------
--                          InputIEEE_11_52_to_11_52
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin (2008)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity InputIEEE_11_52_to_11_52 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(63 downto 0);
          R : out  std_logic_vector(11+52+2 downto 0)   );
end entity;

architecture arch of InputIEEE_11_52_to_11_52 is
signal expX, expX_d1 :  std_logic_vector(10 downto 0);
signal fracX :  std_logic_vector(51 downto 0);
signal sX, sX_d1 : std_logic;
signal expZero, expZero_d1 : std_logic;
signal expInfty, expInfty_d1 : std_logic;
signal fracZero, fracZero_d1 : std_logic;
signal reprSubNormal, reprSubNormal_d1 : std_logic;
signal sfracX, sfracX_d1 :  std_logic_vector(51 downto 0);
signal fracR :  std_logic_vector(51 downto 0);
signal expR :  std_logic_vector(10 downto 0);
signal infinity : std_logic;
signal zero : std_logic;
signal NaN : std_logic;
signal exnR :  std_logic_vector(1 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            expX_d1 <=  expX;
            sX_d1 <=  sX;
            expZero_d1 <=  expZero;
            expInfty_d1 <=  expInfty;
            fracZero_d1 <=  fracZero;
            reprSubNormal_d1 <=  reprSubNormal;
            sfracX_d1 <=  sfracX;
         end if;
      end process;
   expX  <= X(62 downto 52);
   fracX  <= X(51 downto 0);
   sX  <= X(63);
   expZero  <= '1' when expX = (10 downto 0 => '0') else '0';
   expInfty  <= '1' when expX = (10 downto 0 => '1') else '0';
   fracZero <= '1' when fracX = (51 downto 0 => '0') else '0';
   reprSubNormal <= fracX(51);
   -- since we have one more exponent value than IEEE (field 0...0, value emin-1),
   -- we can represent subnormal numbers whose mantissa field begins with a 1
   sfracX <= fracX(50 downto 0) & '0' when (expZero='1' and reprSubNormal='1')    else fracX;
   ----------------Synchro barrier, entering cycle 1----------------
   fracR <= sfracX_d1;
   -- copy exponent. This will be OK even for subnormals, zero and infty since in such cases the exn bits will prevail
   expR <= expX_d1;
   infinity <= expInfty_d1 and fracZero_d1;
   zero <= expZero_d1 and not reprSubNormal_d1;
   NaN <= expInfty_d1 and not fracZero_d1;
   exnR <= 
           "00" when zero='1' 
      else "10" when infinity='1' 
      else "11" when NaN='1' 
      else "01" ;  -- normal number
   R <= exnR & sX_d1 & expR & fracR; 
end architecture;


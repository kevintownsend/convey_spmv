--------------------------------------------------------------------------------
--                         OutputIEEE_11_52_to_11_52
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: F. Ferrandi  (2009)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity OutputIEEE_11_52_to_11_52 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(11+52+2 downto 0);
          R : out  std_logic_vector(63 downto 0)   );
end entity;

architecture arch of OutputIEEE_11_52_to_11_52 is
signal expX, expX_d1 :  std_logic_vector(10 downto 0);
signal fracX, fracX_d1 :  std_logic_vector(51 downto 0);
signal sX, sX_d1 : std_logic;
signal exnX, exnX_d1 :  std_logic_vector(1 downto 0);
signal expZero, expZero_d1 : std_logic;
signal sfracX :  std_logic_vector(51 downto 0);
signal fracR :  std_logic_vector(51 downto 0);
signal expR :  std_logic_vector(10 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            expX_d1 <=  expX;
            fracX_d1 <=  fracX;
            sX_d1 <=  sX;
            exnX_d1 <=  exnX;
            expZero_d1 <=  expZero;
         end if;
      end process;
   expX  <= X(62 downto 52);
   fracX  <= X(51 downto 0);
   sX  <= X(63);
   exnX  <= X(65 downto 64);
   expZero  <= '1' when expX = (10 downto 0 => '0') else '0';
   -- since we have one more exponent value than IEEE (field 0...0, value emin-1),
   -- we can represent subnormal numbers whose mantissa field begins with a 1
   ----------------Synchro barrier, entering cycle 1----------------
   sfracX <= 
      (51 downto 0 => '0') when (exnX_d1 = "00") else
      '1' & fracX_d1(51 downto 1) when (expZero_d1 = '1' and exnX_d1 = "01") else
      fracX_d1 when (exnX_d1 = "01") else 
      (51 downto 1 => '0') & exnX_d1(0);
   fracR <= sfracX;
   expR <=  
      (10 downto 0 => '0') when (exnX_d1 = "00") else
      expX_d1 when (exnX_d1 = "01") else 
      (10 downto 0 => '1');
   R <= sX_d1 & expR & fracR; 
end architecture;


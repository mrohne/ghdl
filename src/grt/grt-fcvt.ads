--  GHDL Run Time (GRT) - Floating point conversions.
--  Copyright (C) 2017 Tristan Gingold
--
--  GHDL is free software; you can redistribute it and/or modify it under
--  the terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 2, or (at your option) any later
--  version.
--
--  GHDL is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or
--  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with GCC; see the file COPYING.  If not, write to the Free
--  Software Foundation, 59 Temple Place - Suite 330, Boston, MA
--  02111-1307, USA.
--
--  As a special exception, if other files instantiate generics from this
--  unit, or you link this unit with other files to produce an executable,
--  this unit does not by itself cause the resulting executable to be
--  covered by the GNU General Public License. This exception does not
--  however invalidate any other reasons why the executable file might be
--  covered by the GNU Public License.

--  IMPORTANT: this unit can also be used by the front-end, so it must NOT
--  depend on anything else from grt (except the grt parent package), including
--  grt.types.

with Interfaces; use Interfaces;

package Grt.Fcvt is
   --  Convert V to 10-based number stored (in ASCII) in STR/LEN [using at most
   --  NDIGITS digits.]
   --  LEN is the number of characters needed (so it may be greater than
   --   STR'Length).
   --  Requires STR'First = 1.
   procedure To_String (Str : out String;
                        Len : out Natural;
                        V : IEEE_Float_64);

   --  Input format is [+-]int[.int][e[+-]int]
   --  where int is digit { _ digit }
   --    and [+-] means optional + or -.
   --  The input string must be correctly formatted.
   function From_String (Str : String) return IEEE_Float_64;

   --  Ad-hoc implementation of bignums, with the minimal features to support
   --  radix conversion.
   type Bignum is private;

   --  Compute L * R + CARRY_IN.
   procedure Bignum_Mul_Int
     (L : in out Bignum; R : Positive; Carry_In : Natural := 0);

   --  Multiply two bignums.
   function Bignum_Mul (L, R : Bignum) return Bignum;

   --  Compute L**N
   function Bignum_Pow (L : Natural; N : Natural) return Bignum;

   --  Create a bignum from a natural.
   procedure Bignum_Int (Res : out Bignum; N : Natural);

   --  Convert N to RES.  OK is set to True if the number fits in RES.
   procedure Bignum_To_Int
     (N : Bignum; Res : out Unsigned_64; OK : out Boolean);

   --  Return (-1)**Neg * F * BASE**EXP to a float.
   function To_Float_64
     (Neg : Boolean; F : Bignum; Base : Positive; Exp : Integer)
     return IEEE_Float_64;
private
   type Unsigned_32_Array is array (Natural range <>) of Unsigned_32;

   type Bignum is record
      --  Number of digits.  Must be 0 for number 0.
      N : Natural;
      --  Digits.  The leading digit V(N + 1) must not be 0.
      V : Unsigned_32_Array (1 .. 37);
   end record;
end Grt.Fcvt;

////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 1999-2008 Easics NV.
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//
// Purpose : synthesizable CRC function
//   * polynomial: (0 4 5 8)
//   * data width: 8
//
// Info : tools@easics.be
//        http://www.easics.com
////////////////////////////////////////////////////////////////////////////////

  // polynomial: (0 4 5 8)
  // data width: 8
  // convention: the first serial bit is D[7]
  function [7:0] nextCRC8_D8;

    input [7:0] Data;
    input [7:0] crc;
    reg [7:0] d;
    reg [7:0] c;
    reg [7:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[7] = d[1] ^ d[3] ^ d[4] ^ d[7] ^ c[7] ^ c[4] ^ c[3] ^ c[1];
    newcrc[6] = d[0] ^ d[2] ^ d[3] ^ d[6] ^ c[6] ^ c[3] ^ c[2] ^ c[0];
    newcrc[5] = d[1] ^ d[2] ^ d[5] ^ c[5] ^ c[2] ^ c[1];
    newcrc[4] = d[0] ^ d[1] ^ d[4] ^ c[4] ^ c[1] ^ c[0];
    newcrc[3] = d[0] ^ d[1] ^ d[4] ^ d[7] ^ c[7] ^ c[4] ^ c[1] ^ c[0];
    newcrc[2] = d[0] ^ d[1] ^ d[4] ^ d[6] ^ d[7] ^ c[7] ^ c[6] ^ c[4] ^ c[1] ^ c[0];
    newcrc[1] = d[0] ^ d[3] ^ d[5] ^ d[6] ^ c[6] ^ c[5] ^ c[3] ^ c[0];
    newcrc[0] = d[2] ^ d[4] ^ d[5] ^ c[5] ^ c[4] ^ c[2];
    nextCRC8_D8 = newcrc;
  end
  endfunction

% -*- Mode:octave; Coding:us-ascii-unix; fill-column:120 -*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.S.%%
%% Copyright (c) 2025, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
%% 
%% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
%% following conditions are met:
%% 
%% 1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the
%%    following disclaimer.
%% 
%% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the
%%    following disclaimer in the documentation and/or other materials provided with the distribution.
%% 
%% 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
%%    products derived from this software without specific prior written permission.
%% 
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
%% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
%% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
%% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
%% USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%
%% File      applyToCols.m          
%% Author    Mitch Richling http://www.mitchr.me/
%% Date      2025-07-14        
%% Keywords  apply margin function                
%% Std       octave matlab_2022b           
%% Usage 
%%  Description
%%    Apply a function to the columns of a matrix, and return a vector of the results.
%%  Calling Forms
%%    y = applyToCols(func, x)
%%  Inputs
%%    - func .......... A function handle
%%    - x ............. A matrix
%%  Outputs
%%    - out .......... A vector of function results
%%  Details
%%    This function provides a simple interface for applying a function to the columns of a matrix.  
%%   
%%    See the commentary on built-in functions operateing on "margins" and about cells in applyToRows.m.
%%  Examples
%%    Example 1: Compute the maximum value in each column
%%      sum(applyToCols(@vecnorm, a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.H.E.%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y] = applyToCols(func, x)
  validateattributes(func,  {'function_handle'}, {'nonempty'});
  validateattributes(x,     {'numeric'}, {'nonempty'});
  y = zeros(1, size(x, 2));
  for i = 1:size(x,2)
	y(i) = func(x(1:end, i));
  end
end

#!/usr/bin/env -S sh
# -*- Mode:Shell-script; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      install.sh
# @author    Mitch Richling http://www.mitchr.me/
# @brief     Put files in position for Matlab & Octave to pick them up.@EOL
# @keywords  path
# @std       sh
# @copyright 
#  @parblock
#  Copyright (c) 2025, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#  
#  1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.
#  
#  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#  
#  3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software
#     without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
#  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
#  DAMAGE.
#  @endparblock
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# The files you want to put into various directories
TO_MATLAB_PATH='hist2d.m plotFreqSpec.m plotCurveFile.m runningOn.m sumByBlocks.m applyToRows.m applyToCols.m simplifyCurveEuc.m'

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# This can be a space separated list to distribute files into multiple locations
MATLAB_PATH='~/core/matlab ~/core/octave'

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Set this to 'T' to copy files.  Set it to anything else to just print what would be done instead.
if [ "$1" == '--dry-run' ]; then
  DOIT='F'
else
  DOIT='T'
  if [ "$#" != '0' ]; then
    echo "ERROR: The only allowed command line option is '--dry-run'"
    echo ""
    echo ""
    echo "This script is designed to distribute new/modified files into one or more"
    echo "directories and be quite verbose about what it's doing.  The original use"
    echo "case was to make sure various Matlab & Octave files were placed into"
    echo "directories included on the load path for the various versions of Matlab &"
    echo "Octave I was using at the time."
    echo ""
    echo "This script will distribute the following files:"
    for f in $TO_MATLAB_PATH; do
      echo "  - $f"
    done
    echo "Into the following directories:"
    for p in $MATLAB_PATH; do
      eval p=$p
      echo "  - $p"
    done
    exit
  fi
fi

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
for p in $MATLAB_PATH; do
  eval p=$p
  if [ -e $p ]; then
    for f in $TO_MATLAB_PATH; do
      if [ -e $f ]; then
        nf=$p/$f
        if [ ! -e $nf ]; then
          echo "INFO: New file:             $nf"
          if [ $DOIT = 'T' ]; then
            cp $f $nf                      
          else
            echo "INFO: Dry Run Mode"
          fi
        elif ! diff -q $f $nf >/dev/null; then
          echo "INFO: File Difference:      $nf"
          if [ $DOIT = 'T' ]; then
            cp $f $nf                      
          else
            echo "INFO: Dry Run Mode"
          fi
        else
          echo "INFO: File is up to date:   $nf"
        fi
      else
        echo "ERROR: Missing source file: $f"
      fi
    done
    # Look for stuff not on the list
    ls $p/* | grep -Ev "$(echo $TO_MATLAB_PATH | sed 's/  */|/g; s@^@/(@; s/$/)$/;')" | sed 's/^/WARNING: Unexpected file:   /'
  else
    echo "ERROR: Missing destination: $p"
  fi
done

#!/bin/bash
offset=1
ref=abl_ligand.inpcrd
prmtop=abl_ligand.prmtop
outtraj=concatenated.nc

# Clean start
rm -f rmsd.cpptraj

# Write cpptraj input
{
  echo "parm $prmtop"
  for C in 2 6 7 8 9; do
    echo "trajin step$C.nc 0 last $offset"
  done
  echo "trajout $outtraj netcdf"
  echo "reference $ref parm $prmtop [$ref]"
  echo "autoimage"
  echo "rms @CA ref [$ref] out $ref-rmsd-pre.csv mass"
  echo "go"
  echo "quit"
} >> rmsd.cpptraj

# Run cpptraj
cpptraj -i rmsd.cpptraj
# add actual commas to the .csv file so the frame number and rmsd are in seperate columns in excel
sed 's/^ *//; s/ \+/,/g' $ref-rmsd-pre.csv > $ref-rmsd.csv
rm $ref-rmsd-pre.csv

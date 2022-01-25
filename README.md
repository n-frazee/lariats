# Project Overview
*Add some actual stuff here*

## Directory Breakdown

- The `libs` directory contains text files representing the sublibraries of the Lockey 2021 paper. Each line in the text file represents a single lariat configuration.
- The `peps` directory contains the .pdb and .psf files for the peptide and the files necessary to generate them. The directories represent the sublibrary then the line from the text file used to generate the peptide.
- The `common` directory contains all the scripts referenced by the scripts in the main directory.
- `fftk_linkage_params` contains the files used in conjunction with FFTK in VMD to generate the parameters for the linkage that makes the lariats cyclic peptides.
- `future_trash` contains directories that will be deleted as soon as it has been made sure they're useless.

## Short Script Description

- `aa_string_generator.sh` creates the sublibrary directories and the `peps.txt` contained in each of them. `peps.txt` is all the possible residue configurations for the sublibrary.
- `psfgen_maker.sh` takes a predefined number of the lines from `peps.txt` and creates the necessary `psfgen` script to generate the peptide.
- `run_min_eq.sh` runs all of the generated peptides through a minimization and equilibration procedure, submitting a new job for each peptide.

## Plan of Attack on running the Octanol and Water Experiments
1. Generate the string describing the lariats
2. Interpret that string using psfgen to make a 3d structure
3. Solvate and neutralize lariats (10 A padding on all sides)
4. Minimize 5k
5. 100 ps NVT restrain CAs
6. 1 ns NPT restrain CAs
7. Production run in NVT; add gamd if necessary

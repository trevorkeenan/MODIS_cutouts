# MODIS_cutouts

A simple R script, based on the MODIStools package, for extracting MODIS data for a list of locations.

To extract MODIS data:
  1. supply a file containing the latitude and longitude of your locations (example given)
  2. edit the file paths in the R script to match your architecture
  3. specify the MODIS product and band required
  4. specify the time period required (as currently set up the code downloads one year at a time).
  5. specify the size of the grid surrounding each pixel required (currently 1km grid).
  
  See details of the MODISSubsets call in the MODIStools package for more info.
  (https://cran.r-project.org/web/packages/MODISTools/MODISTools.pdf)  
  

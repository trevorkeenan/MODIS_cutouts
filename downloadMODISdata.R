# this script will...
# loop though the lat lon's provided
# query the MODIS server to extract a product band for a defined pixel size

# NOTES: pulling all years together seems to time out the server
# running year by year works better
# code is designed to retry download if not successful (3 attempts)
# and continue to next site year if download fails
# It will also skip data that has already been downloaded
# which allows for rerunning to catch any site years that were missed (highly advised)

# Trevor Keenan, Jan 2017

# must install MODIStools before running
library(MODISTools)

setwd('./MODIS_cutouts/')
# this should contain the subfolder '/dataDownloaded/'

# set details of product, band, time period and resolution
Product<-"MOD15A2";
Band<-'Fpar_1km';
pixel <- c(1,1) # 1,1 indicates 1km grid size = 3*3
yearsRequired<-seq(2000,2016,1) # set the years required

# read in the site locations
siteinfo <- read.csv( paste("./siteinfo_fluxnet2015.csv", sep="" ) )
nsites <- dim(siteinfo)[1]

# for each site
for (idx in 1:nsites){
  
  # get the current site name
  sitename <- as.character(siteinfo$mysitename[idx])
  # set folder for saving results
  outDir<-paste('./dataDownloaded/',sitename,sep="" )
  
  # test if there is already data downloaded for this site
  # if there is, find last year downloaded and get the next:end 
  tmp<-dir(outDir,'*.asc')
  
  if (length(tmp)==0){  # no data previously downloaded
    # create the dir
    dir.create(outDir)
    yearsToDownload <- yearsRequired
  }else{
    # identify what years are already downloaded
  locEnd<-regexpr("Start", tmp)
  yearsDownloaded<- as.numeric(substring(tmp, locEnd+5,locEnd+8))
  
  # find the missing years 
  yearsToDownload <- yearsRequired[! yearsRequired %in% yearsDownloaded]
  }
  # define the current site lat and lon
  lon <- siteinfo$lon[idx]
  lat <- siteinfo$lat[idx]
  print(lat)
  print(lon)
  
  # if the last year is >2016 then all the data is already downloaded  
  if (length(yearsToDownload)>0) {
    
    for (idx2 in yearsToDownload ){
      enddate<-idx2
      period <- data.frame(lat=lat,long=lon,start.date=idx2,end.date=enddate,id=1)
      
      print(idx2)
   
      # request data. downloaded to outDir.  
      r <- 1
      attempt <- 1
      while( !is.null(r) && attempt <= 3 ) {
        attempt <- attempt + 1
        try(
          r <- MODISSubsets(LoadDat = period,Products = Product,Bands = Band,Size = pixel,SaveDir = outDir,StartDate = T)
        )
      } 
    }
  }
}


# additional useful code...
#dates<-GetDates(Product = Product, Lat = Lat, Long = Lon)
#MODISSubsets(LoadDat = period,Products = Product,Bands = Band,Size = pixel,SaveDir = outDir,StartDate = T)


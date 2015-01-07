library('dplyr')
dist<-read.table('/Users/erinmcmahon/mygit/datavis/assets/distday/openpaths_emcmahon013.csv',sep=',',header=TRUE)

lagged<-function(x){
  n=length(x)
  y<-array(x[1],dim=c(n))
  for (i in 2:n) {
    y[i]<-x[i-1]
  }
  return(y)
}

lon2<-lagged(dist$lon)
lon1<-dist$lon
lat2<-lagged(dist$lat)
lat1<-dist$lat
lat1<-lat1*pi/180
lat2<-lat2*pi/180
lon1<-lon1*pi/180
lon2<-lon2*pi/180
dlon = lon2 - lon1 
dlat = lat2 - lat1 
a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2 
c = 2 * atan2( sqrt(a), sqrt(1-a) ) 
R=3961
d = R * c

dist['dist']<-d
dist$ln.dist<-log(dist$dist)
dist$ln.dist[1]<-0
hist(dist$ln.dist)

dist$date<-as.POSIXct(strptime(dist$date,"%m/%d/%y %H:%M"))
dist$day<-cut(dist$date,"1 day")
dist.day<-ddply(dist,.(day),summarize,dist=sum(dist))
dist.day$day<-strftime(strptime(dist.day$day,"%Y-%m-%d %H:%M:%S"),"%Y-%M-%D")
dist.day$ln.dist<-log(dist.day$dist)
write.table(dist.day,file="/Users/erinmcmahon/mygit/datavis/assets/distday/distdayd3.csv",sep=",",row.names=FALSE)



#dist$hour<-cut(dist$date,"1 hour")
#dist.hour<-ddply(dist,(.hour),summarize,)
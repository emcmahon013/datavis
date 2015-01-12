library('plyr')
dist<-read.table('/Users/erinmcmahon/mygit/datavis/assets/distday/openpaths_emcmahon013.csv',sep=',',header=TRUE)

lagged<-function(x){
  n=length(x)
  y<-array(x[1],dim=c(n))
  for (i in 2:n) {
    y[i]<-x[i-1]
  }
  return(y)
}

wkday<-function(x){
  if (x=='Monday'){
    y<-1
  } else if(x=='Tuesday'){
    y<-2
  } else if (x=='Wednesday'){
    y<-3
  } else if (x=='Thursday'){
    y<-4
  } else if (x=='Friday'){
    y<-5
  } else if (x=='Saturday'){
    y<-6
  } else {y<-7}
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
dist.day$day<-strftime(strptime(dist.day$day,"%Y-%m-%d %H:%M:%S"),"%Y-%m-%d")
dist.day$ln.dist<-log(dist.day$dist)
colnames(dist.day)<-c('Date','Dist','Ln')
write.table(dist.day,file="/Users/erinmcmahon/mygit/datavis/assets/distday/distday.csv",sep=",",row.names=FALSE)
dist.day$day<-weekdays(as.Date(dist.day$Date))
dist.day$wkday<-mapply(dist.day$day,FUN=wkday)
dist.wk<-ddply(dist.day,.(wkday),summarize,count=length(Dist))

dist$clean.dist<-dist$dist
dec<-dist[order(dist$dist,decreasing=T),]
dist$clean.dist[6120]<-0.5
dist$clean.dist[6114]<-0.5
dist$clean.dist[2309]<-0.5
dist$clean.dist[3999]<-0.5
dist$clean.dist[4146]<-0.5
dist$clean.dist[2450]<-0.5
dist$clean.dist[2452]<-0.5

#dist$date<-as.POSIXct(strptime(dist$date,"%m/%d/%y %H:%M"))
dist$hr<-cut(dist$date,"1 hour")
dist.hr<-ddply(dist,.(hr),summarize,dist=sum(clean.dist))
colnames(dist.hr)<-c('date','dist')
dist.hr$day<-weekdays(as.Date(dist.hr$date))
dist.hr$wkday<-mapply(dist.hr$day,FUN=wkday)
dist.hr$hr<-strftime(strptime(dist.hr$date,"%Y-%m-%d %H:%M:%S"),"%H")
dist.hr$yr<-strftime(strptime(dist.hr$date,"%Y-%m-%d %H:%M:%S"),"%Y")
dist.hr<-dist.hr[,c(1,3,4,5,2)]
dist.hr$ln<-log(dist.hr$dist)
dist.hr$ln[1]<-0

dist.test<-merge(dist.hr,dist.wk,by=c("wkday"),all=TRUE)
dist.test$date<-strptime(dist.test$date,"%Y-%m-%d %H:%M:%S")
dist.test<-dist.test[order(dist.test$date),]
dist.test$row.names<-NULL

dist.agg<-ddply(dist.test,.(wkday,hr),summarise,dist=sum(dist))
dist.count<-ddply(dist.test,.(wkday,hr),summarise,count=length(dist))
dist.tot<-ddply(dist.test,.(wkday,hr),summarize,total=mean(count))
dist.agg$avg<-dist.agg$dist/dist.tot$total


write.table(dist.agg,file="/Users/erinmcmahon/mygit/datavis/assets/distday/disthr.csv",sep=",",row.names=FALSE)


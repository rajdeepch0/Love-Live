install.packages('googleway')
install.packages('rlist')
library('rlist')
library('googleway')
setwd(choose.dir("Desktop"))
data1 = read.csv(file="finalchangeschool&hospital.csv",header=TRUE,sep=",")
api_key = 'AIzaSyBykEitL7xzzZb3QovW2vDq6rrx7Z2iHCs'
m = matrix(ncol = 4)
for (i in data1$Suburb)
{
  test = NULL
  test2 = NULL
  test3 = NULL
  sear = paste0(i,",VIC","");
  print(sear);
  test = google_places(search_string=sear,
                       place_type="transit_station",radius=1,
                       key=api_key)
  test2 = google_places(search_string=sear,radius=1,place_type="transit_station",page_token=test$next_page_token,key=api_key)
  test3 = google_places(search_string=sear,radius=1,place_type="transit_station",page_token=test2$next_page_token,key=api_key)
  loop=1
  while(loop<=length(test$results$name))
  {
    temp = c(i,test$results$name[loop],test$results$geometry$location$lat[loop],test$results$geometry$location$lng[loop])
    m <- rbind(m,temp)
    loop = loop + 1
  }
  loop1=1
  while(loop1<=length(test2$results$name))
  {
    if(!is.null(test2)){
      temp = c(i,test2$results$name[loop1],test2$results$geometry$location$lat[loop1],test2$results$geometry$location$lng[loop1])
      m <- rbind(m,temp)
    }
    loop1 = loop1 + 1
  }
  loop2=1
  while(loop2<=length(test3$results$name))
  {
    if(!is.null(test3)){
      temp = c(i,test3$results$name[loop2],test3$results$geometry$location$lat[loop2],test3$results$geometry$location$lng[loop2])
      m <- rbind(m,temp)
    }
    loop2 = loop2 + 1
  }
  #temp_df = data.frame(m)
  #temp_df = temp_df[!grepl(i,temp_df$X2),]
  #m_temp = temp_df
  #m_final = rbind(m_final,m_temp)
}
m_dataframe = data.frame(m)
m_dataframe = na.omit(m_dataframe)
m_dataframe = m_dataframe[!duplicated(m_dataframe),]
colnames(m_dataframe) = c("Suburb","Name","Lat","long")
write.csv(m_dataframe,file="transit_station - pagetoken.csv")
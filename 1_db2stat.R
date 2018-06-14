# mydf$meta에 포함된 caption 정보를 cap_vec에 저장한 후 빈도 순으로 cap_tbl에 저장하여 plot한다.(1)
# cap_vec에 한번이라도 나온 caption을 cap_vec_red에 저장하고
# thre보다 작은 frequency를 갖는 caption을 제외한 결과를 cap_vec_final에 저장한 후
# 빈도 순으로 cap_tbl_final에 저장하여 plot한다.(2)

# 처음 설치시만 실행
install.packages("rJava")
install.packages("DBI")
install.packages("RJDBC")

Sys.setlocale(category = "LC_ALL", locale = "us")# invalid multibyte string at '<ec><9d><b4>'와 같은 에러가 발생시에만 실행한다.
library(DBI)
library(rJava)
library(RJDBC)
thre<-50
# classPath는 각자 올바른 경로를 입력해야 한다.
drv <- JDBC(driverClass="com.mysql.cj.jdbc.Driver", classPath = "/home/vdo-data3/install/mysql-connector-java_8.0.11-1ubuntu16.04_all/usr/share/java/mysql-connector-java-8.0.11.jar")
conn <- dbConnect(drv, "jdbc:mysql://49.236.137.219", "root", "dKDm7^#vjK1W")
query <- "select meta from vdo.tbl_task_file where tidx=5"
mydf <- dbGetQuery(conn, query)
cap_list<-list()
split<-list()
a<-nrow(mydf)
# 이중 for문에서 시간이 오래걸릴 수 있으므로 실행후 >가 뜰때까지 기다리자.
for(i in 1:a){
  split[i]<-strsplit(mydf$meta[[i]], '"name"\\:\\"')
  b=length(split[[i]])
  for(j in 2:b){
    cap_list<-append(cap_list, strsplit(split[[i]][j], '"')[[1]][1])
  }
}
cap_vec<-unlist(cap_list)
cap_vec
length(cap_vec)
cap_tbl<-sort(table(cap_vec), decreasing=T)
nrow(cap_tbl)
cap_tbl
plot(cap_tbl)
cap_vec_red<-names(cap_tbl)
cap_vec2rm<-c()
for(c in cap_vec_red){
  if(length(which(cap_vec==c))<thre){
    cap_vec2rm<-append(cap_vec2rm, c)
  }
}
cap_vec_final<-cap_vec[!cap_vec %in% cap_vec2rm]
cap_vec_final
length(cap_vec_final)
cap_tbl_final<-sort(table(cap_vec_final), decreasing=T)
cap_tbl_final
nrow(cap_tbl_final)
plot(cap_tbl_final)

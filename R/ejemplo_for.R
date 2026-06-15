lldf <- list(
  catA = list(
    sub_cat1 = data.frame(X = 1:2, Y = c("A","B")),
    sub_cat2 = data.frame(X = c(3,6), Y = c("A2","B"))
  ),
  catB = list(
    sub_cat1 = data.frame(X = 1:2, Y = c("Z","W")),
    sub_cat2 = data.frame(X = c(4,7), Y = c("AA","C"))
  )
)

result<-data.frame()
nomcats<-names(lldf)
for(nomcat in nomcats){ #nomcat="catA" | "catB"
  ldfcat<-lldf[[nomcat]]
  nomsubcats<-names(ldfcat)
  for(nomsubcat in nomsubcats){ #nomsubcat="sub_cat1" | "sub_cat2"
    df_subcat<-ldfcat[[nomsubcat]]
    df_subcat$cat <- nomcat
    df_subcat$sub_cat <- nomsubcat
    result <- rbind(result, df_subcat)}
   }
result
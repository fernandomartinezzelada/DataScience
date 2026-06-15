?dplyr

?dplyr::filter

?head

?dplyr::count()

sales <- data.frame(
  Region = c("East", "West", "East", "West", "East", "West"),
  Category = c("Electronics", "Clothing", "Electronics", "Electronics", "Clothing", 
               "Electronics")
)
sales 
sales %>%
  count()

?dplyr::inner_join()

?dplyr::group_by()

?dplyr::order_by()

?dplyr::arrange()

sales %>%
  dplyr::arrange(Region,desc(Category))

-2.7435    +     4.5135




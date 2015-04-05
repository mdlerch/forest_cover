
# data manipulation
library(tidyr)
library(dplyr)
# different plotting libraries
library(ggplot2)
library(streamgraph)
library(rcdimple)
library(rbokeh)
library(ggvis)

# grab right n characters of a string
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

# data ------------------------------------------------

# load data
dat <- read.csv("data/our_train.csv", header = T, stringsAsFactors = F) %>% 
  tbl_df() %>% 
  select(-X)

# turn soil column into long format
soil_long <- dat %>% 
  gather(Soil, yn, -(Id:Wilderness_Area4), -Cover_Type) %>% 
  filter(yn == 1) %>% 
  mutate(
    Soil = as.character(Soil), 
    Soil = ifelse(nchar(Soil) == 10, substrRight(Soil, 1), substrRight(Soil, 2)), 
    Soil = as.numeric(Soil)
  ) %>% 
  select(-yn)

# turn wilderness to long format 
wild_long <- dat %>% 
  gather(Wilderness, yn, -(Id:Horizontal_Distance_To_Fire_Points), -(Soil_Type1:Soil_Type40), -Cover_Type) %>%
  filter(yn == 1) %>% 
  mutate(
    Wilderness = Wilderness %>% as.character %>% substrRight(1) %>% as.numeric) %>% 
  select(-yn)

# soil vs cover ------------------------------------

# basic bar chart
qplot(factor(Soil), data = soil_long, fill = factor(Cover_Type)) + 
  scale_fill_brewer(palette = "PuOr")
# as a streamgraph
soil_long %>% 
  group_by(Soil, Cover_Type) %>% 
  summarise(num = n()) %>% 
  ungroup() %>% 
  mutate(Soil = Soil %>% paste0(., "-01-01") %>% as.Date) %>%  ## super cheesy
  streamgraph("Cover_Type", "num", "Soil", interpolate="monotone") %>%
  sg_axis_x(1, "year", "%Y") %>%
  sg_legend(show=TRUE, label="Cover Type: ")%>%
  sg_fill_brewer("PuOr")

# wilderness vs cover ------------------------------------

# basic bar chart
qplot(factor(Wilderness), data = wild_long, fill = factor(Cover_Type)) + 
  scale_fill_brewer(palette = "PuOr")
# using rcdimple
wild_long %>% 
  group_by(Cover_Type, Wilderness) %>% 
  summarise(num = n()) %>% 
  ungroup() %>% 
  dimple(
    x = "Wilderness", 
    y = "num", 
    groups = "Cover_Type", 
    type = "bar", 
    data = .
  ) %>% 
  add_legend(x = 2, width = 300)

# vs elevation by wilderness
wild_bokeh <- wild_long %>% 
  mutate(Wilderness = as.character(Wilderness), 
         Cover_Type = Cover_Type + runif(n(), -.1, .1))
figure() %>% 
  ly_points(Elevation, Cover_Type, data = wild_bokeh,
            glyph = Wilderness, color = Wilderness, alpha = 0.5, 
            hover = list(Elevation, Wilderness, Cover_Type))

# by quant vars --------------------------------------------

# elevation - not useful on its own
dat %>% 
  mutate(Cover_Type = factor(Cover_Type)) %>% 
  ggvis(~Elevation, fill = ~Cover_Type) %>% 
  group_by(Cover_Type) %>% 
  layer_densities()

# aspect - not very helpful
dat %>% 
  mutate(Cover_Type = factor(Cover_Type)) %>% 
  ggvis(~Aspect, fill = ~Cover_Type) %>% 
  group_by(Cover_Type) %>% 
  layer_densities()
# something with polar coordinates(?)






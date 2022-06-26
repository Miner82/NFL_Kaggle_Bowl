
library(tidyverse)
library(gifski)
library(av)
library(gganimate)
library(cowplot)
library(repr)
library(ggplot2) 

options(warn=-1)
df_games <- read_csv("C:/users/user/desktop/games.csv",
                     col_types = cols())
df_players <- read_csv("C:/users/user/desktop/players.csv",
                     col_types = cols())
df_plays <- read_csv("C:/users/user/desktop/plays.csv",
                     col_types = cols())
# -there are some nonparsing error here due to multiple returnerIDs for laterals.
# passerID field manually removed.

df_tracking19 <- read_csv("C:/users/user/desktop/tracking2019.csv", col_types = cols())
#df_tracking19 <- subset(df_tracking19$gameId == 2019122100)

#Standardizing tracking data so its always in direction of offense vs raw on-field coordinates.
df_trackingcorrect19 <- df_tracking19 %>%
  mutate(x = ifelse(playDirection == "left", 120-x, x),
         y = ifelse(playDirection == "left", 160/3 - y, y))

## declaring values for field coordinates

# General field boundaries
xmin <- 0
xmax <- 160/3
hash.right <- 38.35
hash.left <- 12
hash.width <- 3.3

#picking a random play
#@set.seed(1)

#example_play <- df_plays %>%
#  select(gameId, playId, playDescription) %>% 
#  sample_n(1)
#merging games data to play
e_play <- inner_join(df_plays,
                           df_games,
                           by = c("gameId" = "gameId"))

#merging tracking data to play
e_play <- inner_join(e_play,
                           df_trackingcorrect19,
                           by = c("gameId" = "gameId",
                                  "playId" = "playId"))
      # select a game and a play from our badkickreturns runs                                                 
sample_play <- e_play[e_play$gameId == 2019122100 & e_play$playId == 36, ]
#mark out the field
cols_fill <- c("#FB4F14", "#663300", "#A5ACAF")
cols_col <- c("#000000", "#663300", "#000000")


#plot_title <- str_trim(gsub("\\s*\\([^\\)]+\\)","",as.character(e_play$play="36")))

# Specific boundaries for a given play
ymin <- max(round(min(sample_play$x, na.rm = TRUE) - 10, -1), 0)
ymax <- min(round(max(sample_play$x, na.rm = TRUE) + 10, -1), 120)

#hash marks
df.hash <- expand.grid(x = c(0, 23.36667, 29.96667, xmax), y = (10:110))
df.hash <- df.hash %>% filter(!(floor(y %% 5) == 0))
df.hash <- df.hash %>% filter(y < ymax, y > ymin)

ggplot() +
  
  #setting size and color parameters
  scale_size_manual(values = c(6, 4, 6), guide = FALSE) + 
  scale_shape_manual(values = c(21, 16, 21), guide = FALSE) +
  scale_fill_manual(values = cols_fill, guide = FALSE) + 
  #adding hash marks
  annotate("text", x = df.hash$x[df.hash$x < 55/2], 
           y = df.hash$y[df.hash$x < 55/2], label = "_", hjust = 0, vjust = -0.2) + 
  annotate("text", x = df.hash$x[df.hash$x > 55/2], 
           y = df.hash$y[df.hash$x > 55/2], label = "_", hjust = 1, vjust = -0.2) + scale_colour_manual(values = cols_col, guide = FALSE) +
  #adding yard lines
  annotate("segment", x = xmin, 
           y = seq(max(10, ymin), min(ymax, 110), by = 5), 
           xend =  xmax, 
           yend = seq(max(10, ymin), min(ymax, 110), by = 5)) +
  #adding field yardline text
  annotate("text", x = rep(hash.left, 11), y = seq(10, 110, by = 10), 
           label = c("G   ", seq(10, 50, by = 10), rev(seq(10, 40, by = 10)), "   G"), 
           angle = 270, size = 4) + 
  annotate("text", x = rep((xmax - hash.left), 11), y = seq(10, 110, by = 10), 
           label = c("   G", seq(10, 50, by = 10), rev(seq(10, 40, by = 10)), "G   "), 
           angle = 90, size = 4) + 
  #adding field exterior
  annotate("segment", x = c(xmin, xmin, xmax, xmax), 
           y = c(ymin, ymax, ymax, ymin), 
           xend = c(xmin, xmax, xmax, xmin), 
           yend = c(ymax, ymax, ymin, ymin), colour = "black") + 
  #adding players
  geom_point(data = sample_play, aes(x = (xmax-y),
                                      y = x, 
                                      shape = team,
                                      fill = team,
                                      group = nflId,
                                      size = team,
                                      colour = team), 
             alpha = 0.7) +  
  #adding jersey numbers
  geom_text(data = sample_play, aes(x = (xmax-y), y = x, label = jerseyNumber), colour = "white", 
            vjust = 0.36, size = 3.5) + 
  
  #applying plot limits
  ylim(ymin, ymax) + 
  coord_fixed() +
  
  #applying theme
  #theme_nothing() + 
  #theme(plot.title = element_text()) +
  #titling plot with play description
  labs(title = "Now showing ") +
  
  #setting animation parameters
  transition_time(frameId)  +
  ease_aes('cubic-in-out') + 
  NULL

# selecting a play 


#suppress warnings for this notebook
options(warn=-1)
#to turn warnings back on
#options(warn=0)

#load packages
library(ggplot2)
install.packages("GGally")
suppressMessages( #suppress messages for this piece of code
    library(GGally))

install.packages("faraway")
suppressMessages(
    library(faraway))
data(nepali)

suppressMessages(
    library(dplyr))

nepali <- nepali %>%
  select(id, sex, wt, ht, age) %>%
  mutate(id = factor(id),
         sex = factor(sex, levels = c(1, 2),
                      labels = c("Male", "Female"))) %>%
  distinct(id, .keep_all = TRUE)


head(nepali)

ggpairs(nepali %>% select(sex, wt, ht, age))

data(worldcup) #part of the faraway package, which we already installed

install.packages("dlnm")
suppressMessages(
    library(dlnm))
data(chicagoNMMAPS)
chic <- chicagoNMMAPS
chic_july <- chic %>%
  filter(month == 7 & year == 1995) #limit dataset to July 1995

install.packages("ggthemes")
library(ggthemes)

chicago_plot <- ggplot(chic_july, aes(x = date, y = death)) + 
  xlab("Day in July 1995") + 
  ylab("All-cause deaths") + 
  ylim(0, 450) 

chicago_plot + 
  geom_area(fill = "black") + 
  theme_excel() #add ggtheme

chicago_plot + 
  geom_line() + 
  theme_tufte() #ggtheme

# First, create a messier example version of the data with 'bad' labels

library(forcats)

wc_example_data <- worldcup %>%
  dplyr::rename(Pos = Position) %>%
  mutate(Pos = fct_recode(Pos,
                          "DC" = "Defender",
                          "FW" = "Forward", 
                          "GK" = "Goalkeeper",
                          "MF" = "Midfielder"))

# Plot data

wc_example_data %>%
  ggplot(aes(x = Pos)) + 
  geom_bar() 

wc_example_data %>%
  mutate(Pos = fct_recode(Pos,
                          "Defender" = "DC",
                          "Forward" = "FW", 
                          "Goalkeeper" = "GK",
                          "Midfielder" = "MF")) %>%
  ggplot(aes(x = Pos)) +
  geom_bar(fill = "lightgray") + 
  xlab("") + 
  ylab("Number of players") + 
  coord_flip() + 
  theme_tufte()

ggplot(filter(worldcup, Position == "Forward"), aes(x = Passes, y = Shots)) + 
        geom_point(size = 1.5) + 
        theme_few()

ggplot(filter(worldcup, Position == "Forward"), aes(x = Passes, y = Shots)) + 
        geom_point(size = 1.5) + 
        theme_few()  + 
        geom_smooth() #add reference line
 

worldcup %>%
  ggplot(aes(x = Time, y = Shots, color = Position)) + 
  geom_point() 

worldcup %>%
  ggplot(aes(x = Time, y = Shots)) + 
  geom_point() +
  facet_grid(. ~ Position) 

worldcup %>%
  filter(Team %in% c("Spain", "Netherlands")) %>%
  ggplot(aes(x = Time, y = Shots)) + 
  geom_point() +
  facet_grid(Team ~ Position)

worldcup %>%
  ggplot(aes(x = Time, y = Shots)) + 
  geom_point(alpha = 0.25) +
  facet_wrap(~ Team, ncol = 6) 

suppressMessages(
    worldcup %>%
      group_by(Team) %>%
      summarize(mean_time = mean(Time)) %>%
      ggplot(aes(x = mean_time, y = Team)) + 
      geom_point() + 
      theme_few() + 
      xlab("Mean time per player (minutes)") + ylab("") 
)

suppressMessages(
    worldcup %>%
      group_by(Team) %>%
      summarize(mean_time = mean(Time)) %>%
      arrange(mean_time) %>%                         # re-order categorical variable and re-set
      mutate(Team = factor(Team, levels = Team)) %>% # factor levels before plotting
      ggplot(aes(x = mean_time, y = Team)) + 
      geom_point() + 
      theme_few() + 
      xlab("Mean time per player (minutes)") + ylab("") 
)


worldcup %>%
  dplyr::select(Team, Time) %>%
  dplyr::group_by(Team) %>% #group data by team
  dplyr::mutate(ave_time = mean(Time),
                min_time = min(Time),
                max_time = max(Time)) %>% #average time within team
  dplyr::arrange(ave_time) %>% #order by mean time
  dplyr::ungroup() %>%
  dplyr::mutate(Team = factor(Team, levels = unique(Team))) %>% #reset factor levels
  ggplot(aes(x = Time, y = Team)) + 
  geom_segment(aes(x = min_time, xend = max_time, yend = Team),
               alpha = 0.5, color = "gray") + 
  geom_point(alpha = 0.5) + 
  geom_point(aes(x = ave_time), size = 2, color = "red", alpha = 0.5) + 
  theme_minimal() + 
  ylab("")

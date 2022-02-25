## ----setup-------------------------------------------

library(gapminder)
library(here)
library(tidyverse)
library(socviz)


## 3.3 Mappings Link Data to Things You See

# Reminder of what gapminder looks like
gapminder

# Defining the landscape/dimensionality of our graph 
p <- ggplot(data = gapminder)
p

# Giving our landscape more structure (making axis for graph)
p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y = lifeExp))
p

## 3.4 Build Your Plots Layer by Layer (turns data into scatter plot)
p + geom_point() 

gapdata <- as.data.frame(gapminder)

# Note: next ggplot() command is redundant

p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y=lifeExp))
#Turn data into a "smooth" function, line with confidence interval shadow
p + geom_smooth()

# Add back individual dots as well, dots with line

p + geom_point() + geom_smooth() 


# Fitting a linear regression to data

p + geom_point() + geom_smooth(method = "lm") 

# Default method

p + geom_point() + geom_smooth(method = "gam") 
p + geom_point() + geom_smooth() 

# Converting X scale to logarithmic base 10 scale
# makes data fit better, look more linear
p + geom_point() +
    geom_smooth(method = "gam") +
    scale_x_log10()

# Using Loess mode smoothing
# looks even smoother
p + geom_point() +
    geom_smooth(method = "loess") +
    scale_x_log10()


# Setting labels on scale_() functions
# makes x axis dollars
p + geom_point() +
    geom_smooth(method = "gam") +
    scale_x_log10(labels = scales::dollar)


## 3.5 Mapping Aesthetics vs Setting Them

p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y = lifeExp,
                          color = "purple"))
# Note: have mapped a dimension ("color") into a character constant ("purple")

p + geom_point() +
    geom_smooth(method = "loess") +
    scale_x_log10()


# If you want to use a color for all points

p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y = lifeExp))
p + geom_point(color = "purple") +
    geom_smooth(method = "loess") +
    scale_x_log10()


# Setting opacity for points and color for line
# linear line that is too thick
p + geom_point(alpha = 0.3) +
    geom_smooth(color = "orange", se = FALSE, size = 8, method = "lm") +
    scale_x_log10()


# Tying all this together
# making a title, labels, caption
p + geom_point(alpha = 0.3) + geom_smooth(method = "gam") +
    scale_x_log10(labels = scales::dollar) +
    labs(x = "GDP Per Capita", y = "Life Expectancy in Years",
         title = "Economic Growth and Life Expectancy",
         subtitle = "Data points are country-years",
         caption = "Source: Gapminder.")


# Using multiple colors as a dimension
# adds the continent dimension, with separate color and lines for each
p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y = lifeExp,
                          color = continent))
p + geom_point() +
    geom_smooth(method = "loess") +
    scale_x_log10()


## ----03-make-a-plot-17, fig.cap='Mapping the continent variable to the color aesthetic, and correcting the error bars using the fill aesthetic.', fig.width=8.5, fig.height=5----
# coloring in the "fill" or confidence interval
p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y = lifeExp,
                          color = continent,
                          fill = continent))
p + geom_point() +
    geom_smooth(method = "loess") +
    scale_x_log10()


## 3.6 Aesthetics Can Be Mapped per Geom

# Here color is mapped to continent for the points
# but not the smoother.
# how to keep color for the dots, but keep just 1 line
p <- ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))
p + geom_point(mapping = aes(color = continent)) +
    geom_smooth(method = "loess") +
    scale_x_log10()


#Mapping a continuous variable to color.like a gradient

p + geom_point(mapping = aes(color = log(pop))) +
    scale_x_log10()    


## 3.7 Save Your Work

# Save your entire plot (including aesthetics) to an object
# store the object you want to save in a new object, then save it
# not required, but makes the ggsave command easier
p_out <- p + geom_point(mapping = aes(color = log(pop))) +
    scale_x_log10()
p_out
ggsave("ifexp_vs_gdp_gradient.pdf",plot = p_out)
# ggsave() currently recognises the extensions eps/ps, 
# tex (pictex), df, jpeg, tiff, png, bmp, svg
# and wmf (windows only).
ggsave("ifexp_vs_gdp_gradient.jpg",plot = p_out)

library(hexSticker)
library(png)
imgPath <- "data-raw/sticker.png"

sticker(imgPath,
        # pic
        package = "covid19usa",
        p_size = 4,
        p_y = 1.70,
        p_color = "black",
        p_family = "serif",
        # plot
        s_x = 1, s_y = 1, # position
        s_width = 0.9, s_height = 1.1, # size
        h_fill = "#c9e9f6",
        h_color = "black",
        filename = file.path("man/figures/logo.png"))

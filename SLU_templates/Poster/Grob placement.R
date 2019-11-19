# Poster template
library(magick)
head <- image_read("SLU_templates/Poster/header.jpg")
image_resize(a, "250x250")

library(grid)
g <- grob()
?grid.layout()
a <- grid.layout(3,1)
a
print(a)

pushViewport(?viewport(1,1))

grid.show.layout(a)

pushViewport(viewport(layout = a, layout.pos.row = 1, layout.pos.col = 1))

a <- grid.rect(gp = gpar(fill = "red"), draw = F)
grid.draw(a)

grid.lines()
library(ggplot2)
?ggplot2:::ggplot_gtable

library(gtable)
g <- gtable(unit(c(5,30,30,30,5), "npc"), unit(c(15,10,5,25,25,10), "npc"))
plot(1)


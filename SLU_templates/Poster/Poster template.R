# Text elements
text <- c("Interesting headlines",
          "Subheadings that further explain the report",
          "Conclusion",
          "Hit evelit, as il earupta tem-quodicit aruptatatin consedio eum lacest, occatusamusa am. Imus, ium quas aciist di destio              optat. It ent plis aut utem quo.",
          "Subheading",
          "Quis atur, sum quo et volorum aut dolorio consequi qui beaturi orpore est, expe prehentur quat mo veliquae dolorecate pa volup-tust?",
          "Subheading",
          "Ad el moloreperum nonsequia ilis ma alit, sequidebis seque re-risquibus, ne re pa debis au.\n Et ut optae. Piscitatis cus adisita tectem int rerferia poritam ad ma-gnistio. Conse quia quam, cusci iderferum aut accum, vent.",
          "Results",
          "Et ut optae. Piscitatis cus adisita tectem int rerferia poritam ad ma-gnistio. Conse quia quam, cusci iderferum aut accum, vent",
          "Us voloribus dolesti alisitiumet. Tis reperchit, es est, consequ-am qui aliquia cores volorepudit voluptatqui conse volupieniam abore disto ex eostibus a debitae pudaepu dantoreseque eos sun. Aut optas excea quatios eum sum reribus qui oditasp erunti qui iur, ipic te voloratio. Et ut optae. Piscitatis cus adisita tectem int rerferia poritam ad. Magnistio. Conse quia quam, cusci iderferum aut accum, vent. Us voloribus dolesti alisitiumet.")
texts <- data.frame(text, size = c(112, 70, rep(36, 9)), bold = c(T,F,T,T,T,F,T,F,T,F,F))


# Figure elements
library(magick)
head <- image_read("SLU_templates/Poster/header.jpg")

sq_plot <- image_crop(head, "500x500")

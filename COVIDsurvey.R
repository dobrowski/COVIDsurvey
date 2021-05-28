

### Load libraries --------

library(MCOE)
library(tidyverse)
library(googledrive)
library(googlesheets4)
library(blastula)
library(lubridate)
library(keyring)
library(here)

setwd("/Users/daviddobrowski/Documents/R/COVIDsurvey/")


drive_auth(email = "ddobrowski@montereycoe.org")
gs4_auth(token = drive_token())


### Pull the newest sheets from the folder  ---------


# 
# listfiles <- drive_find( q = "   name contains '(Responses) for'")
# 
# listfiles2 <- listfiles %>%
#     unnest_wider(col = drive_resource, names_repair = "unique")  %>%
#     filter(str_detect(owners,"Jessica Hull"),
#            modifiedTime == max(modifiedTime))
# 
# 
# sheet_id <- listfiles2$webViewLink

 sheet_id <- "https://docs.google.com/spreadsheets/d/1ji7n4zFXiiOVF5S7CvNjTpv4kLqEvRd2u9y2AlpTkuE/edit#gid=1061807504"


### Gets the daily responses -----

survey.responses <- read_sheet(sheet_id)

edsrv <- survey.responses %>%
    mutate(calendardate = as.Date(Date)) %>%
    filter(#Department ==  "Educational Services",
           calendardate == max((calendardate))
           )

### To generate list of everyone's email -----

# mino <- "evaldez@montereycoe.org"
# 
# emails <- edsrv %>%
#     select(`Email Address`) %>%
#     unique()
# 
# emails[32,1] <- mino
# 
# 
# write_rds(emails, "emaillist.rds")




# ### Analyze to determine who didn't respond -------

# emails <- read_rds(here("emaillist.rds"))


emails <- tibble::tribble(
                  ~`Email Address`,
       "elgomez@montereycoe.org",
     "mmatteoni@montereycoe.org",
     "ggonzalez@montereycoe.org",
    "adchavarin@montereycoe.org",
        "erubio@montereycoe.org",
      "jsavinon@montereycoe.org",
      "nesparza@montereycoe.org",
       "jelemen@montereycoe.org",
         "mwold@montereycoe.org",
      "acabrera@montereycoe.org",
        "dgreen@montereycoe.org",
"jevera@montereycoe.org",
       "eporter@montereycoe.org",
    "ddobrowski@montereycoe.org",
      "maramire@montereycoe.org",
     "laramirez@montereycoe.org",
        "gkuehl@montereycoe.org",
     "rodgarcia@montereycoe.org",
       "ronunez@montereycoe.org",
       "dholmes@montereycoe.org",
         "mcano@montereycoe.org",
     "wfranzell@montereycoe.org",

    "dorsalazar@montereycoe.org",
      "hpainter@montereycoe.org",
    "lgomezgong@montereycoe.org",
     "rphillips@montereycoe.org",
    "micramirez@montereycoe.org",
        "ilopez@montereycoe.org",
      "rpeterso@montereycoe.org",
       "evaldez@montereycoe.org",
    "clewis@montereycoe.org"
    )




missing.surveys <- left_join(emails, edsrv) %>% 
    filter(is.na(calendardate))


### Send emails ----


# create_smtp_creds_key(
#     id = "blastula",
#     user = "ddobrowski@montereycoe.org",
#     host = "smtp.gmail.com",
# 
#   #  provider = "gmail",
# #        overwrite = TRUE,
#      port = 465,
#      use_ssl = TRUE
#  )
# # 
# 
# create_smtp_creds_file(
#     file = "blastula",
#     host = "smtp.gmail.com",
#     port = 465,
#     user = "ddobrowski@montereycoe.org",
#     use_ssl = TRUE
#     
# )
# 
# 
# 
# plot <- qplot(disp, hp, data = mtcars, colour = mpg)
# plot_email <- add_ggplot(plot)



email <- compose_email(
    body = md(c(
        "Hello Adriana, \n\n
        It appears the following people have not submitted their COVID-19 daily survey. \n\n",
        missing.surveys$`Email Address`
        )),
    footer = md(c("Spreadsheet checked and email sent on ", add_readable_time()  ))
)


#write.csv(missing.surveys, "Missing Surveys.csv")


email %>%
    smtp_send(
        from = "ddobrowski@montereycoe.org",
        to = "adchavarin@montereycoe.org",
        cc = "ddobrowski@montereycoe.org",
        subject = "Missing MCOE Daily Wellness Surveys",
        credentials =creds_file("blastula")
    )


# https://thecoatlessprofessor.com/programming/r/sending-an-email-from-r-with-blastula-to-groups-of-students/


quit(save="no")

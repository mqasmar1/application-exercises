## Scrape popular TV shows from a locally saved IMDB TV Meter page
##
## BEFORE YOU RUN THIS SCRIPT — save the HTML page first:
##
##   1. Open https://www.imdb.com/chart/tvmeter in Chrome or Firefox
##   2. Wait for the full page to load (scroll down a bit if needed)
##   3. Press Ctrl+S (Windows/Linux) or Cmd+S (Mac)
##   4. In the Save dialog:
##        - Set "Save as type" to "Webpage, Complete" (Chrome)
##          or "Web Page, complete" (Firefox)
##        - Name the file:  imdb-tvmeter.html
##        - Save it into your AE 07 folder
##   5. Come back here and run the script
##
## Why? IMDB blocks automated requests from cloud environments like JupyterHub.
## Reading a locally saved file bypasses that restriction while keeping
## all the same rvest concepts intact.

# Load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)

# Read local html page ---------------------------------------------------------

page <- read_html("imdb-tvmeter.html")   # hint: "imdb-tvmeter.html"

# Names ------------------------------------------------------------------------

names <- page %>%
  html_nodes(".ipc-title-link-wrapper .ipc-title__text") %>%
  html_text()

# Years ------------------------------------------------------------------------
# Tip: inspect the saved file in a browser to find the right CSS selector.
# Each show's year appears in a metadata span — look for a class similar
# to what you used in the movies script.

years_raw <- page %>%
  html_nodes(".ipc-inline-list__item") %>%
  html_text()


years <- years_raw[seq(1, length(years_raw), by = 3)] %>%
  as.numeric()

# Scores -----------------------------------------------------------------------

scores <- page %>%
  html_nodes(".ipc-rating-star--rating") %>%
  html_text() %>%
  as.numeric()

# TV shows dataframe -----------------------------------------------------------

n <- min(length(names), length(scores), length(years))

tvshows <- tibble(
  rank  = 1:n,
  name  = names[1:n],
  year  = years[1:n],
  score = scores[1:n]
)

# Add new variables ------------------------------------------------------------

tvshows <- tvshows %>%
  mutate(
    genre     = NA,
    runtime   = NA,
    n_episode = NA,
  )

# Add new info for first show --------------------------------------------------

tvshows$genre[1]     <- "Action, Comedy, Crime"
tvshows$runtime[1]   <- 60
tvshows$n_episode[1] <- 40

# Add new info for second show -------------------------------------------------

tvshows$genre[2]     <- "Medical Drama, Psychological Drama, Drama"
tvshows$runtime[2]   <- 50
tvshows$n_episode[2] <- 45

# Add new info for third show --------------------------------------------------

tvshows$genre[3]     <- "Sitcom, Comedy, Drama"
tvshows$runtime[3]   <- NA
tvshows$n_episode[3] <- 4

# shinySpeech

## Description
This application allows users to obtain the top 10 nouns appearing in selected speeches by interactively choosing specific variables through the API data provided by the riksdagenAPI package.

## Installation
To run this application, you need to have the following R packages installed:

```r
install.packages("shiny")
devtools::install_github("lyuuuuY/riksdagenAPI")  
```
## Usage
```r
library(shiny)
runGitHub("shiny_2", "lyuuuuY") 
```

## Instructions
You can enter the member ID into our Shiny app to get the top 10 most frequent nouns. For example, "0729710260118."

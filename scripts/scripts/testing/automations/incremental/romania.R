pcr <- c()
ag <- c()
date <- c()
  
link <- paste("https://gov.ro/ro/media/comunicate&page=4&page=",i,sep = "")
  
links <- read_html(link) %>%
html_nodes(".DescriptionList h2 a") %>%
html_attr("href")
  
url <- links[str_detect(links, "buletin")][1]
  
url <- read_html(url) %>%
html_node(".filesBoxInner a") %>%
html_attr("href")
  
date <- str_extract(url, "\\d+-\\d+_BULETIN") %>%
  str_replace("BULETIN", as.character(year(today()))) %>%
  dmy()
if (is.na(date)) date <- today()
  
url <- str_replace(url, "http\\://https", "https")
  
download.file(url = url, destfile = "tmp/tmp.pdf", quiet = TRUE)
  
file <- pdf_text("tmp/tmp.pdf")
  
pcr <- file %>%
  str_extract("Până la această dată, la nivel național, au fost prelucrate?.*") %>%
    
  na.omit() %>%
  str_replace_all("[^\\d]", "") %>%
  as.integer()
  
ag <- file %>%
  str_extract("teste RT-PCR și?.*") %>%
    
  na.omit() %>%
  str_replace_all("[^\\d]", "") %>%
  as.integer()

count <- pcr + ag

add_snapshot(
  count = count,
  date = date,
  sheet_name = "Romania",
  country = "Romania",
  testing_type = "PCR only",
  units = "tests performed",
  source_url = url,
  source_label = "Ministry of Internal Affairs"

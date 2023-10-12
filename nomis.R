# Process to explore nomis() data for specific datasets
library(nomisr)

# You'll want to start by browsing the nomis dataset towards getting dataset ID (like "NM_529_1" below)
religion_search <- nomis_search(name = "*Religion*")
religion_measures <- nomis_get_metadata("ST104", "measures")
tibble::glimpse(religion_measures)
religion_geography <- nomis_get_metadata("NM_529_1", "geography", "TYPE")

# grab daata from nomis for 2001 census religion / ethnicity
z0 <- nomis_get_data(id = "NM_1872_1", time = "latest", geography = "TYPE499", measures=c(20100))
saveRDS(z0, file = "z0.rds")

# Get table of Census 2011 religion data from nomis
z <- nomis_get_data(id = "NM_529_1", time = "latest", geography = "TYPE499", measures=c(20301))
saveRDS(z, file = "z.rds")
z <- readRDS(file = (here("example_data", "z.rds")))

# grab data from nomis for 2011 census religion / ethnicity table
z1 <- nomis_get_data(id = "NM_659_1", time = "latest", geography = "TYPE499", measures=c(20100))
saveRDS(z1, file = "z1.rds")

# grab data from nomis for 2021 census religion / ethnicity table
z2 <- nomis_get_data(id = "NM_2131_1", time = "latest", geography = "TYPE499", measures=c(20100))
saveRDS(z2, file = "z2.rds")

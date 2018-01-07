library(tidyverse)

ach_profile <- read_csv("data/achievement_profile_data_with_CORE.csv")
View(ach_profile)
summary(ach_profile)
class(ach_profile)
## Exercise 1
# Use filter() to find the number of districts with a 100% Algebra I proficiency rate.

filter(ach_profile,AlgI == 100)


## Exercise 2
# Create a new variable called `math_achievement` with a value of:
#     * `"High"` if a district's Math proficiency is 75% or higher;
#     * `"Medium"` if a district's Math proficiency is between 50% and 75%;
#     * `"Low"` if a district's Math proficiency is below 50%.

mutate(ach_profile,
       math_achievement  = case_when (
           Math >= 75 ~ "High" ,
           Math >= 50 ~ "Medium" ,
           Math < 50 ~ "Low",
           TRUE ~ "NO DATA"
       )
       ) %>% select(Math,math_achievement)


## Exercise 3
# Filter down to district 792 (Shelby County), then pipe the result to `View()`.

ach_profile %>%
    filter(system==792) %>%
    View()


## Exercise 4
# Do the following in one sequence of function calls, piped together:
# 1. Read in the `data/tvaas.csv` file.
# 2. Rename variables as follows:
#     * `District Name` to `system`.
#     * `District-Wide: Composite` to `TVAAS Composite`.
#     * `District-Wide: Literacy` to `TVAAS Literacy`.
#     * `District-Wide: Numeracy` to `TVAAS Numeracy`.
# 3. Drop the `District Name` variable.

tvaas  <- read_csv("data/tvaas.csv") %>%
  rename(system = `District Number`,
         `TVAAS Composite` =`District-Wide: Composite`,
          `TVAAS Literacy` = `District-Wide: Literacy`,
          `TVAAS Numeracy` = `District-Wide: Numeracy`)   %>%
      select(-`District Name`)


## Exercise 5
# Sort alphabetically by CORE region, then by Algebra I proficiency in descending order.
# Then, keep just the district name, Algebra I proficiency, and CORE region variables.

arrange(ach_profile,CORE_region,desc(AlgI)) %>%
    select(system_name,AlgI,CORE_region)

## Exercise 6
# Use `summarise()` to find the mean, minimum, and maximum district grad rate.
# Assign variable names to the resulting data frame.

ach_profile %>%
   summarise(mean_grad=mean(Graduation,na.rm=TRUE),
             min_grad = min(Graduation,na.rm=TRUE),
             max_grad=max(Graduation,na.rm=TRUE))

## Exercise 7
# Identify districts with a higher Percent ED than the median district, and a
# higher Math proficiency than the median district.

ach_profile %>%
    mutate(median_ED = median(Pct_ED,na.rm=TRUE),
           median_Math = median(Math,na.rm=TRUE)) %>%
    filter(Pct_ED >median_ED & Math > median_Math) %>%
    select(system_name,Pct_ED,Math)


# Exercise 8
# Identify districts with a higher dropout rate than the average of districts
# in the same CORE Region.

ach_profile %>%
    group_by(CORE_region) %>%
    mutate(dropout_mean = mean(Dropout, na.rm = TRUE)) %>%
    ungroup() %>%
    filter(Dropout > dropout_mean) %>%
    select(system_name, CORE_region, Dropout, dropout_mean)


## Exercise 9
# Calculate three variables:
# * A district's average proficiency in math subjects (Math, Algebra I-II)
# * A district's average proficiency in English subjects (ELA, English I-III)
# * A district's average proficiency in science subjects (Science, Biology I, Chemistry)
# Then, reorder variables such that:
# * The math average is next to the individual math variables.
# * The English average is next to the individual English variables.
# * The science average is next to the individual science variables.

ach_profile %>%
    rowwise() %>%
    mutate(mean_Math = mean(c(Math,AlgI,AlgII),na.rm=TRUE),
           mean_English = mean(c(ELA,EngI,EngII,EngIII),na.rm=TRUE),
           mean_Science = mean(c(Science,BioI,Chemistry),na.rm=TRUE)
    ) %>%
ungroup() %>%
select(system, system_name, Math, AlgI, AlgII, mean_Math,
       ELA, EngI, EngII, EngIII, mean_English, Science, BioI, Chemistry, mean_Science)




## Exercise 10
# Create a data frame with the number of districts at each TVAAS level, by CORE region.

    ach_profile %>%
    inner_join(tvaas,by="system") %>%
    group_by(CORE_region, `TVAAS Composite`) %>%
        count() %>%
        ungroup()
        #spread(`TVAAS Composite`, n)


## Exercise 11
# Reshape the `tvaas` data frame long by subject, then arrange by system.

    tvaas %>%
        gather(subject, score, `TVAAS Composite`:`TVAAS Numeracy`) %>%
        arrange(`system`)


library(readr)
library(tidyr)
library(dplyr)

ach_profile <- read_csv("data/achievement_profile_data_with_CORE.csv")

## Exercise 1
# Use filter() to find the number of districts with a 100% Algebra I proficiency rate.

filter(ach_profile, AlgI == 100)

## Exercise 2
# Create a new variable called `math_achievement` with a value of:
#     * `"High"` if a district's Math proficiency is 75% or higher;
#     * `"Medium"` if a district's Math proficiency is between 50% and 75%;
#     * `"Low"` if a district's Math proficiency is below 50%.

mutate(ach_profile,
       math_achievement = ifelse(Math >= 75, "High", NA),
       math_achievement = ifelse(Math >= 50 & Math < 75, "Medium",
                                 math_achievement),
       math_achievement = ifelse(Math < 50, "Low", math_achievement))

## Exercise 3
# Filter down to district 792 (Shelby County), then pipe the result to `View()`.

ach_profile %>%
    filter(system == 792) %>%
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

tvaas <- read_csv("data/tvaas.csv") %>%
    rename(system = `District Number`,
           `TVAAS Composite` = `District-Wide: Composite`,
           `TVAAS Literacy` = `District-Wide: Literacy`,
           `TVAAS Numeracy` = `District-Wide: Numeracy`) %>%
    select(-`District Name`)

## Exercise 5
# Sort alphabetically by CORE region, then by Algebra I proficiency in descending order.
# Then, keep just the district name, Algebra I proficiency, and CORE region variables.

ach_profile %>%
    arrange(CORE_region, desc(AlgI)) %>%
    select(system_name, AlgI, CORE_region)

## Exercise 6
# Use `summarise()` to find the mean, minimum, and maximum district grad rate.
# Assign variable names to the resulting data frame.

ach_profile %>%
    filter(system_name != "State of Tennessee") %>%
    summarise(mean_grad = mean(Graduation, na.rm = TRUE),
              min_grad = min(Graduation, na.rm = TRUE),
              max_grad = max(Graduation, na.rm = TRUE))

## Exercise 7
# Identify districts with a higher Percent ED than the median district, and a
# higher Math proficiency than the median district.

ach_profile %>%
    filter(system_name != "State of Tennessee") %>%
    mutate(median_pct_ED = median(Pct_ED, na.rm = TRUE),
           median_Math = median(Math, na.rm = TRUE)) %>%
    filter(Pct_ED > median_pct_ED & Math > median_Math) %>%
    select(system, system_name, Math, median_Math)

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
    mutate(Math_avg = mean(c(Math, AlgI, AlgII), na.rm = TRUE),
           Eng_avg = mean(c(ELA, EngI, EngII, EngIII), na.rm = TRUE),
           Sci_avg = mean(c(Science, BioI, Chemistry), na.rm = TRUE)) %>%
    select(system, system_name, Math, AlgI, AlgII, Math_avg,
           ELA, EngI, EngII, EngIII, Eng_avg, Science, BioI, Chemistry, Sci_avg)

## Exercise 10
# Create a data frame with the number of districts at each TVAAS level, by CORE region.

ach_profile %>%
    inner_join(tvaas, by = "system") %>%
    mutate(Level1 = ifelse(`TVAAS Composite` == 1, 1, 0),
           Level2 = ifelse(`TVAAS Composite` == 2, 1, 0),
           Level3 = ifelse(`TVAAS Composite` == 3, 1, 0),
           Level4 = ifelse(`TVAAS Composite` == 4, 1, 0),
           Level5 = ifelse(`TVAAS Composite` == 5, 1, 0)) %>%
    group_by(CORE_region) %>%
    summarise(Level1 = sum(Level1, na.rm = TRUE),
              Level2 = sum(Level2, na.rm = TRUE),
              Level3 = sum(Level3, na.rm = TRUE),
              Level4 = sum(Level4, na.rm = TRUE),
              Level5 = sum(Level5, na.rm = TRUE)) %>%
    ungroup()

## Exercise 11
# Reshape the tvaas data frame long by subject.

tvaas %>%
    gather(subject, score, `TVAAS Composite`:`TVAAS Numeracy`) %>%
    arrange(system)

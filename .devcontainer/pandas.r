# devtools::install_github("rstudio/reticulate")
library(reticulate)
# supress warnings
 warnings <- import("warnings")
 warnings$simplefilter(action = 'ignore', category='FutureWarning')

library(dplyr) # %>%
library(testthat)

py_available() %>% stopifnot('python (3.9?) expected' = .)
# Retrieve/force initialization of Python
py_config()

# one time install of miniconda, to install pandas
#   but pandas installed in container
# py_install('pandas')
# install miniconda

sklearn <- import("sklearn") # convert = FALSE
# whether the output of Python functions is automatically converted to an R object equivalent 
sklearn$`__version__`

os <- import("os")
os$listdir(".")

lst <- list(1, 2, 3)
# convert this R list to a Python list
py_lst <- r_to_py(lst, convert = T)
typeof(py_lst)
class(py_lst)
# py_lst$append(5)
py_lst # TODO: how to print?
# py_lst$pop(0L)
lst2 <- py_to_r(py_lst)
# print(lst2)

pd <- import("pandas", convert = FALSE) # as = "pd", 
# pandas <- import('pandas')
before <- iris
expect_is(before,class = "data.frame")
convert <- r_to_py(before)
# as = "pd"
expect_is(convert,class = "pd.core.frame.DataFrame")
# expect_is(convert,class = "pandas.core.frame.DataFrame")

after  <- py_to_r(convert)
class(after)
expect_is(after, class = "pd.core.frame.DataFrame")
# expect_is(after, class = "data.frame")

pd$DataFrame(x = [1,2])


print(sessionInfo(), locale=FALSE)


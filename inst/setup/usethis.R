
# https://usethis.r-lib.org/articles/usethis-setup.html
library(devtools) ## or library(usethis)
use_devtools()
# https://usethis.r-lib.org/
library(usethis)


(path <- file.path(tempdir(), "mypkg"))
# opens a new posit/Rstudio
create_package(path)
# only needed since this session isn't interactive

# opens another new posit/Rstudio
# proj_activate(path)

usethis::use_proprietary_license("1x2 Ltd.")
# use_mit_license("1x2 Ltd.")

use_git()
# use_git_config(user.name = "John",
#   user.email = "john@1x2.ltd")
# Local Git user's email ('john@1x2.ltd') doesn't appear to be registered with GitHub.
usethis::use_git_config(user.name = "John Gavin",
                        user.email = "john.b.gavin@gmail.com")

git_sitrep() # situation-report git config --global --list
usethis::gh_token_help()
# use_git_config(core.editor = "nano") # git config --global core.editor emacs

# cd ~/Documents/GitHub/usethisDockerPackage
# git config credential.helper store
# usethis::create_github_token()
# macOS Keychain - store this token in any password-management software that you use
# gitcreds::gitcreds_set()



# https://github.com/JaseZiv/worldfootballR_data/blob/master/R/fb_big5_advanced_season_stats/update_big5_advanced_stats.R
usethis::git_default_branch()
use_package("worldfootballR", "Suggests")
usethis::use_github("JaseZiv/worldfootballR_data")
# https://cran.r-project.org/web/packages/footBayes/vignettes/footBayes_a_rapid_guide.html
use_package("footBayes", "Suggests")


# Set up other files -------------------------------------------------
use_readme_md()
use_news_md()
use_test("my-test")
# x <- 1
# y <- 2
# use_data(x, y)


devtools::has_devel() # package build tools are installed and available.
pkgbuild::check_build_tools() # report on your system
# (interactive RStudio) trigger an automatic installation of build tools.


# https://usethis.r-lib.org/articles/pr-functions.html

!rmdir /s /q book\_build
#rm -rf book/_build/
!jupyter-book build --all book
!ghp-import -n -p -f book/_build/html

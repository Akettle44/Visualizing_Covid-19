now = $(date)
Rscript corona.R
git add index.html
git commit -m "$now"
git push origin master 

## Pop[[ulate]]-temp[[late]]

### Introduction

`poptemp` is a simple little R library that can be used to generate individual files by *populating* an arbitrary *template* with the values found in the rows of a data frame. This can be useful when you would like to generate many individualized reports, letters, analyses or other documents from a template.


### Installing

If you don't already have the [`devtools`](https://github.com/hadley/devtools) library installed, install it!

To install `poptemp` directly from github:

```r
devtools::install_github("ram6ler/poptemp")
```

### Example use

You are the *Company Designator of Inane Tasks* (every company has one), just bursting to use your RStudio skills to help you designate inane tasks more efficiently. In particular, you need to assign an inane task to each of the employees Jack, Ivan, Johab and Jan. Although the task is very similar in each case, the specifics are different. The following data frame contains the details:

```r
inane_task_details <- data.frame(
  person = c("Jack", "Ivan", "Johab", "Jan"),
  model_mean = c(85, 90, 100, 120),
  model_sd = c(10, 5, 8, 15)
)
```

You set up a template file, say `template.Rmd`, that has the approprate variable (column) names in the appropriate places: 

#### template.Rmd

		---
		output: html_document
		---
		
		Dear [[person]]
		
		The following script produces a random sample of size 10 drawn from a population 
		with a Gaussian distribution, mean $\mu=[[model_mean]]$ and standard deviation 
		$\sigma=[[model_sd]]$.
		
		```{r}
		set.seed(1)
		random_sample <- rnorm(10, mean = [[model_mean]], sd = [[model_sd]])
		```
		
		```
		`r paste(sprintf("%.2f", random_sample), collapse = "\n")`
		```
		
		Ignoring the population parameters, please calculate the 95% confidence interval 
		for the mean based on the sample and let me know whether it captures the population
		mean. Urgently please.
		
		Regards,
		
		The Company Designator of Inane Tasks


You load up the `poptemp` library:

```r
library(poptemp)
```

You then execute the function `pop_temp`, specifying the data, template and names for the files to be produced. For example:

```r
pop_temp(
  data = inane_task_details,
  template_file = "template.Rmd",
  output_name_template = "problem-[[i]]-for-[[person]]",
  output_extension = ".Rmd"
)

```

(For other settings, such as the directory for the output files or the format for the substitution markers in the template, see `? pop_temp`.)

This writes several new files to your working directory:

* `problem-1-for-Jack.Rmd`
* `problem-2-for-Ivan.Rmd`
* `problem-3-for-Johab.Rmd`
* `problem-4-for-Jan.Rmd`

You finally knit these files and send them out, content with a productive morning!

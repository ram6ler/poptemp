
#' pop_temp
#'
#' Create a set of files by populating a template with a set of values
#' taken from rows of a data frame.
#'
#' @param data A data frame containing the values to use.
#' @param template The character object to use as a template.
#' @param template_file The file to use as a template (overwrites \code{template} if set).
#'
#' @param output_name_template A template to use when naming the output files (default: row number).
#' @param output_extension File extension of the output files (default .txt).
#' @param begin_token Token in the template to begin substitution (default [[).
#' @param end_token Token to use in the template to end substitution (default ]]).
#'
#' @return
#' @export
#'
#' @examples
#'
pop_temp <- function(
  data,
  template,
  template_file = "n",
  output_folder = "./",
  output_name_template = "[[i]]",
  output_extension = ".txt",
  begin_token = "\\[\\[",
  end_token = "\\]\\]"
) {

  replace_values <- function(string, item_list) {
    pattern <- sprintf(
      "%s%s%s",
      begin_token,
      names(item_list)[1],
      end_token
    )

    len <- length(item_list)

    current_replacement <- gsub(pattern, item_list[[1]], string)
    if (len > 1) {
      replace_values(
        current_replacement,
        item_list[2:len]
      )
    } else current_replacement

  }

  string <- if (template_file == "n") {
    template
  } else {
    readChar(template_file, file_info(template_file)$size)
  }
  for (i in 1:nrow(data)) {
    item_list <- sapply(names(data), function(x) as.character(data[[x]][i]))

    out_file_name <- replace_values(
      gsub("\\[\\[i\\]\\]", i, output_name_template),
      item_list
    )

    sink(sprintf("%s%s%s", output_folder, out_file_name, output_extension))
    cat(replace_values(string, item_list))
    sink()
  }

}


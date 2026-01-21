#!/bin/bash

# constants
TFPLAN_BINARY='tfplan.binary'
EXCLUDE_PATTERNS='unchanged|depends on a resource or a module with changes pending'

# get resource summary content
# grep '#'                        : get lines containing '#'
# grep -v -E "$EXCLUDE_PATTERNS"  : exclude lines matching the exclude patterns
# sed 's/#//g'                    : remove '#' characters from the lines
# || true                         : in case of no matches, do not error out
get_resource_summary_content() {
  grep '#' | grep -v -E "$EXCLUDE_PATTERNS" | sed 's/#//g' || true
}

# get plan summary content
# grep -E '(No changes|Plan:)'    : get lines containing 'No changes' or 'Plan:'
# || true                         : in case of no matches, do not error out
get_plan_summary_content() {
  grep -E '(No changes|Plan:)' || true
}

# even though sort --ignore-nonprinting is a thing, it does not work as documented on github's ubuntu-latest runner (as of 2026-01)
# so here's a function using awk, sort, and cut that ignores color codes for sorting but maintains them in the output
# awk
# x=$0                         : save original line with colors
# gsub(/\x1b\[[0-9;]*m/,"")    : strip color codes from $0
# print $0 "\t" x              : print stripped text, TAB, original line
# sort                         : sort by stripped text (first field)
# cut -f2-                     : extract only the original colored line
sort_on_text_not_color_codes() {
  awk '{x=$0; gsub(/\x1b\[[0-9;]*m/,""); print $0 "\t" x}' | sort | cut -f2-
}

# format lines from a terragrunt plan run on a single unit
#
# example input line #1 (plan summary):
#   00:00:00.000 STDOUT terraform: Plan: 2 to add, 0 to change, 1 to destroy.
# example input line #2 (resource summary):
#   00:00:00.000 STDOUT terraform:   # aws_cloudwatch_log_metric_filter.console_login_without_mfa will be destroyed
#
# example desired formatted line #1 (plan summary):
#   [unit-name]    Plan: 2 to add, 0 to change, 1 to destroy.
# example desired formatted line #2 (resource summary):
#   [unit-name]    aws_cloudwatch_log_metric_filter.console_login_without_mfa will be destroyed
#
# unit=$(basename "$(pwd)")         : get the current unit name
# awk
#   -v unit="[$unit]"               : set awk variable 'unit' to the current unit name in square brackets
#   '{$1=$2=$3="";                  : remove first three fields (timestamp, "STDOUT", and "terraform:")
#     sub(/^[ \t]+/, "");           : trim leading whitespace
#     print unit "|" $0}'           : print unit and rest of line separated by '|'
# column -t -s "|"                  : align columns using '|' as separator
# sort_on_text_not_color_codes      : sort the lines ignoring color codes
# || true                           : in case of no matches, do not error out
format_single_unit() {
  unit=$(basename "$(pwd)")
  awk -v unit="[$unit]" '{$1=$2=$3=""; sub(/^[ \t]+/, ""); print unit "|" $0}' | column -t -s "|" | sort_on_text_not_color_codes || true
}

# format lines from a terragrunt plan run on multiple units
#
# example input line #1 (plan summary):
#   00:00:00.000 STDOUT [logs] terraform: Plan: 2 to add, 0 to change, 1 to destroy.
# example input line #2 (resource summary):
#   00:00:00.000 STDOUT [logs] terraform:   # data.aws_iam_policy_document.cloudtrail_to_cloudwatch_policy will be read during apply
#
# example desired formatted line #1 (plan summary):
#   [logs]    Plan: 2 to add, 0 to change, 1 to destroy.
# example desired formatted line #2 (resource summary):
#   [logs]    data.aws_iam_policy_document.cloudtrail_to_cloudwatch_policy will be read during apply
#
# awk
#   '{unit=$3;                      : get the unit name from the third field
#     $1=$2=$3=$4="";               : remove first four fields (timestamp, "STDOUT", unit name, and "terraform:")
#     sub(/^[ \t]+/, "");           : trim leading whitespace
#     print unit "|" $0}'           : print unit and rest of line separated by '|'
# column -t -s "|"                  : align columns using '|' as separator
# sort_on_text_not_color_codes      : sort the lines ignoring color codes
# || true                           : in case of no matches, do not error out
format_multiple_units() {
  awk '{unit=$3; $1=$2=$3=$4=""; sub(/^[ \t]+/, ""); print unit "|" $0}' | column -t -s "|" | sort_on_text_not_color_codes || true
}

# add formatting for diff syntax highlighting in markdown
# sed 's/^/  /'                          : add 2 spaces to each line (so the spacing is consistent)
# sed '/created/s/^  /+ /'               : for lines containing 'created', replace the two spaces at the start with '+ '
# sed '/destroyed/s/^  /- /'             : for lines containing 'destroyed', replace the two spaces at the start with '- '
# sed '/[1-9][0-9]* to destroy/s/^  /- /'  : for lines containing 'X to destroy' where X is a non-zero number, replace the two spaces at the start with '- '
#
# this makes it easier to read additions and deletions in the GitHub markdown diff code block
# + will be marked green
# - will be marked red
format_for_diff() {
  sed 's/^/  /' | sed '/created/s/^  /+ /' | sed '/destroyed/s/^  /- /' | sed '/[1-9][0-9]* to destroy/s/^  /- /'
}

# get the plan summary
# get_plan_summary_content   : call function to get content for the plan summary
# if TG_ALL is set to true, terragrunt is running on multiple units and script will call the appropriate formatter
# if TG_ALL is set to false, terragrunt is running on a single unit and script will call the appropriate formatter
# and format the output for diff syntax highlighting in markdown
get_plan_summary() {
  get_plan_summary_content | \
    if [ "$TG_ALL" = "true" ]; then
      format_multiple_units | format_for_diff
    else
      format_single_unit | format_for_diff
    fi
}

# get the resource summary
# get_resource_summary_content   : call function to get content for the resource summary
# if TG_ALL is set to true, terragrunt is running on multiple units and script will call the appropriate formatter
# if TG_ALL is set to false, terragrunt is running on a single unit and script will call the appropriate formatter
# and format the output for diff syntax highlighting in markdown
get_resource_summary() {
  get_resource_summary_content | \
    if [ "$TG_ALL" = "true" ]; then
      format_multiple_units | format_for_diff
    else
      format_single_unit | format_for_diff
    fi
}

# add markdown diff code block
# sed '1s/^/```diff\n/;$s/$/\n```/'    : add ```diff at the start and ``` at the end
add_markdown_code_block_diff() {
  sed '1s/^/```diff\n/; $s/$/\n```/'
}

#
# main
#

raw_text_color=$(terragrunt show "$TFPLAN_BINARY" 2>&1)
raw_text_no_color=$(terragrunt show -no-color "$TFPLAN_BINARY" 2>&1)

echo -e "\n::group::plan summary:"
echo "$raw_text_color" | get_plan_summary
echo -e "::endgroup::"

echo -e "\n::group::resource summary:"
echo "$raw_text_color" | get_resource_summary
echo -e "::endgroup::"

echo -e "\n::group::raw text"
echo "$raw_text_color"
echo -e "::endgroup::"

echo "$raw_text_no_color" | get_plan_summary | add_markdown_code_block_diff >> "$GITHUB_STEP_SUMMARY"
echo "$raw_text_no_color" | get_resource_summary | add_markdown_code_block_diff >> "$GITHUB_STEP_SUMMARY"

# annotate
echo -e "\n::notice::Plan summary.\n"

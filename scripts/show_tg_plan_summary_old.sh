#!/bin/bash


# constants
TFPLAN_BINARY='tfplan.binary'
EXCLUDE_PATTERNS='unchanged|depends on a resource or a module with changes pending'


# get plan summary content
# grep -E '(No changes|Plan:)'    : get lines containing 'No changes' or 'Plan:'
# || true                         : in case of no matches, do not error out
get_unit_summary_content() {
  grep -E '(No changes|Plan:)' || true
}


# get resource summary content
# grep '#'                        : get lines containing '#'
# grep -v -E "$EXCLUDE_PATTERNS"  : exclude lines matching the exclude patterns
# || true                         : in case of no matches, do not error out
get_resource_summary_content() {
  grep '#' | grep -v -E "$EXCLUDE_PATTERNS" || true
}


# even though sort --ignore-nonprinting is a thing, it does not work as documented on github's ubuntu-latest runner (as of 2026-01)
# so here's a function using awk, sort, and cut that ignores color codes for sorting but maintains them in the output
# awk command breakdown:
#   x=$0                         : save original line with colors
#   gsub(/\x1b\[[0-9;]*m/,"")    : strip color codes from $0
#   print $0 "\t" x              : print stripped text, TAB, original line
#   sort                         : sort by stripped text (first field)
#   cut -f2-                     : extract only the original colored line
sort_on_text_not_color_codes() {
  awk '{x=$0; gsub(/\x1b\[[0-9;]*m/,""); print $0 "\t" x}' | sort | cut -f2-
}

# Colorize text matching a pattern with ANSI escape codes
#
# Usage: echo "text" | colorize "pattern" "color_code"
#
# Parameters:
#   $1 - pattern to match and colorize
#   $2 - ANSI color code (default: 32 for green)
#
# Common color codes:
#   31 - red
#   32 - green
#   33 - yellow
#
# sed command breakdown:
#   s/$pattern/.../g                              : substitute all occurrences (g flag) of $pattern
#   \x1b[1m                                       : ANSI escape sequence for bold text
#   \x1b[${color}m                                : ANSI escape sequence for color (variable interpolation)
#   $pattern                                      : the matched text itself
#   \x1b[0m\x1b[0m                                : ANSI reset sequence (twice for full reset)
#   Result: s/$pattern/\x1b[1m\x1b[${color}m$pattern\x1b[0m\x1b[0m/g
#
# Example transformation:
#   Input:  "resource created successfully"
#   Output: "resource \x1b[1m\x1b[32mcreated\x1b[0m\x1b[0m successfully"
#           (displays as: resource created successfully with "created" in bold green)
#
# Examples:
#   echo "file created" | colorize "created" "32"      # green
#   echo "resource destroyed" | colorize "destroyed" "31"   # red
#   echo "plan modified" | colorize "modified" "33"    # yellow
colorize() {
  local pattern=$1
  local color=${2:-32}  # default to green (32)
  sed "s/$pattern/\x1b[1m\x1b[${color}m$pattern\x1b[0m\x1b[0m/g"
}


# add markdown diff code block
# Wraps piped input with markdown code fence for diff syntax highlighting
#
# sed command breakdown:
#   '1s/^/```diff\n/; $s/$/\n```/'         : two substitution commands separated by semicolon
#
#   First substitution (1s/^/```diff\n/):
#     1                                    : address - operate only on line 1 (first line)
#     s/^/```diff\n/                       : substitute command
#       ^                                  : matches the beginning of the line
#       ```diff\n                          : replacement text (markdown code fence with newline)
#     Result: prepends "```diff" on its own line before the first line of input
#
#   Second substitution ($s/$/\n```/):
#     $                                    : address - operate only on $ (last line)
#     s/$/\n```/                           : substitute command
#       $                                  : matches the end of the line
#       \n```                              : replacement text (newline followed by closing fence)
#     Result: appends "```" on its own line after the last line of input
#
# Example transformation:
#   Input:  "[logs]    Plan: 2 to add"
#   Output: "```diff\n[logs]    Plan: 2 to add\n```"
#   (displays as a properly formatted markdown diff code block)
add_markdown_code_block_diff() {
  sed '1s/^/```diff\n/; $s/$/\n```/'
}


# format plan summary lines from terragrunt output
#
# This function processes terragrunt plan output lines to extract and format plan summaries.
# It handles both single-unit and multi-unit terragrunt runs based on the TG_ALL environment variable.
#
# Environment Variables:
#   TG_ALL - if "true", formats for multiple units; if "false", formats for a single unit
#
# Input Format (single unit):
#   00:00:00.000 STDOUT terraform: Plan: 2 to add, 0 to change, 1 to destroy.
#
# Input Format (multiple units):
#   00:00:00.000 STDOUT [logs] terraform: Plan: 2 to add, 0 to change, 1 to destroy.
#
# Output Format (both modes):
#   [unit-name]    Plan: 2 to add, 0 to change, 1 to destroy.
#
# Processing Logic:
#   Multiple units mode (TG_ALL=true):
#     - Extract unit name from field 3 (already in [brackets])
#     - Remove fields 1-4: timestamp, "STDOUT", unit name, "terraform:"
#     - Format: unit | remaining text
#
#   Single unit mode (TG_ALL=false):
#     - Derive unit name from current directory: $(basename "$(pwd)")
#     - Remove fields 1-3: timestamp, "STDOUT", "terraform:"
#     - Format: [unit] | remaining text
#
# awk command breakdown (multiple units):
#   '{unit=$3;                  : get the unit name from the third field (including brackets)
#   $1=$2=$3=$4="";             : remove first four fields (timestamp, "STDOUT", unit name, and "terraform:")
#   sub(/^[ \t]+/, "")          : trim leading whitespace left over from removed fields
#                                 - /^[ \t]+/ matches one or more spaces/tabs at the start
#                                 - "" replaces them with nothing
#   print unit "|" $0           : output unit name, pipe separator, and cleaned remaining text
#
# awk command breakdown (single unit):
#   -v unit="[$unit]"           : set awk variable 'unit' to the current unit name in square brackets
#   $1=$2=$3="";                : remove first three fields (timestamp, "STDOUT", and "terraform:")
#   sub(/^[ \t]+/, "")          : trim leading whitespace left over from removed fields
#   print unit "|" $0           : output unit name, pipe separator, and cleaned remaining text
#
# Post-processing:
#   - column -t -s "|"             : align columns using '|' as separator
#   - sort_on_text_not_color_codes : sort lines while preserving ANSI color codes
#   - || true                      : prevent errors if no matches found
format_unit_summary_lines() {
  if [ "$TG_ALL" = "true" ]; then
    # multiple units
    awk '{unit=$3; $1=$2=$3=$4=""; sub(/^[ \t]+/, ""); print unit "|" $0}' | \
    column -t -s "|"                                                       | \
    sort_on_text_not_color_codes || true
  else
    # single unit
    unit=$(basename "$(pwd)")
    awk -v unit="[$unit]" '{$1=$2=$3=""; sub(/^[ \t]+/, ""); print unit "|" $0}' | \
    column -t -s "|"                                                             | \
    sort_on_text_not_color_codes || true
  fi
}


# Format resource summary lines from terragrunt output
#
# This function processes terragrunt resource summary output lines to extract and format resource details.
# It handles both single-unit and multi-unit terragrunt runs based on the TG_ALL environment variable,
# and adjusts field extraction based on whether ANSI color codes are present in the input.
#
# Parameters:
#   $1 - color_mode: "color" or "no-color"
#
# Environment Variables:
#   TG_ALL - must be "true" for multiple units or "false" for single unit
#
# Input Format (single unit with color):
#   00:00:00.000 STDOUT terraform:   # module.setup_cost_budget[0].aws_budgets_budget.monthly will be created
#
# Input Format (multiple units with color):
#   00:00:00.000 STDOUT [credits] terraform:   # module.setup_cost_budget[0].aws_budgets_budget.monthly will be created
#
# Output Format (both modes):
#   [unit-name]    module.setup_cost_budget[0].aws_budgets_budget.monthly    will be created
#
# Case Breakdown:
#
#   "true-color" (multiple units with color codes):
#     - Extract unit from field 3 (e.g., "[credits]")
#     - Extract resource from field 7
#     - Remove fields 1-7: timestamp, "STDOUT", unit, "terraform:", "#", resource
#     - Add color reset codes after unit: "\x1b[0m\x1b[0m"
#     - Format: unit color-reset | resource | remaining text
#
#   "true-no-color" (multiple units without color codes):
#     - Extract unit from field 3 (e.g., "[credits]")
#     - Extract resource from field 6
#     - Remove fields 1-6: timestamp, "STDOUT", unit, "terraform:", "#", resource
#     - Format: unit | resource | remaining text
#
#   "false-color" (single unit with color codes):
#     - Derive unit from current directory: $(basename "$(pwd)")
#     - Extract resource from field 6
#     - Remove fields 1-6: timestamp, "STDOUT", "terraform:", "#", resource
#     - Format: [unit] | resource | remaining text
#
#   "false-no-color" (single unit without color codes):
#     - Derive unit from current directory: $(basename "$(pwd)")
#     - Extract resource from field 5
#     - Remove fields 1-5: timestamp, "STDOUT", "terraform:", "#", resource
#     - Format: [unit] | resource | remaining text
#
# awk command breakdown (multiple units + color):
#   '{unit=$3;                                      : get the unit name from the third field (including brackets)
#   resource=$7;                                    : get the resource name from the seventh field
#   $1=$2=$3=$4=$5=$6=$7="";                        : remove first seven fields (timestamp, "STDOUT", unit name, "terraform:", "#", and resource)
#   sub(/^[ \t]+/, "")                              : trim leading whitespace left over from removed fields
#                                                     - /^[ \t]+/ matches one or more spaces/tabs at the start
#                                                     - "" replaces them with nothing
#   print unit "\x1b[0m\x1b[0m|" resource "|" $0}'  : output unit name with color reset, pipe separator, resource name, another pipe, and cleaned remaining text
#                                                     - \x1b[0m\x1b[0m resets ANSI color codes after the unit name to prevent color bleed into the rest of the line
#
# awk command breakdown (multiple units + no color):
#   same as above but with 2 differences:
#   - resource is from field 6 instead of 7 (something to do with color codes making field counts differ)
#   - no color reset codes after unit name
#
# awk command breakdown (single unit + color):
#   -v unit="[$unit]"                               : set awk variable 'unit' to the current unit name in square brackets
#   resource=$6;                                    : get the resource name from the sixth field
#   $1=$2=$3=$4=$5=$6="";                           : remove first six fields (timestamp, "STDOUT", "terraform:", "#", and resource)
#   sub(/^[ \t]+/, "")                              : trim leading whitespace left over from removed fields
#   print unit "\x1b[0m\x1b[0m|" resource "|" $0}'  : output unit name, pipe separator, resource name, another pipe, and cleaned remaining text
#                                                     - \x1b[0m\x1b[0m resets ANSI color codes after the unit name to prevent color bleed into the rest of the line
#
# awk command breakdown (single unit + no color):
#   same as above but with 2 differences:
#   - resource is from field 5 instead of 6 (something to do with color codes making field counts differ)
#   - no color reset codes after unit name
#
# Post-processing:
#   - column -t -s "|"             : align the three columns using '|' as separator
#   - sort_on_text_not_color_codes : sort lines while preserving ANSI color codes
#   - || true                      : prevent errors if no matches found
format_resource_summary_lines() {
  local color_mode=$1

  case "${TG_ALL}-${color_mode}" in
    "true-color")
      # multiple units + color
      awk '{unit=$3; resource=$7; $1=$2=$3=$4=$5=$6=$7=""; sub(/^[ \t]+/, ""); print unit "\x1b[0m\x1b[0m|" resource "|" $0}' |
      column -t -s "|" |
      sort_on_text_not_color_codes || true
      ;;
    "true-no-color")
      # multiple units + no-color
      awk '{unit=$3; resource=$6; $1=$2=$3=$4=$5=$6=""; sub(/^[ \t]+/, ""); print unit "|" resource "|" $0}' |
      column -t -s "|" |
      sort_on_text_not_color_codes || true
      ;;
    "false-color")
      # single unit + color
      unit=$(basename "$(pwd)")
      awk -v unit="[$unit]" '{resource=$6; $1=$2=$3=$4=$5=$6=""; sub(/^[ \t]+/, ""); print unit "\x1b[0m\x1b[0m|" resource "|" $0}' |
      column -t -s "|" |
      sort_on_text_not_color_codes || true
      ;;
    "false-no-color")
      # single unit + no-color
      unit=$(basename "$(pwd)")
      awk -v unit="[$unit]" '{resource=$5; $1=$2=$3=$4=$5=""; sub(/^[ \t]+/, ""); print unit "|" resource "|" $0}' |
      column -t -s "|" |
      sort_on_text_not_color_codes || true
      ;;
    *)
      echo "Error in format_resource_summary_lines function: Invalid combination of TG_ALL='${TG_ALL}' and color_mode='${color_mode}'" >&2
      exit 1
      ;;
  esac
}


# add formatting for diff syntax highlighting in markdown
# - lines starting with '- ' will be marked red in markdown diff
#
# sed 's/^/  /'                            : add 2 spaces to each line (so the spacing is consistent)
# sed '/[1-9][0-9]* to destroy/s/^  /- /'  : for lines with non-zero destroy count, replace leading spaces with '- '
format_unit_summary_for_diff() {
  sed 's/^/  /' | sed '/[1-9][0-9]* to destroy/s/^  /- /'
}


# add formatting for diff syntax highlighting in markdown
# - lines starting with '+ ' will be marked green in markdown diff
# - lines starting with '- ' will be marked red in markdown diff
# - lines starting with '~ ' will be marked yellow in markdown diff
#
# sed 's/^/  /'                            : add 2 spaces to each line (so the spacing is consistent)
# sed '/created/s/^  /+ /'                 : for lines containing 'created', replace leading spaces with '+ '
# sed '/destroyed/s/^  /- /'               : for lines containing 'destroyed', replace leading spaces with '- '
# sed '/updated in-place/s/^  /~ /'        : for lines containing 'updated in-place', replace leading spaces with '~ '
format_resource_summary_for_diff() {
  sed 's/^/  /' | sed '/created/s/^  /+ /' | sed '/destroyed/s/^  /- /' | sed '/updated in-place/s/^  /~ /'
}


# add colors for echo'ing into github action logs
# colorize "- " "31"                                                              : color the "- " in red
# sed '/[1-9][0-9]* to destroy/s/destroy/\x1b[1m\x1b[31mdestroy\x1b[0m\x1b[0m/g'  : bold red the word 'destroy' when there is a non-zero destroy count
format_unit_summary_with_colors_for_logs() {
  colorize "- " "31" | sed '/[1-9][0-9]* to destroy/s/destroy/\x1b[1m\x1b[31mdestroy\x1b[0m\x1b[0m/g'
}


# add colors for echo'ing into github action logs
# - the pattern 'destroyed' is already colored red by terragrunt, so no need to color it again
#
# colorize "created" "32"           : color the pattern 'created' in green
# colorize "updated in-place" "33"  : color the pattern 'updated in-place' in yellow
# colorize "+ " "32"                : color the pattern '+ ' in green
# colorize "- " "31"                : color the pattern '- ' in red
# colorize "~ " "33"                : color the pattern '~ ' in yellow
format_resource_summary_with_colors_for_logs() {
  colorize "created" "32" | colorize "updated in-place" "33" | colorize "+ " "32" | colorize "- " "31" | colorize "~ " "33"
}


build_unit_summary_from_color() {
  get_unit_summary_content                 | \
  format_unit_summary_lines                | \
  format_unit_summary_for_diff             | \
  format_unit_summary_with_colors_for_logs
}


build_unit_summary_from_no_color() {
  get_unit_summary_content                | \
  format_unit_summary_lines               | \
  format_unit_summary_for_diff            | \
  add_markdown_code_block_diff
}


build_resource_summary_from_color() {
  get_resource_summary_content                 | \
  format_resource_summary_lines "color"        | \
  format_resource_summary_for_diff             | \
  format_resource_summary_with_colors_for_logs
}


build_resource_summary_from_no_color() {
  get_resource_summary_content               | \
  format_resource_summary_lines "no-color"   | \
  format_resource_summary_for_diff           | \
  add_markdown_code_block_diff
}



#
# main
#

raw_text_with_color=$(terragrunt show "$TFPLAN_BINARY" 2>&1)
raw_text_without_color=$(terragrunt show -no-color "$TFPLAN_BINARY" 2>&1)

echo -e "\n::group::plan summary:"
echo "$raw_text_with_color" | build_unit_summary_from_color
echo -e "::endgroup::"

echo -e "\n::group::resource summary:"
echo "$raw_text_with_color" | build_resource_summary_from_color
echo -e "::endgroup::"

echo -e "\n::group::raw text"
echo "$raw_text_with_color"
echo -e "::endgroup::"

echo "$raw_text_without_color" | build_unit_summary_from_no_color >> "$GITHUB_STEP_SUMMARY"
echo "$raw_text_without_color" | build_resource_summary_from_no_color >> "$GITHUB_STEP_SUMMARY"

# annotate
echo -e "\n::notice::Plan summary.\n"

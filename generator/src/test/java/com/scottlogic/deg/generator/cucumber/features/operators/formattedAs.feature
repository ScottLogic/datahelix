Feature: User can specify that a value is so formatted

Background:
     Given the generation strategy is full
       And there is a field foo

Scenario Outline: Running a valid 'formattedAs' request should be successful
     Given foo is in set:
       | <input> |
       And foo is formatted as <format>
       And foo is anything but null
     Then the following data should be generated:
       | foo        |
       | <expected> |
     Examples:
      | input                    | format       | expected                       |
#      | 1.0                      | "%a"         | "0x1.0p0"                      | no way to specify float over double
#      | 1.5                      | "%a"         | "0x1.8p0"                      | no way to specify float over double
      | 1                        | "%b"         | "true"                         |
      | "1"                      | "%b"         | "true"                         |
      | 2018-10-10T00:00:00.000Z | "%b"         | "true"                         |
      | ""                       | "%b"         | "true"                         |
      | 32                       | "%c"         | " "                            |
      | 33                       | "%c"         | "!"                            |
      | 34                       | "%c"         | """                            |
      | 40                       | "%c"         | "("                            |
      | 46                       | "%c"         | "."                            |
      | 48                       | "%c"         | "0"                            |
      | 59                       | "%c"         | ";"                            |
      | 65                       | "%c"         | "A"                            |
      | 96                       | "%c"         | "`"                            |
      | 97                       | "%c"         | "a"                            |
      | 123                      | "%c"         | "{"                            |
      | 124                      | "%c"         | "\|"                           |
      | 0                        | "%d"         | "0"                            |
      | 1                        | "%d"         | "1"                            |
      | 9223372036854775808      | "%d"         | "9223372036854775808"          |
      | -9223372036854775809     | "%d"         | "-9223372036854775809"         |
      | 1                        | "%20d"       | "                   1"         |
      | -1                       | "%20d"       | "                  -1"         |
      | 11                       | "%20d"       | "                  11"         |
      | 1111111111111111111      | "%20d"       | " 1111111111111111111"         |
      | 11111111111111111111     | "%20d"       | "11111111111111111111"         |
      | 111111111111111111111    | "%20d"       | "111111111111111111111"        |
      | 1                        | "%-20d"      | "1                   "         |
      | -1                       | "%-20d"      | "-1                  "         |
      | 11                       | "%-20d"      | "11                  "         |
      | 1111111111111111111      | "%-20d"      | "1111111111111111111 "         |
      | 11111111111111111111     | "%-20d"      | "11111111111111111111"         |
      | 111111111111111111111    | "%-20d"      | "111111111111111111111"        |
      | 1                        | "%020d"      | "00000000000000000001"         |
      | -1                       | "%020d"      | "-0000000000000000001"         |
      | 11                       | "%020d"      | "00000000000000000011"         |
      | 1111111111111111111      | "%020d"      | "01111111111111111111"         |
      | 11111111111111111111     | "%020d"      | "11111111111111111111"         |
      | 111111111111111111111    | "%020d"      | "111111111111111111111"        |
      | 1                        | "\|%+20d\|"  | "\|                  +1\|"     |
      | -1                       | "\|%+20d\|"  | "\|                  -1\|"     |
      | 11                       | "\|%+20d\|"  | "\|                 +11\|"     |
      | 1111111111111111111      | "\|%+20d\|"  | "\|+1111111111111111111\|"     |
      | 11111111111111111111     | "\|%+20d\|"  | "\|+11111111111111111111\|"    |
      | 111111111111111111111    | "\|%+20d\|"  | "\|+111111111111111111111\|"   |
      | 1                        | "% d"        | " 1"                           |
      | 11                       | "% d"        | " 11"                          |
      | 1111111111111111111      | "% d"        | " 1111111111111111111"         |
      | 11111111111111111111     | "% d"        | " 11111111111111111111"        |
      | 111111111111111111111    | "% d"        | " 111111111111111111111"       |
      | 1                        | "%,d"        | "1"                            |
      | -1                       | "%,d"        | "-1"                           |
      | 11                       | "%,d"        | "11"                           |
      | 111                      | "%,d"        | "111"                          |
      | 1111                     | "%,d"        | "1,111"                        |
      | 1111111111111111111      | "%,d"        | "1,111,111,111,111,111,111"    |
      | 1                        | "%(d"        | "1"                            |
      | 11                       | "%(d"        | "11"                           |
      | 1111111111111111111      | "%(d"        | "1111111111111111111"          |
      | 11111111111111111111     | "%(d"        | "11111111111111111111"         |
      | 111111111111111111111    | "%(d"        | "111111111111111111111"        |
      | -1                       | "%(d"        | "(1)"                          |
      | -11                      | "%(d"        | "(11)"                         |
      | -1111111111111111111     | "%(d"        | "(1111111111111111111)"        |
      | -11111111111111111111    | "%(d"        | "(11111111111111111111)"       |
      | -111111111111111111111   | "%(d"        | "(111111111111111111111)"      |
      | 1.0                      | "%e"         | "1.000000e+00"                 |
      | -1.0                     | "%e"         | "-1.000000e+00"                |
      | 100.0                    | "%e"         | "1.000000e+02"                 |
      | 123456789.123456789      | "%e"         | "1.234568e+08"                 |
      | 1.0                      | "%f"         | "1.000000"                     |
      | -1.0                     | "%f"         | "-1.000000"                    |
      | 1.1                      | "%f"         | "1.100000"                     |
      | 123456789.123456789      | "%f"         | "123456789.123457"             |
      | 1.0                      | "%g"         | "1.00000"                      |
      | -1.0                     | "%g"         | "-1.00000"                     |
      | 1.1                      | "%g"         | "1.10000"                      |
      | 123456789.123456789      | "%g"         | "1.23457e+08"                  |
      | ""                       | "%h"         | "0"                            |
#      |                          | "%n"         | "\n"                           | struggling to display the correct kind of newline
#      | 1                        | "%n"         | "\n"                           | struggling to display the correct kind of newline
#      | "1"                      | "%n"         | "\n"                           | struggling to display the correct kind of newline
#      | 2018-10-10T00:00:00.000  | "%n"         | "\n"                           | struggling to display the correct kind of newline
      | 0                        | "%o"         | "0"                            |
      | 1                        | "%o"         | "1"                            |
      | 123456789                | "%o"         | "726746425"                    |
      | -123456789               | "%o"         | "37051031353"                  |
      | ""                       | "%s"         | ""                             |
      | 1                        | "%s"         | "1"                            |
      | "1"                      | "%s"         | "1"                            |
      | 2018-10-10T00:00:00.000Z | "%s"         | "2018-10-10T00:00Z"            |
      | 2018-10-10T00:00:10.000Z | "%s"         | "2018-10-10T00:00:10Z"         |
      | 2018-10-10T00:00:01.000Z | "%s"         | "2018-10-10T00:00:01Z"         |
      | 2018-10-10T00:00:59.100Z | "%s"         | "2018-10-10T00:00:59.100Z"     |
      | 2018-10-10T00:00:59.001Z | "%s"         | "2018-10-10T00:00:59.001Z"     |
      | ""                       | "%10s"       | "          "                   |
      | 1                        | "%10s"       | "         1"                   |
      | 11111111111              | "%10s"       | "11111111111"                  |
      | "1"                      | "%10s"       | "         1"                   |
      | "11111111111"            | "%10s"       | "11111111111"                  |
      | 2018-10-10T00:00:00.000Z | "%10s"       | "2018-10-10T00:00Z"            |
      | 2018-10-10T00:00:10.000Z | "%10s"       | "2018-10-10T00:00:10Z"         |
      | 2018-10-10T00:00:01.000Z | "%10s"       | "2018-10-10T00:00:01Z"         |
      | 2018-10-10T00:00:59.100Z | "%10s"       | "2018-10-10T00:00:59.100Z"     |
      | 2018-10-10T00:00:59.001Z | "%10s"       | "2018-10-10T00:00:59.001Z"     |
      | ""                       | "%-10s"      | "          "                   |
      | 1                        | "%-10s"      | "1         "                   |
      | 11111111111              | "%-10s"      | "11111111111"                  |
      | "1"                      | "%-10s"      | "1         "                   |
      | "11111111111"            | "%-10s"      | "11111111111"                  |
      | 2018-10-10T00:00:00.000Z | "%-10s"      | "2018-10-10T00:00Z"            |
      | 2018-10-10T00:00:10.000Z | "%-10s"      | "2018-10-10T00:00:10Z"         |
      | 2018-10-10T00:00:01.000Z | "%-10s"      | "2018-10-10T00:00:01Z"         |
      | 2018-10-10T00:00:59.100Z | "%-10s"      | "2018-10-10T00:00:59.100Z"     |
      | 2018-10-10T00:00:59.001Z | "%-10s"      | "2018-10-10T00:00:59.001Z"     |
      | ""                       | "%.5s"       | ""                             |
      | 1                        | "%.5s"       | "1"                            |
      | 11111111111              | "%.5s"       | "11111"                        |
      | "1"                      | "%.5s"       | "1"                            |
      | "11111111111"            | "%.5s"       | "11111"                        |
      | 2018-10-10T00:00:00.000Z | "%.5s"       | "2018-"                        |
      | 2018-10-10T00:00:10.000Z | "%.5s"       | "2018-"                        |
      | 2018-10-10T00:00:01.000Z | "%.5s"       | "2018-"                        |
      | 2018-10-10T00:00:59.100Z | "%.5s"       | "2018-"                        |
      | 2018-10-10T00:00:59.001Z | "%.5s"       | "2018-"                        |
      | ""                       | "%10.5s"     | "          "                   |
      | 1                        | "%10.5s"     | "         1"                   |
      | 12345678901              | "%10.5s"     | "     12345"                   |
      | "1"                      | "%10.5s"     | "         1"                   |
      | "12345678901"            | "%10.5s"     | "     12345"                   |
      | 2018-10-10T00:00:00.000Z | "%10.5s"     | "     2018-"                   |
      | 2018-10-10T00:00:10.000Z | "%10.5s"     | "     2018-"                   |
      | 2018-10-10T00:00:01.000Z | "%10.5s"     | "     2018-"                   |
      | 2018-10-10T00:00:59.100Z | "%10.5s"     | "     2018-"                   |
      | 2018-10-10T00:00:59.001Z | "%10.5s"     | "     2018-"                   |
      | 0                        | "%x"         | "0"                            |
      | 1                        | "%x"         | "1"                            |
      | 123456789                | "%x"         | "75bcd15"                      |
      | -123456789               | "%x"         | "f8a432eb"                     |
      | 2018-12-01T16:17:18.199Z | "%tA"        | "Saturday"                     |
      | 2018-12-01T16:17:18.199Z | "%ta"        | "Sat"                          |
      | 2018-12-01T16:17:18.199Z | "%tB"        | "December"                     |
      | 2018-12-01T16:17:18.199Z | "%tb"        | "Dec"                          |
      | 2018-12-01T16:17:18.199Z | "%tC"        | "20"                           |
#      | 2018-12-01T16:17:18.199Z | "%tc"        | "Sat Dec 11 16:17:18 UTC 2018" | requires timezone information
      | 2018-12-01T16:17:18.199Z | "%tD"        | "12/01/18"                     |
      | 2018-12-01T16:17:18.199Z | "%td"        | "01"                           |
      | 2018-12-01T16:17:18.199Z | "%te"        | "1"                            |
      | 2018-12-01T16:17:18.199Z | "%tF"        | "2018-12-01"                   |
      | 2018-12-01T16:17:18.199Z | "%tH"        | "16"                           |
      | 2018-12-01T16:17:18.199Z | "%th"        | "Dec"                          |
      | 2018-12-01T16:17:18.199Z | "%tI"        | "04"                           |
      | 2018-12-01T16:17:18.199Z | "%tj"        | "335"                          |
      | 2018-12-01T09:17:18.199Z | "%tk"        | "9"                            |
      | 2018-12-01T16:17:18.199Z | "%tl"        | "4"                            |
      | 2018-12-01T16:07:18.199Z | "%tM"        | "07"                           |
      | 2018-02-01T16:17:18.199Z | "%tm"        | "02"                           |
      | 2018-02-01T16:17:18.099Z | "%tN"        | "099000000"                    |
      | 2018-02-01T16:17:18.199Z | "%tp"        | "pm"                           |
#      | 2018-02-01T16:17:18.199Z  | "%tQ"        | "02"                           | requires timezone information
      | 2018-02-01T16:17:18.199Z | "%tR"        | "16:17"                        |
      | 2018-02-01T16:17:18.199Z | "%tr"        | "04:17:18 PM"                  |
      | 2018-02-01T16:17:08.199Z | "%tS"        | "08"                           |
#      | 2018-02-01T16:17:18.199Z  | "%ts"        | "02"                           | requires timezone information
      | 2018-02-01T16:17:18.199Z | "%tT"        | "16:17:18"                     |
      | 2018-02-01T16:17:08.199Z | "%tY"        | "2018"                         |
      | 2018-02-01T16:17:08.199Z | "%ty"        | "18"                           |
#      | 2018-02-01T16:17:08.199Z  | "%tZ"        | "08"                           | requires timezone information
#      | 2018-02-01T16:17:08.199Z  | "%tz"        | "08"                           | requires timezone information

Scenario Outline: Running an invalid 'formattedAs' request should fail with an error message
     Given foo is in set:
       | <input> |
       And foo is formatted as <format>
       And foo is anything but null
     Then the profile is invalid because "Unable to format value `.+` with format expression `.+`: .*"
       And no data is created
     Examples:
      | input                    | format      |
      | "1"                      | "%20d"      |
      | 2018-02-01T16:17:18.199Z | "%20d"      |
      | "1"                      | "%-20d"     |
      | 2018-02-01T16:17:18.199Z | "%-20d"     |
      | "1"                      | "%020d"     |
      | 2018-02-01T16:17:18.199Z | "%020d"     |
      | "1"                      | "\|%020d\|" |
      | 2018-02-01T16:17:18.199Z | "\|%020d\|" |
      | "1"                      | "% d"       |
      | 2018-02-01T16:17:18.199Z | "% d"       |
      | "1"                      | "%,d"       |
      | 2018-02-01T16:17:18.199Z | "%,d"       |
      | "1"                      | "%(d"       |
      | 2018-02-01T16:17:18.199Z | "%(d"       |
      | "1"                      | "%o"        |
      | 2018-02-01T16:17:18.199Z | "%o"        |
      | "1"                      | "%x"        |
      | 2018-02-01T16:17:18.199Z | "%x"        |
      | "1"                      | "%t"        |
      | 1                        | "%t"        |
      | "1"                      | "%tA"       |
      | 1                        | "%tA"       |
      | "1"                      | "%ta"       |
      | 1                        | "%ta"       |
      | "1"                      | "%tB"       |
      | 1                        | "%tB"       |
      | "1"                      | "%tb"       |
      | 1                        | "%tb"       |
      | "1"                      | "%tC"       |
      | 1                        | "%tC"       |
      | "1"                      | "%tc"       |
      | 1                        | "%tc"       |
      | "1"                      | "%tD"       |
      | 1                        | "%tD"       |
      | "1"                      | "%td"       |
      | 1                        | "%td"       |
      | "1"                      | "%te"       |
      | 1                        | "%te"       |
      | "1"                      | "%tF"       |
      | 1                        | "%tF"       |
      | "1"                      | "%tH"       |
      | 1                        | "%tH"       |
      | "1"                      | "%th"       |
      | 1                        | "%th"       |
      | "1"                      | "%tI"       |
      | 1                        | "%tI"       |
      | "1"                      | "%tj"       |
      | 1                        | "%tj"       |
      | "1"                      | "%tk"       |
      | 1                        | "%tk"       |
      | "1"                      | "%tl"       |
      | 1                        | "%tl"       |
      | "1"                      | "%tM"       |
      | 1                        | "%tM"       |
      | "1"                      | "%tm"       |
      | 1                        | "%tm"       |
      | "1"                      | "%tN"       |
      | 1                        | "%tN"       |
      | "1"                      | "%tp"       |
      | 1                        | "%tp"       |
      | "1"                      | "%tQ"       |
      | 1                        | "%tQ"       |
      | "1"                      | "%tR"       |
      | 1                        | "%tR"       |
      | "1"                      | "%tr"       |
      | 1                        | "%tr"       |
      | "1"                      | "%tS"       |
      | 1                        | "%tS"       |
      | "1"                      | "%ts"       |
      | 1                        | "%ts"       |
      | "1"                      | "%tT"       |
      | 1                        | "%tT"       |
      | "1"                      | "%tY"       |
      | 1                        | "%tY"       |
      | "1"                      | "%ty"       |
      | 1                        | "%ty"       |
      | "1"                      | "%tZ"       |
      | 1                        | "%tZ"       |
      | "1"                      | "%tz"       |
      | 1                        | "%tz"       |

  Scenario Outline: Running an 'null' value 'formattedAs' request should fail with an invalid profile exception
    Given foo is in set:
      | <input> |
      And foo is formatted as <format>
      And foo is anything but null
    Then the profile is invalid because "Couldn't recognise 'value' property, it must be set to a value, field: foo"
      And no data is created
    Examples:
      | input                    | format      |
      | "1"                      | null        |
      | 1                        | null        |
      | 2018-02-01T16:17:18.199Z | null        |

@ignore #266, formattedAs %b doesn't work correctly with null values
Scenario: Running an 'formattedAs' request with a null value should return false
    Given foo is null
      And foo is formatted as "%b"
    Then the following data should be generated:
      | foo   |
      | false |

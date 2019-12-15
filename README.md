# Advent of Code

Solutions to different years of [Advent of Code](https://adventofcode.com) puzzles in different languages.

Code is not always nice and cleaned up or optimised. The idea is to create a working algorithm to resolve the puzzle. Most of the time every solution has a test with examples provided in the puzzle.

## Setup script

Script creates directory for given year and day and copies files for chosen language from `_templates` directory to `$year/day_$day` directory.

```bash
./setup 2018 1 elixir
./setup 2019 1 ruby
./setup 2020 1
```
function "0x0" --description "Paste to 0x0.st"
  set -f 0x0_version "0.1.1"
  argparse \
    --exclusive e,d \
    'T/show-token' \
    'c/copy' \
    'curl-args' \
    'd/expire-date=' \
    'delete' \
    'dry-run' \
    'e/expires-in=' \
    'h/help' \
    'i/instance=' \
    'n/name=' \
    'no-secret' \
    't/token=' \
    'v/verbose' \
    'version' \
    -- $argv; or return
  if set -q _flag_help
    echo "0x0.fish v$0x0_version"
    echo
    echo "Usage: 0x0 [OPTIONS] [FILE | REMOTE_URL | INSTANCE_URL]"
    echo
    echo "Paste to 0x0.st via curl. With no FILE, or when FILE is -, reads standard input."
    echo "If a http(s) URL is given instead of a file path, it is passed to 0x0.st"
    echo "without fetching its contents locally."
    echo
    echo "Options:"
    echo "  -n, --name NAME         Set the name of the file sent to 0x0.st. Ignored if"
    echo "                          REMOTE_URL is given."
    echo "                          [default: FILE or paste.txt]"
    echo "  -e, --expires-in TIME   Set the lifetime of the file in hours. Also supports"
    echo "                          optional modifiers: h for hour, d for day, w for week,"
    echo "                          m for month, y for year (case-insensitive)."
    echo "                          [examples: 24, 2w2d5h, 1y]"
    echo "  -d, --expire-date DATE  Set the expiration date for the file, either in"
    echo "                          Unix epoch *milliseconds* or in the format parsed"
    echo "                          by GNU date. Cannot be used if --expires-in is set."
    echo "                          On macOS, install gdate for this option to work."
    echo "  -T, --show-token        Also display the management token that can be used to"
    echo "                          delete or edit pasted files. Requires curl >= 7.84.0."
    echo "      --no-secret         Do not make the file URL secret."
    echo "  -c, --copy              Automatically copy the resulting link to the"
    echo "                          clipboard. Supports xclip, wl-copy, pbcopy."
    echo "  -i, --instance URL      Use a custom server instead of https://0x0.st."
    echo "  -t, --token TOKEN       Set the management token returned from the X-Token HTTP"
    echo "                          header. Allows you to remove a pasted file or change"
    echo "                          the expiration date."
    echo "      --delete            Remove the file. Requires --token and the pasted"
    echo "                          file's URL as the argument."
    echo "      --dry-run           Output the curl command without doing any requests."
    echo "      --curl-args         Advanced option: pass all arguments after the first"
    echo "                          one to curl. Prepend -- to pass options."
    echo "                          [example: 0x0 file.txt --curl-args -- -H 'x-test: 1']"
    echo "  -v, --verbose           Verbose output."
    echo "      --version           Display version and exit."
    echo "  -h, --help              Display this help message and exit."
    return
  end
  if set -q _flag_version
    echo $0x0_version
    return
  end
  # Defaults
  set -f instance "https://0x0.st"
  set -f file "-"
  set -f name "paste.txt"
  set -q _flag_instance
    and set -f instance $_flag_instance
  if set -q argv[1]; and test "$argv[1]" != '-'
    set -f file $argv[1]
    if string match -qr '^https?://' "$argv[1]"
      set -l instance_no_slash (string replace -r '/?$' '' -- "$instance")
      if string match -q "$instance_no_slash/*" "$argv[1]"
         or test "$instance_no_slash" = "$argv[1]"
        set -f is_instance_url true
      else
        set -f is_remote_url true
      end
    else
      set -f name (basename -- "$argv[1]")
    end
  end
  if set -q argv[2]; and not set -q _flag_curl_args
    echo "0x0: too many arguments" >&2
    return 1
  end
  set -q _flag_copy; and set -f copy $_flag_copy
  set -q _flag_curl_args; and set -f allow_additional_curl_args $_flag_curl_args
  set -q _flag_delete; and set -f delete $_flag_delete
  set -q _flag_dry_run; and set -f dry_run $_flag_dry_run
  set -q _flag_name; and set -f name $_flag_name
  set -q _flag_show_token; and set -f show_token $_flag_show_token
  set -q _flag_token; and set -f token $_flag_token
  set -q _flag_verbose; and set -f verbose $_flag_verbose
  set -q _flag_no_secret; or set -f secret true
  if set -q _flag_expires_in
    if not string match -rq '^(\d+[yYmMwWdDhH]?)+$' "$_flag_expires_in"
      echo "0x0: --expires-in: expected numbers with optional y/m/w/d/h modifiers" >&2
      return 1
    end
    set -f expires (math 0( \
          string replace -ra '(\d+)[yY]' '+($1*24*365)' -- "$_flag_expires_in" \
        | string replace -ra '(\d+)[mM]' '+($1*24*30)' \
        | string replace -ra '(\d+)[wW]' '+($1*24*7)' \
        | string replace -ra '(\d+)[dD]' '+($1*24)' \
        | string replace -ra '(\d+)[hH]' '+($1)' \
        | string replace -ra '(\d+)$' '+($1)'))
    # All values below 1650460320000 ms are treated as durations:
    # https://git.0x0.st/mia/0x0/src/commit/0cd289d9812675f60a9d81b0b9ce0a3d08cc4d35/fhost.py#L292
    if test "$expires" -ge 1650460320000
      echo "0x0: --expires-in: cannot be larger than or equal to 1650460320000" >&2
      return 1
    end
  end
  if set -q _flag_expire_date
    if string match -rq '^[0-9]+$' "$_flag_expire_date"
      set -f expires $_flag_expire_date
    else
      set -l date_command date
      type -q gdate; and set date_command gdate
      set -f expires ($date_command -d "$_flag_expire_date" +%s%3N 2>/dev/null)
      if test -z "$expires"
        echo "0x0: --expire-date: invalid date '$_flag_expire_date'" >&2
        return 1
      end
    end
    if test "$expires" -lt 1650460320000
      echo "0x0: --expire-date: cannot be smaller than 1650460320000 ms" >&2
      return 1
    end
  end
  set -f curl_args --fail --show-error
  if set -q verbose
    set -a curl_args --progress-bar
  else
    set -a curl_args --no-progress-meter
  end
  if set -q is_remote_url
    set -a curl_args -F "url=$file"
  else if not set -q is_instance_url
    set -a curl_args -F "file=@$file;filename=$name"
  end
  if set -q secret; and not set -q token
    set -a curl_args -F "secret="
  end
  if set -q expires
    set -a curl_args -F "expires=$expires"
  end
  if set -q token
    if not set -q is_instance_url
      echo "0x0: --token: must be used with $instance URLs" >&2
      return 1
    end
    set -a curl_args -F "token=$token"
  end
  if set -q delete
    if not set -q token
      echo "0x0: --delete: requires --token" >&2
      return 1
    end
    set -a curl_args -F "delete="
  end
  if set -q show_token
    set -a curl_args -w '%{stderr}Token: %header{x-token}\n'
  end
  if set -q allow_additional_curl_args
    set -a curl_args $argv[2..-1]
  end
  set -a curl_args (set -q token; and echo "$file"; or echo "$instance")
  if set -q _flag_dry_run
    echo curl (string escape -- $curl_args)
    return
  end
  set -q verbose; and echo '+' curl (string escape -- $curl_args) >&2
  if set -q copy
    set -l output (curl $curl_args)
    string join \n -- $output
    set -l link $output[1]
    set -q verbose; and echo "Copying $link" >&2
    if type -q wl-copy; and begin
                              test "$XDG_SESSION_TYPE" = "wayland"
                              or set -q WAYLAND_DISPLAY
                            end
      echo -n -- $link | wl-copy
    else if type -q pbcopy
      echo -n -- $link | pbcopy
    else if type -q xclip
      echo -n -- $link | xclip -selection clipboard
    else
      echo "0x0: cannot find suitable program for copying" >&2
    end
  else
    curl $curl_args
  end
end

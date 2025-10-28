#!/usr/bin/env zsh

shopt -s nullglob globstar

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=("$prefix"/**/*.gpg)
password_files=("${password_files[@]#"$prefix"/}")
password_files=("${password_files[@]%.gpg}")

# Use walker instead of rofi
password=$(printf '%s\n' "${password_files[@]}" | walker -d "$@")

[[ -n $password ]] || exit

pass_cmd=show
if pass show "$password" | grep -q '^otpauth://'; then
  pass_cmd=otp
fi

pass $pass_cmd -c "$password" 2>/dev/null

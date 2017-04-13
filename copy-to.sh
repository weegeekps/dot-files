#/bin/zsh

# Updates the contents of my dot-files directory with the latest versions on the machine.

# I probably should do a little bit more powerful script for this; right now this can't handle directories well with my desired limits on what gets copied. So, we're skipping dirs instead.

setopt extended_glob

filesArr=(~/dot-files/^(README.md|.git|copy-to.sh)(D:t))

for file in $filesArr; do
	if [[ -d ~/$file ]]; then
		echo "$file is a directory."
		continue
	fi
	if [[ -f ~/$file ]]; then
		cp -i ~/$file ~/dot-files/$file
		continue
	fi
done

setopt noextendedglob


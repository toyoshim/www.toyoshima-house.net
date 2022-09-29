#!/usr/bin/ruby

while gets()
	if /(.*)(href=".*?")(.*)/
		$pre = $1
		$sur = $3
		$_ = $2
		gsub(/\\/, "/")
		printf "%s%s%s\n", $pre, $_, $sur
	else
		print
	end
end

